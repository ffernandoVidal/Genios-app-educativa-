# Diagnóstico del frontend (solo lectura) — 2026-10-14

No se modificó ningún archivo de los proyectos Flutter revisados ni se tocó Neon.

## Hallazgo principal
`C:\Users\Ferna\Desktop\PROYECTO GENIOS` **no contiene frontend**. Existen proyectos Flutter de iteraciones anteriores en otras carpetas, hechos contra una API y un esquema **distintos** (18 tablas, rutas en inglés, `http://localhost:3000/api`).

| Proyecto | Estado |
|---|---|
| `...\PROYECTO DE GRADUACION - GENIOS\frontend` (`genios_app`, 2026-10-09) | 189 archivos .dart, ~20 000 líneas, 47 pruebas. `flutter_bloc`, `flame`, `http`, `shared_preferences`. Funcionalidades: auth, catálogo, juegos (~20 minijuegos Flame), progreso, tiempo de estudio, personal docente |
| `...\Juegos` (`genios_juegos`) | Paquete de juegos de Matemáticas (6 juegos); las demás materias, vacías |
| `...\Dashboard\frontend` | Esqueleto (2 archivos) |
| `Genioss\frontend`, `Documents\genio\genio_app`, `edugalaxia` | Versiones anteriores / otro proyecto; no revisados a fondo |

## Contraste con la API actual
| Aspecto | Frontend anterior | API actual |
|---|---|---|
| Prefijo y base | `/…` sobre `localhost:3000/api` | `/api/v1/…` |
| Rutas | `/auth/login`, `/catalog/subjects`, `/games/{code}/play`, `/game-sessions`, `/usage/heartbeat`, `/me/summary`, `/reports/*` | ver `docs/api.md` (no coinciden) |
| Sesión | token guardado en `TokenStore` (`shared_preferences`) | JWT en memoria + refresh en cookie HttpOnly + invitado en cookie |
| Errores | `{error, code}` | Problem Details `{title, codigo, idCorrelacion}` |
| Evaluación de respuestas | **en el cliente** (`opcion.esCorrecta`, `actual.correcta`) | **en el servidor**; el cliente nunca recibe la clave |
| Puntos | **calculados en el cliente** (`_score += …`) | calculados y registrados en el servidor |
| Tipos de partida | cada juego Flame con su lógica y sus reglas | una partida de 10 preguntas de opción múltiple |
| Invitado / progresión / docentes por aula | no existen | existen |

## Qué se puede reutilizar y qué no
| Reutilizable (con adaptación) | No reutilizable tal cual |
|---|---|
| Tema y widgets infantiles (`core/theme`, `kids_widgets`), `breakpoints` (responsive) | Repositorios y modelos de `auth`, `catalog`, `progress`, `study_time`, `staff` (rutas y formas distintas) |
| Patrón BLoC por *feature* (`data/domain/presentation`) | Lógica de juegos que evalúa y puntúa en el cliente (viola RNF-05 y RNF-06) |
| `ApiClient` como base (manejo de 401/429, `ApiException`) — requiere cookies, CSRF y Problem Details | Pantallas de personal escolar (modelo de instituciones/grupos que la API actual no tiene) |
| Animaciones y arte de los minijuegos Flame como *presentación* | |

## Brechas del backend para el frontend (ver `docs/requisitos.md`)
1. Metadatos visuales del catálogo (icono, color, posición en el mapa).
2. Explicación de la pregunta tras responder.
3. Nombre de la materia: `Lenguaje` vs "Comunicación y Lenguaje".
4. Logros/recompensas sin endpoint.
5. Login de docentes con Google sin probar (Client ID).
6. CORS y cookies entre dominios distintos del front y la API (configuración por entorno pendiente).

## Plan incremental propuesto (requiere aprobación)
1. **Decisión de base:** crear `frontend/` nuevo en este repositorio (Flutter web) y *portar* de forma selectiva tema, widgets y breakpoints; no copiar repositorios ni juegos. 
2. Núcleo: cliente HTTP con cookies y CSRF, manejo de Problem Details, navegación (`go_router`), estado (`flutter_bloc`, ya usado), tema espacial.
3. Catálogo y mapa: materias → niveles → categorías con los cuatro estados.
4. Partida completa de 10 preguntas con mecha, retroalimentación, resultado y reanudación.
5. Modo invitado y aviso de registro; login/registro de estudiante; unirse a aula.
6. Progreso, puntos, estadísticas y tiempo disponible.
7. Panel docente (Google, aulas, estadísticas).
8. Pruebas de widgets/navegación/errores de red y verificación del MVP.

## No pudo comprobarse
- Que los proyectos anteriores compilen o pasen sus 47 pruebas (no se ejecutaron).
- El contenido de `Genioss`, `genio_app` y `edugalaxia`.
- Rendimiento de la API bajo carga.
