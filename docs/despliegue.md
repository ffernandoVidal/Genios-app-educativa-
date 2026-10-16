# Despliegue de GENIOS (pruebas en la nube)

Frontend Flutter Web en Cloudflare Pages, API en Render (Docker), PostgreSQL en Neon. Nada de esto se publica sin que el propietario lo haga.

## Comprobado en local
- `docker build --no-cache -f backend/Dockerfile -t genios-api:test backend` termina sin errores (imagen de ~355 MB).
- El contenedor arranca en Production, escucha en `0.0.0.0:$PORT`, `/health` y `/health/ready` responden `saludable` (la segunda consulta Neon).
- CORS: el origen configurado recibe `Access-Control-Allow-Origin`; otro origen no.
- `flutter build web --release --dart-define=URL_API=https://...` compila y el resultado no contiene `localhost`.

## Causa del error MSB4018
`backend/.dockerignore` estaba vacío, así que `COPY src/ src/` copiaba las carpetas `obj/` creadas en Windows, con rutas de Visual Studio. Ahora `.dockerignore` excluye `bin/`, `obj/`, `.env*`, claves y pruebas.

## Cambios en la API
- `PORT`: si existe, la API escucha ahí (Render lo define).
- `UseForwardedHeaders`: detrás del proxy de Render la API ve el HTTPS y la IP real (el límite de intentos es por IP).
- No hay `Database.Migrate()` ni `EnsureCreated()`: el esquema solo cambia con los scripts de `database/migraciones/` que tú apruebes.

## 1. Render (API)
1. Sube el repo a GitHub (`git push`, lo haces tú).
2. Render → New → Web Service → repositorio `Genios-app-educativa-`.
3. Language/Runtime: **Docker**. Root Directory: `backend`. Dockerfile Path: `./Dockerfile`. Branch: `main`.
4. Health Check Path: `/health`.
5. Plan: el gratuito (se duerme tras ~15 min sin tráfico y tarda en despertar; verifícalo en el panel de Render antes de elegir, los planes cambian).
6. Variables de entorno (valores desde tu `.env` local, nunca en Git):

| Variable | Valor |
|---|---|
| `ASPNETCORE_ENVIRONMENT` | `Production` |
| `ConnectionStrings__GeniosDatabase` | cadena Npgsql de Neon (con `SSL Mode=VerifyFull`) |
| `Autenticacion__Clave` | clave larga aleatoria para firmar el JWT (puedes usar la actual o generar otra) |
| `Autenticacion__GoogleClientId` | el ID de cliente público de Google |
| `Cors__OrigenesPermitidos__0` | `https://TU-PROYECTO.pages.dev` (sin barra final) |

Sesiones, cookies y rol docente: ver `docs/sesiones.md` (la API en `api.genios.siacgt.com`).

`Google__ClientSecret` no se usa y no hace falta en Render.

## 2. Cloudflare Workers Builds (frontend)
El Worker `genios-siacgt` se compila y publica solo con cada push a `main` (Workers & Pages → `genios-siacgt` → Settings → Builds → Connect). Archivos: `frontend/wrangler.jsonc` (nombre del Worker y carpeta `build/web`, sin rutas ni variables, para no tocar el dominio ni los ajustes del panel) y `frontend/cloudflare-build.sh` (instala Flutter 3.47.1 y compila).

| Campo | Valor |
|---|---|
| Repositorio / rama | `ffernandoVidal/Genios-app-educativa-` / `main` |
| Root directory | `frontend` |
| Build command | `bash cloudflare-build.sh` |
| Deploy command | `npx wrangler deploy` |
| Build watch paths | incluir `frontend/*`; excluir `backend/*`, `docs/*`, `database/*`, `tools/*` |
| Preview builds | desactivadas |
| Build variables (tipo Variable) | `URL_API=https://api.genios.siacgt.com`, `GOOGLE_CLIENT_ID=<id publico>` |

Nunca pongas secretos del backend en las variables de build. Las rutas usan hash (`/#/...`), no hace falta regla SPA.
Verificar: log del build, `https://genios.siacgt.com` en ventana privada, dominio aún asignado en Domains & Routes.
Rollback: Deployments/Version History del Worker → elegir la versión anterior, o `npx wrangler rollback`.
Manual (alternativa): `flutter build web --release --dart-define=URL_API=... --dart-define=GOOGLE_CLIENT_ID=...` y `npx wrangler deploy` desde `frontend/`.

## 3. Google Cloud Console
APIs y servicios → Credenciales → tu ID de cliente OAuth (Aplicación web) → **Orígenes autorizados de JavaScript**: añade `https://TU-PROYECTO.pages.dev`. No se necesitan URI de redirección (se usa el token ID).

## 4. Después de desplegar
1. Abre `https://TU-API.onrender.com/health` y `/health/ready`.
2. Abre la web de Pages, regístrate/entra y juega una partida.
3. Si el navegador bloquea llamadas: revisa que `Cors__OrigenesPermitidos__0` coincida exactamente con el origen.

## Pendientes y avisos
- No se probó Render ni Cloudflare (no se publicó nada).
- Datos: el Neon actual es el mismo que usas en pruebas. Para pruebas públicas conviene una rama/base de Neon separada.
- La cookie de renovación entre dominios distintos requiere `Autenticacion__CookieSameSite=None`, y los navegadores pueden bloquearla como cookie de terceros; hoy la web no la usa para reanudar sesión (se pierde al recargar).
- El plan gratuito de Render hace arrancar en frío: la primera petición puede tardar ~1 min.
- Rota las credenciales de Neon y Google si alguna vez se compartieron fuera de tu equipo (no encontré secretos en el historial de Git).
