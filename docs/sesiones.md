# Sesiones persistentes (diseño y configuración)

## Modelo
- **Access token:** JWT de 15 minutos. Vive solo en memoria de la app (`SesionApp`); nunca en `localStorage`. Se envía con `Authorization: Bearer`.
- **Token de renovación:** 32 bytes aleatorios. Solo viaja en la cookie `genios_renovacion` (HttpOnly, Secure, `SameSite=Lax`, `Path=/api/v1/autenticacion`, sin `Domain`). En la base se guarda únicamente su hash SHA-256 (`sesiones_autenticacion`). Nunca aparece en el cuerpo JSON.
- **Rotación:** cada `POST /autenticacion/renovar` revoca el token usado y emite uno nuevo en la misma familia. La revocación es la condición del `UPDATE`, así que dos renovaciones simultáneas con el mismo token solo dejan pasar una. Reutilizar un token ya rotado revoca toda la familia y queda en `auditoria_seguridad` (`token_renovacion_reutilizado`).
- **Duración absoluta:** `Autenticacion__DiasMaximosSesion` (30). La caducidad de cada token nuevo es `min(ahora + DiasRenovacion, inicio de la sesión + DiasMaximosSesion)`; el inicio es el `MIN(creado_en)` de la familia. Renovar nunca pasa de ese límite. Sin tablas nuevas.
- **Invitado:** cookie propia `genios_invitado` (Path `/`), con la política de cookies configurada; la sesión se recupera mientras sea válida. La ventana de reanudación de partidas (10 min) no cambia.

## Contratos
| Endpoint | Entrada | Salida |
|---|---|---|
| `POST /autenticacion/estudiante/iniciar-sesion` | usuario y contraseña | `{tokenAcceso, expiraEnSegundos, usuario{id, nombreMostrar, roles…}}` + `Set-Cookie` de renovación |
| `POST /autenticacion/google` | `{idToken}` (no se acepta ningún rol) | igual; una identidad nueva llega con `roles: []` |
| `POST /autenticacion/docente/confirmar` | Bearer; sin cuerpo | igual, con `roles: ["docente"]` y token nuevo. 403 `rol_no_permitido` si la cuenta ya tiene otro rol o no es de Google |
| `POST /autenticacion/renovar` | cookie + cabecera `X-GENIOS-CSRF` | igual; cookie rotada. 401 si no hay cookie, vencida o revocada; 403 sin cabecera |
| `GET /usuarios/yo` | Bearer | `{id, nombreMostrar, nombreUsuario, correo, roles}` |
| `POST /autenticacion/cerrar-sesion` | cabecera `X-GENIOS-CSRF` (cookie opcional) | 204 siempre; revoca la familia si hay cookie y borra las cookies de renovación y de invitado con los mismos Path/SameSite/Secure |

## Rol docente
- Los roles son exclusivos y permanentes. El rol lo concede solo `POST /autenticacion/docente/confirmar` y solo a una identidad de Google **sin rol**. Se crea `perfiles_docente` en ese momento (en una transacción) y no antes.
- Una cuenta con rol estudiante no puede pasar a docente; docente nunca pasa a estudiante.
- Confirmaciones simultáneas: la clave primaria evita duplicados y la segunda recibe el resultado ya concedido.
- `Autenticacion__DocentePorGoogleAbierto` y `DominiosDocentes` ya no existen.
- Cuentas anteriores con roles/perfiles inconsistentes: `docs/cuentas-inconsistentes.md` (no se tocó ninguna).

## Flutter
Al abrir: `/cargando` → `renovar` → `GET /usuarios/yo` (el rol viene del servidor) → destino. Sin cuenta, `GET /sesiones-juego/yo` busca un invitado vigente. Un error de red deja reintentar y no borra nada; una sesión rechazada por el servidor cierra con un aviso visible. Una identidad sin rol solo puede ver `/docente/confirmar`.
Un invitado que recibe 401 intenta reanudar su sesión una vez; si el navegador no guarda la cookie, vuelve a la bienvenida **con un aviso**, no en silencio.
El apodo del invitado no lo guarda el servidor: al recargar vuelve como «Explorador».

## Infraestructura (a hacer por el propietario)
Frontend `https://genios.siacgt.com` y API `https://api.genios.siacgt.com` comparten el sitio `siacgt.com`, por eso `SameSite=Lax` funciona con `fetch` y credenciales.

Render (servicio de la API), variables:
| Variable | Valor |
|---|---|
| `Cors__OrigenesPermitidos__0` | `https://genios.siacgt.com` (sin barra final; añade otros como `__1`) |
| `Autenticacion__CookieSegura` | `true` (valor por defecto) |
| `Autenticacion__CookieSameSite` | `Lax` (valor por defecto) |
| `Autenticacion__DiasRenovacion` / `DiasMaximosSesion` | `30` / `30` (valores por defecto) |
| `Autenticacion__GoogleClientId`, `Autenticacion__Clave`, `ConnectionStrings__GeniosDatabase` | como antes |
| `Autenticacion__DocentePorGoogleAbierto` | **borrarla** si existe (ya no se usa) |

Flutter: compilar con `--dart-define=URL_API=https://api.genios.siacgt.com` (sigue siendo configurable). Google Cloud: el origen autorizado de JavaScript es `https://genios.siacgt.com`.
El dominio `onrender.com` anterior se conserva, pero con él las cookies son entre sitios y no funcionan de forma fiable: el frontend publicado debe apuntar al dominio propio.

## Rollback
1. Backend: volver a la imagen/commit anterior en Render (Deploys → Rollback). No hay cambios de esquema, así que no hace falta revertir la base.
2. Frontend: volver a publicar el `build/web` anterior en Cloudflare.
3. Las sesiones existentes siguen válidas tras el rollback (tabla sin cambios); `DiasMaximosSesion` solo se aplica al renovar.
