# Contenido inicial — revisión de `002_contenido_inicial.sql`

**Estado:** NO aplicado en Neon (pendiente de aprobación). Todo es contenido de **PRUEBA / PROVISIONAL**.

## Qué carga
| Asignatura | Nivel | Categoría (orden) | Activa | Origen de las preguntas |
|---|---|---|---|---|
| Matemáticas | Nivel 1 [PRUEBA] | suma (1) | sí | generadas, rango 1–20 |
| Matemáticas | Nivel 1 [PRUEBA] | resta (2) | sí | generadas, rango 1–20 |
| Matemáticas | Nivel 1 [PRUEBA] | multiplicacion (3) | **no** | generadas, rango 2–9 |
| Matemáticas | Nivel 1 [PRUEBA] | division (4) | **no** | generadas, rango 2–9 |
| Lenguaje | Nivel 1 [PRUEBA] | ortografia_prueba (1) | sí | banco: 10 preguntas [PRUEBA] |
| Ciencias Sociales | — | — | — | **sin contenido** (pensum pendiente) |
| Ciencias Naturales | — | — | — | **sin contenido** (pensum pendiente) |

Totales (verificados en una ejecución en seco): 2 niveles, 5 categorías (3 activas), 4 reglas de generación, 10 preguntas, 30 opciones, 10 claves.

## Cómo se identifica lo provisional
- Niveles: nombre `Nivel 1 [PRUEBA]`.
- Reglas de generación: nombre `... [PRUEBA]` y `parametros.provisional = true` (los rangos numéricos NO son el pensum).
- Categorías de Matemáticas: descripción `Rango numerico PROVISIONAL`.
- Preguntas de Lenguaje: `fuente = 'PRUEBA'`, código `prueba_ortografia_N` y enunciado con `[PRUEBA]`.

## Relaciones (todas con claves foráneas existentes)
`asignaturas 1─N niveles_educativos 1─N categorias 1─N {reglas_generacion_preguntas, preguntas}`;
`preguntas 1─N opciones_pregunta`, `preguntas 1─1 claves_respuesta` (clave = `{"opcionId": <id de la opción correcta>}`).
Las claves viven solo en el servidor; la API nunca las devuelve.

## Idempotencia (comprobada)
Cada fila se protege con su clave natural: niveles `(asignatura, orden)`, categorías `(nivel, código)`, reglas `(categoría, código, versión)` con `ON CONFLICT DO NOTHING`; las preguntas se omiten si ya existe `(categoría, código)`. Ejecutado dos veces en la misma transacción dio los mismos conteos en ambas. No modifica ni borra filas existentes. Reversión: ver cabecera del script.

## Progresión (PROPUESTA, implementada)
En cada nivel, la primera categoría activa está abierta y cada siguiente se abre cuando el jugador tiene una partida **completada** de la anterior. El servidor lo exige al crear la partida (`categoria_bloqueada`) y lo informa en el listado de categorías. "Completada" no significa "aprobada": el porcentaje del primer intento se guarda aparte.

## Pendiente de decisión
1. Qué temas definitivos forman "dos temas por materia" en cada asignatura.
2. Reglas para abrir multiplicación y división (hoy inactivas).
3. Contenido y pensum de Ciencias Sociales y Ciencias Naturales.
4. Rangos numéricos definitivos de Matemáticas.
