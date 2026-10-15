# GENIOS — frontend (Flutter web / PWA)

Interfaz infantil (9 a 12 años) que consume la API ASP.NET Core. No contiene reglas de negocio: no evalúa respuestas, no calcula puntos ni decide qué misión se puede jugar. Todo eso lo valida la API.

## Estructura
```
lib/
  app/          app, rutas (go_router), configuración
  diseno/       sistema visual: tokens (colores, medidas, tipografía), tema y componentes reutilizables
                (fondo espacial, astronauta, botones, tarjetas de materia y misión, cabecera, menú lateral…)
  core/         cliente HTTP (cookies, anti-CSRF, renovación), sesión, ajustes, estados comunes
  features/
    acceso/     bienvenida, JUGAR como invitado (solo apodo), inicio de sesión, registro, acceso docente (pendiente)
    cabina/     cabina del astronauta con el botón JUGAR y el menú lateral
    catalogo/   materias (tarjetas) y misiones de cada materia con estados
    partida/    misión de 10 preguntas: respuesta, retroalimentación, mecha, resultados e invitación a registrarse
    progreso/   perfil: puntos, tiempo del día y avance por materia
    salon/      unirse al aula con código y ver el aula actual
    ajustes/    animaciones, texto grande, sonido (próximamente), cerrar sesión
test/           cliente HTTP, repositorios, cubits, pantallas, diseño adaptable y accesibilidad (repositorios falsos en test/soporte)
assets/fuentes  Baloo 2 y Nunito (licencia OFL incluida)
```
Estado con `flutter_bloc` (Cubit); un repositorio por *feature* detrás de una interfaz.

## Ejecutar en desarrollo
1. API (desde `backend/`), permitiendo el origen del front:
   `Cors__OrigenesPermitidos__0=http://localhost:8080` y `dotnet run --project src/GENIOS.Api` (puerto 5136 con `launchSettings.json`).
2. Front: `flutter run -d chrome --web-port 8080 --dart-define=URL_API=http://localhost:5136`

`URL_API` se fija al compilar. En producción el front y la API necesitan HTTPS; si están en dominios distintos, la API debe configurarse con `Autenticacion__CookieSameSite=None` y `Autenticacion__CookieSegura=true`.

## Comprobaciones
```
flutter analyze
flutter test
flutter build web --release
```

## Sesión y seguridad
- El token de acceso vive solo en memoria. Las cookies HttpOnly (renovación e invitado) las gestiona el navegador; el cliente se crea con credenciales (`BrowserClient.withCredentials`).
- Las operaciones que modifican datos envían `X-GENIOS-CSRF`. Ante un 401 se intenta una renovación; si falla, se vuelve a la bienvenida.
- Las rutas privadas del enrutador solo ordenan la navegación; la autorización real es de la API.
