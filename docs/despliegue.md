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
| `Autenticacion__DocentePorGoogleAbierto` | `false` (en `true`, cualquier cuenta Google es docente) |

`Google__ClientSecret` no se usa y no hace falta en Render.

## 2. Cloudflare Pages (frontend)
Cloudflare Pages no trae el SDK de Flutter, por eso se compila en tu equipo y se sube `build/web`:

```
cd frontend
flutter build web --release --dart-define=URL_API=https://TU-API.onrender.com --dart-define=GOOGLE_CLIENT_ID=TU_ID_PUBLICO
npx wrangler pages deploy build/web --project-name genios
```
(o en el panel: Workers & Pages → Create → Pages → Upload assets → arrastra `build/web`). Las rutas usan hash (`/#/...`), por eso no hace falta regla SPA. `GOOGLE_CLIENT_ID` y `URL_API` son públicos; nunca pases secretos con `--dart-define`.

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
