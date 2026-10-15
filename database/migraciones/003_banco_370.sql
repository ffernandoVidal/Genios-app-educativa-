-- ============================================================================
-- GENIOS - Banco educativo V1 (370 preguntas) - GENERADO por tools/banco/importar_banco.py
-- Fuente: data/educational/preguntas_genios_consolidado_370.json
--
-- SOLO DATOS: no cambia el esquema. Idempotente: cada fila se protege con su clave natural
-- (ON CONFLICT DO NOTHING / NOT EXISTS). Se puede ejecutar varias veces; la segunda vez no cambia nada.
-- No modifica ni borra filas existentes ni respuestas históricas.
--
-- ESTADO PEDAGÓGICO: preguntas con fuente = 'GENIOS_BANCO_370_V1', PENDIENTES de revisión curricular (CNB Guatemala).
-- Mapeo (propuesto, requiere aprobación): asignatura -> «Nivel 1» -> categoría (una por category_code).
--
-- Reversión (solo si no hay partidas sobre estas categorías):
--   DELETE FROM claves_respuesta WHERE pregunta_id IN (SELECT id FROM preguntas WHERE fuente = 'GENIOS_BANCO_370_V1');
--   DELETE FROM opciones_pregunta WHERE pregunta_id IN (SELECT id FROM preguntas WHERE fuente = 'GENIOS_BANCO_370_V1');
--   DELETE FROM preguntas WHERE fuente = 'GENIOS_BANCO_370_V1';
--   DELETE FROM categorias WHERE codigo IN (<códigos MAT-/LEN-/NAT-/SOC- del banco>) AND id NOT IN (SELECT categoria_id FROM preguntas);
-- ============================================================================
BEGIN;

-- Matemáticas
INSERT INTO niveles_educativos (asignatura_id, nombre, numero_orden)
SELECT id, 'Nivel 1', 1 FROM asignaturas WHERE codigo = 'MATEMATICAS'
ON CONFLICT (asignatura_id, numero_orden) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'MAT-MULT', 'Multiplicaciones', 'Grado 5', 1, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'MATEMATICAS' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'MAT-FRAC', 'Fracciones', 'Grado 5', 2, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'MATEMATICAS' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'MAT-DEC', 'Los números decimales', 'Grado 5', 3, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'MATEMATICAS' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'MAT-TIEM', 'Tiempo y dinero', 'Grado 5', 4, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'MATEMATICAS' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'MAT-GEOM', 'Rectas y ángulos', 'Grado 5', 5, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'MATEMATICAS' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'MAT-PLAN', 'Figuras planas', 'Grado 5 · misión 8 del banco', 6, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'MATEMATICAS' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'MAT-CUER', 'Los cuerpos geométricos', 'Grado 5 · misión 9 del banco', 7, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'MATEMATICAS' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'MAT-EST', 'Estadística', 'Grado 5 · misión 10 del banco', 8, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'MATEMATICAS' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
-- Comunicación y Lenguaje
INSERT INTO niveles_educativos (asignatura_id, nombre, numero_orden)
SELECT id, 'Nivel 1', 1 FROM asignaturas WHERE codigo = 'LENGUAJE'
ON CONFLICT (asignatura_id, numero_orden) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'LEN-ACEN', 'Acentuación', 'Grado 5', 1, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'LENGUAJE' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'LEN-ORT', 'Ortografía: b y v', 'Grado 5', 2, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'LENGUAJE' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'LEN-ORT2', 'Ortografía (II)', 'Grado 5 · misión 3 del banco', 3, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'LENGUAJE' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'LEN-TIP', 'Tipos de palabras', 'Grado 5 · misión 4 del banco', 4, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'LENGUAJE' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'LEN-PREF', 'Prefijos y sufijos', 'Grado 5 · misión 5 del banco', 5, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'LENGUAJE' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'LEN-SUST', 'Sustantivos, adjetivos y adverbios', 'Grado 5 · misión 6 del banco', 6, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'LENGUAJE' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'LEN-PRON', 'Pronombres y determinantes', 'Grado 5 · misión 7 del banco', 7, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'LENGUAJE' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'LEN-VERB', 'El verbo', 'Grado 5 · misión 8 del banco', 8, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'LENGUAJE' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'LEN-ORAC', 'La oración', 'Grado 5 · misión 9 del banco', 9, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'LENGUAJE' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'LEN-CONJ', 'Preposiciones, conjunciones e interjecciones', 'Grado 5 · misión 10 del banco', 10, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'LENGUAJE' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
-- Ciencias Naturales
INSERT INTO niveles_educativos (asignatura_id, nombre, numero_orden)
SELECT id, 'Nivel 1', 1 FROM asignaturas WHERE codigo = 'CIENCIAS_NATURALES'
ON CONFLICT (asignatura_id, numero_orden) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'NAT-VIVOS', 'Los seres vivos', 'Grado 5', 1, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_NATURALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'NAT-SALUD', 'Nuestra salud', 'Grado 5', 2, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_NATURALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'NAT-PLANT', 'Las plantas', 'Grado 5 · misión 4 del banco', 3, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_NATURALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'NAT-ECO', 'Los ecosistemas', 'Grado 5 · misión 5 del banco', 4, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_NATURALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'NAT-BIOS', 'La biosfera', 'Grado 5 · misión 6 del banco', 5, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_NATURALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'NAT-MAT', 'La materia', 'Grado 5 · misión 7 del banco', 6, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_NATURALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'NAT-ENER', 'La energía', 'Grado 5 · misión 8 del banco', 7, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_NATURALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'NAT-ELEC', 'Electricidad y magnetismo', 'Grado 5 · misión 9 del banco', 8, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_NATURALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'NAT-MAQ', 'Las máquinas', 'Grado 5 · misión 10 del banco', 9, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_NATURALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
-- Ciencias Sociales
INSERT INTO niveles_educativos (asignatura_id, nombre, numero_orden)
SELECT id, 'Nivel 1', 1 FROM asignaturas WHERE codigo = 'CIENCIAS_SOCIALES'
ON CONFLICT (asignatura_id, numero_orden) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'SOC-GEO', 'Geografía de Guatemala', 'Grado 5', 1, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_SOCIALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'SOC-MAYA', 'Civilización Maya y período prehispánico', 'Grado 6', 2, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_SOCIALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'SOC-UNIV', 'El universo', 'Grado 5 · misión 1 del banco', 3, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_SOCIALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'SOC-TIER', 'La Tierra', 'Grado 5 · misión 2 del banco', 4, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_SOCIALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'SOC-CLIM', 'El clima de Guatemala', 'Grado 5 · misión 3 del banco', 5, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_SOCIALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'SOC-POBL', 'La población', 'Grado 5 · misión 5 del banco', 6, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_SOCIALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'SOC-ECON', 'Sectores económicos de Guatemala', 'Grado 5 · misión 6 del banco', 7, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_SOCIALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'SOC-COL', 'Conquista y época colonial', 'Grado 6 · misión 8 del banco', 8, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_SOCIALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'SOC-INDEP', 'Independencia de Guatemala', 'Grado 6 · misión 9 del banco', 9, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_SOCIALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
SELECT n.id, 'SOC-MODER', 'Guatemala moderna y contemporánea', 'Grado 6 · misión 10 del banco', 10, TRUE
FROM niveles_educativos n JOIN asignaturas a ON a.id = n.asignatura_id
WHERE a.codigo = 'CIENCIAS_SOCIALES' AND n.numero_orden = 1
ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;

-- MAT-MULT-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-MULT-01', 'opcion_multiple', '¿Cuánto es 7 × 8?', '7 grupos de 8 equivalen a 56.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-MULT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-MULT-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-01-1', '54', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-01-2', '56', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-01-3', '58', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-01-4', '64', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '7 grupos de 8 equivalen a 56.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-MULT-01-2'
WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-MULT-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-MULT-02', 'opcion_multiple', '¿Cuánto es 12 × 6?', '12 multiplicado por 6 es 72.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-MULT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-MULT-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-02-1', '62', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-02-2', '68', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-02-3', '72', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-02-4', '76', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '12 multiplicado por 6 es 72.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-MULT-02-3'
WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-MULT-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-MULT-03', 'opcion_multiple', '¿Cuánto es 9 × 9?', '9 grupos de 9 equivalen a 81.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-MULT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-MULT-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-03-1', '72', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-03-2', '81', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-03-3', '90', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-03-4', '99', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '9 grupos de 9 equivalen a 81.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-MULT-03-2'
WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-MULT-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-MULT-04', 'opcion_multiple', '¿Cuánto es 15 × 4?', '15 + 15 + 15 + 15 = 60.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-MULT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-MULT-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-04-1', '45', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-04-2', '50', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-04-3', '60', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-04-4', '75', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '15 + 15 + 15 + 15 = 60.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-MULT-04-3'
WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-MULT-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-MULT-05', 'opcion_multiple', '¿Cuánto es 23 × 3?', '20 × 3 = 60 y 3 × 3 = 9.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-MULT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-MULT-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-05-1', '63', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-05-2', '66', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-05-3', '69', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-05-4', '72', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '20 × 3 = 60 y 3 × 3 = 9.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-MULT-05-3'
WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-MULT-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-MULT-06', 'opcion_multiple', 'Una caja tiene 12 lápices. ¿Cuántos hay en 7 cajas?', '12 × 7 = 84.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-MULT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-MULT-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-06-1', '72', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-06-2', '82', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-06-3', '84', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-06-4', '96', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '12 × 7 = 84.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-MULT-06-3'
WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-MULT-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-MULT-07', 'opcion_multiple', '¿Cuánto es 25 × 12?', '25 × (10 + 2) = 250 + 50.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-MULT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-MULT-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-07-1', '250', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-07-2', '275', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-07-3', '300', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-07-4', '325', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '25 × (10 + 2) = 250 + 50.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-MULT-07-3'
WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-MULT-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-MULT-08', 'opcion_multiple', '¿Qué propiedad muestra 6 × 4 = 4 × 6?', 'Cambiar el orden de los factores no altera el producto.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-MULT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-MULT-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-08-1', 'Asociativa', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-08-2', 'Conmutativa', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-08-3', 'Distributiva', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-08-4', 'Elemento neutro', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Cambiar el orden de los factores no altera el producto.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-MULT-08-2'
WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-MULT-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-MULT-09', 'opcion_multiple', '¿Cuánto es 104 × 5?', '100 × 5 + 4 × 5 = 520.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-MULT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-MULT-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-09-1', '500', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-09-2', '510', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-09-3', '520', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-09-4', '540', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '100 × 5 + 4 × 5 = 520.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-MULT-09-3'
WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-MULT-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-MULT-10', 'opcion_multiple', 'En una escuela hay 18 aulas con 24 sillas cada una. ¿Cuántas sillas hay?', '18 × 24 = 432.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-MULT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-MULT-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-10-1', '412', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-10-2', '422', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-10-3', '432', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-MULT-10-4', '442', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '18 × 24 = 432.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-MULT-10-3'
WHERE c.codigo = 'MAT-MULT' AND p.codigo = 'MAT-MULT-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-FRAC-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-FRAC-01', 'opcion_multiple', '¿Qué fracción representa una de cuatro partes iguales?', 'Una parte de cuatro es un cuarto.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-FRAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-FRAC-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-01-1', '1/2', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-01-2', '1/3', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-01-3', '1/4', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-01-4', '4/1', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Una parte de cuatro es un cuarto.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-FRAC-01-3'
WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-FRAC-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-FRAC-02', 'opcion_multiple', '¿Cuál es el numerador de 3/7?', 'El numerador es el número superior.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-FRAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-FRAC-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-02-1', '3', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-02-2', '7', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-02-3', '10', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-02-4', '4', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El numerador es el número superior.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-FRAC-02-1'
WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-FRAC-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-FRAC-03', 'opcion_multiple', '¿Qué fracción es equivalente a 1/2?', 'Multiplicar numerador y denominador por 2 produce 2/4.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-FRAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-FRAC-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-03-1', '1/3', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-03-2', '2/4', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-03-3', '3/5', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-03-4', '2/3', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Multiplicar numerador y denominador por 2 produce 2/4.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-FRAC-03-2'
WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-FRAC-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-FRAC-04', 'opcion_multiple', '¿Cuánto es 1/4 + 2/4?', 'Con denominadores iguales se suman los numeradores.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-FRAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-FRAC-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-04-1', '2/8', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-04-2', '3/4', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-04-3', '3/8', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-04-4', '1/2', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Con denominadores iguales se suman los numeradores.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-FRAC-04-2'
WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-FRAC-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-FRAC-05', 'opcion_multiple', '¿Qué fracción es mayor?', 'Entre fracciones unitarias, el menor denominador indica mayor tamaño.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-FRAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-FRAC-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-05-1', '1/5', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-05-2', '1/4', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-05-3', '1/3', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-05-4', '1/6', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Entre fracciones unitarias, el menor denominador indica mayor tamaño.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-FRAC-05-3'
WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-FRAC-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-FRAC-06', 'opcion_multiple', '¿Cuánto es 5/6 − 2/6?', '5 sextos menos 2 sextos son 3 sextos.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-FRAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-FRAC-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-06-1', '3/6', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-06-2', '3/12', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-06-3', '7/6', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-06-4', '2/6', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '5 sextos menos 2 sextos son 3 sextos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-FRAC-06-1'
WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-FRAC-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-FRAC-07', 'opcion_multiple', '¿Cuánto es 1/2 de 18?', '18 dividido entre 2 es 9.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-FRAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-FRAC-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-07-1', '6', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-07-2', '8', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-07-3', '9', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-07-4', '12', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '18 dividido entre 2 es 9.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-FRAC-07-3'
WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-FRAC-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-FRAC-08', 'opcion_multiple', '¿Cuál es la forma simplificada de 6/8?', 'Dividimos numerador y denominador entre 2.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-FRAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-FRAC-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-08-1', '2/3', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-08-2', '3/4', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-08-3', '4/6', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-08-4', '1/2', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Dividimos numerador y denominador entre 2.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-FRAC-08-2'
WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-FRAC-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-FRAC-09', 'opcion_multiple', '¿Cuánto es 2/3 × 3/4?', 'El producto 6/12 se simplifica a 1/2.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-FRAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-FRAC-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-09-1', '1/2', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-09-2', '5/7', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-09-3', '6/7', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-09-4', '2/7', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El producto 6/12 se simplifica a 1/2.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-FRAC-09-1'
WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-FRAC-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-FRAC-10', 'opcion_multiple', 'Una pizza se divide en 8 porciones y se comen 3. ¿Qué fracción queda?', 'Quedan 8 − 3 = 5 porciones de 8.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-FRAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-FRAC-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-10-1', '3/8', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-10-2', '4/8', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-10-3', '5/8', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-FRAC-10-4', '6/8', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Quedan 8 − 3 = 5 porciones de 8.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-FRAC-10-3'
WHERE c.codigo = 'MAT-FRAC' AND p.codigo = 'MAT-FRAC-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ACEN-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ACEN-01', 'opcion_multiple', '¿Cuál palabra es aguda?', 'La fuerza de voz está en la última sílaba.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ACEN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ACEN-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-01-1', 'árbol', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-01-2', 'canción', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-01-3', 'lápiz', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-01-4', 'música', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La fuerza de voz está en la última sílaba.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ACEN-01-2'
WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ACEN-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ACEN-02', 'opcion_multiple', '¿Cuál palabra es esdrújula?', 'La sílaba tónica es la antepenúltima.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ACEN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ACEN-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-02-1', 'camino', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-02-2', 'reloj', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-02-3', 'pájaro', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-02-4', 'papel', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La sílaba tónica es la antepenúltima.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ACEN-02-3'
WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ACEN-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ACEN-03', 'opcion_multiple', '¿Cuál palabra es llana o grave?', 'La sílaba tónica de mesa es la penúltima.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ACEN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ACEN-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-03-1', 'mesa', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-03-2', 'café', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-03-3', 'compás', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-03-4', 'corazón', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La sílaba tónica de mesa es la penúltima.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ACEN-03-1'
WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ACEN-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ACEN-04', 'opcion_multiple', '¿Cuál palabra lleva tilde correctamente?', 'Es llana terminada en consonante distinta de n o s.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ACEN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ACEN-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-04-1', 'arbol', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-04-2', 'árbol', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-04-3', 'arból', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-04-4', 'árbòl', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Es llana terminada en consonante distinta de n o s.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ACEN-04-2'
WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ACEN-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ACEN-05', 'opcion_multiple', '¿Cuál de estas palabras es aguda y termina en vocal?', 'Las agudas terminadas en vocal llevan tilde.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ACEN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ACEN-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-05-1', 'sofá', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-05-2', 'árbol', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-05-3', 'túnel', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-05-4', 'lápiz', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las agudas terminadas en vocal llevan tilde.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ACEN-05-1'
WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ACEN-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ACEN-06', 'opcion_multiple', '¿Qué palabra contiene un hiato?', 'La vocal cerrada tónica í rompe el diptongo.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ACEN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ACEN-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-06-1', 'tierra', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-06-2', 'ciudad', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-06-3', 'país', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-06-4', 'fuerte', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La vocal cerrada tónica í rompe el diptongo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ACEN-06-3'
WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ACEN-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ACEN-07', 'opcion_multiple', '¿Qué palabra contiene un diptongo?', 'La combinación ai se pronuncia en una sola sílaba.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ACEN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ACEN-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-07-1', 'poeta', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-07-2', 'teatro', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-07-3', 'aire', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-07-4', 'país', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La combinación ai se pronuncia en una sola sílaba.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ACEN-07-3'
WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ACEN-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ACEN-08', 'opcion_multiple', '¿Qué opción usa tilde diacrítica correctamente?', 'Tú es pronombre personal y mi es posesivo.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ACEN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ACEN-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-08-1', 'Tu tienes mi libro.', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-08-2', 'Tú tienes mi libro.', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-08-3', 'Tú tienes mí libro.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-08-4', 'Tu tienes mí libro.', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Tú es pronombre personal y mi es posesivo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ACEN-08-2'
WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ACEN-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ACEN-09', 'opcion_multiple', '¿Qué pregunta está escrita correctamente?', 'Los interrogativos cómo y la palabra estás llevan tilde.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ACEN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ACEN-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-09-1', '¿Como estas?', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-09-2', '¿Cómo estás?', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-09-3', '¿Cómo estas?', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-09-4', '¿Como estás?', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los interrogativos cómo y la palabra estás llevan tilde.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ACEN-09-2'
WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ACEN-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ACEN-10', 'opcion_multiple', '¿Qué palabra está acentuada correctamente?', 'Es palabra esdrújula y lleva tilde en la antepenúltima sílaba.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ACEN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ACEN-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-10-1', 'matematicas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-10-2', 'matemátícas', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-10-3', 'matemáticas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ACEN-10-4', 'matematicás', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Es palabra esdrújula y lleva tilde en la antepenúltima sílaba.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ACEN-10-3'
WHERE c.codigo = 'LEN-ACEN' AND p.codigo = 'LEN-ACEN-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT-01', 'opcion_multiple', '¿Cuál palabra está escrita correctamente?', 'El nombre del animal se escribe vaca, con v.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-01-1', 'baca (animal)', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-01-2', 'vaca (animal)', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-01-3', 'vakka (animal)', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-01-4', 'vaca (con b)', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El nombre del animal se escribe vaca, con v.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT-01-2'
WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT-02', 'opcion_multiple', '¿Cómo se escribe el medio de transporte?', 'Avión se escribe con v y tilde en la o.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-02-1', 'avión', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-02-2', 'abión', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-02-3', 'havión', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-02-4', 'avíon', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Avión se escribe con v y tilde en la o.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT-02-1'
WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT-03', 'opcion_multiple', '¿Cuál es la forma correcta?', 'Biblioteca se escribe con b en ambas posiciones.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-03-1', 'biblioteca', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-03-2', 'viblioteca', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-03-3', 'bivlioteca', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-03-4', 'vivlioteca', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Biblioteca se escribe con b en ambas posiciones.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT-03-1'
WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT-04', 'opcion_multiple', '¿Qué palabra nombra un color y está bien escrita?', 'Verde comienza con v.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-04-1', 'berde', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-04-2', 'verde', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-04-3', 'vherde', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-04-4', 'berrde', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Verde comienza con v.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT-04-2'
WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT-05', 'opcion_multiple', '¿Cuál es la escritura correcta del verbo?', 'Escribir termina en -bir.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-05-1', 'escrivir', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-05-2', 'escribir', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-05-3', 'escríbir', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-05-4', 'ezcribir', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Escribir termina en -bir.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT-05-2'
WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT-06', 'opcion_multiple', '¿Cuál palabra está bien escrita?', 'Invierno se escribe con v.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-06-1', 'inbierno', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-06-2', 'inviermo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-06-3', 'invierno', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-06-4', 'imbierno', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Invierno se escribe con v.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT-06-3'
WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT-07', 'opcion_multiple', 'Completa: «El barco ___ por el lago».', 'Navega se escribe con v.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-07-1', 'navega', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-07-2', 'nabega', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-07-3', 'navega con b', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-07-4', 'nabegha', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Navega se escribe con v.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT-07-1'
WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT-08', 'opcion_multiple', '¿Cuál es la forma correcta?', 'El sufijo -bilidad se escribe generalmente con b.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-08-1', 'amavilidad', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-08-2', 'amabilidad', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-08-3', 'hamabilidad', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-08-4', 'amavilidád', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El sufijo -bilidad se escribe generalmente con b.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT-08-2'
WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT-09', 'opcion_multiple', '¿Cuál palabra está escrita correctamente?', 'Nuevo se escribe con v.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-09-1', 'nuebo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-09-2', 'nuevo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-09-3', 'nuevbo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-09-4', 'nuehvo', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Nuevo se escribe con v.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT-09-2'
WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT-10', 'opcion_multiple', '¿Cuál oración tiene ortografía correcta?', 'El verbo beber se escribe con b.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-10-1', 'El niño be vio.', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-10-2', 'El niño bebió agua.', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-10-3', 'El niño vevió agua.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT-10-4', 'El niño bevió agua.', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El verbo beber se escribe con b.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT-10-2'
WHERE c.codigo = 'LEN-ORT' AND p.codigo = 'LEN-ORT-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-VIVOS-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-VIVOS-01', 'opcion_multiple', '¿Cuál de los siguientes es un ser vivo?', 'Los árboles realizan funciones vitales.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-VIVOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-VIVOS-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-01-1', 'Roca', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-01-2', 'Árbol', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-01-3', 'Mesa', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-01-4', 'Agua', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los árboles realizan funciones vitales.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-VIVOS-01-2'
WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-VIVOS-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-VIVOS-02', 'opcion_multiple', '¿Cuál es la unidad básica de los seres vivos?', 'La célula es la unidad estructural y funcional básica.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-VIVOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-VIVOS-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-02-1', 'Órgano', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-02-2', 'Tejido', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-02-3', 'Célula', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-02-4', 'Sistema', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La célula es la unidad estructural y funcional básica.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-VIVOS-02-3'
WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-VIVOS-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-VIVOS-03', 'opcion_multiple', '¿Qué necesitan las plantas para realizar fotosíntesis?', 'La luz aporta energía para la fotosíntesis.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-VIVOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-VIVOS-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-03-1', 'Luz', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-03-2', 'Plástico', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-03-3', 'Arena seca únicamente', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-03-4', 'Humo', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La luz aporta energía para la fotosíntesis.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-VIVOS-03-1'
WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-VIVOS-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-VIVOS-04', 'opcion_multiple', '¿Cuál es una función vital?', 'La nutrición permite obtener materia y energía.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-VIVOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-VIVOS-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-04-1', 'Nutrición', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-04-2', 'Pintura', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-04-3', 'Construcción', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-04-4', 'Programación', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La nutrición permite obtener materia y energía.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-VIVOS-04-1'
WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-VIVOS-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-VIVOS-05', 'opcion_multiple', '¿Cuál organismo es un hongo?', 'El champiñón pertenece al reino de los hongos.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-VIVOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-VIVOS-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-05-1', 'Mariposa', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-05-2', 'Champiñón', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-05-3', 'Pino', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-05-4', 'Pez', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El champiñón pertenece al reino de los hongos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-VIVOS-05-2'
WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-VIVOS-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-VIVOS-06', 'opcion_multiple', '¿Cuál nivel organiza células semejantes que trabajan juntas?', 'Un tejido es un conjunto de células especializadas.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-VIVOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-VIVOS-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-06-1', 'Tejido', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-06-2', 'Ecosistema', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-06-3', 'Población', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-06-4', 'Planeta', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Un tejido es un conjunto de células especializadas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-VIVOS-06-1'
WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-VIVOS-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-VIVOS-07', 'opcion_multiple', '¿Qué estructura de la célula contiene generalmente el ADN de las células animales?', 'En las células animales, el núcleo contiene la mayor parte del ADN.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-VIVOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-VIVOS-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-07-1', 'Pared celular', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-07-2', 'Núcleo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-07-3', 'Cloroplasto', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-07-4', 'Vacuola central', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'En las células animales, el núcleo contiene la mayor parte del ADN.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-VIVOS-07-2'
WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-VIVOS-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-VIVOS-08', 'opcion_multiple', '¿Qué característica comparten todos los seres vivos?', 'Los seres vivos poseen organización celular.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-VIVOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-VIVOS-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-08-1', 'Están hechos de células', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-08-2', 'Pueden volar', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-08-3', 'Tienen cuatro patas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-08-4', 'Producen su propia luz', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los seres vivos poseen organización celular.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-VIVOS-08-1'
WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-VIVOS-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-VIVOS-09', 'opcion_multiple', '¿Qué organismos producen su propio alimento mediante fotosíntesis?', 'Las plantas verdes usan energía solar para producir azúcares.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-VIVOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-VIVOS-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-09-1', 'Plantas verdes', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-09-2', 'Leones', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-09-3', 'Hongos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-09-4', 'Lombrices', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las plantas verdes usan energía solar para producir azúcares.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-VIVOS-09-1'
WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-VIVOS-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-VIVOS-10', 'opcion_multiple', '¿Cuál secuencia va de menor a mayor organización biológica?', 'Las células forman tejidos; los tejidos, órganos; y los órganos, sistemas.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-VIVOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-VIVOS-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-10-1', 'Órgano, tejido, célula, sistema', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-10-2', 'Célula, tejido, órgano, sistema', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-10-3', 'Sistema, célula, tejido, órgano', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-VIVOS-10-4', 'Tejido, sistema, célula, órgano', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las células forman tejidos; los tejidos, órganos; y los órganos, sistemas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-VIVOS-10-2'
WHERE c.codigo = 'NAT-VIVOS' AND p.codigo = 'NAT-VIVOS-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-SALUD-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-SALUD-01', 'opcion_multiple', '¿Qué hábito ayuda a prevenir enfermedades?', 'La higiene de manos ayuda a reducir el contagio.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-SALUD'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-SALUD-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-01-1', 'No lavarse las manos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-01-2', 'Lavarse las manos con jabón', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-01-3', 'Compartir cepillos dentales', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-01-4', 'Dormir muy poco', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La higiene de manos ayuda a reducir el contagio.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-SALUD-01-2'
WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-SALUD-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-SALUD-02', 'opcion_multiple', '¿Qué nutriente es una fuente importante de energía?', 'Los carbohidratos son una fuente habitual de energía.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-SALUD'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-SALUD-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-02-1', 'Carbohidratos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-02-2', 'Piedras', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-02-3', 'Plástico', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-02-4', 'Arena', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los carbohidratos son una fuente habitual de energía.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-SALUD-02-1'
WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-SALUD-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-SALUD-03', 'opcion_multiple', '¿Qué bebida es recomendable para hidratarse normalmente?', 'El agua potable ayuda a mantener la hidratación.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-SALUD'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-SALUD-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-03-1', 'Agua potable', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-03-2', 'Bebida energética', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-03-3', 'Refresco azucarado', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-03-4', 'Café muy cargado', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El agua potable ayuda a mantener la hidratación.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-SALUD-03-1'
WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-SALUD-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-SALUD-04', 'opcion_multiple', '¿Qué actividad favorece la salud?', 'Mover el cuerpo regularmente favorece la salud.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-SALUD'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-SALUD-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-04-1', 'Permanecer sentado todo el día', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-04-2', 'Actividad física regular', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-04-3', 'Saltarse siempre comidas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-04-4', 'No descansar', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Mover el cuerpo regularmente favorece la salud.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-SALUD-04-2'
WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-SALUD-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-SALUD-05', 'opcion_multiple', '¿Qué protege los dientes?', 'El cepillado con flúor ayuda a prevenir caries.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-SALUD'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-SALUD-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-05-1', 'Cepillarlos con pasta dental fluorada', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-05-2', 'Comer dulces todo el día', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-05-3', 'Nunca cepillarlos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-05-4', 'Morder objetos duros', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El cepillado con flúor ayuda a prevenir caries.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-SALUD-05-1'
WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-SALUD-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-SALUD-06', 'opcion_multiple', '¿Para qué sirven las vacunas?', 'Entrenan al sistema inmunitario contra enfermedades específicas.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-SALUD'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-SALUD-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-06-1', 'Para sustituir todos los alimentos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-06-2', 'Para prevenir ciertas enfermedades infecciosas', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-06-3', 'Para curar cualquier golpe', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-06-4', 'Para evitar dormir', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Entrenan al sistema inmunitario contra enfermedades específicas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-SALUD-06-2'
WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-SALUD-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-SALUD-07', 'opcion_multiple', '¿Qué acción es adecuada ante fiebre persistente?', 'Los síntomas persistentes requieren valoración profesional.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-SALUD'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-SALUD-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-07-1', 'Automedicarse con antibióticos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-07-2', 'Consultar a un adulto responsable y personal de salud', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-07-3', 'Ignorar siempre los síntomas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-07-4', 'Tomar medicamentos de otra persona', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los síntomas persistentes requieren valoración profesional.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-SALUD-07-2'
WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-SALUD-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-SALUD-08', 'opcion_multiple', '¿Cuál opción describe una alimentación variada?', 'La variedad ayuda a aportar nutrientes diferentes.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-SALUD'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-SALUD-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-08-1', 'Comer un solo alimento', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-08-2', 'Consumir distintos grupos de alimentos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-08-3', 'Beber únicamente gaseosas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-08-4', 'Evitar siempre frutas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La variedad ayuda a aportar nutrientes diferentes.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-SALUD-08-2'
WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-SALUD-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-SALUD-09', 'opcion_multiple', '¿Cuál es una forma adecuada de reducir contagios respiratorios?', 'La etiqueta respiratoria disminuye la dispersión de gotas.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-SALUD'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-SALUD-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-09-1', 'Toser sin cubrirse', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-09-2', 'Cubrirse al toser con el antebrazo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-09-3', 'Compartir pañuelos usados', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-09-4', 'No ventilar espacios', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La etiqueta respiratoria disminuye la dispersión de gotas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-SALUD-09-2'
WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-SALUD-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-SALUD-10', 'opcion_multiple', '¿Por qué es importante dormir lo suficiente?', 'El sueño favorece procesos de recuperación, memoria y atención.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-SALUD'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-SALUD-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-10-1', 'Ayuda al descanso y aprendizaje', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-10-2', 'Sustituye beber agua', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-10-3', 'Evita la necesidad de alimentarse', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-SALUD-10-4', 'Hace innecesario el ejercicio', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El sueño favorece procesos de recuperación, memoria y atención.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-SALUD-10-1'
WHERE c.codigo = 'NAT-SALUD' AND p.codigo = 'NAT-SALUD-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-GEO-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-GEO-01', 'opcion_multiple', '¿Cuál es la capital de Guatemala?', 'La Ciudad de Guatemala es la capital del país.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-GEO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-GEO-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-01-1', 'Quetzaltenango', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-01-2', 'Ciudad de Guatemala', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-01-3', 'Escuintla', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-01-4', 'Antigua Guatemala', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La Ciudad de Guatemala es la capital del país.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-GEO-01-2'
WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-GEO-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-GEO-02', 'opcion_multiple', '¿Cuántos departamentos tiene Guatemala?', 'Guatemala está dividida administrativamente en 22 departamentos.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-GEO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-GEO-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-02-1', '18', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-02-2', '20', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-02-3', '22', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-02-4', '24', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Guatemala está dividida administrativamente en 22 departamentos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-GEO-02-3'
WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-GEO-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-GEO-03', 'opcion_multiple', '¿En qué región de América se ubica Guatemala?', 'Guatemala forma parte de Centroamérica.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-GEO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-GEO-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-03-1', 'América del Sur', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-03-2', 'América Central', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-03-3', 'América del Norte ártica', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-03-4', 'El Caribe insular', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Guatemala forma parte de Centroamérica.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-GEO-03-2'
WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-GEO-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-GEO-04', 'opcion_multiple', '¿Qué océano limita con la costa sur de Guatemala?', 'La costa sur guatemalteca se encuentra sobre el océano Pacífico.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-GEO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-GEO-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-04-1', 'Atlántico', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-04-2', 'Índico', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-04-3', 'Pacífico', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-04-4', 'Ártico', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La costa sur guatemalteca se encuentra sobre el océano Pacífico.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-GEO-04-3'
WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-GEO-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-GEO-05', 'opcion_multiple', '¿Qué país limita al norte y al oeste con Guatemala?', 'México comparte fronteras al norte y oeste de Guatemala.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-GEO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-GEO-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-05-1', 'Honduras', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-05-2', 'El Salvador', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-05-3', 'Belice', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-05-4', 'México', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'México comparte fronteras al norte y oeste de Guatemala.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-GEO-05-4'
WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-GEO-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-GEO-06', 'opcion_multiple', '¿Cuál es un departamento de Guatemala?', 'Petén es uno de los 22 departamentos guatemaltecos.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-GEO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-GEO-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-06-1', 'Petén', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-06-2', 'Yucatán', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-06-3', 'Chiapas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-06-4', 'San Salvador', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Petén es uno de los 22 departamentos guatemaltecos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-GEO-06-1'
WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-GEO-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-GEO-07', 'opcion_multiple', '¿En qué departamento se encuentra el lago de Atitlán?', 'El lago de Atitlán se ubica en el departamento de Sololá.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-GEO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-GEO-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-07-1', 'Petén', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-07-2', 'Sololá', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-07-3', 'Izabal', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-07-4', 'Jalapa', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El lago de Atitlán se ubica en el departamento de Sololá.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-GEO-07-2'
WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-GEO-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-GEO-08', 'opcion_multiple', '¿Cuál es el punto más alto de Guatemala?', 'El volcán Tajumulco es la elevación más alta de Guatemala.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-GEO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-GEO-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-08-1', 'Volcán de Agua', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-08-2', 'Volcán Tajumulco', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-08-3', 'Volcán Pacaya', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-08-4', 'Cerro Alux', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El volcán Tajumulco es la elevación más alta de Guatemala.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-GEO-08-2'
WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-GEO-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-GEO-09', 'opcion_multiple', '¿Con qué cuerpo de agua tiene Guatemala una costa en el este?', 'Guatemala tiene una corta costa caribeña en Izabal.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-GEO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-GEO-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-09-1', 'Mar Caribe', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-09-2', 'Mar Mediterráneo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-09-3', 'Mar Rojo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-09-4', 'Mar Caspio', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Guatemala tiene una corta costa caribeña en Izabal.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-GEO-09-1'
WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-GEO-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-GEO-10', 'opcion_multiple', '¿Qué línea imaginaria divide la Tierra en hemisferios norte y sur?', 'El ecuador es la referencia de latitud 0°.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-GEO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-GEO-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-10-1', 'Meridiano de Greenwich', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-10-2', 'Ecuador', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-10-3', 'Trópico de Capricornio', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-GEO-10-4', 'Círculo polar ártico', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El ecuador es la referencia de latitud 0°.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-GEO-10-2'
WHERE c.codigo = 'SOC-GEO' AND p.codigo = 'SOC-GEO-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MAYA-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MAYA-01', 'opcion_multiple', '¿Cuál fue una ciudad importante de la civilización Maya en Guatemala?', 'Tikal fue una importante ciudad maya en Petén.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MAYA'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MAYA-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-01-1', 'Tikal', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-01-2', 'Roma', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-01-3', 'Atenas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-01-4', 'París', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Tikal fue una importante ciudad maya en Petén.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MAYA-01-1'
WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MAYA-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MAYA-02', 'opcion_multiple', '¿En qué departamento está Tikal?', 'Tikal se encuentra en Petén.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MAYA'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MAYA-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-02-1', 'Petén', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-02-2', 'Escuintla', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-02-3', 'Sacatepéquez', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-02-4', 'Jutiapa', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Tikal se encuentra en Petén.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MAYA-02-1'
WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MAYA-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MAYA-03', 'opcion_multiple', '¿Cuál sistema numérico usaron los mayas?', 'El sistema de numeración maya se basa en veinte.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MAYA'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MAYA-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-03-1', 'Decimal sin cero', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-03-2', 'Vigesimal', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-03-3', 'Binario digital', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-03-4', 'Romano', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El sistema de numeración maya se basa en veinte.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MAYA-03-2'
WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MAYA-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MAYA-04', 'opcion_multiple', '¿Qué símbolo se usaba comúnmente para representar el cero maya?', 'Un símbolo con forma de concha representaba el cero.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MAYA'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MAYA-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-04-1', 'Concha o caracol', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-04-2', 'Triángulo rojo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-04-3', 'Estrella de cinco puntas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-04-4', 'Letra X', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Un símbolo con forma de concha representaba el cero.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MAYA-04-1'
WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MAYA-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MAYA-05', 'opcion_multiple', '¿Qué estudia la arqueología?', 'La arqueología estudia sociedades a través de vestigios.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MAYA'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MAYA-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-05-1', 'Únicamente el clima', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-05-2', 'Las sociedades pasadas a partir de restos materiales', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-05-3', 'Solo los animales vivos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-05-4', 'Las reglas ortográficas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La arqueología estudia sociedades a través de vestigios.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MAYA-05-2'
WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MAYA-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MAYA-06', 'opcion_multiple', '¿Qué período maya precedió al Clásico?', 'La secuencia general es Preclásico, Clásico y Posclásico.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MAYA'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MAYA-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-06-1', 'Moderno', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-06-2', 'Posclásico', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-06-3', 'Preclásico', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-06-4', 'Contemporáneo', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La secuencia general es Preclásico, Clásico y Posclásico.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MAYA-06-3'
WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MAYA-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MAYA-07', 'opcion_multiple', '¿Qué actividad fue fundamental para la alimentación maya?', 'El maíz fue un cultivo central para muchas comunidades mayas.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MAYA'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MAYA-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-07-1', 'Cultivo de maíz', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-07-2', 'Cultivo de trigo europeo exclusivamente', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-07-3', 'Fabricación de motores', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-07-4', 'Pesca industrial oceánica', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El maíz fue un cultivo central para muchas comunidades mayas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MAYA-07-1'
WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MAYA-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MAYA-08', 'opcion_multiple', '¿Cuál sitio arqueológico de Guatemala es famoso por sus estelas?', 'Quiriguá destaca por sus monumentos y estelas talladas.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MAYA'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MAYA-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-08-1', 'Quiriguá', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-08-2', 'Antigua Grecia', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-08-3', 'Pompeya', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-08-4', 'Machu Picchu', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Quiriguá destaca por sus monumentos y estelas talladas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MAYA-08-1'
WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MAYA-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MAYA-09', 'opcion_multiple', '¿Qué conocimiento desarrollaron los mayas?', 'La observación astronómica sustentó sus calendarios.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MAYA'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MAYA-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-09-1', 'Astronomía y calendarios', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-09-2', 'Viajes espaciales', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-09-3', 'Imprenta láser', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-09-4', 'Fotografía digital', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La observación astronómica sustentó sus calendarios.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MAYA-09-1'
WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MAYA-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MAYA-10', 'opcion_multiple', '¿Cuál afirmación sobre los pueblos mayas actuales es correcta?', 'Los pueblos mayas mantienen una importante presencia cultural y lingüística.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MAYA'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MAYA-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-10-1', 'Desaparecieron por completo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-10-2', 'Sus comunidades, culturas e idiomas continúan vivos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-10-3', 'Solo existieron en Europa', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MAYA-10-4', 'Todos hablan un único idioma', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los pueblos mayas mantienen una importante presencia cultural y lingüística.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MAYA-10-2'
WHERE c.codigo = 'SOC-MAYA' AND p.codigo = 'SOC-MAYA-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-DEC-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-DEC-01', 'opcion_multiple', '¿Cuál es el valor del dígito 7 en 24.73?', 'El 7 ocupa la posición de las décimas; representa siete décimas, equivalentes a 0.7.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-DEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-DEC-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-01-1', '70', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-01-2', '0.7', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-01-3', '7', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-01-4', '0.07', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El 7 ocupa la posición de las décimas; representa siete décimas, equivalentes a 0.7.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-DEC-01-2'
WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-DEC-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-DEC-02', 'opcion_multiple', '¿Cuál número decimal es mayor?', 'Comparamos 3.580, 3.508, 3.085 y 3.500. El mayor es 3.580.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-DEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-DEC-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-02-1', '3.085', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-02-2', '3.5', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-02-3', '3.58', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-02-4', '3.508', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Comparamos 3.580, 3.508, 3.085 y 3.500. El mayor es 3.580.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-DEC-02-3'
WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-DEC-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-DEC-03', 'opcion_multiple', '¿Cómo se descompone 46.205?', 'El 2 vale dos décimas; el 0, cero centésimas; el 5, cinco milésimas.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-DEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-DEC-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-03-1', '40 + 6 + 0.02 + 0.005', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-03-2', '40 + 6 + 0.2 + 0.05', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-03-3', '4 + 6 + 0.2 + 0.005', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-03-4', '40 + 6 + 0.2 + 0.005', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El 2 vale dos décimas; el 0, cero centésimas; el 5, cinco milésimas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-DEC-03-4'
WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-DEC-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-DEC-04', 'opcion_multiple', 'Redondea 18.476 a las centésimas.', 'La centésima es 7 y la milésima siguiente es 6; al ser 6 ≥ 5, aumenta a 8.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-DEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-DEC-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-04-1', '18.48', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-04-2', '18.47', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-04-3', '18.5', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-04-4', '18.476', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La centésima es 7 y la milésima siguiente es 6; al ser 6 ≥ 5, aumenta a 8.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-DEC-04-1'
WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-DEC-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-DEC-05', 'opcion_multiple', '¿Qué fracción es equivalente al decimal 0.375 en su forma irreducible?', '0.375 = 375/1000. Al dividir numerador y denominador entre 125, obtenemos 3/8.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-DEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-DEC-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-05-1', '5/8', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-05-2', '3/8', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-05-3', '3/5', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-05-4', '37/100', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '0.375 = 375/1000. Al dividir numerador y denominador entre 125, obtenemos 3/8.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-DEC-05-2'
WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-DEC-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-DEC-06', 'opcion_multiple', 'Calcula 12.85 + 4.096 − 3.7.', 'Alinea los decimales: 12.850 + 4.096 = 16.946; luego 16.946 − 3.700 = 13.246.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-DEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-DEC-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-06-1', '12.246', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-06-2', '14.246', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-06-3', '13.246', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-06-4', '13.256', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Alinea los decimales: 12.850 + 4.096 = 16.946; luego 16.946 − 3.700 = 13.246.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-DEC-06-3'
WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-DEC-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-DEC-07', 'opcion_multiple', 'Un paquete de arroz pesa 2.75 kg. ¿Cuánto pesan 6 paquetes iguales?', 'Multiplicamos 2.75 × 6 = 16.50. El peso total es 16.5 kilogramos.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-DEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-DEC-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-07-1', '15.5 kg', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-07-2', '16.05 kg', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-07-3', '17.5 kg', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-07-4', '16.5 kg', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Multiplicamos 2.75 × 6 = 16.50. El peso total es 16.5 kilogramos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-DEC-07-4'
WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-DEC-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-DEC-08', 'opcion_multiple', 'Una cuerda de 9.6 metros se corta en pedazos de 0.8 metros. ¿Cuántos pedazos completos se obtienen?', 'Dividimos 9.6 ÷ 0.8. Multiplicando ambos términos por 10: 96 ÷ 8 = 12.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-DEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-DEC-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-08-1', '12', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-08-2', '10', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-08-3', '11', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-08-4', '14', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Dividimos 9.6 ÷ 0.8. Multiplicando ambos términos por 10: 96 ÷ 8 = 12.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-DEC-08-1'
WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-DEC-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-DEC-09', 'opcion_multiple', 'Una botella contiene 1.25 litros. Se llenan 7 botellas y luego se utilizan 2.4 litros. ¿Cuántos litros quedan?', 'Inicialmente hay 1.25 × 7 = 8.75 litros; después de usar 2.4 quedan 8.75 − 2.4 = 6.35.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-DEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-DEC-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-09-1', '7.35 litros', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-09-2', '6.35 litros', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-09-3', '6.25 litros', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-09-4', '5.35 litros', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Inicialmente hay 1.25 × 7 = 8.75 litros; después de usar 2.4 quedan 8.75 − 2.4 = 6.35.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-DEC-09-2'
WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-DEC-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-DEC-10', 'opcion_multiple', 'En una feria se compran 3.5 kg de fruta a Q12.80 por kg y se paga con Q50. ¿Cuánto vuelto corresponde?', 'Costo: 3.5 × 12.80 = Q44.80. Vuelto: Q50.00 − Q44.80 = Q5.20.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-DEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-DEC-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-10-1', 'Q5.80', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-10-2', 'Q6.20', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-10-3', 'Q5.20', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-DEC-10-4', 'Q4.80', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Costo: 3.5 × 12.80 = Q44.80. Vuelto: Q50.00 − Q44.80 = Q5.20.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-DEC-10-3'
WHERE c.codigo = 'MAT-DEC' AND p.codigo = 'MAT-DEC-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-TIEM-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-TIEM-01', 'opcion_multiple', '¿Cuántos minutos hay en 2 horas y 15 minutos?', 'Cada hora tiene 60 minutos. 2 × 60 + 15 = 135 minutos.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-TIEM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-TIEM-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-01-1', '150 minutos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-01-2', '135 minutos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-01-3', '115 minutos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-01-4', '125 minutos', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Cada hora tiene 60 minutos. 2 × 60 + 15 = 135 minutos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-TIEM-01-2'
WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-TIEM-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-TIEM-02', 'opcion_multiple', 'Si una actividad comienza a las 9:35 a. m. y dura 40 minutos, ¿a qué hora termina?', 'De 9:35 a 10:00 pasan 25 minutos; faltan 15 minutos, así que termina a las 10:15.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-TIEM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-TIEM-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-02-1', '10:25 a. m.', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-02-2', '9:75 a. m.', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-02-3', '10:15 a. m.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-02-4', '10:05 a. m.', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'De 9:35 a 10:00 pasan 25 minutos; faltan 15 minutos, así que termina a las 10:15.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-TIEM-02-3'
WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-TIEM-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-TIEM-03', 'opcion_multiple', '¿Cuántos quetzales hay en 8 billetes de Q20 y 3 monedas de Q5?', '8 × Q20 = Q160 y 3 × Q5 = Q15. Total: Q175.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-TIEM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-TIEM-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-03-1', 'Q165', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-03-2', 'Q180', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-03-3', 'Q190', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-03-4', 'Q175', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '8 × Q20 = Q160 y 3 × Q5 = Q15. Total: Q175.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-TIEM-03-4'
WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-TIEM-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-TIEM-04', 'opcion_multiple', 'Una estudiante compra un libro de Q36.75 y paga con Q50. ¿Cuánto recibe de vuelto?', 'Se resta el costo del pago: Q50.00 − Q36.75 = Q13.25.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-TIEM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-TIEM-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-04-1', 'Q13.25', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-04-2', 'Q12.25', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-04-3', 'Q13.75', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-04-4', 'Q14.25', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Se resta el costo del pago: Q50.00 − Q36.75 = Q13.25.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-TIEM-04-1'
WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-TIEM-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-TIEM-05', 'opcion_multiple', '¿Cuánto tiempo transcurre entre las 7:48 a. m. y las 9:13 a. m.?', 'De 7:48 a 8:48 hay una hora; de 8:48 a 9:13 pasan 25 minutos.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-TIEM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-TIEM-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-05-1', '2 horas y 25 minutos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-05-2', '1 hora y 25 minutos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-05-3', '1 hora y 15 minutos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-05-4', '1 hora y 35 minutos', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'De 7:48 a 8:48 hay una hora; de 8:48 a 9:13 pasan 25 minutos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-TIEM-05-2'
WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-TIEM-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-TIEM-06', 'opcion_multiple', 'Una excursión dura 2 horas y 45 minutos, más un descanso de 35 minutos. ¿Cuál es la duración total?', '45 + 35 = 80 minutos, equivalentes a 1 hora y 20 minutos. Total: 3 horas y 20 minutos.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-TIEM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-TIEM-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-06-1', '2 horas y 80 minutos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-06-2', '3 horas y 30 minutos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-06-3', '3 horas y 20 minutos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-06-4', '3 horas y 10 minutos', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '45 + 35 = 80 minutos, equivalentes a 1 hora y 20 minutos. Total: 3 horas y 20 minutos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-TIEM-06-3'
WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-TIEM-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-TIEM-07', 'opcion_multiple', 'Tres cuadernos cuestan Q18.50 cada uno y dos lápices Q4.75 cada uno. ¿Cuál es el total?', 'Cuadernos: 3 × 18.50 = Q55.50; lápices: 2 × 4.75 = Q9.50. Total Q65.00.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-TIEM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-TIEM-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-07-1', 'Q60.25', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-07-2', 'Q64.50', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-07-3', 'Q66.00', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-07-4', 'Q65.00', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Cuadernos: 3 × 18.50 = Q55.50; lápices: 2 × 4.75 = Q9.50. Total Q65.00.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-TIEM-07-4'
WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-TIEM-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-TIEM-08', 'opcion_multiple', 'Un viaje comienza a las 10:50 p. m. y termina a la 1:20 a. m. del día siguiente. ¿Cuánto dura?', 'De 10:50 p. m. a medianoche hay 1 h 10 min; de medianoche a 1:20 a. m., 1 h 20 min. Suman 2 h 30 min.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-TIEM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-TIEM-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-08-1', '2 horas y 30 minutos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-08-2', '1 hora y 30 minutos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-08-3', '2 horas y 20 minutos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-08-4', '3 horas y 30 minutos', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'De 10:50 p. m. a medianoche hay 1 h 10 min; de medianoche a 1:20 a. m., 1 h 20 min. Suman 2 h 30 min.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-TIEM-08-1'
WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-TIEM-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-TIEM-09', 'opcion_multiple', 'Se compran 4 entradas de Q27.50 y se recibe un descuento total de Q15. ¿Cuánto se paga?', 'Cuatro entradas cuestan 4 × Q27.50 = Q110.00; aplicando el descuento total de Q15, se pagan Q95.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-TIEM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-TIEM-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-09-1', 'Q110.00', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-09-2', 'Q95.00', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-09-3', 'Q100.00', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-09-4', 'Q105.00', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Cuatro entradas cuestan 4 × Q27.50 = Q110.00; aplicando el descuento total de Q15, se pagan Q95.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-TIEM-09-2'
WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-TIEM-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-TIEM-10', 'opcion_multiple', 'Una feria inicia a las 8:45 a. m. Hay 3 talleres de 55 minutos y dos descansos de 20 minutos. ¿A qué hora termina?', 'Talleres: 3 × 55 = 165 min. Descansos: 2 × 20 = 40 min. Total: 205 min = 3 h 25 min. 8:45 + 3:25 = 12:10 p. m.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-TIEM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-TIEM-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-10-1', '12:00 p. m.', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-10-2', '12:30 p. m.', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-10-3', '12:10 p. m.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-TIEM-10-4', '11:50 a. m.', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Talleres: 3 × 55 = 165 min. Descansos: 2 × 20 = 40 min. Total: 205 min = 3 h 25 min. 8:45 + 3:25 = 12:10 p. m.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-TIEM-10-3'
WHERE c.codigo = 'MAT-TIEM' AND p.codigo = 'MAT-TIEM-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-GEOM-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-GEOM-01', 'opcion_multiple', '¿Qué tipo de ángulo mide exactamente 90°?', 'Un ángulo recto mide exactamente 90 grados.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-GEOM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-GEOM-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-01-1', 'Ángulo llano', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-01-2', 'Ángulo recto', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-01-3', 'Ángulo agudo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-01-4', 'Ángulo obtuso', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Un ángulo recto mide exactamente 90 grados.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-GEOM-01-2'
WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-GEOM-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-GEOM-02', 'opcion_multiple', '¿Cómo se llaman dos rectas que se cruzan formando ángulos de 90°?', 'Las rectas perpendiculares se intersectan formando cuatro ángulos rectos.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-GEOM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-GEOM-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-02-1', 'Coincidentes', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-02-2', 'Curvas', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-02-3', 'Perpendiculares', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-02-4', 'Paralelas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las rectas perpendiculares se intersectan formando cuatro ángulos rectos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-GEOM-02-3'
WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-GEOM-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-GEOM-03', 'opcion_multiple', 'Un ángulo mide 135°. ¿Cómo se clasifica?', 'Es obtuso porque mide más de 90° y menos de 180°.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-GEOM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-GEOM-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-03-1', 'Agudo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-03-2', 'Recto', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-03-3', 'Completo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-03-4', 'Obtuso', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Es obtuso porque mide más de 90° y menos de 180°.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-GEOM-03-4'
WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-GEOM-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-GEOM-04', 'opcion_multiple', '¿Cuánto mide el ángulo complementario de uno de 37°?', 'Dos ángulos complementarios suman 90°. Por ello, 90° − 37° = 53°.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-GEOM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-GEOM-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-04-1', '53°', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-04-2', '43°', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-04-3', '63°', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-04-4', '143°', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Dos ángulos complementarios suman 90°. Por ello, 90° − 37° = 53°.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-GEOM-04-1'
WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-GEOM-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-GEOM-05', 'opcion_multiple', '¿Cuánto mide el ángulo suplementario de uno de 68°?', 'Los ángulos suplementarios suman 180°. 180° − 68° = 112°.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-GEOM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-GEOM-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-05-1', '122°', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-05-2', '112°', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-05-3', '22°', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-05-4', '102°', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los ángulos suplementarios suman 180°. 180° − 68° = 112°.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-GEOM-05-2'
WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-GEOM-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-GEOM-06', 'opcion_multiple', '¿Qué instrumento se utiliza para medir ángulos en grados?', 'El transportador muestra una escala de grados con la cual puede medirse la apertura del ángulo.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-GEOM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-GEOM-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-06-1', 'Regla graduada', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-06-2', 'Escuadra sin escala angular', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-06-3', 'Transportador', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-06-4', 'Compás', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El transportador muestra una escala de grados con la cual puede medirse la apertura del ángulo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-GEOM-06-3'
WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-GEOM-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-GEOM-07', 'opcion_multiple', 'Dos ángulos adyacentes forman una línea recta. Uno mide 124°. ¿Cuánto mide el otro?', 'Al formar un ángulo llano, suman 180°. El faltante es 180° − 124° = 56°.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-GEOM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-GEOM-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-07-1', '46°', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-07-2', '66°', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-07-3', '76°', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-07-4', '56°', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Al formar un ángulo llano, suman 180°. El faltante es 180° − 124° = 56°.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-GEOM-07-4'
WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-GEOM-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-GEOM-08', 'opcion_multiple', 'En un plano cartesiano, ¿qué punto se encuentra 3 unidades a la izquierda y 4 hacia arriba del origen?', 'Ir a la izquierda cambia la coordenada x a −3; subir da coordenada y = 4.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-GEOM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-GEOM-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-08-1', '(-3, 4)', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-08-2', '(3, 4)', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-08-3', '(-4, 3)', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-08-4', '(3, -4)', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Ir a la izquierda cambia la coordenada x a −3; subir da coordenada y = 4.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-GEOM-08-1'
WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-GEOM-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-GEOM-09', 'opcion_multiple', 'Un ángulo de 42° 35′ se suma con otro de 18° 45′. ¿Cuál es el resultado?', 'Sumamos 35′ + 45′ = 80′ = 1° 20′. Luego 42° + 18° + 1° = 61°: resultado 61° 20′.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-GEOM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-GEOM-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-09-1', '60° 20′', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-09-2', '61° 20′', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-09-3', '60° 80′', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-09-4', '61° 10′', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Sumamos 35′ + 45′ = 80′ = 1° 20′. Luego 42° + 18° + 1° = 61°: resultado 61° 20′.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-GEOM-09-2'
WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-GEOM-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-GEOM-10', 'opcion_multiple', 'Un triángulo tiene ángulos interiores de (2x + 10)°, (x + 20)° y (3x − 30)°. ¿Cuál es el valor de x?', 'Los ángulos de un triángulo suman 180°. (2x + 10)+(x + 20)+(3x − 30)=180, por tanto 6x=180 y x=30.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-GEOM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-GEOM-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-10-1', '35', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-10-2', '40', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-10-3', '30', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-GEOM-10-4', '25', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los ángulos de un triángulo suman 180°. (2x + 10)+(x + 20)+(3x − 30)=180, por tanto 6x=180 y x=30.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-GEOM-10-3'
WHERE c.codigo = 'MAT-GEOM' AND p.codigo = 'MAT-GEOM-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-PLAN-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-PLAN-01', 'opcion_multiple', 'Un triángulo tiene lados de 5, 5 y 8 cm. ¿Cómo se clasifica por sus lados?', 'Tiene exactamente dos lados iguales, por eso es isósceles.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-PLAN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-PLAN-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-01-1', 'Isósceles', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-01-2', 'Escaleno', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-01-3', 'Rectángulo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-01-4', 'Equilátero', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Tiene exactamente dos lados iguales, por eso es isósceles.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-PLAN-01-1'
WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-PLAN-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-PLAN-02', 'opcion_multiple', '¿Cuánto suman los ángulos interiores de cualquier triángulo plano?', 'Una propiedad de los triángulos planos es que sus tres ángulos interiores suman 180°.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-PLAN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-PLAN-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-02-1', '360°', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-02-2', '270°', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-02-3', '180°', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-02-4', '90°', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Una propiedad de los triángulos planos es que sus tres ángulos interiores suman 180°.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-PLAN-02-3'
WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-PLAN-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-PLAN-03', 'opcion_multiple', '¿Cómo se llama el cuadrilátero que tiene dos pares de lados paralelos y cuatro ángulos rectos?', 'El rectángulo tiene ángulos de 90° y lados opuestos paralelos.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-PLAN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-PLAN-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-03-1', 'Rombo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-03-2', 'Rectángulo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-03-3', 'Paralelogramo sin ángulos rectos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-03-4', 'Trapecio', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El rectángulo tiene ángulos de 90° y lados opuestos paralelos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-PLAN-03-2'
WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-PLAN-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-PLAN-04', 'opcion_multiple', '¿Cuál es el perímetro de un cuadrado de lado 7 cm?', 'Se suman sus cuatro lados: 4 × 7 = 28 cm.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-PLAN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-PLAN-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-04-1', '49 cm', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-04-2', '28 cm', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-04-3', '21 cm', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-04-4', '14 cm', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Se suman sus cuatro lados: 4 × 7 = 28 cm.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-PLAN-04-2'
WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-PLAN-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-PLAN-05', 'opcion_multiple', '¿Cuál es el área de un rectángulo de 9 cm de largo y 4 cm de ancho?', 'El área se calcula como base por altura: 9 × 4 = 36 cm².', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-PLAN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-PLAN-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-05-1', '13 cm²', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-05-2', '40 cm²', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-05-3', '26 cm²', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-05-4', '36 cm²', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El área se calcula como base por altura: 9 × 4 = 36 cm².'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-PLAN-05-4'
WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-PLAN-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-PLAN-06', 'opcion_multiple', '¿Cómo se denomina el segmento que une el centro de un círculo con un punto de su circunferencia?', 'El radio va desde el centro hasta cualquier punto de la circunferencia.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-PLAN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-PLAN-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-06-1', 'Diámetro', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-06-2', 'Cuerda', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-06-3', 'Radio', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-06-4', 'Arco', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El radio va desde el centro hasta cualquier punto de la circunferencia.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-PLAN-06-3'
WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-PLAN-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-PLAN-07', 'opcion_multiple', '¿Cuánto mide el diámetro de una circunferencia de radio 6 cm?', 'El diámetro equivale a dos radios: 2 × 6 = 12 cm.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-PLAN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-PLAN-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-07-1', '6 cm', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-07-2', '18 cm', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-07-3', '12 cm', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-07-4', '36 cm', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El diámetro equivale a dos radios: 2 × 6 = 12 cm.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-PLAN-07-3'
WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-PLAN-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-PLAN-08', 'opcion_multiple', '¿Cuánto suman los ángulos interiores de un pentágono?', 'La suma es (5 − 2) × 180° = 540°.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-PLAN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-PLAN-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-08-1', '540°', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-08-2', '720°', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-08-3', '900°', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-08-4', '360°', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La suma es (5 − 2) × 180° = 540°.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-PLAN-08-1'
WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-PLAN-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-PLAN-09', 'opcion_multiple', '¿Cuál es el área de un triángulo de base 12 cm y altura perpendicular 5 cm?', 'La fórmula es base × altura ÷ 2: 12 × 5 ÷ 2 = 30 cm².', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-PLAN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-PLAN-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-09-1', '60 cm²', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-09-2', '30 cm²', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-09-3', '17 cm²', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-09-4', '24 cm²', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La fórmula es base × altura ÷ 2: 12 × 5 ÷ 2 = 30 cm².'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-PLAN-09-2'
WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-PLAN-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-PLAN-10', 'opcion_multiple', 'Un terreno rectangular mide 15 m por 8 m. Se reserva un cuadrado de 3 m de lado. ¿Qué área queda libre?', 'El terreno mide 15 × 8 = 120 m²; se restan 3 × 3 = 9 m², dejando 111 m².', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-PLAN'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-PLAN-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-10-1', '120 m²', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-10-2', '111 m²', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-10-3', '105 m²', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-PLAN-10-4', '102 m²', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El terreno mide 15 × 8 = 120 m²; se restan 3 × 3 = 9 m², dejando 111 m².'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-PLAN-10-2'
WHERE c.codigo = 'MAT-PLAN' AND p.codigo = 'MAT-PLAN-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-CUER-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-CUER-01', 'opcion_multiple', '¿Cuántas caras tiene un cubo?', 'Un cubo tiene seis caras cuadradas congruentes.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-CUER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-CUER-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-01-1', '12 caras', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-01-2', '6 caras', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-01-3', '8 caras', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-01-4', '4 caras', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Un cubo tiene seis caras cuadradas congruentes.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-CUER-01-2'
WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-CUER-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-CUER-02', 'opcion_multiple', '¿Cuántas aristas tiene un cubo?', 'Las seis caras comparten doce aristas distintas.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-CUER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-CUER-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-02-1', '12 aristas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-02-2', '10 aristas', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-02-3', '14 aristas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-02-4', '8 aristas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las seis caras comparten doce aristas distintas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-CUER-02-1'
WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-CUER-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-CUER-03', 'opcion_multiple', '¿Cuántos vértices tiene un cubo?', 'En el cubo se encuentran tres aristas en cada uno de sus ocho vértices.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-CUER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-CUER-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-03-1', '8 vértices', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-03-2', '6 vértices', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-03-3', '12 vértices', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-03-4', '10 vértices', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'En el cubo se encuentran tres aristas en cada uno de sus ocho vértices.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-CUER-03-1'
WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-CUER-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-CUER-04', 'opcion_multiple', '¿Cuál es el sólido con dos bases circulares paralelas y una superficie lateral curva?', 'El cilindro tiene dos bases circulares congruentes unidas por una superficie lateral curva.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-CUER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-CUER-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-04-1', 'Prisma triangular', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-04-2', 'Esfera', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-04-3', 'Cilindro', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-04-4', 'Cono', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El cilindro tiene dos bases circulares congruentes unidas por una superficie lateral curva.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-CUER-04-3'
WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-CUER-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-CUER-05', 'opcion_multiple', '¿Cuál es el sólido con una sola base circular y un vértice fuera de ella?', 'El cono tiene una base circular y culmina en un vértice.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-CUER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-CUER-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-05-1', 'Cilindro', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-05-2', 'Esfera', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-05-3', 'Cono', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-05-4', 'Pirámide de base cuadrada', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El cono tiene una base circular y culmina en un vértice.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-CUER-05-3'
WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-CUER-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-CUER-06', 'opcion_multiple', '¿Cuál de estos cuerpos no tiene caras planas ni vértices?', 'La esfera tiene una superficie curva continua, sin aristas ni vértices.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-CUER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-CUER-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-06-1', 'Cono', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-06-2', 'Cilindro', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-06-3', 'Esfera', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-06-4', 'Pirámide', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La esfera tiene una superficie curva continua, sin aristas ni vértices.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-CUER-06-3'
WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-CUER-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-CUER-07', 'opcion_multiple', '¿Cuál es el volumen de un cubo cuya arista mide 3 cm?', 'Volumen del cubo = 3 × 3 × 3 = 27 cm³.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-CUER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-CUER-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-07-1', '18 cm³', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-07-2', '27 cm³', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-07-3', '81 cm³', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-07-4', '9 cm³', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Volumen del cubo = 3 × 3 × 3 = 27 cm³.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-CUER-07-2'
WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-CUER-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-CUER-08', 'opcion_multiple', 'Un prisma rectangular mide 4 cm, 3 cm y 5 cm. ¿Cuál es su volumen?', 'Multiplicamos largo, ancho y alto: 4 × 3 × 5 = 60 cm³.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-CUER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-CUER-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-08-1', '47 cm³', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-08-2', '120 cm³', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-08-3', '60 cm³', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-08-4', '12 cm³', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Multiplicamos largo, ancho y alto: 4 × 3 × 5 = 60 cm³.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-CUER-08-3'
WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-CUER-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-CUER-09', 'opcion_multiple', '¿Cuántas caras en total tiene una pirámide de base cuadrada?', 'Tiene una base cuadrada y cuatro caras laterales triangulares.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-CUER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-CUER-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-09-1', '5 caras', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-09-2', '6 caras', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-09-3', '8 caras', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-09-4', '4 caras', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Tiene una base cuadrada y cuatro caras laterales triangulares.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-CUER-09-1'
WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-CUER-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-CUER-10', 'opcion_multiple', 'Una caja de 6 cm × 5 cm × 4 cm se llena con cubos de 1 cm de arista sin dejar huecos. ¿Cuántos cubos caben?', 'El volumen interior es 6 × 5 × 4 = 120 cm³; cada cubito ocupa 1 cm³.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-CUER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-CUER-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-10-1', '150 cubos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-10-2', '60 cubos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-10-3', '90 cubos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-CUER-10-4', '120 cubos', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El volumen interior es 6 × 5 × 4 = 120 cm³; cada cubito ocupa 1 cm³.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-CUER-10-4'
WHERE c.codigo = 'MAT-CUER' AND p.codigo = 'MAT-CUER-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-EST-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-EST-01', 'opcion_multiple', 'En una encuesta, el color favorito es una variable ¿de qué tipo?', 'Describe categorías, no cantidades numéricas.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-EST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-EST-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-01-1', 'Ordinal numérica', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-01-2', 'Cualitativa', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-01-3', 'Cuantitativa discreta', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-01-4', 'Cuantitativa continua', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Describe categorías, no cantidades numéricas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-EST-01-2'
WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-EST-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-EST-02', 'opcion_multiple', 'La cantidad de hermanos que tiene una persona es una variable ¿de qué tipo?', 'Se cuenta mediante números enteros.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-EST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-EST-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-02-1', 'Cuantitativa discreta', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-02-2', 'Cuantitativa continua', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-02-3', 'Cualitativa ordinal', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-02-4', 'Cualitativa nominal', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Se cuenta mediante números enteros.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-EST-02-1'
WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-EST-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-EST-03', 'opcion_multiple', '¿Cuál es la moda de 2, 4, 4, 5 y 7?', 'Es el valor que se repite más veces.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-EST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-EST-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-03-1', '4.4', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-03-2', '5', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-03-3', '7', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-03-4', '4', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Es el valor que se repite más veces.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-EST-03-4'
WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-EST-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-EST-04', 'opcion_multiple', '¿Cuál es la media de los números 4, 6 y 8?', 'La suma 4 + 6 + 8 = 18; al dividir entre 3 resulta 6.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-EST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-EST-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-04-1', '8', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-04-2', '18', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-04-3', '4', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-04-4', '6', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La suma 4 + 6 + 8 = 18; al dividir entre 3 resulta 6.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-EST-04-4'
WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-EST-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-EST-05', 'opcion_multiple', '¿Cuál es la mediana de 3, 5, 7, 9 y 12?', 'Hay cinco datos ordenados, y el tercero es 7.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-EST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-EST-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-05-1', '9', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-05-2', '7', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-05-3', '5', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-05-4', '8', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Hay cinco datos ordenados, y el tercero es 7.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-EST-05-2'
WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-EST-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-EST-06', 'opcion_multiple', 'En una tabla, 12 estudiantes prefieren fútbol y 8 baloncesto. ¿Cuántos participaron?', 'Sumamos las frecuencias de las dos categorías: 12 + 8 = 20.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-EST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-EST-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-06-1', '12 estudiantes', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-06-2', '20 estudiantes', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-06-3', '24 estudiantes', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-06-4', '8 estudiantes', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Sumamos las frecuencias de las dos categorías: 12 + 8 = 20.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-EST-06-2'
WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-EST-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-EST-07', 'opcion_multiple', '¿Qué gráfico suele ser adecuado para comparar cantidades entre categorías?', 'La longitud de las barras permite comparar las frecuencias.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-EST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-EST-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-07-1', 'Gráfico de barras', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-07-2', 'Histograma de intervalos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-07-3', 'Diagrama de dispersión', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-07-4', 'Línea temporal', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La longitud de las barras permite comparar las frecuencias.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-EST-07-1'
WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-EST-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-EST-08', 'opcion_multiple', 'En un gráfico circular, ¿qué ángulo representa el 25 % del total?', 'El círculo tiene 360° y el 25 % equivale a 360 × 0.25 = 90°.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-EST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-EST-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-08-1', '90°', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-08-2', '180°', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-08-3', '120°', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-08-4', '45°', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El círculo tiene 360° y el 25 % equivale a 360 × 0.25 = 90°.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-EST-08-1'
WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-EST-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-EST-09', 'opcion_multiple', 'Las calificaciones son 6, 8, 8, 9 y 9. ¿Cuál es su media?', 'La suma es 40 y hay cinco notas: 40 ÷ 5 = 8.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-EST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-EST-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-09-1', '8', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-09-2', '8.5', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-09-3', '7', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-09-4', '9', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La suma es 40 y hay cinco notas: 40 ÷ 5 = 8.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-EST-09-1'
WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- MAT-EST-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'MAT-EST-10', 'opcion_multiple', 'En 40 respuestas, 14 son «sí», 16 «no» y el resto «tal vez». ¿Qué porcentaje contestó «tal vez»?', 'Faltan 40 − 14 − 16 = 10; 10/40 = 0.25 = 25 %.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'MAT-EST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'MAT-EST-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-10-1', '30 %', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-10-2', '10 %', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-10-3', '40 %', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'MAT-EST-10-4', '25 %', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Faltan 40 − 14 − 16 = 10; 10/40 = 0.25 = 25 %.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'MAT-EST-10-4'
WHERE c.codigo = 'MAT-EST' AND p.codigo = 'MAT-EST-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT2-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT2-01', 'opcion_multiple', '¿Cuál es la escritura correcta del plural de «luz»?', 'La z final cambia a c antes de -es.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT2'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT2-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-01-1', 'Lusces', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-01-2', 'Luces', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-01-3', 'Lúces', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-01-4', 'Luzes', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La z final cambia a c antes de -es.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT2-01-2'
WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT2-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT2-02', 'opcion_multiple', '¿Cuál es la forma correcta del verbo «haber» en «Ayer ___ un accidente»?', '«Hubo» es una forma impersonal de haber, con h y b.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT2'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT2-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-02-1', 'Huvo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-02-2', 'Hubó', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-02-3', 'Ubo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-02-4', 'Hubo', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Hubo» es una forma impersonal de haber, con h y b.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT2-02-4'
WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT2-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT2-03', 'opcion_multiple', '¿Cuál es la escritura correcta del nombre de un pequeño roedor?', 'Al inicio de palabra el sonido fuerte se escribe con una sola r.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT2'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT2-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-03-1', 'Ratón', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-03-2', 'Rátón', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-03-3', 'Rratón', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-03-4', 'Rratónn', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Al inicio de palabra el sonido fuerte se escribe con una sola r.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT2-03-1'
WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT2-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT2-04', 'opcion_multiple', '¿Cuál es la escritura correcta del verbo que significa inspeccionar detenidamente?', '«Examinar» se escribe con x, no con s.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT2'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT2-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-04-1', 'Ecsaminar', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-04-2', 'Examinar', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-04-3', 'Esaminar', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-04-4', 'Exhaminar', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Examinar» se escribe con x, no con s.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT2-04-2'
WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT2-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT2-05', 'opcion_multiple', '¿Cuál de estas palabras está escrita correctamente?', 'La palabra acción se escribe con doble c.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT2'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT2-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-05-1', 'Ación', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-05-2', 'Acción', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-05-3', 'Accíon', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-05-4', 'Asción', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La palabra acción se escribe con doble c.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT2-05-2'
WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT2-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT2-06', 'opcion_multiple', '¿Qué signo se coloca al inicio de una pregunta directa en español?', 'En español se usan signos de interrogación de apertura y cierre.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT2'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT2-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-06-1', '?', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-06-2', '¿', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-06-3', '!', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-06-4', '¡', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'En español se usan signos de interrogación de apertura y cierre.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT2-06-2'
WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT2-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT2-07', 'opcion_multiple', '¿Cuál es la abreviatura habitual de «señora»?', 'La abreviatura conserva letras de la palabra original y lleva punto.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT2'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT2-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-07-1', 'Sra.', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-07-2', 'Sñra.', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-07-3', 'Señr.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-07-4', 'Srñ.', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La abreviatura conserva letras de la palabra original y lleva punto.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT2-07-1'
WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT2-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT2-08', 'opcion_multiple', '¿Qué palabra está correctamente escrita cuando significa «que se puede realizar»?', '«Factible» significa realizable o posible.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT2'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT2-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-08-1', 'Fasible', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-08-2', 'Factíble', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-08-3', 'Factible', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-08-4', 'Factivle', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Factible» significa realizable o posible.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT2-08-3'
WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT2-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT2-09', 'opcion_multiple', '¿Cuál es la forma correcta del infinitivo de «conduzco»?', 'El infinitivo se escribe con c y termina en -cir.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT2'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT2-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-09-1', 'Conduzir', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-09-2', 'Conducir', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-09-3', 'Condusir', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-09-4', 'Conducír', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El infinitivo se escribe con c y termina en -cir.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT2-09-2'
WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORT2-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORT2-10', 'opcion_multiple', 'Elige la oración con los signos de puntuación correctos.', 'La coma separa el vocativo «María» y los signos rodean la pregunta directa.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORT2'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORT2-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-10-1', 'María, ¿trajiste el cuaderno?', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-10-2', 'María ¿trajiste el cuaderno?', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-10-3', 'María, ¿trajiste el cuaderno.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORT2-10-4', 'María, trajiste el cuaderno?', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La coma separa el vocativo «María» y los signos rodean la pregunta directa.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORT2-10-1'
WHERE c.codigo = 'LEN-ORT2' AND p.codigo = 'LEN-ORT2-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-TIP-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-TIP-01', 'opcion_multiple', '¿Cuál es un sinónimo adecuado de «alegre» en «un niño alegre»?', '«Contento» mantiene el sentido de estado de ánimo positivo.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-TIP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-TIP-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-01-1', 'Abundante', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-01-2', 'Florero', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-01-3', 'Pan', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-01-4', 'Contento', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Contento» mantiene el sentido de estado de ánimo positivo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-TIP-01-4'
WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-TIP-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-TIP-02', 'opcion_multiple', '¿Cuál es el antónimo de «escaso»?', '«Abundante» expresa lo contrario de poca cantidad.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-TIP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-TIP-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-02-1', 'Generoso — egoísta', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-02-2', 'Abundante', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-02-3', 'Violín', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-02-4', 'Polisemia', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Abundante» expresa lo contrario de poca cantidad.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-TIP-02-2'
WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-TIP-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-TIP-03', 'opcion_multiple', 'En «la hoja del árbol» y «la hoja de papel», ¿qué fenómeno presenta «hoja»?', 'Una misma palabra tiene significados relacionados.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-TIP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-TIP-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-03-1', 'Abundante', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-03-2', 'Polisemia', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-03-3', 'Varios sentidos de una misma palabra', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-03-4', 'Florero', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Una misma palabra tiene significados relacionados.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-TIP-03-2'
WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-TIP-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-TIP-04', 'opcion_multiple', '«Votar» y «botar» son palabras ¿de qué tipo?', 'Suenan igual en el español de Guatemala, aunque se escriben y significan distinto.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-TIP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-TIP-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-04-1', 'Homófonas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-04-2', 'Florero', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-04-3', 'Pan', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-04-4', 'Polisemia', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Suenan igual en el español de Guatemala, aunque se escriben y significan distinto.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-TIP-04-1'
WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-TIP-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-TIP-05', 'opcion_multiple', '¿Cuál es la palabra primitiva de «panadero»?', '«Panadero» se forma a partir de «pan» con un sufijo.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-TIP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-TIP-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-05-1', 'Pan', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-05-2', 'Florero', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-05-3', 'Generoso — egoísta', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-05-4', 'Contento', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Panadero» se forma a partir de «pan» con un sufijo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-TIP-05-1'
WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-TIP-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-TIP-06', 'opcion_multiple', '¿Qué tipo de palabra es «sacapuntas» por su formación?', 'Se forma combinando dos bases léxicas: saca + puntas.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-TIP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-TIP-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-06-1', 'Generoso — egoísta', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-06-2', 'Compuesta', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-06-3', 'Violín', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-06-4', 'Pan', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Se forma combinando dos bases léxicas: saca + puntas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-TIP-06-2'
WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-TIP-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-TIP-07', 'opcion_multiple', '¿Cuál pertenece al campo semántico de instrumentos musicales?', 'El violín es un instrumento musical.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-TIP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-TIP-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-07-1', 'Generoso — egoísta', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-07-2', 'Homófonas', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-07-3', 'Polisemia', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-07-4', 'Violín', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El violín es un instrumento musical.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-TIP-07-4'
WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-TIP-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-TIP-08', 'opcion_multiple', '¿Qué palabra es derivada de «flor»?', '«Florero» se forma añadiendo -ero a la base «flor».', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-TIP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-TIP-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-08-1', 'Polisemia', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-08-2', 'Florero', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-08-3', 'Generoso — egoísta', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-08-4', 'Contento', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Florero» se forma añadiendo -ero a la base «flor».'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-TIP-08-2'
WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-TIP-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-TIP-09', 'opcion_multiple', '¿Cuál de estas parejas está formada por antónimos?', 'Los términos expresan actitudes opuestas respecto de compartir.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-TIP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-TIP-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-09-1', 'Contento', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-09-2', 'Generoso — egoísta', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-09-3', 'Compuesta', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-09-4', 'Homófonas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los términos expresan actitudes opuestas respecto de compartir.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-TIP-09-2'
WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-TIP-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-TIP-10', 'opcion_multiple', 'En «el banco del parque» y «el banco donde guardo dinero», ¿qué relación suele describirse en ejercicios escolares?', '«Banco» presenta acepciones diferentes reconocidas por el diccionario; los matices etimológicos pueden variar.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-TIP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-TIP-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-10-1', 'Polisemia', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-10-2', 'Abundante', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-10-3', 'Homófonas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-TIP-10-4', 'Varios sentidos de una misma palabra', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Banco» presenta acepciones diferentes reconocidas por el diccionario; los matices etimológicos pueden variar.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-TIP-10-4'
WHERE c.codigo = 'LEN-TIP' AND p.codigo = 'LEN-TIP-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PREF-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PREF-01', 'opcion_multiple', 'En «deshacer», ¿qué parte es el prefijo?', '«des-» se agrega antes de la base y suele expresar inversión de la acción.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PREF'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PREF-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-01-1', 'Imposible', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-01-2', 'des-', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-01-3', 'Guatemalteco', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-01-4', 'Felicidad', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«des-» se agrega antes de la base y suele expresar inversión de la acción.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PREF-01-2'
WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PREF-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PREF-02', 'opcion_multiple', 'En «panadería», ¿qué parte es un sufijo derivativo?', 'El sufijo -ería puede formar nombres de establecimientos.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PREF'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PREF-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-02-1', '‑ería', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-02-2', 'Nacional', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-02-3', 'Debajo de', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-02-4', 'Imposible', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El sufijo -ería puede formar nombres de establecimientos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PREF-02-1'
WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PREF-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PREF-03', 'opcion_multiple', '¿Qué significa el prefijo «re-» en «reescribir»?', '«Reescribir» es volver a escribir.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PREF'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PREF-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-03-1', 'Guatemalteco', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-03-2', '‑ería', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-03-3', 'Zapatero', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-03-4', 'Hacer de nuevo', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Reescribir» es volver a escribir.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PREF-03-4'
WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PREF-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PREF-04', 'opcion_multiple', '¿Cuál es una palabra derivada con el sufijo «-ero» a partir de «zapato»?', 'El sufijo -ero permite formar el nombre de un oficio.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PREF'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PREF-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-04-1', '‑ería', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-04-2', 'Zapatero', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-04-3', 'Nacional', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-04-4', 'Felicidad', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El sufijo -ero permite formar el nombre de un oficio.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PREF-04-2'
WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PREF-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PREF-05', 'opcion_multiple', '¿Cuál es la forma con prefijo que expresa lo contrario de «posible»?', '«Im-» es una variante del prefijo negativo in- ante p.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PREF'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PREF-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-05-1', 'des-', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-05-2', 'Hacer de nuevo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-05-3', 'Imposible', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-05-4', 'Aclarar', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Im-» es una variante del prefijo negativo in- ante p.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PREF-05-3'
WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PREF-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PREF-06', 'opcion_multiple', '¿Cuál es el gentilicio habitual de una persona de Guatemala?', '«Guatemalteco» nombra la procedencia del país Guatemala.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PREF'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PREF-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-06-1', 'Guatemalteco', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-06-2', 'Felicidad', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-06-3', 'Imposible', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-06-4', 'Zapatero', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Guatemalteco» nombra la procedencia del país Guatemala.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PREF-06-1'
WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PREF-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PREF-07', 'opcion_multiple', '¿Qué palabra se forma correctamente de «nación» con el sufijo «-al»?', '«Nacional» es un adjetivo derivado de nación.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PREF'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PREF-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-07-1', 'Nacional', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-07-2', 'Hacer de nuevo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-07-3', 'Debajo de', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-07-4', 'Felicidad', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Nacional» es un adjetivo derivado de nación.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PREF-07-1'
WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PREF-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PREF-08', 'opcion_multiple', 'En «submarino», ¿qué expresa el prefijo «sub-»?', '«Sub-» indica posición inferior, como bajo el mar.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PREF'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PREF-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-08-1', '‑ería', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-08-2', 'des-', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-08-3', 'Zapatero', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-08-4', 'Debajo de', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Sub-» indica posición inferior, como bajo el mar.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PREF-08-4'
WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PREF-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PREF-09', 'opcion_multiple', '¿Qué sustantivo se deriva de «feliz» mediante «-dad»?', 'Se modifica la base «feliz» y se añade -idad, variante de -dad.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PREF'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PREF-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-09-1', 'Debajo de', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-09-2', 'des-', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-09-3', 'Felicidad', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-09-4', 'Guatemalteco', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Se modifica la base «feliz» y se añade -idad, variante de -dad.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PREF-09-3'
WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PREF-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PREF-10', 'opcion_multiple', '¿Qué verbo se forma de «claro» con un prefijo y un sufijo?', '«Aclarar» se forma con a- y -ar a partir de «claro».', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PREF'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PREF-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-10-1', 'Guatemalteco', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-10-2', 'Aclarar', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-10-3', 'des-', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PREF-10-4', '‑ería', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Aclarar» se forma con a- y -ar a partir de «claro».'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PREF-10-2'
WHERE c.codigo = 'LEN-PREF' AND p.codigo = 'LEN-PREF-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-SUST-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-SUST-01', 'opcion_multiple', '¿Cuál de estas palabras es un sustantivo abstracto?', 'Nombra una cualidad, no un objeto físico.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-SUST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-SUST-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-01-1', 'Rebaño', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-01-2', 'Valentía', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-01-3', 'Cuidadosamente', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-01-4', 'Comparativo de superioridad', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Nombra una cualidad, no un objeto físico.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-SUST-01-2'
WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-SUST-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-SUST-02', 'opcion_multiple', '¿Cuál es el plural correcto de «lápiz»?', 'La z cambia a c y se agrega -es.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-SUST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-SUST-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-02-1', 'Lápices', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-02-2', 'Dos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-02-3', 'Cuidadosamente', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-02-4', 'Comparativo de superioridad', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La z cambia a c y se agrega -es.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-SUST-02-1'
WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-SUST-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-SUST-03', 'opcion_multiple', 'En «la casa amplia», ¿cuál es el adjetivo?', 'La palabra describe una cualidad de casa.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-SUST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-SUST-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-03-1', 'Dos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-03-2', 'Cuidadosamente', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-03-3', 'Amplia', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-03-4', 'Rebaño', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La palabra describe una cualidad de casa.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-SUST-03-3'
WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-SUST-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-SUST-04', 'opcion_multiple', '¿Cuál es el adverbio de modo en «resolvió cuidadosamente»?', 'Indica cómo se realizó la acción.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-SUST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-SUST-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-04-1', 'Superlativo absoluto', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-04-2', 'Comparativo de superioridad', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-04-3', 'Lápices', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-04-4', 'Cuidadosamente', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Indica cómo se realizó la acción.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-SUST-04-4'
WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-SUST-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-SUST-05', 'opcion_multiple', '¿Qué grado del adjetivo aparece en «más alto que»?', 'La estructura más + adjetivo + que establece una comparación.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-SUST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-SUST-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-05-1', 'Comparativo de superioridad', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-05-2', 'Amplia', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-05-3', 'Árboles', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-05-4', 'Superlativo absoluto', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La estructura más + adjetivo + que establece una comparación.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-SUST-05-1'
WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-SUST-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-SUST-06', 'opcion_multiple', 'En «los árboles verdes», ¿qué palabra es el sustantivo?', 'Nombra seres y funciona como núcleo nominal.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-SUST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-SUST-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-06-1', 'Rebaño', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-06-2', 'Superlativo absoluto', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-06-3', 'Cuidadosamente', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-06-4', 'Árboles', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Nombra seres y funciona como núcleo nominal.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-SUST-06-4'
WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-SUST-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-SUST-07', 'opcion_multiple', '¿Cuál es un sustantivo colectivo?', 'Designa un conjunto de animales, aunque está en singular.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-SUST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-SUST-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-07-1', 'Árboles', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-07-2', 'Rebaño', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-07-3', 'Superlativo absoluto', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-07-4', 'Valentía', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Designa un conjunto de animales, aunque está en singular.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-SUST-07-2'
WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-SUST-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-SUST-08', 'opcion_multiple', '¿Qué grado presenta «muy interesante»?', 'El adverbio «muy» intensifica la cualidad sin compararla con otra.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-SUST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-SUST-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-08-1', 'Rebaño', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-08-2', 'Valentía', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-08-3', 'Superlativo absoluto', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-08-4', 'Árboles', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El adverbio «muy» intensifica la cualidad sin compararla con otra.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-SUST-08-3'
WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-SUST-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-SUST-09', 'opcion_multiple', 'En «Ayer caminamos lentamente», ¿cuál es el adverbio de tiempo?', 'Sitúa la acción en el tiempo.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-SUST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-SUST-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-09-1', 'Ayer', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-09-2', 'Rebaño', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-09-3', 'Superlativo absoluto', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-09-4', 'Comparativo de superioridad', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Sitúa la acción en el tiempo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-SUST-09-1'
WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-SUST-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-SUST-10', 'opcion_multiple', 'En «Las montañas altas parecen lejanas», ¿cuántos adjetivos calificativos hay?', '«Altas» caracteriza a montañas y «lejanas» expresa otra propiedad de ellas.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-SUST'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-SUST-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-10-1', 'Comparativo de superioridad', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-10-2', 'Rebaño', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-10-3', 'Superlativo absoluto', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-SUST-10-4', 'Dos', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Altas» caracteriza a montañas y «lejanas» expresa otra propiedad de ellas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-SUST-10-4'
WHERE c.codigo = 'LEN-SUST' AND p.codigo = 'LEN-SUST-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PRON-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PRON-01', 'opcion_multiple', 'En «Ella terminó el dibujo», ¿qué palabra es pronombre personal?', 'Sustituye o señala a la persona de la que se habla.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PRON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PRON-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-01-1', 'Ana estudia y ella practica.', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-01-2', 'Artículo determinado', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-01-3', 'Demostrativo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-01-4', 'Ella', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Sustituye o señala a la persona de la que se habla.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PRON-01-4'
WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PRON-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PRON-02', 'opcion_multiple', 'En «este cuaderno», ¿qué clase de determinante es «este»?', 'Indica cercanía con respecto a quien habla.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PRON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PRON-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-02-1', 'Demostrativo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-02-2', 'Artículo determinado', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-02-3', 'Distancia media en la referencia tradicional', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-02-4', 'Posesivo', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Indica cercanía con respecto a quien habla.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PRON-02-1'
WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PRON-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PRON-03', 'opcion_multiple', 'En «nuestros amigos», ¿qué clase de determinante es «nuestros»?', 'Expresa una relación de pertenencia.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PRON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PRON-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-03-1', 'Posesivo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-03-2', 'Demostrativo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-03-3', 'Numeral cardinal', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-03-4', 'Artículo determinado', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Expresa una relación de pertenencia.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PRON-03-1'
WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PRON-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PRON-04', 'opcion_multiple', 'En «tres libros», ¿qué clase de determinante es «tres»?', 'Indica una cantidad exacta.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PRON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PRON-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-04-1', 'Ella', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-04-2', 'Indefinido', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-04-3', 'Nosotros', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-04-4', 'Numeral cardinal', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Indica una cantidad exacta.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PRON-04-4'
WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PRON-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PRON-05', 'opcion_multiple', 'En «algunas personas», ¿qué clase de determinante es «algunas»?', 'Indica una cantidad no precisada.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PRON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PRON-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-05-1', 'Numeral cardinal', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-05-2', 'Distancia media en la referencia tradicional', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-05-3', 'Ella', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-05-4', 'Indefinido', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Indica una cantidad no precisada.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PRON-05-4'
WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PRON-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PRON-06', 'opcion_multiple', 'En «el perro», ¿qué clase de palabra es «el»?', 'Presenta al sustantivo como identificable en el contexto.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PRON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PRON-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-06-1', 'Artículo determinado', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-06-2', 'Indefinido', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-06-3', 'Ana estudia y ella practica.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-06-4', 'Distancia media en la referencia tradicional', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Presenta al sustantivo como identificable en el contexto.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PRON-06-1'
WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PRON-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PRON-07', 'opcion_multiple', '¿Cuál de estas formas es un pronombre personal de primera persona plural?', 'Se refiere a un grupo que incluye al hablante.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PRON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PRON-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-07-1', 'Posesivo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-07-2', 'Ana estudia y ella practica.', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-07-3', 'Nosotros', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-07-4', 'Ella', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Se refiere a un grupo que incluye al hablante.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PRON-07-3'
WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PRON-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PRON-08', 'opcion_multiple', 'En «esa mochila», ¿qué señala «esa»?', 'El demostrativo «esa» suele situar algo a distancia intermedia de quien habla.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PRON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PRON-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-08-1', 'Indefinido', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-08-2', 'Artículo determinado', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-08-3', 'Distancia media en la referencia tradicional', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-08-4', 'Dos', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El demostrativo «esa» suele situar algo a distancia intermedia de quien habla.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PRON-08-3'
WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PRON-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PRON-09', 'opcion_multiple', '¿Cuál oración emplea correctamente un pronombre en lugar de repetir «Ana»?', '«Ella» retoma al referente Ana y evita la repetición.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PRON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PRON-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-09-1', 'Numeral cardinal', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-09-2', 'Ella', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-09-3', 'Nosotros', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-09-4', 'Ana estudia y ella practica.', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Ella» retoma al referente Ana y evita la repetición.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PRON-09-4'
WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-PRON-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-PRON-10', 'opcion_multiple', 'En «aquellos cinco árboles», ¿cuántos determinantes acompañan a «árboles»?', '«Aquellos» es demostrativo y «cinco» es numeral.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-PRON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-PRON-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-10-1', 'Demostrativo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-10-2', 'Posesivo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-10-3', 'Ana estudia y ella practica.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-PRON-10-4', 'Dos', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Aquellos» es demostrativo y «cinco» es numeral.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-PRON-10-4'
WHERE c.codigo = 'LEN-PRON' AND p.codigo = 'LEN-PRON-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-VERB-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-VERB-01', 'opcion_multiple', '¿Cuál es el infinitivo del verbo «cantábamos»?', '«Cantábamos» es una forma conjugada del verbo cantar.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-VERB'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-VERB-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-01-1', 'Cantar', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-01-2', 'Futuro simple', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-01-3', 'Estudiaras', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-01-4', 'El equipo resolvió el problema.', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Cantábamos» es una forma conjugada del verbo cantar.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-VERB-01-1'
WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-VERB-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-VERB-02', 'opcion_multiple', 'En «yo estudio», ¿cuál es la persona gramatical?', 'El sujeto «yo» corresponde a primera persona singular.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-VERB'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-VERB-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-02-1', 'Escrito', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-02-2', 'Pretérito perfecto simple', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-02-3', 'Tienen', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-02-4', 'Primera del singular', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El sujeto «yo» corresponde a primera persona singular.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-VERB-02-4'
WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-VERB-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-VERB-03', 'opcion_multiple', '¿Qué tiempo verbal presenta «ayer caminamos» en este contexto?', '«Ayer» sitúa «caminamos» como acción terminada en el pasado.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-VERB'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-VERB-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-03-1', 'Futuro simple', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-03-2', 'Pretérito perfecto simple', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-03-3', 'Tienen', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-03-4', 'Primera del singular', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Ayer» sitúa «caminamos» como acción terminada en el pasado.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-VERB-03-2'
WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-VERB-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-VERB-04', 'opcion_multiple', 'En «mañana viajaremos», ¿qué tiempo expresa el verbo?', '«Viajaremos» se refiere a un hecho posterior.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-VERB'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-VERB-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-04-1', 'Tienen', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-04-2', 'Estudiaras', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-04-3', 'Pasiva perifrástica', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-04-4', 'Futuro simple', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Viajaremos» se refiere a un hecho posterior.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-VERB-04-4'
WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-VERB-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-VERB-05', 'opcion_multiple', '¿Cuál es el participio irregular de «escribir»?', 'El participio de escribir es escrito, no «escribido».', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-VERB'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-VERB-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-05-1', 'Cantar', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-05-2', 'Escrito', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-05-3', 'Tienen', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-05-4', 'Futuro simple', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El participio de escribir es escrito, no «escribido».'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-VERB-05-2'
WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-VERB-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-VERB-06', 'opcion_multiple', '¿Qué modo verbal aparece en «Ojalá llueva»?', '«Llueva» expresa un deseo o posibilidad.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-VERB'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-VERB-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-06-1', 'Subjuntivo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-06-2', 'Primera del singular', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-06-3', 'El equipo resolvió el problema.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-06-4', 'Pretérito perfecto simple', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Llueva» expresa un deseo o posibilidad.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-VERB-06-1'
WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-VERB-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-VERB-07', 'opcion_multiple', '¿Cuál es la forma correcta de «tener» para «ellos» en presente?', '«Tener» presenta irregularidad: ellos tienen.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-VERB'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-VERB-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-07-1', 'Tienen', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-07-2', 'Primera del singular', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-07-3', 'Futuro simple', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-07-4', 'Escrito', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Tener» presenta irregularidad: ellos tienen.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-VERB-07-1'
WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-VERB-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-VERB-08', 'opcion_multiple', 'En «La carta fue enviada por Lucía», ¿qué voz verbal aparece?', 'La estructura ser + participio con complemento agente expresa voz pasiva.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-VERB'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-VERB-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-08-1', 'Futuro simple', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-08-2', 'Pasiva perifrástica', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-08-3', 'Tienen', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-08-4', 'Estudiaras', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La estructura ser + participio con complemento agente expresa voz pasiva.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-VERB-08-2'
WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-VERB-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-VERB-09', 'opcion_multiple', '¿Qué oración está en voz activa?', 'El sujeto «el equipo» realiza directamente la acción del verbo.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-VERB'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-VERB-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-09-1', 'Cantar', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-09-2', 'Primera del singular', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-09-3', 'El equipo resolvió el problema.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-09-4', 'Pretérito perfecto simple', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El sujeto «el equipo» realiza directamente la acción del verbo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-VERB-09-3'
WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-VERB-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-VERB-10', 'opcion_multiple', 'En «Si estudiaras, comprenderías mejor», ¿qué forma verbal expresa la condición hipotética?', 'El imperfecto de subjuntivo introduce la hipótesis.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-VERB'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-VERB-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-10-1', 'Estudiaras', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-10-2', 'Futuro simple', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-10-3', 'Pretérito perfecto simple', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-VERB-10-4', 'Tienen', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El imperfecto de subjuntivo introduce la hipótesis.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-VERB-10-1'
WHERE c.codigo = 'LEN-VERB' AND p.codigo = 'LEN-VERB-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORAC-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORAC-01', 'opcion_multiple', '¿Cuál de estas oraciones es interrogativa directa?', 'Solicita información y usa signos de interrogación.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORAC-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-01-1', 'Complemento indirecto', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-01-2', 'Movió', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-01-3', '¿Dónde está mi mochila?', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-01-4', 'Vuela rápido', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Solicita información y usa signos de interrogación.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORAC-01-3'
WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORAC-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORAC-02', 'opcion_multiple', '¿Cuál es el sujeto en «Los niños leen cuentos»?', 'Es el grupo nominal del que se afirma que lee cuentos.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORAC-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-02-1', 'Complemento indirecto', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-02-2', 'Exclamativa', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-02-3', 'Nosotros', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-02-4', 'Los niños', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Es el grupo nominal del que se afirma que lee cuentos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORAC-02-4'
WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORAC-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORAC-03', 'opcion_multiple', '¿Cuál es el predicado en «El colibrí vuela rápido»?', 'Incluye el verbo y los complementos que se dicen del sujeto.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORAC-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-03-1', 'Vuela rápido', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-03-2', 'Exclamativa', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-03-3', '¿Dónde está mi mochila?', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-03-4', 'Complemento directo', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Incluye el verbo y los complementos que se dicen del sujeto.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORAC-03-1'
WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORAC-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORAC-04', 'opcion_multiple', 'En «Marta compró un libro», ¿qué es «un libro»?', 'Es lo comprado; puede sustituirse por «lo».', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORAC-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-04-1', 'Movió', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-04-2', 'Vuela rápido', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-04-3', 'Complemento directo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-04-4', 'Exclamativa', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Es lo comprado; puede sustituirse por «lo».'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORAC-04-3'
WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORAC-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORAC-05', 'opcion_multiple', 'En «Ana entregó flores a su abuela», ¿qué función tiene «a su abuela»?', 'Indica a quién se destina la entrega; se puede sustituir por «le».', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORAC-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-05-1', 'Exclamativa', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-05-2', 'Nosotros', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-05-3', 'Complemento directo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-05-4', 'Complemento indirecto', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Indica a quién se destina la entrega; se puede sustituir por «le».'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORAC-05-4'
WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORAC-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORAC-06', 'opcion_multiple', 'En «Jugamos en el patio», ¿qué indica «en el patio»?', 'Expresa dónde se realiza la acción.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORAC-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-06-1', 'Complemento directo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-06-2', '¿Dónde está mi mochila?', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-06-3', 'Complemento circunstancial de lugar', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-06-4', 'Exclamativa', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Expresa dónde se realiza la acción.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORAC-06-3'
WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORAC-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORAC-07', 'opcion_multiple', '¿Qué tipo de oración es «¡Qué alegría verte!»?', 'Expresa una emoción mediante una exclamación.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORAC-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-07-1', 'Los niños', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-07-2', '¿Dónde está mi mochila?', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-07-3', 'Exclamativa', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-07-4', 'Nosotros', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Expresa una emoción mediante una exclamación.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORAC-07-3'
WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORAC-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORAC-08', 'opcion_multiple', 'En «El viento movió las hojas», ¿cuál es el núcleo del predicado?', 'El verbo conjugado es el núcleo del predicado verbal.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORAC-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-08-1', 'Nosotros', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-08-2', 'Complemento indirecto', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-08-3', 'Movió', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-08-4', 'Los niños', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El verbo conjugado es el núcleo del predicado verbal.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORAC-08-3'
WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORAC-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORAC-09', 'opcion_multiple', '¿Cuál es el sujeto omitido de «Llegamos temprano»?', 'La terminación verbal -amos señala primera persona plural.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORAC-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-09-1', 'Complemento indirecto', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-09-2', 'Nosotros', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-09-3', 'Ayer', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-09-4', 'Movió', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La terminación verbal -amos señala primera persona plural.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORAC-09-2'
WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-ORAC-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-ORAC-10', 'opcion_multiple', 'En «Ayer, mi hermana preparó una sopa para nosotros», ¿cuál es el complemento circunstancial de tiempo?', 'Indica cuándo ocurrió la acción.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-ORAC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-ORAC-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-10-1', 'Movió', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-10-2', 'Complemento indirecto', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-10-3', 'Ayer', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-ORAC-10-4', '¿Dónde está mi mochila?', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Indica cuándo ocurrió la acción.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-ORAC-10-3'
WHERE c.codigo = 'LEN-ORAC' AND p.codigo = 'LEN-ORAC-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-CONJ-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-CONJ-01', 'opcion_multiple', 'En «El cuaderno está sobre la mesa», ¿qué palabra es preposición?', 'Introduce la relación espacial con «la mesa».', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-CONJ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-CONJ-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-01-1', 'Estar distraído', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-01-2', 'No salimos porque llovía.', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-01-3', 'Sobre', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-01-4', 'Oposición', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Introduce la relación espacial con «la mesa».'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-CONJ-01-3'
WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-CONJ-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-CONJ-02', 'opcion_multiple', 'En «Iré si no llueve», ¿qué palabra introduce la condición?', 'La conjunción «si» introduce una condición.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-CONJ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-CONJ-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-02-1', 'Estar distraído', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-02-2', 'Conviene anticiparse a los riesgos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-02-3', 'Si', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-02-4', 'Tic-tac', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La conjunción «si» introduce una condición.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-CONJ-02-3'
WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-CONJ-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-CONJ-03', 'opcion_multiple', '¿Qué expresa «¡Ay!» en «¡Ay, me golpeé!»?', 'La interjección comunica una reacción emocional o física.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-CONJ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-CONJ-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-03-1', 'Conviene anticiparse a los riesgos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-03-2', 'Oposición', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-03-3', 'Conjunción copulativa', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-03-4', 'Dolor', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La interjección comunica una reacción emocional o física.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-CONJ-03-4'
WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-CONJ-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-CONJ-04', 'opcion_multiple', '¿Cuál es una onomatopeya usada para representar el sonido de un reloj?', 'Imita convencionalmente el sonido repetido del reloj.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-CONJ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-CONJ-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-04-1', 'Tic-tac', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-04-2', 'Dolor', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-04-3', 'Oposición', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-04-4', 'No salimos porque llovía.', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Imita convencionalmente el sonido repetido del reloj.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-CONJ-04-1'
WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-CONJ-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-CONJ-05', 'opcion_multiple', 'En «Quise salir, pero llovía», ¿qué relación introduce «pero»?', 'Es una conjunción adversativa que contrapone las ideas.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-CONJ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-CONJ-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-05-1', 'Oposición', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-05-2', 'Dolor', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-05-3', 'Si', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-05-4', 'Conviene anticiparse a los riesgos', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Es una conjunción adversativa que contrapone las ideas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-CONJ-05-1'
WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-CONJ-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-CONJ-06', 'opcion_multiple', '¿Qué significa el refrán «Más vale prevenir que lamentar»?', 'Recomienda adoptar medidas antes de que ocurra un problema.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-CONJ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-CONJ-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-06-1', 'Si', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-06-2', 'Dolor', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-06-3', 'Conviene anticiparse a los riesgos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-06-4', 'Oposición', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Recomienda adoptar medidas antes de que ocurra un problema.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-CONJ-06-3'
WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-CONJ-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-CONJ-07', 'opcion_multiple', '¿Cuál es la preposición en «Llegó desde Quetzaltenango»?', 'Indica el punto de origen.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-CONJ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-CONJ-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-07-1', 'Desde', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-07-2', 'Estar distraído', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-07-3', 'No salimos porque llovía.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-07-4', 'Conjunción copulativa', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Indica el punto de origen.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-CONJ-07-1'
WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-CONJ-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-CONJ-08', 'opcion_multiple', 'En «Pedro y Ana estudian», ¿qué función cumple «y»?', 'Une dos elementos del mismo nivel.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-CONJ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-CONJ-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-08-1', 'Desde', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-08-2', 'Conjunción copulativa', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-08-3', 'Oposición', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-08-4', 'Si', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Une dos elementos del mismo nivel.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-CONJ-08-2'
WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-CONJ-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-CONJ-09', 'opcion_multiple', '¿Qué significado tiene «estar en las nubes» en sentido figurado?', 'La expresión se usa para quien no presta atención al contexto.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-CONJ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-CONJ-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-09-1', 'Conviene anticiparse a los riesgos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-09-2', 'Conjunción copulativa', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-09-3', 'No salimos porque llovía.', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-09-4', 'Estar distraído', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La expresión se usa para quien no presta atención al contexto.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-CONJ-09-4'
WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- LEN-CONJ-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'LEN-CONJ-10', 'opcion_multiple', '¿Cuál oración usa correctamente una conjunción causal?', '«Porque» presenta la causa de no salir.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'LEN-CONJ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'LEN-CONJ-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-10-1', 'Conjunción copulativa', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-10-2', 'Dolor', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-10-3', 'Tic-tac', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'LEN-CONJ-10-4', 'No salimos porque llovía.', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), '«Porque» presenta la causa de no salir.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'LEN-CONJ-10-4'
WHERE c.codigo = 'LEN-CONJ' AND p.codigo = 'LEN-CONJ-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-PLANT-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-PLANT-01', 'opcion_multiple', '¿Qué estructura de la planta absorbe principalmente agua y sales minerales del suelo?', 'Los pelos absorbentes de las raíces incorporan agua y minerales.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-PLANT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-PLANT-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-01-1', 'Fotosíntesis', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-01-2', 'Raíz', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-01-3', 'Anteras', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-01-4', 'Un esqueje de geranio forma raíces', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los pelos absorbentes de las raíces incorporan agua y minerales.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-PLANT-01-2'
WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-PLANT-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-PLANT-02', 'opcion_multiple', '¿Qué proceso permite a las plantas fabricar azúcares con luz, agua y dióxido de carbono?', 'Las plantas transforman energía luminosa en energía química almacenada en azúcares.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-PLANT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-PLANT-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-02-1', 'Fotosíntesis', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-02-2', 'Anteras', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-02-3', 'Las primeras producen semillas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-02-4', 'Se forman semillas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las plantas transforman energía luminosa en energía química almacenada en azúcares.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-PLANT-02-1'
WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-PLANT-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-PLANT-03', 'opcion_multiple', '¿En qué orgánulos de las células vegetales ocurre principalmente la fotosíntesis?', 'Contienen clorofila y otros componentes necesarios para captar energía luminosa.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-PLANT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-PLANT-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-03-1', 'Un esqueje de geranio forma raíces', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-03-2', 'Floema', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-03-3', 'Cloroplastos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-03-4', 'Fotosíntesis', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Contienen clorofila y otros componentes necesarios para captar energía luminosa.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-PLANT-03-3'
WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-PLANT-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-PLANT-04', 'opcion_multiple', '¿Qué tejido transporta agua y sales minerales desde la raíz?', 'El xilema conduce la savia bruta hacia las partes aéreas.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-PLANT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-PLANT-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-04-1', 'Cloroplastos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-04-2', 'Floema', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-04-3', 'Las primeras producen semillas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-04-4', 'Xilema', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El xilema conduce la savia bruta hacia las partes aéreas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-PLANT-04-4'
WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-PLANT-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-PLANT-05', 'opcion_multiple', '¿Qué tejido distribuye los azúcares producidos en la fotosíntesis?', 'El floema transporta sustancias orgánicas a otras partes de la planta.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-PLANT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-PLANT-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-05-1', 'Cloroplastos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-05-2', 'Para intercambiar gases y regular la pérdida de agua', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-05-3', 'Fotosíntesis', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-05-4', 'Floema', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El floema transporta sustancias orgánicas a otras partes de la planta.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-PLANT-05-4'
WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-PLANT-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-PLANT-06', 'opcion_multiple', '¿Qué parte de una flor produce el polen?', 'Las anteras, parte del estambre, forman los granos de polen.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-PLANT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-PLANT-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-06-1', 'Cloroplastos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-06-2', 'Raíz', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-06-3', 'Floema', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-06-4', 'Anteras', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las anteras, parte del estambre, forman los granos de polen.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-PLANT-06-4'
WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-PLANT-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-PLANT-07', 'opcion_multiple', '¿Qué ocurre después de la fecundación en muchas plantas con flores?', 'El óvulo fecundado se desarrolla hasta originar una semilla.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-PLANT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-PLANT-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-07-1', 'Floema', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-07-2', 'Se forman semillas', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-07-3', 'Raíz', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-07-4', 'Xilema', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El óvulo fecundado se desarrolla hasta originar una semilla.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-PLANT-07-2'
WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-PLANT-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-PLANT-08', 'opcion_multiple', '¿Cuál es un ejemplo de reproducción asexual vegetal?', 'Una parte vegetativa produce otra planta sin unión de gametos.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-PLANT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-PLANT-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-08-1', 'Floema', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-08-2', 'Un esqueje de geranio forma raíces', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-08-3', 'Xilema', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-08-4', 'Se forman semillas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Una parte vegetativa produce otra planta sin unión de gametos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-PLANT-08-2'
WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-PLANT-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-PLANT-09', 'opcion_multiple', '¿En qué se diferencian, de forma general, las plantas con semillas de los musgos?', 'Los musgos se reproducen mediante esporas y carecen de semillas.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-PLANT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-PLANT-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-09-1', 'Xilema', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-09-2', 'Anteras', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-09-3', 'Se forman semillas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-09-4', 'Las primeras producen semillas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los musgos se reproducen mediante esporas y carecen de semillas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-PLANT-09-4'
WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-PLANT-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-PLANT-10', 'opcion_multiple', '¿Por qué las hojas suelen tener estomas?', 'Los estomas permiten la entrada de CO₂ y salida de oxígeno y vapor de agua.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-PLANT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-PLANT-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-10-1', 'Raíz', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-10-2', 'Xilema', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-10-3', 'Floema', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-PLANT-10-4', 'Para intercambiar gases y regular la pérdida de agua', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los estomas permiten la entrada de CO₂ y salida de oxígeno y vapor de agua.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-PLANT-10-4'
WHERE c.codigo = 'NAT-PLANT' AND p.codigo = 'NAT-PLANT-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ECO-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ECO-01', 'opcion_multiple', '¿Qué incluye un ecosistema además de los seres vivos?', 'Incluye suelo, agua, luz y condiciones físicas que interactúan con la comunidad.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ECO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ECO-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-01-1', 'Temperatura', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-01-2', 'Producción de frutos y semillas', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-01-3', 'Factores no vivos del entorno', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-01-4', 'Alga fotosintética', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Incluye suelo, agua, luz y condiciones físicas que interactúan con la comunidad.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ECO-01-3'
WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ECO-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ECO-02', 'opcion_multiple', '¿Qué factor es abiótico en un bosque?', 'La temperatura es una condición física, no un organismo.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ECO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ECO-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-02-1', 'Temperatura', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-02-2', 'Saltamontes', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-02-3', 'Transforman materia orgánica muerta', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-02-4', 'En una laguna', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La temperatura es una condición física, no un organismo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ECO-02-1'
WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ECO-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ECO-03', 'opcion_multiple', '¿Cuál es un productor en un ecosistema de lago?', 'Las algas autótrofas producen materia orgánica mediante fotosíntesis.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ECO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ECO-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-03-1', 'Saltamontes', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-03-2', 'Mayor manejo humano en el cultivo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-03-3', 'Alga fotosintética', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-03-4', 'En una laguna', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las algas autótrofas producen materia orgánica mediante fotosíntesis.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ECO-03-3'
WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ECO-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ECO-04', 'opcion_multiple', '¿Cuál es un consumidor primario en una cadena con hierba, saltamontes y rana?', 'Come al productor, la hierba, y es presa de la rana.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ECO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ECO-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-04-1', 'Factores no vivos del entorno', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-04-2', 'Saltamontes', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-04-3', 'En una laguna', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-04-4', 'Temperatura', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Come al productor, la hierba, y es presa de la rana.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ECO-04-2'
WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ECO-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ECO-05', 'opcion_multiple', '¿Qué hacen los descomponedores?', 'Hongos y bacterias liberan nutrientes que pueden reutilizarse.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ECO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ECO-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-05-1', 'Producción de frutos y semillas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-05-2', 'Factores no vivos del entorno', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-05-3', 'Transforman materia orgánica muerta', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-05-4', 'Alga fotosintética', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Hongos y bacterias liberan nutrientes que pueden reutilizarse.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ECO-05-3'
WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ECO-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ECO-06', 'opcion_multiple', '¿Dónde se encuentra un ecosistema acuático de agua dulce?', 'Las lagunas contienen ecosistemas de agua dulce.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ECO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ECO-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-06-1', 'Bosque nuboso', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-06-2', 'Mayor manejo humano en el cultivo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-06-3', 'Factores no vivos del entorno', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-06-4', 'En una laguna', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las lagunas contienen ecosistemas de agua dulce.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ECO-06-4'
WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ECO-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ECO-07', 'opcion_multiple', '¿Cuál es un ejemplo de ecosistema terrestre en Guatemala?', 'Los bosques nubosos de montaña son ecosistemas terrestres.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ECO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ECO-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-07-1', 'Aporta distintas funciones ecológicas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-07-2', 'Bosque nuboso', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-07-3', 'Transforman materia orgánica muerta', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-07-4', 'En una laguna', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los bosques nubosos de montaña son ecosistemas terrestres.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ECO-07-2'
WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ECO-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ECO-08', 'opcion_multiple', '¿Qué diferencia a un cultivo agrícola de un bosque con poca intervención humana?', 'El cultivo se organiza y modifica intencionalmente para producir alimentos.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ECO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ECO-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-08-1', 'Factores no vivos del entorno', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-08-2', 'Bosque nuboso', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-08-3', 'Mayor manejo humano en el cultivo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-08-4', 'Transforman materia orgánica muerta', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El cultivo se organiza y modifica intencionalmente para producir alimentos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ECO-08-3'
WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ECO-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ECO-09', 'opcion_multiple', 'Si desaparecen los polinizadores, ¿qué proceso puede reducirse en muchas plantas?', 'Numerosas flores dependen de animales para trasladar el polen.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ECO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ECO-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-09-1', 'Alga fotosintética', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-09-2', 'Mayor manejo humano en el cultivo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-09-3', 'Temperatura', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-09-4', 'Producción de frutos y semillas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Numerosas flores dependen de animales para trasladar el polen.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ECO-09-4'
WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ECO-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ECO-10', 'opcion_multiple', '¿Por qué la diversidad de especies puede ayudar a la estabilidad ecológica?', 'La variedad de organismos puede aumentar alternativas ante cambios ambientales.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ECO'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ECO-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-10-1', 'Aporta distintas funciones ecológicas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-10-2', 'Transforman materia orgánica muerta', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-10-3', 'Alga fotosintética', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ECO-10-4', 'Bosque nuboso', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La variedad de organismos puede aumentar alternativas ante cambios ambientales.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ECO-10-1'
WHERE c.codigo = 'NAT-ECO' AND p.codigo = 'NAT-ECO-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-BIOS-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-BIOS-01', 'opcion_multiple', '¿Qué es un hábitat?', 'Incluye condiciones y recursos necesarios para su supervivencia.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-BIOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-BIOS-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-01-1', 'Facilitar movimiento de especies', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-01-2', 'Lugar donde vive una especie', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-01-3', 'Rana', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-01-4', 'Puede disminuir el oxígeno disponible', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Incluye condiciones y recursos necesarios para su supervivencia.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-BIOS-01-2'
WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-BIOS-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-BIOS-02', 'opcion_multiple', '¿Con qué inicia normalmente una cadena alimentaria basada en fotosíntesis?', 'Plantas y algas convierten energía solar en materia orgánica.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-BIOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-BIOS-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-02-1', 'Mayor erosión del suelo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-02-2', 'Productor', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-02-3', 'Facilitar movimiento de especies', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-02-4', 'Puede disminuir el oxígeno disponible', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Plantas y algas convierten energía solar en materia orgánica.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-BIOS-02-2'
WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-BIOS-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-BIOS-03', 'opcion_multiple', '¿Qué representa la flecha en «hierba → conejo»?', 'Señala que el conejo obtiene materia y energía al consumir hierba.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-BIOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-BIOS-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-03-1', 'Rana', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-03-2', 'Pueden alterar las especies locales', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-03-3', 'Facilitar movimiento de especies', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-03-4', 'Flujo de energía hacia el consumidor', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Señala que el conejo obtiene materia y energía al consumir hierba.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-BIOS-03-4'
WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-BIOS-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-BIOS-04', 'opcion_multiple', '¿Qué organismo ocupa el nivel de consumidor secundario en «pasto → saltamontes → rana»?', 'La rana se alimenta del consumidor primario, el saltamontes.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-BIOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-BIOS-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-04-1', 'Facilitar movimiento de especies', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-04-2', 'Rana', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-04-3', 'Productor', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-04-4', 'Puede disminuir el oxígeno disponible', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La rana se alimenta del consumidor primario, el saltamontes.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-BIOS-04-2'
WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-BIOS-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-BIOS-05', 'opcion_multiple', '¿Cuál es una acción directa para reducir residuos domésticos?', 'Alargar la vida útil de objetos disminuye desechos generados.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-BIOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-BIOS-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-05-1', 'Puede disminuir el oxígeno disponible', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-05-2', 'Facilitar movimiento de especies', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-05-3', 'Reutilizar recipientes', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-05-4', 'Flujo de energía hacia el consumidor', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Alargar la vida útil de objetos disminuye desechos generados.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-BIOS-05-3'
WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-BIOS-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-BIOS-06', 'opcion_multiple', '¿Qué sucede cuando se contamina un río con aguas residuales no tratadas?', 'La degradación microbiana de materia orgánica puede consumir oxígeno disuelto.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-BIOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-BIOS-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-06-1', 'Reutilizar recipientes', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-06-2', 'Mayor erosión del suelo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-06-3', 'Puede disminuir el oxígeno disponible', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-06-4', 'Pueden alterar las especies locales', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La degradación microbiana de materia orgánica puede consumir oxígeno disuelto.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-BIOS-06-3'
WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-BIOS-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-BIOS-07', 'opcion_multiple', '¿Qué problema puede causar la deforestación en laderas?', 'La pérdida de raíces y cobertura vegetal facilita el arrastre del suelo.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-BIOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-BIOS-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-07-1', 'Pueden alterar las especies locales', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-07-2', 'Flujo de energía hacia el consumidor', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-07-3', 'Mayor erosión del suelo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-07-4', 'Productor', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La pérdida de raíces y cobertura vegetal facilita el arrastre del suelo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-BIOS-07-3'
WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-BIOS-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-BIOS-08', 'opcion_multiple', '¿Qué medida ayuda a proteger un nacimiento de agua?', 'La vegetación protege el suelo y favorece procesos de infiltración.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-BIOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-BIOS-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-08-1', 'Rana', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-08-2', 'Reutilizar recipientes', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-08-3', 'Conservar la vegetación cercana', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-08-4', 'Facilitar movimiento de especies', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La vegetación protege el suelo y favorece procesos de infiltración.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-BIOS-08-3'
WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-BIOS-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-BIOS-09', 'opcion_multiple', '¿Por qué no conviene liberar mascotas exóticas en áreas naturales?', 'Algunas pueden competir, depredar o transmitir enfermedades a especies nativas.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-BIOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-BIOS-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-09-1', 'Reutilizar recipientes', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-09-2', 'Lugar donde vive una especie', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-09-3', 'Productor', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-09-4', 'Pueden alterar las especies locales', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Algunas pueden competir, depredar o transmitir enfermedades a especies nativas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-BIOS-09-4'
WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-BIOS-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-BIOS-10', 'opcion_multiple', '¿Qué beneficio ofrece restaurar corredores biológicos entre bosques?', 'La conectividad permite desplazamiento y flujo genético entre poblaciones.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-BIOS'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-BIOS-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-10-1', 'Flujo de energía hacia el consumidor', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-10-2', 'Productor', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-10-3', 'Facilitar movimiento de especies', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-BIOS-10-4', 'Lugar donde vive una especie', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La conectividad permite desplazamiento y flujo genético entre poblaciones.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-BIOS-10-3'
WHERE c.codigo = 'NAT-BIOS' AND p.codigo = 'NAT-BIOS-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAT-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAT-01', 'opcion_multiple', '¿Qué propiedad indica cuánta materia tiene un objeto?', 'La masa se relaciona con la cantidad de materia y se mide habitualmente en kg o g.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAT-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-01-1', '8 g/cm³', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-01-2', 'Se conserva', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-01-3', 'Volumen', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-01-4', 'Masa', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La masa se relaciona con la cantidad de materia y se mide habitualmente en kg o g.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAT-01-4'
WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAT-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAT-02', 'opcion_multiple', '¿Qué propiedad corresponde al espacio ocupado por un cuerpo?', 'El volumen mide el espacio tridimensional ocupado.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAT-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-02-1', 'Volumen', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-02-2', 'Se expande para ocupar el recipiente', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-02-3', '8 g/cm³', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-02-4', 'Masa', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El volumen mide el espacio tridimensional ocupado.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAT-02-1'
WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAT-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAT-03', 'opcion_multiple', '¿Cuál es la unidad del sistema internacional para medir masa?', 'El kilogramo es la unidad base de masa del SI.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAT-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-03-1', 'Flotar', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-03-2', 'Kilogramo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-03-3', '8 g/cm³', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-03-4', '4 g/cm³', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El kilogramo es la unidad base de masa del SI.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAT-03-2'
WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAT-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAT-04', 'opcion_multiple', '¿Cuál es la densidad de un objeto de masa 200 g y volumen 50 cm³?', 'Densidad = masa/volumen = 200/50 = 4 g/cm³.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAT-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-04-1', 'Se expande para ocupar el recipiente', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-04-2', '4 g/cm³', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-04-3', 'Masa', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-04-4', 'Volumen', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Densidad = masa/volumen = 200/50 = 4 g/cm³.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAT-04-2'
WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAT-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAT-05', 'opcion_multiple', 'Un material tiene menor densidad que el agua y no absorbe agua. ¿Qué tenderá a hacer al colocarlo suavemente?', 'Si su densidad media es menor, puede alcanzar equilibrio flotando.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAT-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-05-1', 'Se conserva', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-05-2', 'Flotar', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-05-3', 'Kilogramo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-05-4', '8 g/cm³', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Si su densidad media es menor, puede alcanzar equilibrio flotando.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAT-05-2'
WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAT-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAT-06', 'opcion_multiple', '¿Qué estado tiene volumen definido pero toma la forma de su recipiente?', 'Un líquido mantiene aproximadamente su volumen y se adapta al contenedor.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAT-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-06-1', 'Líquido', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-06-2', '8 g/cm³', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-06-3', 'Se expande para ocupar el recipiente', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-06-4', 'Flotar', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Un líquido mantiene aproximadamente su volumen y se adapta al contenedor.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAT-06-1'
WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAT-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAT-07', 'opcion_multiple', '¿Qué cambio de estado ocurre de sólido a líquido?', 'La fusión sucede cuando un sólido pasa a estado líquido.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAT-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-07-1', 'Volumen', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-07-2', 'Fusión', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-07-3', '4 g/cm³', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-07-4', 'Se conserva', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La fusión sucede cuando un sólido pasa a estado líquido.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAT-07-2'
WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAT-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAT-08', 'opcion_multiple', '¿Qué sucede con la masa del agua cuando un hielo se derrite sin perder material?', 'En un sistema cerrado, cambiar de estado no crea ni destruye materia.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAT-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-08-1', 'Se conserva', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-08-2', 'Líquido', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-08-3', 'Masa', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-08-4', '8 g/cm³', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'En un sistema cerrado, cambiar de estado no crea ni destruye materia.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAT-08-1'
WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAT-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAT-09', 'opcion_multiple', '¿Qué propiedad distingue principalmente a un gas de un líquido en un recipiente cerrado?', 'Los gases no tienen volumen propio fijo, a diferencia de los líquidos.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAT-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-09-1', 'Se expande para ocupar el recipiente', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-09-2', '4 g/cm³', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-09-3', 'Se conserva', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-09-4', 'Volumen', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los gases no tienen volumen propio fijo, a diferencia de los líquidos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAT-09-1'
WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAT-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAT-10', 'opcion_multiple', 'Un cubo de 2 cm de arista tiene una masa de 64 g. ¿Cuál es su densidad?', 'Volumen = 2³ = 8 cm³; densidad = 64/8 = 8 g/cm³.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAT'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAT-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-10-1', 'Líquido', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-10-2', 'Se conserva', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-10-3', 'Fusión', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAT-10-4', '8 g/cm³', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Volumen = 2³ = 8 cm³; densidad = 64/8 = 8 g/cm³.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAT-10-4'
WHERE c.codigo = 'NAT-MAT' AND p.codigo = 'NAT-MAT-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ENER-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ENER-01', 'opcion_multiple', '¿Qué tipo de energía está relacionada con el movimiento de un objeto?', 'La energía cinética depende de la masa y la rapidez del cuerpo.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ENER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ENER-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-01-1', 'Energía del agua en movimiento o caída', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-01-2', 'Cinética', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-01-3', 'Transforma luz en energía eléctrica', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-01-4', 'Evita uso innecesario de energía', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La energía cinética depende de la masa y la rapidez del cuerpo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ENER-01-2'
WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ENER-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ENER-02', 'opcion_multiple', '¿Qué transformación ocurre principalmente en una linterna encendida?', 'La pila convierte energía química en eléctrica; el foco emite luz y calor.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ENER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ENER-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-02-1', 'Foco LED', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-02-2', 'Cinética', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-02-3', 'Química a eléctrica y luminosa', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-02-4', 'Evita uso innecesario de energía', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La pila convierte energía química en eléctrica; el foco emite luz y calor.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ENER-02-3'
WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ENER-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ENER-03', 'opcion_multiple', '¿Cuál es una fuente renovable de energía?', 'Se repone por procesos naturales en escalas humanas.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ENER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ENER-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-03-1', 'Luz solar', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-03-2', 'Evita uso innecesario de energía', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-03-3', 'Transforma luz en energía eléctrica', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-03-4', 'Energía del agua en movimiento o caída', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Se repone por procesos naturales en escalas humanas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ENER-03-1'
WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ENER-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ENER-04', 'opcion_multiple', '¿Cuál es una fuente no renovable?', 'Su formación geológica es demasiado lenta para reponerse al ritmo del consumo.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ENER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ENER-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-04-1', 'La energía total no se crea ni se destruye', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-04-2', 'Cinética', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-04-3', 'Transforma luz en energía eléctrica', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-04-4', 'Carbón mineral', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Su formación geológica es demasiado lenta para reponerse al ritmo del consumo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ENER-04-4'
WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ENER-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ENER-05', 'opcion_multiple', '¿Qué energía almacena una liga estirada?', 'La deformación permite almacenar energía recuperable al soltarla.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ENER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ENER-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-05-1', 'Potencial elástica', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-05-2', 'Cinética', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-05-3', 'Química a eléctrica y luminosa', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-05-4', 'Transforma luz en energía eléctrica', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La deformación permite almacenar energía recuperable al soltarla.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ENER-05-1'
WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ENER-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ENER-06', 'opcion_multiple', '¿Por qué un panel fotovoltaico produce electricidad durante el día?', 'Las celdas fotovoltaicas convierten parte de la energía de la luz.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ENER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ENER-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-06-1', 'Energía del agua en movimiento o caída', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-06-2', 'Potencial elástica', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-06-3', 'Transforma luz en energía eléctrica', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-06-4', 'Evita uso innecesario de energía', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las celdas fotovoltaicas convierten parte de la energía de la luz.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ENER-06-3'
WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ENER-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ENER-07', 'opcion_multiple', '¿Qué aparato doméstico suele consumir menos para iluminar igual que un foco incandescente?', 'Los LED requieren menos energía eléctrica para producir una iluminación comparable.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ENER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ENER-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-07-1', 'Foco LED', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-07-2', 'Energía del agua en movimiento o caída', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-07-3', 'Cinética', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-07-4', 'Carbón mineral', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los LED requieren menos energía eléctrica para producir una iluminación comparable.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ENER-07-1'
WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ENER-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ENER-08', 'opcion_multiple', '¿Qué significa conservar la energía en una transformación?', 'Puede transferirse o transformarse en otras formas.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ENER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ENER-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-08-1', 'La energía total no se crea ni se destruye', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-08-2', 'Energía del agua en movimiento o caída', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-08-3', 'Evita uso innecesario de energía', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-08-4', 'Luz solar', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Puede transferirse o transformarse en otras formas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ENER-08-1'
WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ENER-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ENER-09', 'opcion_multiple', '¿Qué fuente aprovecha una central hidroeléctrica?', 'La corriente mueve turbinas conectadas a generadores.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ENER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ENER-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-09-1', 'Cinética', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-09-2', 'Química a eléctrica y luminosa', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-09-3', 'Energía del agua en movimiento o caída', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-09-4', 'Foco LED', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La corriente mueve turbinas conectadas a generadores.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ENER-09-3'
WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ENER-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ENER-10', 'opcion_multiple', '¿Por qué apagar luces de espacios vacíos reduce el consumo eléctrico?', 'Reduce el tiempo de funcionamiento sin afectar la iluminación requerida.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ENER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ENER-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-10-1', 'Química a eléctrica y luminosa', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-10-2', 'Transforma luz en energía eléctrica', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-10-3', 'Evita uso innecesario de energía', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ENER-10-4', 'La energía total no se crea ni se destruye', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Reduce el tiempo de funcionamiento sin afectar la iluminación requerida.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ENER-10-3'
WHERE c.codigo = 'NAT-ENER' AND p.codigo = 'NAT-ENER-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ELEC-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ELEC-01', 'opcion_multiple', '¿Qué es necesario para que circule corriente en un circuito simple con pila?', 'Las cargas necesitan una trayectoria completa entre los terminales.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ELEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ELEC-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-01-1', 'Aumenta el riesgo de descarga eléctrica', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-01-2', 'Paralelo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-01-3', 'Un camino conductor cerrado', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-01-4', 'Voltímetro', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las cargas necesitan una trayectoria completa entre los terminales.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ELEC-01-3'
WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ELEC-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ELEC-02', 'opcion_multiple', '¿Qué material suele ser buen conductor de electricidad?', 'Sus electrones móviles permiten una conducción eléctrica eficiente.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ELEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ELEC-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-02-1', 'Magnetismo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-02-2', 'Aumenta el riesgo de descarga eléctrica', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-02-3', 'Cobre', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-02-4', 'Se apaga', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Sus electrones móviles permiten una conducción eléctrica eficiente.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ELEC-02-3'
WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ELEC-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ELEC-03', 'opcion_multiple', '¿Qué material se usa comúnmente para aislar cables?', 'Muchos polímeros dificultan el paso de corriente y protegen al usuario.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ELEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ELEC-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-03-1', 'Plástico aislante', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-03-2', 'Se apaga', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-03-3', 'Paralelo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-03-4', 'Dos polos norte', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Muchos polímeros dificultan el paso de corriente y protegen al usuario.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ELEC-03-1'
WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ELEC-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ELEC-04', 'opcion_multiple', '¿Qué ocurre con un foco en serie si se abre el interruptor del circuito?', 'Al interrumpir el camino cerrado deja de circular corriente.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ELEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ELEC-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-04-1', 'Dos polos norte', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-04-2', 'Voltímetro', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-04-3', 'Paralelo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-04-4', 'Se apaga', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Al interrumpir el camino cerrado deja de circular corriente.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ELEC-04-4'
WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ELEC-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ELEC-05', 'opcion_multiple', '¿Qué instrumento permite medir el voltaje?', 'Mide diferencia de potencial entre dos puntos.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ELEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ELEC-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-05-1', 'Un camino conductor cerrado', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-05-2', 'Voltímetro', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-05-3', 'Plástico aislante', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-05-4', 'Abrir o cerrar el circuito', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Mide diferencia de potencial entre dos puntos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ELEC-05-2'
WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ELEC-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ELEC-06', 'opcion_multiple', '¿Cómo se denomina la propiedad de un imán de atraer ciertos materiales?', 'Algunos materiales como hierro responden fuertemente a campos magnéticos.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ELEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ELEC-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-06-1', 'Aumenta el riesgo de descarga eléctrica', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-06-2', 'Cobre', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-06-3', 'Magnetismo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-06-4', 'Plástico aislante', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Algunos materiales como hierro responden fuertemente a campos magnéticos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ELEC-06-3'
WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ELEC-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ELEC-07', 'opcion_multiple', '¿Qué polos magnéticos se repelen entre sí?', 'Los polos del mismo tipo se repelen.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ELEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ELEC-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-07-1', 'Dos polos norte', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-07-2', 'Se apaga', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-07-3', 'Voltímetro', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-07-4', 'Abrir o cerrar el circuito', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los polos del mismo tipo se repelen.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ELEC-07-1'
WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ELEC-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ELEC-08', 'opcion_multiple', '¿Para qué sirve el interruptor de una lámpara sencilla?', 'Controla el paso de corriente hacia la lámpara.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ELEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ELEC-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-08-1', 'Plástico aislante', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-08-2', 'Un camino conductor cerrado', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-08-3', 'Abrir o cerrar el circuito', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-08-4', 'Dos polos norte', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Controla el paso de corriente hacia la lámpara.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ELEC-08-3'
WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ELEC-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ELEC-09', 'opcion_multiple', '¿Qué conexión permite que otros focos sigan encendidos si uno se funde, en condiciones normales?', 'Cada rama tiene su propio camino de corriente.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ELEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ELEC-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-09-1', 'Abrir o cerrar el circuito', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-09-2', 'Cobre', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-09-3', 'Se apaga', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-09-4', 'Paralelo', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Cada rama tiene su propio camino de corriente.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ELEC-09-4'
WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-ELEC-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-ELEC-10', 'opcion_multiple', '¿Por qué no se deben manipular enchufes con manos mojadas?', 'La humedad puede reducir la resistencia eléctrica de la piel.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-ELEC'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-ELEC-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-10-1', 'Dos polos norte', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-10-2', 'Voltímetro', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-10-3', 'Aumenta el riesgo de descarga eléctrica', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-ELEC-10-4', 'Cobre', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La humedad puede reducir la resistencia eléctrica de la piel.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-ELEC-10-3'
WHERE c.codigo = 'NAT-ELEC' AND p.codigo = 'NAT-ELEC-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAQ-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAQ-01', 'opcion_multiple', '¿Cuál es una máquina simple que gira alrededor de un punto de apoyo?', 'Su barra rígida gira en torno al fulcro para transmitir fuerzas.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAQ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAQ-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-01-1', 'Cuña', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-01-2', 'Plano inclinado', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-01-3', 'Polea', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-01-4', 'Palanca', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Su barra rígida gira en torno al fulcro para transmitir fuerzas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAQ-01-4'
WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAQ-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAQ-02', 'opcion_multiple', '¿Qué máquina simple se usa en una rampa?', 'Reduce la fuerza necesaria para subir algo a cambio de más recorrido.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAQ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAQ-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-02-1', 'Intercambian fuerza por distancia o tiempo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-02-2', 'Plano inclinado', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-02-3', 'Engranajes', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-02-4', 'Cuña', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Reduce la fuerza necesaria para subir algo a cambio de más recorrido.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAQ-02-2'
WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAQ-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAQ-03', 'opcion_multiple', '¿Qué máquina simple forma la hoja cortante de un hacha?', 'La cuña transforma fuerza aplicada en fuerzas laterales de separación.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAQ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAQ-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-03-1', 'Palanca', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-03-2', 'Polea', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-03-3', 'Plano inclinado enrollado', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-03-4', 'Cuña', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La cuña transforma fuerza aplicada en fuerzas laterales de separación.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAQ-03-4'
WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAQ-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAQ-04', 'opcion_multiple', '¿Qué máquina simple emplea una cuerda sobre una rueda acanalada?', 'Puede cambiar la dirección de la fuerza y, en sistemas compuestos, reducir su magnitud.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAQ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAQ-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-04-1', 'Combinan palancas y cuñas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-04-2', 'Plano inclinado enrollado', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-04-3', 'Polea', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-04-4', 'Intercambian fuerza por distancia o tiempo', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Puede cambiar la dirección de la fuerza y, en sistemas compuestos, reducir su magnitud.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAQ-04-3'
WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAQ-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAQ-05', 'opcion_multiple', '¿Qué máquina simple representa un tornillo?', 'Su rosca funciona como un plano inclinado alrededor de un cilindro.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAQ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAQ-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-05-1', 'La fuente principal de energía', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-05-2', 'Intercambian fuerza por distancia o tiempo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-05-3', 'Engranajes', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-05-4', 'Plano inclinado enrollado', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Su rosca funciona como un plano inclinado alrededor de un cilindro.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAQ-05-4'
WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAQ-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAQ-06', 'opcion_multiple', '¿Por qué las tijeras se consideran una máquina compuesta?', 'Los mangos funcionan como palancas y las hojas como cuñas cortantes.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAQ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAQ-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-06-1', 'Combinan palancas y cuñas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-06-2', 'Facilita transportar una carga', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-06-3', 'Plano inclinado enrollado', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-06-4', 'La fuente principal de energía', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los mangos funcionan como palancas y las hojas como cuñas cortantes.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAQ-06-1'
WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAQ-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAQ-07', 'opcion_multiple', '¿Qué ventaja ofrece una carretilla al mover tierra?', 'La combinación de rueda y palanca ayuda a desplazar peso.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAQ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAQ-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-07-1', 'Palanca', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-07-2', 'Plano inclinado', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-07-3', 'Cuña', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-07-4', 'Facilita transportar una carga', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La combinación de rueda y palanca ayuda a desplazar peso.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAQ-07-4'
WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAQ-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAQ-08', 'opcion_multiple', '¿Qué mecanismo se usa para transmitir giro entre ejes mediante ruedas dentadas?', 'Sus dientes transmiten movimiento y fuerza de un eje a otro.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAQ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAQ-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-08-1', 'Intercambian fuerza por distancia o tiempo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-08-2', 'Facilita transportar una carga', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-08-3', 'Engranajes', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-08-4', 'La fuente principal de energía', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Sus dientes transmiten movimiento y fuerza de un eje a otro.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAQ-08-3'
WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAQ-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAQ-09', 'opcion_multiple', '¿Cuál es una diferencia entre una máquina manual y una motorizada?', 'La manual usa esfuerzo humano y la motorizada utiliza un motor.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAQ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAQ-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-09-1', 'Combinan palancas y cuñas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-09-2', 'Intercambian fuerza por distancia o tiempo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-09-3', 'Facilita transportar una carga', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-09-4', 'La fuente principal de energía', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La manual usa esfuerzo humano y la motorizada utiliza un motor.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAQ-09-4'
WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- NAT-MAQ-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'NAT-MAQ-10', 'opcion_multiple', '¿Por qué las máquinas no eliminan el trabajo físico necesario?', 'Pueden facilitar tareas, pero no crean energía de la nada.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'NAT-MAQ'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'NAT-MAQ-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-10-1', 'Combinan palancas y cuñas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-10-2', 'Engranajes', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-10-3', 'Plano inclinado', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'NAT-MAQ-10-4', 'Intercambian fuerza por distancia o tiempo', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Pueden facilitar tareas, pero no crean energía de la nada.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'NAT-MAQ-10-4'
WHERE c.codigo = 'NAT-MAQ' AND p.codigo = 'NAT-MAQ-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-UNIV-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-UNIV-01', 'opcion_multiple', '¿Qué estrella está en el centro del sistema solar?', 'La gravedad del Sol mantiene a los planetas en sus órbitas.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-UNIV'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-UNIV-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-01-1', 'Vía Láctea', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-01-2', 'Cambia la porción iluminada visible desde la Tierra', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-01-3', 'Traslación', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-01-4', 'El Sol', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La gravedad del Sol mantiene a los planetas en sus órbitas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-UNIV-01-4'
WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-UNIV-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-UNIV-02', 'opcion_multiple', '¿Qué planeta es el tercero contando desde el Sol?', 'El orden inicial es Mercurio, Venus y Tierra.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-UNIV'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-UNIV-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-02-1', 'Rotación', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-02-2', 'La Tierra', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-02-3', 'Júpiter', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-02-4', 'La Luna', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El orden inicial es Mercurio, Venus y Tierra.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-UNIV-02-2'
WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-UNIV-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-UNIV-03', 'opcion_multiple', '¿Cuál es el satélite natural de la Tierra?', 'La Luna orbita nuestro planeta.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-UNIV'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-UNIV-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-03-1', 'Júpiter', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-03-2', 'El Sol', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-03-3', 'La Luna', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-03-4', 'Rotación', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La Luna orbita nuestro planeta.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-UNIV-03-3'
WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-UNIV-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-UNIV-04', 'opcion_multiple', '¿Qué movimiento terrestre produce la alternancia de día y noche?', 'La Tierra gira alrededor de su eje aproximadamente cada 24 horas.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-UNIV'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-UNIV-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-04-1', 'Traslación', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-04-2', 'La Tierra', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-04-3', 'Rotación', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-04-4', 'El Sol', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La Tierra gira alrededor de su eje aproximadamente cada 24 horas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-UNIV-04-3'
WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-UNIV-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-UNIV-05', 'opcion_multiple', '¿Qué movimiento completa la Tierra alrededor del Sol en cerca de un año?', 'La órbita terrestre alrededor del Sol dura aproximadamente 365 días y un cuarto.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-UNIV'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-UNIV-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-05-1', 'Traslación', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-05-2', 'El Sol', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-05-3', 'Rotación', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-05-4', 'La Tierra', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La órbita terrestre alrededor del Sol dura aproximadamente 365 días y un cuarto.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-UNIV-05-1'
WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-UNIV-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-UNIV-06', 'opcion_multiple', '¿Cuál es el planeta más grande del sistema solar?', 'Júpiter es el planeta de mayor diámetro y masa del sistema solar.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-UNIV'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-UNIV-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-06-1', 'Cambia la porción iluminada visible desde la Tierra', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-06-2', 'La Tierra', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-06-3', 'Conjunto gravitacional de estrellas, gas y polvo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-06-4', 'Júpiter', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Júpiter es el planeta de mayor diámetro y masa del sistema solar.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-UNIV-06-4'
WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-UNIV-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-UNIV-07', 'opcion_multiple', '¿Qué es una galaxia?', 'Los componentes de una galaxia se mantienen vinculados por gravedad.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-UNIV'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-UNIV-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-07-1', 'La Luna', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-07-2', 'Conjunto gravitacional de estrellas, gas y polvo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-07-3', 'Cambia la porción iluminada visible desde la Tierra', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-07-4', 'Júpiter', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los componentes de una galaxia se mantienen vinculados por gravedad.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-UNIV-07-2'
WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-UNIV-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-UNIV-08', 'opcion_multiple', '¿A qué galaxia pertenece el sistema solar?', 'El Sol es una estrella de la galaxia Vía Láctea.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-UNIV'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-UNIV-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-08-1', 'Júpiter', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-08-2', 'Vía Láctea', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-08-3', 'La Tierra', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-08-4', 'El Sol', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El Sol es una estrella de la galaxia Vía Láctea.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-UNIV-08-2'
WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-UNIV-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-UNIV-09', 'opcion_multiple', '¿Por qué observamos diferentes fases de la Luna?', 'Las fases dependen de la posición relativa del Sol, Tierra y Luna.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-UNIV'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-UNIV-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-09-1', 'Conjunto gravitacional de estrellas, gas y polvo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-09-2', 'Cambia la porción iluminada visible desde la Tierra', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-09-3', 'Júpiter', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-09-4', 'Traslación', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Las fases dependen de la posición relativa del Sol, Tierra y Luna.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-UNIV-09-2'
WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-UNIV-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-UNIV-10', 'opcion_multiple', '¿Por qué ocurre un eclipse solar?', 'Desde ciertas zonas, la Luna bloquea parcial o totalmente la luz solar.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-UNIV'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-UNIV-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-10-1', 'Conjunto gravitacional de estrellas, gas y polvo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-10-2', 'La Luna se interpone entre la Tierra y el Sol', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-10-3', 'Traslación', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-UNIV-10-4', 'La Tierra', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Desde ciertas zonas, la Luna bloquea parcial o totalmente la luz solar.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-UNIV-10-2'
WHERE c.codigo = 'SOC-UNIV' AND p.codigo = 'SOC-UNIV-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-TIER-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-TIER-01', 'opcion_multiple', '¿Cuál es la capa más externa de la Tierra sólida?', 'La corteza es la capa rocosa superficial del planeta.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-TIER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-TIER-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-01-1', 'México', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-01-2', 'Longitud', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-01-3', 'Corteza', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-01-4', 'Hemisferio norte', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La corteza es la capa rocosa superficial del planeta.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-TIER-01-3'
WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-TIER-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-TIER-02', 'opcion_multiple', '¿Qué componente de la Tierra reúne mares, ríos, hielo y agua subterránea?', 'La hidrosfera incluye todas las reservas de agua terrestre.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-TIER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-TIER-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-02-1', 'Océano Pacífico', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-02-2', 'Atmósfera', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-02-3', 'Ecuador terrestre', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-02-4', 'Hidrosfera', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La hidrosfera incluye todas las reservas de agua terrestre.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-TIER-02-4'
WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-TIER-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-TIER-03', 'opcion_multiple', '¿Cómo se llama la envoltura de gases que rodea la Tierra?', 'La atmósfera contiene principalmente nitrógeno y oxígeno.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-TIER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-TIER-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-03-1', 'México', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-03-2', 'Hidrosfera', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-03-3', 'Atmósfera', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-03-4', 'Océano Pacífico', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La atmósfera contiene principalmente nitrógeno y oxígeno.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-TIER-03-3'
WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-TIER-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-TIER-04', 'opcion_multiple', '¿Cuál es el océano que baña la costa sur de Guatemala?', 'La costa sur guatemalteca se extiende sobre el Pacífico.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-TIER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-TIER-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-04-1', 'Hidrosfera', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-04-2', 'Longitud', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-04-3', 'Océano Pacífico', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-04-4', 'Ecuador terrestre', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La costa sur guatemalteca se extiende sobre el Pacífico.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-TIER-04-3'
WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-TIER-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-TIER-05', 'opcion_multiple', '¿Qué mar se encuentra frente a la costa caribeña de Guatemala?', 'Guatemala tiene litoral en el mar Caribe, en el departamento de Izabal.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-TIER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-TIER-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-05-1', 'Hidrosfera', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-05-2', 'Mar Caribe', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-05-3', 'México', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-05-4', 'Ecuador terrestre', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Guatemala tiene litoral en el mar Caribe, en el departamento de Izabal.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-TIER-05-2'
WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-TIER-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-TIER-06', 'opcion_multiple', '¿Qué línea imaginaria divide la Tierra en hemisferios norte y sur?', 'El paralelo 0° sirve de referencia para latitudes.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-TIER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-TIER-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-06-1', 'Hemisferio norte', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-06-2', 'Ecuador terrestre', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-06-3', 'México', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-06-4', 'Latitud', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El paralelo 0° sirve de referencia para latitudes.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-TIER-06-2'
WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-TIER-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-TIER-07', 'opcion_multiple', '¿Qué coordenada indica distancia angular al norte o sur del ecuador?', 'La latitud se expresa en grados norte o sur.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-TIER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-TIER-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-07-1', 'Hemisferio norte', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-07-2', 'Ecuador terrestre', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-07-3', 'Latitud', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-07-4', 'Corteza', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La latitud se expresa en grados norte o sur.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-TIER-07-3'
WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-TIER-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-TIER-08', 'opcion_multiple', '¿Qué coordenada indica distancia angular al este u oeste de Greenwich?', 'La longitud se mide desde el meridiano de referencia.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-TIER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-TIER-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-08-1', 'Latitud', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-08-2', 'Ecuador terrestre', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-08-3', 'Atmósfera', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-08-4', 'Longitud', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La longitud se mide desde el meridiano de referencia.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-TIER-08-4'
WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-TIER-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-TIER-09', 'opcion_multiple', '¿En qué hemisferio se encuentra Guatemala respecto del ecuador?', 'Guatemala está al norte de la línea ecuatorial.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-TIER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-TIER-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-09-1', 'México', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-09-2', 'Hemisferio norte', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-09-3', 'Mar Caribe', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-09-4', 'Hidrosfera', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Guatemala está al norte de la línea ecuatorial.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-TIER-09-2'
WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-TIER-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-TIER-10', 'opcion_multiple', '¿Con qué país comparte Guatemala frontera hacia el norte y el oeste?', 'México limita con Guatemala al norte y al oeste.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-TIER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-TIER-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-10-1', 'México', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-10-2', 'Hidrosfera', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-10-3', 'Latitud', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-TIER-10-4', 'Océano Pacífico', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'México limita con Guatemala al norte y al oeste.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-TIER-10-1'
WHERE c.codigo = 'SOC-TIER' AND p.codigo = 'SOC-TIER-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-CLIM-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-CLIM-01', 'opcion_multiple', '¿A qué se refiere el tiempo atmosférico?', 'Describe condiciones como temperatura, lluvia y viento a corto plazo.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-CLIM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-CLIM-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-01-1', 'Deslizamientos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-01-2', 'Temporada lluviosa', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-01-3', 'Déficit prolongado de lluvias', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-01-4', 'Estado de la atmósfera en un momento y lugar', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Describe condiciones como temperatura, lluvia y viento a corto plazo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-CLIM-01-4'
WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-CLIM-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-CLIM-02', 'opcion_multiple', '¿Qué describe el clima de una región?', 'Se estudia a partir de promedios, variabilidad y tendencias de largo plazo.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-CLIM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-CLIM-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-02-1', 'Cantidad de lluvia caída', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-02-2', 'Deslizamientos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-02-3', 'Patrones atmosféricos observados durante muchos años', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-02-4', 'Altitud', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Se estudia a partir de promedios, variabilidad y tendencias de largo plazo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-CLIM-02-3'
WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-CLIM-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-CLIM-03', 'opcion_multiple', '¿Qué factor suele reducir la temperatura al subir una montaña en Guatemala?', 'En general la temperatura del aire disminuye al aumentar la elevación.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-CLIM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-CLIM-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-03-1', 'Mantener libres los drenajes', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-03-2', 'Altitud', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-03-3', 'Temporada lluviosa', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-03-4', 'Termómetro', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'En general la temperatura del aire disminuye al aumentar la elevación.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-CLIM-03-2'
WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-CLIM-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-CLIM-04', 'opcion_multiple', '¿Qué estación presenta habitualmente más lluvias en buena parte de Guatemala?', 'En extensas zonas del país hay una época con precipitaciones más frecuentes.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-CLIM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-CLIM-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-04-1', 'Termómetro', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-04-2', 'Temporada lluviosa', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-04-3', 'Altitud', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-04-4', 'Mantener libres los drenajes', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'En extensas zonas del país hay una época con precipitaciones más frecuentes.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-CLIM-04-2'
WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-CLIM-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-CLIM-05', 'opcion_multiple', '¿Cuál es un riesgo asociado a lluvias intensas en terrenos inclinados?', 'El exceso de agua puede desestabilizar laderas y provocar movimientos de tierra.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-CLIM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-CLIM-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-05-1', 'Temporada lluviosa', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-05-2', 'Quema de combustibles fósiles', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-05-3', 'Deslizamientos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-05-4', 'Estado de la atmósfera en un momento y lugar', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El exceso de agua puede desestabilizar laderas y provocar movimientos de tierra.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-CLIM-05-3'
WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-CLIM-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-CLIM-06', 'opcion_multiple', '¿Qué fenómeno puede causar períodos de sequía en algunas regiones?', 'La falta persistente de precipitación disminuye agua disponible en suelos y cultivos.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-CLIM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-CLIM-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-06-1', 'Termómetro', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-06-2', 'Patrones atmosféricos observados durante muchos años', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-06-3', 'Déficit prolongado de lluvias', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-06-4', 'Mantener libres los drenajes', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La falta persistente de precipitación disminuye agua disponible en suelos y cultivos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-CLIM-06-3'
WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-CLIM-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-CLIM-07', 'opcion_multiple', '¿Qué mide un pluviómetro?', 'Se usa para medir precipitación acumulada, por ejemplo en milímetros.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-CLIM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-CLIM-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-07-1', 'Mantener libres los drenajes', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-07-2', 'Quema de combustibles fósiles', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-07-3', 'Cantidad de lluvia caída', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-07-4', 'Altitud', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Se usa para medir precipitación acumulada, por ejemplo en milímetros.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-CLIM-07-3'
WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-CLIM-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-CLIM-08', 'opcion_multiple', '¿Qué instrumento mide la temperatura del aire?', 'El termómetro registra temperaturas en grados.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-CLIM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-CLIM-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-08-1', 'Altitud', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-08-2', 'Deslizamientos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-08-3', 'Mantener libres los drenajes', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-08-4', 'Termómetro', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El termómetro registra temperaturas en grados.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-CLIM-08-4'
WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-CLIM-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-CLIM-09', 'opcion_multiple', '¿Qué actividad humana emite dióxido de carbono que contribuye al calentamiento global?', 'Su combustión libera CO₂, uno de los gases de efecto invernadero.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-CLIM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-CLIM-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-09-1', 'Quema de combustibles fósiles', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-09-2', 'Termómetro', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-09-3', 'Cantidad de lluvia caída', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-09-4', 'Déficit prolongado de lluvias', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Su combustión libera CO₂, uno de los gases de efecto invernadero.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-CLIM-09-1'
WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-CLIM-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-CLIM-10', 'opcion_multiple', '¿Qué medida comunitaria ayuda ante tormentas intensas?', 'La limpieza de drenajes reduce obstrucciones y puede disminuir anegamientos locales.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-CLIM'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-CLIM-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-10-1', 'Mantener libres los drenajes', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-10-2', 'Termómetro', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-10-3', 'Patrones atmosféricos observados durante muchos años', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-CLIM-10-4', 'Quema de combustibles fósiles', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La limpieza de drenajes reduce obstrucciones y puede disminuir anegamientos locales.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-CLIM-10-1'
WHERE c.codigo = 'SOC-CLIM' AND p.codigo = 'SOC-CLIM-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-POBL-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-POBL-01', 'opcion_multiple', '¿Qué mide un censo de población?', 'Registra información demográfica sobre personas y hogares.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-POBL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-POBL-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-01-1', 'Español', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-01-2', 'Habitantes por unidad de superficie', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-01-3', 'Inmigración', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-01-4', 'Número y características de habitantes', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Registra información demográfica sobre personas y hogares.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-POBL-01-4'
WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-POBL-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-POBL-02', 'opcion_multiple', '¿Qué se entiende por migración?', 'Puede ocurrir dentro de un país o entre países.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-POBL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-POBL-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-02-1', 'Español', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-02-2', 'Cambio de residencia hacia otro lugar', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-02-3', 'Habitantes de áreas clasificadas como rurales', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-02-4', 'Distribución por edad y sexo', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Puede ocurrir dentro de un país o entre países.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-POBL-02-2'
WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-POBL-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-POBL-03', 'opcion_multiple', '¿Cómo se denomina la salida de personas de su país para residir en otro?', 'Describe el movimiento desde el lugar de origen.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-POBL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-POBL-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-03-1', 'Pueblo Xinka', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-03-2', 'Habitantes por unidad de superficie', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-03-3', 'Emigración', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-03-4', 'Inmigración', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Describe el movimiento desde el lugar de origen.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-POBL-03-3'
WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-POBL-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-POBL-04', 'opcion_multiple', '¿Cómo se denomina la llegada de personas a un país para residir allí?', 'Describe el movimiento visto desde el lugar de destino.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-POBL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-POBL-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-04-1', 'Inmigración', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-04-2', 'Habitantes por unidad de superficie', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-04-3', 'Número y características de habitantes', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-04-4', 'Español', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Describe el movimiento visto desde el lugar de destino.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-POBL-04-1'
WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-POBL-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-POBL-05', 'opcion_multiple', '¿Cuál es uno de los cuatro pueblos reconocidos en Guatemala?', 'Guatemala reconoce a los pueblos Maya, Xinka, Garífuna y Ladino.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-POBL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-POBL-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-05-1', 'Habitantes por unidad de superficie', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-05-2', 'Pueblo Xinka', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-05-3', 'Habitantes de áreas clasificadas como rurales', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-05-4', 'Español', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Guatemala reconoce a los pueblos Maya, Xinka, Garífuna y Ladino.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-POBL-05-2'
WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-POBL-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-POBL-06', 'opcion_multiple', '¿Qué idioma es el oficial de Guatemala según la Constitución?', 'El artículo 143 reconoce al español como idioma oficial y el patrimonio lingüístico de lenguas vernáculas.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-POBL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-POBL-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-06-1', 'Español', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-06-2', 'Número y características de habitantes', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-06-3', 'Cambio de residencia hacia otro lugar', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-06-4', 'Habitantes por unidad de superficie', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El artículo 143 reconoce al español como idioma oficial y el patrimonio lingüístico de lenguas vernáculas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-POBL-06-1'
WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-POBL-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-POBL-07', 'opcion_multiple', '¿Qué significa densidad de población?', 'Se calcula dividiendo población entre área, a menudo en km².', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-POBL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-POBL-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-07-1', 'Pueblo Xinka', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-07-2', 'Número y características de habitantes', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-07-3', 'Habitantes por unidad de superficie', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-07-4', 'Español', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Se calcula dividiendo población entre área, a menudo en km².'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-POBL-07-3'
WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-POBL-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-POBL-08', 'opcion_multiple', '¿Qué es la población rural?', 'Se refiere a localidades rurales según la clasificación censal.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-POBL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-POBL-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-08-1', 'Inmigración', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-08-2', 'Habitantes por unidad de superficie', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-08-3', 'Habitantes de áreas clasificadas como rurales', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-08-4', 'Emigración', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Se refiere a localidades rurales según la clasificación censal.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-POBL-08-3'
WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-POBL-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-POBL-09', 'opcion_multiple', '¿Qué característica es demográfica?', 'La edad permite analizar la composición poblacional.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-POBL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-POBL-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-09-1', 'Edad de las personas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-09-2', 'Emigración', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-09-3', 'Inmigración', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-09-4', 'Cambio de residencia hacia otro lugar', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La edad permite analizar la composición poblacional.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-POBL-09-1'
WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-POBL-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-POBL-10', 'opcion_multiple', '¿Qué ayuda a conocer una pirámide poblacional?', 'Su representación permite comparar grupos de edades y sexos de la población.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-POBL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-POBL-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-10-1', 'Español', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-10-2', 'Número y características de habitantes', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-10-3', 'Distribución por edad y sexo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-POBL-10-4', 'Pueblo Xinka', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Su representación permite comparar grupos de edades y sexos de la población.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-POBL-10-3'
WHERE c.codigo = 'SOC-POBL' AND p.codigo = 'SOC-POBL-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-ECON-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-ECON-01', 'opcion_multiple', '¿A qué sector económico pertenece la agricultura?', 'Produce materias primas mediante aprovechamiento directo de recursos naturales.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-ECON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-ECON-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-01-1', 'Primario', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-01-2', 'Secundario', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-01-3', 'Transformación industrial o artesanal', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-01-4', 'Hotelería', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Produce materias primas mediante aprovechamiento directo de recursos naturales.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-ECON-01-1'
WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-ECON-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-ECON-02', 'opcion_multiple', '¿A qué sector pertenece la fabricación de zapatos en una fábrica?', 'Transforma materiales en productos manufacturados.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-ECON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-ECON-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-02-1', 'Tomar una decisión de consumo informada', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-02-2', 'Hotelería', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-02-3', 'Inicio y organización de una actividad económica', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-02-4', 'Secundario', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Transforma materiales en productos manufacturados.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-ECON-02-4'
WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-ECON-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-ECON-03', 'opcion_multiple', '¿A qué sector pertenece un servicio de transporte de pasajeros?', 'Ofrece servicios en lugar de extraer o fabricar bienes.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-ECON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-ECON-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-03-1', 'Material usado para elaborar otros productos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-03-2', 'Café', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-03-3', 'Primario', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-03-4', 'Terciario', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Ofrece servicios en lugar de extraer o fabricar bienes.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-ECON-03-4'
WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-ECON-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-ECON-04', 'opcion_multiple', '¿Cuál es un cultivo tradicional importante de exportación de Guatemala?', 'El café forma parte de la producción agrícola y del comercio exterior guatemalteco.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-ECON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-ECON-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-04-1', 'Café', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-04-2', 'Inicio y organización de una actividad económica', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-04-3', 'Hotelería', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-04-4', 'Terciario', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El café forma parte de la producción agrícola y del comercio exterior guatemalteco.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-ECON-04-1'
WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-ECON-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-ECON-05', 'opcion_multiple', '¿Qué describe una materia prima?', 'Por ejemplo, el algodón puede convertirse en textiles.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-ECON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-ECON-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-05-1', 'Café', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-05-2', 'Inicio y organización de una actividad económica', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-05-3', 'Material usado para elaborar otros productos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-05-4', 'Secundario', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Por ejemplo, el algodón puede convertirse en textiles.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-ECON-05-3'
WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-ECON-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-ECON-06', 'opcion_multiple', '¿Qué proceso convierte leche en queso para su venta?', 'Agrega valor a una materia prima mediante procesamiento.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-ECON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-ECON-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-06-1', 'Etapas desde insumos hasta comercialización', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-06-2', 'Transformación industrial o artesanal', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-06-3', 'Terciario', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-06-4', 'Inicio y organización de una actividad económica', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Agrega valor a una materia prima mediante procesamiento.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-ECON-06-2'
WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-ECON-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-ECON-07', 'opcion_multiple', '¿Qué actividad económica ofrece alojamiento a visitantes?', 'Es un servicio del sector terciario asociado al turismo.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-ECON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-ECON-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-07-1', 'Hotelería', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-07-2', 'Secundario', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-07-3', 'Tomar una decisión de consumo informada', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-07-4', 'Etapas desde insumos hasta comercialización', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Es un servicio del sector terciario asociado al turismo.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-ECON-07-1'
WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-ECON-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-ECON-08', 'opcion_multiple', '¿Qué es una cadena productiva?', 'Relaciona producción, transformación, transporte y venta.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-ECON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-ECON-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-08-1', 'Etapas desde insumos hasta comercialización', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-08-2', 'Transformación industrial o artesanal', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-08-3', 'Secundario', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-08-4', 'Primario', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Relaciona producción, transformación, transporte y venta.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-ECON-08-1'
WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-ECON-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-ECON-09', 'opcion_multiple', '¿Qué es el emprendimiento?', 'Implica identificar una necesidad, planificar y ofrecer bienes o servicios.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-ECON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-ECON-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-09-1', 'Terciario', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-09-2', 'Material usado para elaborar otros productos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-09-3', 'Inicio y organización de una actividad económica', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-09-4', 'Transformación industrial o artesanal', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Implica identificar una necesidad, planificar y ofrecer bienes o servicios.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-ECON-09-3'
WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-ECON-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-ECON-10', 'opcion_multiple', '¿Qué ventaja ofrece comparar precios antes de comprar útiles escolares?', 'Permite valorar costo, calidad y necesidades con un presupuesto definido.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-ECON'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-ECON-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-10-1', 'Café', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-10-2', 'Inicio y organización de una actividad económica', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-10-3', 'Tomar una decisión de consumo informada', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-ECON-10-4', 'Hotelería', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Permite valorar costo, calidad y necesidades con un presupuesto definido.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-ECON-10-3'
WHERE c.codigo = 'SOC-ECON' AND p.codigo = 'SOC-ECON-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-COL-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-COL-01', 'opcion_multiple', '¿Qué pueblos habitaban el territorio de Guatemala antes de la conquista española?', 'Existían sociedades mayas y otros grupos con organización propia antes de 1524.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-COL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-COL-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-01-1', 'Producción agrícola', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-01-2', 'Imposición de tributos y trabajo forzado', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-01-3', 'Diversos pueblos indígenas', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-01-4', 'Siglo XVI', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Existían sociedades mayas y otros grupos con organización propia antes de 1524.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-COL-01-3'
WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-COL-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-COL-02', 'opcion_multiple', '¿Qué conquistador español encabezó la campaña de 1524 en gran parte del actual territorio guatemalteco?', 'Condujo expediciones militares en la región bajo la Corona española.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-COL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-COL-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-02-1', 'Capitanía General de Guatemala', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-02-2', 'Imposición de tributos y trabajo forzado', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-02-3', 'Pedro de Alvarado', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-02-4', 'Diversos pueblos indígenas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Condujo expediciones militares en la región bajo la Corona española.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-COL-02-3'
WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-COL-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-COL-03', 'opcion_multiple', '¿En qué siglo ocurrió la campaña de conquista de 1524?', 'El año 1524 pertenece al siglo dieciséis.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-COL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-COL-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-03-1', 'Capitanía General de Guatemala', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-03-2', 'Oposición de pueblos originarios al dominio español', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-03-3', 'Siglo XVI', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-03-4', 'Diversos pueblos indígenas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El año 1524 pertenece al siglo dieciséis.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-COL-03-3'
WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-COL-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-COL-04', 'opcion_multiple', '¿Qué fue la resistencia indígena durante la conquista?', 'Diversas comunidades defendieron sus territorios y estructuras políticas.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-COL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-COL-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-04-1', 'Capitanía General de Guatemala', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-04-2', 'Oposición de pueblos originarios al dominio español', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-04-3', 'Terremotos de 1773', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-04-4', 'Diversos pueblos indígenas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Diversas comunidades defendieron sus territorios y estructuras políticas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-COL-04-2'
WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-COL-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-COL-05', 'opcion_multiple', '¿Qué institución representaba el poder de la monarquía española en la región colonial?', 'Fue una entidad de gobierno colonial vinculada a la administración española.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-COL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-COL-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-05-1', 'Arquitectura de iglesias y edificios históricos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-05-2', 'Diversos pueblos indígenas', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-05-3', 'Siglo XVI', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-05-4', 'Capitanía General de Guatemala', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Fue una entidad de gobierno colonial vinculada a la administración española.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-COL-05-4'
WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-COL-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-COL-06', 'opcion_multiple', '¿Qué ciudad fue sede de la capital colonial antes de su traslado al valle de la Ermita?', 'La antigua capital se conoce hoy como Antigua Guatemala.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-COL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-COL-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-06-1', 'Capitanía General de Guatemala', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-06-2', 'Santiago de los Caballeros de Guatemala', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-06-3', 'Oposición de pueblos originarios al dominio español', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-06-4', 'Siglo XVI', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La antigua capital se conoce hoy como Antigua Guatemala.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-COL-06-2'
WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-COL-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-COL-07', 'opcion_multiple', '¿Qué hecho impulsó el traslado de la capital a la Nueva Guatemala de la Asunción?', 'Los sismos de Santa Marta afectaron gravemente Santiago de los Caballeros.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-COL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-COL-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-07-1', 'Arquitectura de iglesias y edificios históricos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-07-2', 'Terremotos de 1773', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-07-3', 'Oposición de pueblos originarios al dominio español', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-07-4', 'Siglo XVI', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los sismos de Santa Marta afectaron gravemente Santiago de los Caballeros.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-COL-07-2'
WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-COL-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-COL-08', 'opcion_multiple', '¿Qué actividad económica era común en la colonia guatemalteca?', 'La agricultura y el comercio fueron actividades económicas relevantes.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-COL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-COL-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-08-1', 'Imposición de tributos y trabajo forzado', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-08-2', 'Siglo XVI', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-08-3', 'Pedro de Alvarado', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-08-4', 'Producción agrícola', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La agricultura y el comercio fueron actividades económicas relevantes.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-COL-08-4'
WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-COL-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-COL-09', 'opcion_multiple', '¿Qué efecto tuvo el sistema colonial sobre muchos pueblos indígenas?', 'El dominio colonial estableció cargas económicas y laborales desiguales.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-COL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-COL-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-09-1', 'Santiago de los Caballeros de Guatemala', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-09-2', 'Imposición de tributos y trabajo forzado', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-09-3', 'Pedro de Alvarado', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-09-4', 'Oposición de pueblos originarios al dominio español', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El dominio colonial estableció cargas económicas y laborales desiguales.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-COL-09-2'
WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-COL-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-COL-10', 'opcion_multiple', '¿Qué patrimonio de Antigua Guatemala refleja su pasado colonial?', 'Los inmuebles conservados representan elementos de su historia colonial.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-COL'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-COL-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-10-1', 'Diversos pueblos indígenas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-10-2', 'Arquitectura de iglesias y edificios históricos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-10-3', 'Oposición de pueblos originarios al dominio español', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-COL-10-4', 'Pedro de Alvarado', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los inmuebles conservados representan elementos de su historia colonial.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-COL-10-2'
WHERE c.codigo = 'SOC-COL' AND p.codigo = 'SOC-COL-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-INDEP-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-INDEP-01', 'opcion_multiple', '¿En qué fecha se firmó el Acta de Independencia de Centroamérica en Guatemala?', 'El acta se firmó el 15 de septiembre de 1821 en la ciudad de Guatemala.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-INDEP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-INDEP-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-01-1', 'Autoridad para decidir sobre sus asuntos', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-01-2', 'Siglo XIX', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-01-3', '1847', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-01-4', '15 de septiembre de 1821', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El acta se firmó el 15 de septiembre de 1821 en la ciudad de Guatemala.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-INDEP-01-4'
WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-INDEP-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-INDEP-02', 'opcion_multiple', '¿De qué monarquía se declaró independiente Centroamérica en 1821?', 'El acta expresó la separación política del dominio de España.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-INDEP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-INDEP-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-02-1', 'México', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-02-2', 'Acta de Independencia', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-02-3', 'Monarquía española', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-02-4', 'Francisco Morazán', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El acta expresó la separación política del dominio de España.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-INDEP-02-3'
WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-INDEP-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-INDEP-03', 'opcion_multiple', '¿En qué siglo ocurrió la independencia centroamericana de 1821?', 'Los años 1801 a 1900 corresponden al siglo XIX.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-INDEP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-INDEP-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-03-1', 'Siglo XIX', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-03-2', 'República Federal de Centroamérica', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-03-3', 'Monarquía española', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-03-4', '1847', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los años 1801 a 1900 corresponden al siglo XIX.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-INDEP-03-1'
WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-INDEP-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-INDEP-04', 'opcion_multiple', '¿Qué institución política se formó en Centroamérica tras la ruptura con el Imperio mexicano?', 'En 1824 se estableció una federación de estados centroamericanos.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-INDEP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-INDEP-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-04-1', 'República Federal de Centroamérica', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-04-2', 'Francisco Morazán', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-04-3', 'Autoridad para decidir sobre sus asuntos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-04-4', 'Siglo XIX', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'En 1824 se estableció una federación de estados centroamericanos.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-INDEP-04-1'
WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-INDEP-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-INDEP-05', 'opcion_multiple', '¿Qué documento estableció formalmente la independencia en 1821?', 'Registró la declaración política firmada en Guatemala.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-INDEP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-INDEP-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-05-1', 'Acta de Independencia', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-05-2', 'Francisco Morazán', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-05-3', 'Siglo XIX', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-05-4', '15 de septiembre de 1821', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Registró la declaración política firmada en Guatemala.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-INDEP-05-1'
WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-INDEP-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-INDEP-06', 'opcion_multiple', '¿Qué dirigente centroamericano es conocido por su papel en la defensa de la federación?', 'Morazán fue una figura central de la historia política federal centroamericana.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-INDEP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-INDEP-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-06-1', 'Cambios y continuidades sociales y políticas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-06-2', 'Acta de Independencia', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-06-3', 'México', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-06-4', 'Francisco Morazán', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Morazán fue una figura central de la historia política federal centroamericana.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-INDEP-06-4'
WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-INDEP-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-INDEP-07', 'opcion_multiple', '¿Con qué país se anexó Centroamérica brevemente después de 1821?', 'En 1822 ocurrió una anexión al Imperio mexicano, que no fue permanente.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-INDEP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-INDEP-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-07-1', 'Monarquía española', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-07-2', '15 de septiembre de 1821', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-07-3', 'Autoridad para decidir sobre sus asuntos', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-07-4', 'México', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'En 1822 ocurrió una anexión al Imperio mexicano, que no fue permanente.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-INDEP-07-4'
WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-INDEP-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-INDEP-08', 'opcion_multiple', '¿Qué expresa la soberanía de un Estado?', 'La soberanía implica capacidad de gobierno sin subordinación a otro Estado.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-INDEP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-INDEP-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-08-1', 'Acta de Independencia', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-08-2', 'Autoridad para decidir sobre sus asuntos', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-08-3', 'Francisco Morazán', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-08-4', 'Monarquía española', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La soberanía implica capacidad de gobierno sin subordinación a otro Estado.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-INDEP-08-2'
WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-INDEP-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-INDEP-09', 'opcion_multiple', '¿En qué año se estableció la República de Guatemala como Estado independiente de la federación?', 'Rafael Carrera proclamó la República de Guatemala en 1847.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-INDEP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-INDEP-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-09-1', 'Cambios y continuidades sociales y políticas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-09-2', '1847', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-09-3', 'Monarquía española', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-09-4', 'México', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Rafael Carrera proclamó la República de Guatemala en 1847.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-INDEP-09-2'
WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-INDEP-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-INDEP-10', 'opcion_multiple', '¿Qué conviene comparar al estudiar los efectos de la independencia?', 'La independencia no transformó de inmediato todas las relaciones económicas y sociales.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-INDEP'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-INDEP-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-10-1', 'Cambios y continuidades sociales y políticas', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-10-2', '1847', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-10-3', 'Acta de Independencia', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-INDEP-10-4', 'México', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La independencia no transformó de inmediato todas las relaciones económicas y sociales.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-INDEP-10-1'
WHERE c.codigo = 'SOC-INDEP' AND p.codigo = 'SOC-INDEP-10'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MODER-01
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MODER-01', 'opcion_multiple', '¿En qué fecha se conmemora la Revolución de Octubre en Guatemala?', 'La revolución de 1944 se recuerda cada 20 de octubre.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MODER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MODER-01');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-01-1', '1944', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-01-2', 'Constitución Política de la República', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-01-3', '20 de octubre', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-01-4', '1996', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-01'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'La revolución de 1944 se recuerda cada 20 de octubre.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MODER-01-3'
WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-01'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MODER-02
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MODER-02', 'opcion_multiple', '¿En qué año ocurrió la Revolución de Octubre de Guatemala?', 'El proceso revolucionario puso fin al gobierno de Federico Ponce Vaides.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MODER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MODER-02');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-02-1', '1944', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-02-2', 'IGSS', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-02-3', 'Congreso de la República', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-02-4', 'Organismo Judicial', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-02'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El proceso revolucionario puso fin al gobierno de Federico Ponce Vaides.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MODER-02-1'
WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-02'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MODER-03
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MODER-03', 'opcion_multiple', '¿Qué presidente asumió el gobierno en 1945 tras el proceso revolucionario?', 'Fue elegido presidente y gobernó de 1945 a 1951.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MODER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MODER-03');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-03-1', 'Juan José Arévalo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-03-2', 'Organismo Judicial', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-03-3', 'Congreso de la República', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-03-4', '20 de octubre', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-03'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Fue elegido presidente y gobernó de 1945 a 1951.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MODER-03-1'
WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-03'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MODER-04
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MODER-04', 'opcion_multiple', '¿Qué institución se creó en Guatemala en 1946 para la seguridad social?', 'El Instituto Guatemalteco de Seguridad Social fue establecido en 1946.', 'basica', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MODER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MODER-04');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-04-1', '20 de octubre', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-04-2', 'Organismo Ejecutivo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-04-3', '1996', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-04-4', 'IGSS', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-04'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El Instituto Guatemalteco de Seguridad Social fue establecido en 1946.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MODER-04-4'
WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-04'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MODER-05
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MODER-05', 'opcion_multiple', '¿En qué año se firmaron los Acuerdos de Paz que pusieron fin al conflicto armado interno?', 'El Acuerdo de Paz Firme y Duradera fue firmado el 29 de diciembre de 1996.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MODER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MODER-05');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-05-1', 'Organismo Ejecutivo', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-05-2', 'Juan José Arévalo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-05-3', '1944', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-05-4', '1996', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-05'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El Acuerdo de Paz Firme y Duradera fue firmado el 29 de diciembre de 1996.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MODER-05-4'
WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-05'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MODER-06
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MODER-06', 'opcion_multiple', '¿Qué organismo del Estado tiene como función principal elaborar leyes?', 'El Congreso ejerce la función legislativa.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MODER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MODER-06');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-06-1', 'Congreso de la República', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-06-2', '20 de octubre', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-06-3', 'Organismo Ejecutivo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-06-4', '1996', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-06'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'El Congreso ejerce la función legislativa.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MODER-06-1'
WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-06'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MODER-07
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MODER-07', 'opcion_multiple', '¿Qué organismo del Estado administra justicia mediante tribunales?', 'Los órganos jurisdiccionales conocen y resuelven controversias aplicando la ley.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MODER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MODER-07');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-07-1', 'Organismo Judicial', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-07-2', 'Organismo Ejecutivo', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-07-3', 'Juan José Arévalo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-07-4', '20 de octubre', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-07'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Los órganos jurisdiccionales conocen y resuelven controversias aplicando la ley.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MODER-07-1'
WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-07'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MODER-08
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MODER-08', 'opcion_multiple', '¿Qué organismo dirige la administración pública nacional?', 'Está encabezado por el presidente y sus autoridades administrativas.', 'intermedia', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MODER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MODER-08');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-08-1', 'IGSS', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-08-2', 'Constitución Política de la República', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-08-3', 'Organismo Ejecutivo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-08-4', '1996', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-08'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Está encabezado por el presidente y sus autoridades administrativas.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MODER-08-3'
WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-08'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MODER-09
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MODER-09', 'opcion_multiple', '¿Qué documento es la norma suprema de Guatemala?', 'Establece la estructura del Estado y derechos fundamentales.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MODER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MODER-09');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-09-1', '1944', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-09-2', 'Congreso de la República', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-09-3', 'Constitución Política de la República', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-09-4', '1996', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-09'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Establece la estructura del Estado y derechos fundamentales.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MODER-09-3'
WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-09'
ON CONFLICT (pregunta_id) DO NOTHING;
-- SOC-MODER-10
INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, explicacion, dificultad, fuente)
SELECT c.id, 'SOC-MODER-10', 'opcion_multiple', '¿Por qué es importante conocer los derechos humanos al estudiar la historia reciente?', 'Ayuda a comprender experiencias históricas y el valor de la convivencia pacífica.', 'avanzada', 'GENIOS_BANCO_370_V1'
FROM categorias c WHERE c.codigo = 'SOC-MODER'
AND NOT EXISTS (SELECT 1 FROM preguntas p WHERE p.categoria_id = c.id AND p.codigo = 'SOC-MODER-10');
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-10-1', 'Organismo Judicial', 1
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-10-2', 'Congreso de la República', 2
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-10-3', 'Juan José Arévalo', 3
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
SELECT p.id, 'SOC-MODER-10-4', 'Permite reconocer la dignidad y los derechos de todas las personas', 4
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-10'
ON CONFLICT (pregunta_id, orden_visual) DO NOTHING;
INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta, explicacion_correcta)
SELECT p.id, jsonb_build_object('opcionId', o.id), 'Ayuda a comprender experiencias históricas y el valor de la convivencia pacífica.'
FROM preguntas p JOIN categorias c ON c.id = p.categoria_id
JOIN opciones_pregunta o ON o.pregunta_id = p.id AND o.codigo_opcion = 'SOC-MODER-10-4'
WHERE c.codigo = 'SOC-MODER' AND p.codigo = 'SOC-MODER-10'
ON CONFLICT (pregunta_id) DO NOTHING;

COMMIT;
