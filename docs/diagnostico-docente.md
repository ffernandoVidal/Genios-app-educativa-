# Centro de Control Docente — diagnóstico (Fases 1 y 2)

Fecha: 2026-10-15. Solo inspección: no se ha modificado código ni Neon para este módulo.

## 1. Qué ya existe (verificado en el código y en el esquema real de Neon)

| Pieza del prompt | Estado | Evidencia | Decisión |
|---|---|---|---|
| Rol docente + login con Google | EXISTE | `AutenticacionController`, `/autenticacion/google`, rol `docente`, `DocentePorGoogleAbierto` (solo desarrollo) | Se reutiliza |
| Crear aula con código `Letra+4 dígitos` | EXISTE | `POST /aulas`; `aulas.codigo_acceso` UNIQUE + CHECK `^[A-Z][0-9]{4}$`; reintento ante colisión (5) | Se reutiliza. La unicidad es global (más estricta que «entre activas») |
| Código permanente al editar | EXISTE (no hay edición) | No hay `PATCH` | Basta con no regenerarlo al editar |
| Aulas del docente / aula ajena → 404 + auditoría | EXISTE | `GET /aulas/mi-aula`, `ExigirAulaDelDocenteAsync`, `acceso_aula_no_autorizado` | Se reutiliza |
| Alta de estudiante nuevo por el docente | EXISTE | `POST /aulas/{id}/estudiantes` + código de un solo uso + `/activar`; el docente nunca ve credenciales | Cumple §12 sin sala de padres; ver decisión 3 |
| Estadísticas por estudiante y por materia | EXISTE PARCIAL | `GET /aulas/{id}/estadisticas` (puntos, % primer intento, partidas, última actividad, por materia) | Se amplía |
| Ranking por aula y materia | EXISTE | `GET /aulas/ranking` | Se reutiliza (el prompt no lo pide; no se quita) |
| Panel docente Flutter | EXISTE PARCIAL | `/docente`: aulas, código, alta, lista, ranking, nuevo código. Sin menú lateral, sin cabina, sin gráficas | Se reconstruye con menú y secciones |
| Retirar estudiante | EXISTE (API) | `DELETE /aulas/{id}/estudiantes/{id}` (estado `retirado`, no borra historial) | Se reutiliza |
| Archivar aula | EXISTE EN ESQUEMA | `aulas.estado` (`activa/eliminada/suspendida`) y `eliminada_en`; sin endpoint | Endpoint nuevo, sin migración |
| Tiempo activo por partida | EXISTE | `partidas.tiempo_activo_ms` (CHECK ≥ 0), `finalizada_en` | Tiempo medio calculable hoy |
| Partida válida | EXISTE | `es_partida_valida` + CHECK: completada y ≥ 10 evaluadas | Base de todas las métricas |
| Primer intento vs reintentos | EXISTE | `preguntas_partida.primera_respuesta_correcta`, `intentos_respuesta` | Reintentos no alteran la nota |
| Fechas en UTC | EXISTE | `timestamptz` en todas las tablas | Conversión a America/Guatemala al presentar |

## 2. Qué NO existe o choca con el prompt

| Requisito | Problema real | Propuesta |
|---|---|---|
| **Aprobación del docente para unirse** (§11) | Hoy `POST /aulas/unirse` crea la membresía **directamente**. La tabla `solicitudes_aula` existe (`pendiente/aceptada/rechazada/cancelada`) pero ningún código la usa. Además tiene `UNIQUE(aula_id, estudiante_id)`: una solicitud rechazada impediría volver a pedir | Cambiar `unirse` para crear/reactivar la solicitud (reusando la fila rechazada o cancelada) y añadir aceptar/rechazar. **Cambia el flujo del estudiante** (ya construido y probado): requiere tu aprobación |
| Grado y sección de la clase (§8) | `aulas` no tiene `grado` ni `seccion` | Migración aditiva: 2 columnas nulas (`grado smallint` 1–6, `seccion varchar(10)`) |
| Materias de la clase (§8) | No hay relación aula–materia; hoy todo estudiante juega todas las materias | No es necesaria para estadísticas (salen de las partidas). Propongo **omitirla** en esta versión |
| Grado del estudiante (§13) | `perfiles_estudiante.grado_escolar` existe, pero nadie lo llena | Llenarlo al agregar estudiante (campo opcional) y, si falta, usar el grado del aula |
| Invitación de registro de un solo uso (§12) | El código de activación de un solo uso ya cubre el caso; no existe flujo de padres ni enlace | Reutilizar lo existente. Una invitación «sin cuenta previa» con enlace exigiría una tabla nueva: **no la propongo todavía** |
| Notificaciones (§6) | No hay tabla ni API | Solo contador de solicitudes pendientes (derivado de `solicitudes_aula`); sin bandeja de notificaciones |
| Misiones/lecciones completadas, lecciones pendientes (§14, §22) | El modelo vigente es asignatura → nivel → **categoría** (≈ lección). No hay tabla de misión ni lección | Misión = nivel; lección = categoría (mismo mapeo ya usado en el banco). «Completada» hoy = una partida terminada; «aprobada» = ≥ 7/10 válidas (se calcula en la consulta, sin cambiar el juego) |
| Temas/preguntas con más errores (§22) | Los datos existen (`preguntas_partida`) | Consulta nueva, sin migración |
| Calendario y gráfica por días (§17–18) | Datos existen (`finalizada_en`, `tiempo_activo_ms`) | Consultas nuevas agrupadas por día en America/Guatemala |
| Variación entre períodos (§21) | Calculable con dos rangos | Solo se muestra si ambos períodos tienen partidas |
| Docente «miembro autorizado» (§24) | Solo existe propietario (`aulas.docente_id`) | Se mantiene solo propietario |
| Paginación/búsqueda de alumnos (§13) | No existe | Parámetros `q`, `aulaId`, `grado`, `rendimiento`, `orden`, `pagina` en el servidor |
| Clasificación REFUERZO/REPASO/APROBADO (§15) | Existe `ReglasJuego.PorcentajeAciertos`; **no** la clasificación | Función de dominio única (`ReglasRendimiento`): < 40 → REFUERZO; 40–60 inclusive → REPASO; > 60 → APROBADO; sin partidas → SIN DATOS. Sin redondear antes de clasificar |
| Pruebas | EXISTEN | 31 unitarias + 37 de integración (Neon, con limpieza), 135 de Flutter | Se amplían |

Nota de coherencia: el prompt define APROBADO como «> 60 %» y 7/10 (70 %); con 10 preguntas no hay partidas con 61–69 %, así que coinciden. Para **promedios** sí pueden aparecer valores como 60,4 % (APROBADO).

## 3. Propuesta de migración (aditiva, NO aplicada)

```sql
-- 004_aulas_grado_seccion.sql  (rollback al final)
BEGIN;
ALTER TABLE aulas ADD COLUMN IF NOT EXISTS grado smallint CHECK (grado BETWEEN 1 AND 6);
ALTER TABLE aulas ADD COLUMN IF NOT EXISTS seccion varchar(10);
CREATE INDEX IF NOT EXISTS idx_partidas_valida_fecha ON partidas (usuario_id, finalizada_en) WHERE es_partida_valida;
COMMIT;
-- Reversión: DROP INDEX idx_partidas_valida_fecha; ALTER TABLE aulas DROP COLUMN seccion, DROP COLUMN grado;
```
Nada más. No se tocan usuarios, roles, partidas ni respuestas.

## 4. Plan por rebanadas (cada una con pruebas antes de pasar a la siguiente)

1. **Dominio y métricas:** `ReglasRendimiento` + pruebas 0/3/4/6/7/10 aciertos y promedios 39,9 / 40 / 60 / 60,4 / SIN DATOS.
2. **Aulas:** editar, archivar, grado/sección (con la migración 004), solicitudes pendientes.
3. **Solicitudes:** unirse → solicitud; aceptar/rechazar; duplicadas; rechazada no crea membresía.
4. **Alumnos:** listado paginado con búsqueda y filtros; ficha individual.
5. **Estadísticas:** por materia, gráfica de partidas por día, calendario, tiempo medio, nota media, variación, clase.
6. **Flutter:** menú lateral responsive (permanente / compacto / Drawer), cabina docente, secciones.
7. **Pruebas de autorización, responsive y verificación visual.**

## 5. Decisiones que necesito antes de programar

1. ¿Autorizas cambiar `POST /aulas/unirse` a «solicitud pendiente» con aprobación del docente? Es el único punto que altera el flujo del estudiante.
2. ¿Autorizas aplicar la migración aditiva 004 (grado, sección, índice)?
3. Para «registrar estudiante nuevo»: ¿se mantiene el código de activación de un solo uso (ya construido) como registro asistido, sin flujo de padres?
