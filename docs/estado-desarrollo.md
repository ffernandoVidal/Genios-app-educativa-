# Estado de desarrollo — GENIOS

**Fase actual:** 0 (auditoría técnica) — completada, pendiente de aprobación.
**Fecha:** 2026-10-14

## Entorno observado (comprobado)
| Herramienta | Resultado |
|---|---|
| .NET SDK | 10.0.401 (también 9.0.305) |
| Flutter / Dart | 3.47.1 / 3.13.1 |
| Git | 2.51.0 |
| Node | 22.19.0 |
| psql | 17.9, en `C:\Program Files\PostgreSQL\17\bin` (no está en el PATH) |
| Chrome (web) | OK |
| Android toolchain | Licencias sin aceptar (no bloquea la versión web) |
| `ConnectionStrings__GeniosDatabase` | NO definida |
| Repositorio Git | No inicializado |

## Esquema
- Script candidato: `C:\Users\Ferna\Downloads\genios_base_datos_postgresql_es.sql` (37 tablas, v1.0-draft, 2026-10-14).
- Existen otros scripts antiguos de 18 tablas en inglés (`Test\esquemas\...`) que NO corresponden a este diseño.
- **PENDIENTE:** confirmar que el script de Downloads es el ejecutado en Neon.
- No se ha accedido a Neon.

## Decisiones
- CONFIRMADO: ver sección 3 del prompt maestro.
- PENDIENTE: vinculación tutor–estudiante, ventana de reanudación, criterio de correo educativo, inactividad, zona horaria diaria, criterio de "categoría completada", tokens de sesión.

## Fase 1 — backend (2026-10-14)
- `backend/GENIOS.sln`: Api, Application, Domain, Infrastructure + UnitTests, IntegrationTests (.NET 10).
- `GET /health` y `GET /health/ready` (SELECT 1 a Neon, timeout 5 s, sin detalles en la respuesta).
- `.env` se carga solo en Development (`DotEnvLoader`); las variables de entorno reales tienen prioridad.
- Verificado: `dotnet test` → 4/4 pasan (incluye Neon real y sin filtrar credenciales); API ejecutada: /health 200, /health/ready 200, sin secretos en logs.
- No hay pruebas unitarias aún (UnitTests vacío). Frontend NO iniciado. `git init` NO ejecutado.

## Fase 2 — persistencia (2026-10-14)
- Scaffold EF Core database-first de las 39 tablas en `Infrastructure/Persistence`; `GeniosDbContext` sobre `NpgsqlDataSource`.
- Esquema cambiado solo con scripts SQL revisados en `database/migraciones/`. Aplicada: `001_autenticacion.sql`.

## Fase 3 y 4 — autenticación y aulas (2026-10-14)
- Capas: Domain (reglas, `ExcepcionNegocio`), Application (DTOs + interfaces), Infrastructure (servicios con EF), Api (controladores, JWT, CORS, límite de intentos).
- Estudiante: registro con código de aula, login con usuario/contraseña. Google: `POST /autenticacion/google` implementado, SIN probar con un idToken real (falta `Autenticacion__GoogleClientId`).
- Tokens: JWT de 15 min + refresh rotativo de 7 días en cookie HttpOnly (hash en BD, reutilización revoca la familia).
- Aulas: crear (docente verificado), unirse (idempotente), listar, retirar. Reinicio de contraseña por código temporal emitido por el docente.
- Rol docente: solo si el dominio del correo está en `Autenticacion:DominiosDocentes` (vacío por defecto = nadie se verifica solo).
- Verificación manual (script temporal, no incluido en pruebas): 48/48 comprobaciones correctas contra Neon; datos de prueba borrados.
- NO implementado aún: `/estudiantes/yo/*` (progreso, estadísticas), `/aulas/{id}/estadisticas`, control de 90 min (Fase 5), `solicitudes_aula` queda sin uso.
- Deuda técnica conocida: `ON DELETE SET NULL` + CHECK de propietario en `partidas`/`sesiones_juego` impide borrar usuarios o sesiones de invitado con partidas.
- Despliegue: el límite de intentos usa la IP directa; detrás de un proxy hay que configurar cabeceras reenviadas.

## Fase 5 — contenido, partidas, puntos y tiempo (2026-10-14)
- Endpoints: asignaturas/niveles/categorías (+progreso), partidas (crear, obtener, pregunta-actual, respuestas, reanudar, finalizar, abandonar, resultado), `estudiantes/yo/uso-diario` (+latido).
- Valores iniciales (config `Juego`): 90 min/día, inactividad 60 s, America/Guatemala, ventana de reanudación 10 min, mecha 30 s.
- Reglas PROPUESTAS aplicadas: mecha = tercer error en la MISMA pregunta (dura 30 s; si vence, la partida termina y no se reanuda); puntos solo por respuesta correcta (cualquier intento), idempotentes por id de intento; bono de 20 una vez por estudiante y categoría (clave determinística); categoría completada = una partida con las 10 preguntas resueltas (distinto de "aprobada"); cada interacción suma como máximo 60 s al día; sin tiempo diario, no hay partidas nuevas y la partida en curso se cierra como abandonada (motivo `limite_diario`); pasada la ventana de 10 min sin actividad, cualquier acceso cierra la partida (`ventana_vencida`); una sola partida en curso por estudiante.
- Preguntas: banco primero, luego generadas por reglas (`reglas_generacion_preguntas.parametros`); instantánea y clave guardadas en el servidor.
- Verificación manual (script temporal, sin añadir a pruebas): 67/67 correctas contra Neon; contenido y datos de prueba borrados.
- Contenido: `database/migraciones/002_contenido_inicial.sql` (4 categorías de Matemáticas + 10 preguntas [PRUEBA] de Lenguaje). NO aplicado en Neon (pendiente de autorización).
- Pendiente: modo invitado, estadísticas (`/estudiantes/yo/progreso|estadisticas|puntos|logros`, `/aulas/{id}/estadisticas`), contenido de Sociales y Naturales (requiere pensum).

## Modo invitado y pruebas automatizadas (2026-10-14)
**Implementado**
- `POST /api/v1/sesiones-juego` (crea o reutiliza la sesión; cookie `genios_invitado` HttpOnly, el token no viaja en el cuerpo y en BD solo está su hash) y `GET /api/v1/sesiones-juego/yo` (partidas válidas, las que cuentan, `invitarARegistrarse`, aviso de progreso anónimo).
- Las partidas aceptan como propietario un estudiante o una sesión de invitado (`Propietario`). Invitados: sin límite diario, sin transacciones de puntos ni progreso de cuenta; los puntos solo constan en la partida.
- Regla de invitación: 3 partidas completadas (10 preguntas) que superen el 61 % al primer intento (≥ 7/10); las incompletas no cuentan; se acumulan entre días y materias. Interpretación PROPUESTA: basta con tener tres que cuenten (no importa si hubo otras válidas por debajo del 61 %).
- Sesión de invitado: vigencia absoluta de 30 días (`Juego:DiasVigenciaInvitado`); al vencer pasa a `expirada` y la cookie deja de servir. Las operaciones que modifican datos exigen la cabecera `X-GENIOS-CSRF`.
- Registrarse NO transfiere nada: la cuenta nueva empieza vacía.
- Progresión de categorías (bloqueo por categoría anterior sin completar) en servidor y en `GET /niveles/{id}/categorias` (ahora requiere estudiante o invitado).

**Pruebas ejecutadas (`dotnet test`, contra Neon real, exit code 0):** 31 unitarias + 18 de integración = 49 correctas, 0 con error. Duración de integración ≈ 2,6 min.
- Unitarias: regla del 61 %, puntos, porcentaje, normalización de usuario y código de aula, generador de operaciones (500 operaciones por tipo: sin negativos, división exacta, 4 opciones distintas, correcta incluida).
- Integración: salud (4); sesión de invitado (cookie HttpOnly sin token en cuerpo, reutilización, anti-CSRF, expiración, nueva sesión vacía); propiedad de partidas (invitado/invitado/estudiante); idempotencia (respuesta y creación de partida); regla de invitación completa (7/10 sí, 6/10 no, incompleta no, acumulación entre días y materias, tercera dispara la invitación); registro sin transferencia; bloqueo de categorías; puntos y bono único; límite diario; mecha (2 s en pruebas) y no reanudar; ventana de reanudación.
- Las pruebas crean su propio contenido con etiqueta única y borran solo lo suyo; tras la ejecución Neon quedó con 0 filas de prueba (comprobado).
- Reproducir: `cd backend; dotnet test GENIOS.sln` (requiere `.env` con la cadena de conexión).

**No cubierto por pruebas automáticas:** login con Google real (falta Client ID), restablecimiento de contraseña y aulas (verificados a mano en la fase anterior, 48/48; sin script automatizado).

## Contenido educativo
Ver `docs/contenido-inicial.md`. `002_contenido_inicial.sql` es idempotente (comprobado en seco) y sigue SIN aplicar en Neon.

## Estadísticas y estados de misión (2026-10-14)
**Implementado:** `GET /estudiantes/yo/progreso`, `/estadisticas`, `/puntos` y `GET /aulas/{id}/estadisticas`; los estados de categoría (bloqueada, disponible, en_progreso, completada) con el requisito de desbloqueo visible (`requiereCategoriaId/Nombre`) en `GET /niveles/{id}/categorias`.
- Los puntos de estas vistas salen del libro de transacciones; los porcentajes, solo de partidas completadas (primer intento). Los reintentos se informan aparte; las partidas incompletas, también.
- Acceso de un docente a un aula ajena o inexistente: 404 y registro `acceso_aula_no_autorizado` en la auditoría.

**Pruebas (`dotnet test`, Neon real, exit code 0): 53 correctas = 31 unitarias + 22 de integración, 0 con error (≈ 5,9 min).** Nuevas: `EstadisticasTests` (4: valores del estudiante, aislamiento entre estudiantes, el docente ve solo a los estudiantes activos de su aula y los retirados desaparecen, rechazo a docente ajeno / estudiante / invitado / anónimo y registro de auditoría) y la prueba de los cuatro estados. Tras la ejecución Neon quedó sin filas de prueba (comprobado).

## Documentación
`docs/api.md` (contrato real), `docs/requisitos.md` (RF/RNF con estado), `docs/diagnostico-frontend.md` (diagnóstico y plan), `docs/contenido-inicial.md`.

## Pendiente
- Frontend: sin iniciar (esperando aprobación del plan de `docs/diagnostico-frontend.md`).
- Backend: explicación de la pregunta en la retroalimentación; metadatos visuales del catálogo; nombre "Comunicación y Lenguaje"; logros; Google con Client ID; auditar más accesos denegados; medir rendimiento; CORS/cookies por entorno.
- Contenido: aprobar y aplicar `002_contenido_inicial.sql` (hoy Neon no tiene categorías ni preguntas); Sociales y Naturales requieren pensum.

## Frontend — incremento 1 (2026-10-14)
`frontend/` (Flutter web/PWA, `flutter_bloc` + `go_router`), creado nuevo en este repositorio. Ver `frontend/README.md`.
**Implementado:** cliente HTTP (cookies, `X-GENIOS-CSRF`, renovación única compartida ante 401, Problem Details, fallos de red), sesión en memoria, bienvenida, entrar como invitado, inicio de sesión de estudiante, salir, universo de materias y mapa de misiones con los cuatro estados y el requisito de desbloqueo; estados de carga, error con reintento y vacío; diseño adaptable (360, 820 y 1440 px).
**Comprobado (reproducible):** `flutter analyze` sin avisos; `flutter test` 33 correctas (cliente HTTP 12, repositorio y cubits 6, flujos de pantallas 15 incluidos desbordamiento en 3 tamaños y etiquetas de accesibilidad); `flutter build web --release` compila. Una prueba temporal (no versionada) ejecutó los repositorios reales contra la API y Neon: 4 materias, registro e inicio de sesión de estudiante, mapa con `disponible`/`bloqueada` + requisito, materia vacía, error `credenciales_invalidas`, sesión de invitado; luego se borró todo lo creado (Neon en 0). CORS verificado con peticiones reales: origen permitido recibe `Allow-Credentials` y la cookie es HttpOnly; origen ajeno no recibe cabeceras CORS.
**Defectos reales hallados y corregidos por las pruebas:** desbordamiento de las tarjetas de planeta en pantallas de 360 px; estado inicial `Cargando<Never>` distinto de `Cargando<T>`.
**No comprobado:** ejecución en un navegador real (cookies/CORS de punta a punta con Chrome); contraste y lectores de pantalla reales (solo etiquetas semánticas); íconos y arte definitivos (los íconos de la PWA siguen siendo los de Flutter).
## Frontend — incremento 2: recorrido completo (2026-10-14)
**Implementado:** mapa de misiones rediseñado (cabecera del planeta con progreso, camino sinuoso con nodos para los cuatro estados, requisito de desbloqueo en el nodo y en un diálogo); **partida de punta a punta** (iniciar misión, pregunta, opciones, envío con clave de idempotencia, retroalimentación del servidor, reintento, mecha con cuenta regresiva decidida por el servidor, resultado, jugar otra vez, salir con confirmación, reanudación al reintentar la creación); insignias de puntos y minutos restantes (estudiante) o avance (invitado); pantalla **Mi progreso** (puntos, aciertos a la primera aparte de los reintentos, planetas, partidas recientes; para el invitado, cuánto falta y la invitación); **registro con código de aula**; nombre visible **Comunicación y Lenguaje** y tildes centralizados en `EstiloMateria.nombreVisible` (el catálogo sigue con `Lenguaje`).
**Comprobado (reproducible):** `dart format` sin cambios, `flutter analyze` sin avisos, `flutter test` **59 correctas** (cliente HTTP 12, repositorio y cubits 6, cubit de partida 11, flujos de pantallas 15 + partida/progreso/registro 15), `flutter build web --release` compila.
**Comprobado contra la API real y Neon** (prueba temporal no versionada, contenido y datos borrados después; Neon en 0): un estudiante se registra, ve su mapa (`disponible` / `bloqueada` + requisito), el servidor rechaza iniciar la bloqueada, juega una partida completa de 10 preguntas probando opciones hasta que el servidor confirma, obtiene 120 puntos (10×10 + bono), el mapa pasa a `completada` / `disponible`, y progreso y puntos coinciden; un invitado crea su sesión (cookie `HttpOnly` + `X-GENIOS-CSRF`), juega una partida completa (100 puntos, sin bono) y consulta su estado.
**Defectos reales hallados y corregidos por las pruebas:** `RepositoryProvider` rechaza un `ChangeNotifier` (se inyecta `FuenteModoSesion`); la confirmación de salida entraba en bucle con `PopScope` bloqueado (ahora usa `canPop` dinámico); tarjetas de planeta desbordadas con nombres largos.
**No comprobado:** ejecución en un navegador real (CORS verificado con peticiones, pero no el flujo en Chrome); lectores de pantalla y contraste reales; el parecido con la referencia pedida (la página `app.academons.com/MissionsScreen` no es legible sin sesión/JavaScript: se necesita una captura); la mecha de 30 s completa en vivo (probada con 2–5 s); la reanudación de una partida tras recargar el navegador (el front no guarda el id de la partida).
**Pendiente en el front:** panel docente y login con Google; reanudar una partida tras recargar; explicación de la pregunta (el API no la devuelve); arte e íconos definitivos; tiempo diario agotado como pantalla propia (hoy aparece como mensaje al iniciar y en la insignia).
**Bloqueo de contenido:** Neon no tiene categorías ni preguntas; sin `002_contenido_inicial.sql` (pendiente de aprobación) el mapa de cada materia muestra el estado vacío. Con contenido temporal el recorrido funciona (ver arriba).

## Siguiente paso
1. Aprobación de `002_contenido_inicial.sql` para tener misiones reales en Neon.
2. Una captura de la referencia visual para ajustar el diseño.
3. Decisiones abiertas: explicación de la pregunta, metadatos del mapa en base de datos, nombre definitivo de Lenguaje.
4. Siguiente incremento: panel docente y reanudación de partidas.

## Frontend — incremento 3: rediseño espacial v2 (2026-10-14)
Recorrido: Bienvenida → (invitado: solo apodo) → Cabina → JUGAR → Materias → Misiones → Partida → Resultados. Menú lateral: Perfil, Salón, Ajustes.
- Sistema visual propio en `lib/diseno/` (paleta oficial, Baloo 2 + Nunito, astronauta y paisaje dibujados como vectores). El fondo acepta una ilustración definitiva (`FondoEspacial.imagen`) cuando se entregue.
- Conectado a la API real: acceso, catálogo/mapa, partida, progreso, estadísticas, aula (`/aulas/mi-aula`, `/aulas/unirse`).
- Verificado: `flutter analyze` sin avisos, 107 pruebas pasando (incluye 4 tamaños de pantalla, texto grande y semántica), `flutter build web --release` correcto.
- NO verificado: el rediseño contra la API real con contenido (Neon sigue sin categorías; `002_contenido_inicial.sql` sin aplicar); apariencia en navegador real.
- Limitaciones: sin sonido; ajustes solo en memoria; apodo del invitado no se envía al servidor; panel docente y Google login pendientes; la API no entrega nivel ni reintentos por partida.

## Autenticación: registro sin aula y acceso docente con Google (2026-10-14)
- **Causa de que se exigiera aula:** solo el código de la API (`ServicioAutenticacion.RegistrarEstudianteAsync` y el formulario). La base de datos no lo exigía: no se tocó Neon ni hubo migraciones.
- **Cambio:** `codigoAula` opcional; sin código el estudiante se registra, inicia sesión, juega y se une después desde Salón.
- **Google:** el front usa Google Identity Services (botón oficial) y envía el ID token a `POST /autenticacion/google`; la API lo valida. Variables: `Autenticacion__GoogleClientId` (backend, `.env`), `--dart-define=GOOGLE_CLIENT_ID=...` (front; el Client ID es público), `Autenticacion__DocentePorGoogleAbierto` (rol docente a cualquier cuenta Google; decisión del usuario, **no usar en producción**). El secreto del cliente quedó en `.env` (ignorado por Git) y la app no lo usa: el flujo con ID token no lo necesita.
- **Origen autorizado en Google Cloud:** `http://localhost:8080` (no hay redirecciones: no se usa flujo OAuth con redirección).
- **Docente:** al entrar con Google queda en `/docente` (el panel todavía no existe); las rutas infantiles lo devuelven allí.
- **Fondo:** se integró la ilustración `assets/imagenes/superficie_lunar.jpg` (735×737 px, estilo plano) con `BoxFit.cover` anclada abajo. Al ser de baja resolución puede verse suave en pantallas grandes; conviene una versión de mayor resolución.
- **Pruebas:** backend 31 unitarias + 30 integración (incluye 8 de cuentas); frontend 115. Ver informe en el chat.
- **Pendiente (módulo de contenido educativo):** NO integrado; ver propuesta aparte (choca con reglas ya implementadas).

## Panel docente y alta de estudiantes (2026-10-14)
- Front `lib/features/docente/` (dominio / datos / presentación) y ruta `/docente` (muestra el panel si la sesión es docente): aulas propias, crear aula, código de acceso copiable, lista de estudiantes, **agregar estudiante** y **nuevo código**.
- Backend: `POST /aulas/{aulaId}/estudiantes` (sin migración). La restricción `ck_usuarios_credenciales` exige hash para cuentas de usuario/contraseña, por eso se guarda el hash de una clave aleatoria y el estudiante la reemplaza con su código en `/activar` («Tengo un código de mi docente»).
- Pruebas: backend +3 (alta, ajeno/estudiante, duplicado/inválido); front +8 (panel, activación). No existe aún: retirar estudiantes en la UI (el endpoint sí), estadísticas del aula en el panel.
- Banco educativo V2 (370 preguntas): **solo Fase 1 (auditoría)**; los JSON están en `data/educational/` (fuera de los assets de Flutter). Nada importado ni migrado.

## Panel docente: estadísticas y ranking (2026-10-15)
- Por estudiante del aula (desde `GET /aulas/{id}/estadisticas`): puntos, % de aciertos al primer intento, partidas, última actividad y desglose **por materia** (ahora con `asignaturaId` y `puntos`). «Cambiar contraseña» emite un código de un solo uso (el docente nunca ve ni fija contraseñas).
- Ranking (`GET /aulas/ranking`) con filtros por aula y por materia, calculado en el servidor.
- Pruebas: backend +4 (ranking: orden, filtros, empates/duplicados, permisos); front 135 en total. La prueba del bono de categoría se volvió independiente de otros estudiantes (compartían categoría).
- Pendiente: nada de esto se ha visto con datos reales (Neon sin contenido; con datos solo en pruebas); filtro por materia en la lista de estudiantes (hoy el desglose está al abrir cada uno).

## Banco de 370 preguntas: importador y ensayo (2026-10-15)
- `tools/banco/importar_banco.py` valida el banco (estructura, 4 opciones, 1 correcta, aritmética automática) y genera `database/migraciones/003_banco_370.sql` (solo datos, idempotente, **NO aplicado**). Nunca escribe en la base.
- Resultado: 370 preguntas, 37 categorías, 0 rechazadas, 40 avisos de revisión (37 categorías con exactamente 10 preguntas; 3 enunciados repetidos). Informe: `data/educational/informe_importacion.json`.
- Ensayo en Neon dentro de una transacción con ROLLBACK: 4 niveles, 37 categorías, 370 preguntas, 1480 opciones, 370 claves, todas con 4 opciones y clave; Neon quedó en 0 filas.
- Mapeo propuesto: asignatura → «Nivel 1» → categoría (una por `category_code`, en el orden de `subjects[].categories`). Puntos del banco ignorados (el servidor calcula 10/15/20). Sin pistas. Todo pendiente de revisión curricular (CNB).

## Banco de 370 preguntas APLICADO en Neon (2026-10-15)
- `003_banco_370.sql` aplicado: 4 niveles, 37 categorías, 370 preguntas, 1480 opciones, 370 claves. Segunda ejecución sin cambios (idempotente). Matemáticas 8 categorías/80, Lenguaje 10/100, Naturales 9/90, Sociales 10/100.
- Humo con la API real (invitado): `GET /niveles/{id}/categorias` → primera categoría «disponible», el resto «bloqueada»; `POST /partidas` → 10 preguntas, 4 opciones, sin clave en la respuesta. Datos del humo borrados.
- Sigue pendiente: revisión curricular (CNB), pistas, regla de desbloqueo ≥ 7/10 (hoy basta una partida completada) y variación entre partidas (solo 10 preguntas por categoría).

## Centro de Control Docente — backend (2026-10-15)
Diagnóstico y decisiones en `docs/diagnostico-docente.md`. Decisiones del usuario: entrada directa con código (sin bandeja de solicitudes), migración 004 aprobada, registro asistido = código de activación existente.
- Migración **004 aplicada** (`aulas.grado`, `aulas.seccion`, índice de partidas válidas por fecha); idempotente, con reversión documentada.
- `ReglasRendimiento` (dominio): <40 REFUERZO; 40–60 inclusive REPASO; >60 APROBADO; sin partidas SIN DATOS; clasifica con el valor exacto (60,4 → APROBADO).
- Aulas: `PATCH /aulas/{id}` (nombre, descripción, grado, sección; el código no cambia), `POST /aulas/{id}/archivar` (eliminación lógica; conserva miembros y partidas), `AulaDto` con grado, sección y total de estudiantes.
- `GET /docente/resumen | estudiantes (búsqueda, aula, grado, rendimiento, orden, paginación) | estudiantes/{id}/estadisticas | .../actividad?anio&mes | .../materias/{id} | aulas/{id}/estadisticas`. Solo estudiantes activos de aulas activas propias; ajeno → 404 + auditoría `acceso_estudiante_no_autorizado`.
- Sin implementar (por decisión): bandeja de solicitudes y notificaciones.
- Pruebas: 44 unitarias; +9 de integración del módulo docente.
