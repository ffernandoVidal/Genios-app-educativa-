-- ============================================================================
-- GENIOS - Contenido inicial (PRUEBA): solo datos, sin cambios de esquema.
--
-- TODO LO QUE SE CARGA AQUI ES PROVISIONAL:
--   * Niveles, reglas y preguntas llevan la marca [PRUEBA] o fuente = 'PRUEBA'.
--   * Los rangos numericos de las reglas de generacion son PROVISIONALES
--     (parametros.provisional = true). El pensum definitivo esta pendiente.
--   * Matematicas: se activan 2 temas (suma, resta). Multiplicacion y division se
--     cargan con activa = FALSE hasta definir las reglas de progresion.
--   * Lenguaje: una categoria con 10 preguntas de prueba para ejercitar el banco de preguntas.
--   * Ciencias Sociales y Ciencias Naturales: SIN contenido (la estructura queda lista).
--
-- IDEMPOTENTE: cada fila se protege con su clave natural (ON CONFLICT DO NOTHING o
-- comprobacion previa). Se puede ejecutar varias veces; la segunda vez no cambia nada.
-- No modifica ni borra filas existentes.
--
-- Reversion (solo si no hay partidas sobre estas categorias):
--   DELETE FROM reglas_generacion_preguntas WHERE parametros->>'provisional' = 'true';
--   DELETE FROM preguntas WHERE fuente = 'PRUEBA';
--   DELETE FROM categorias WHERE codigo IN ('suma','resta','multiplicacion','division','ortografia_prueba');
--   DELETE FROM niveles_educativos WHERE nombre = 'Nivel 1 [PRUEBA]';
-- ============================================================================
BEGIN;

DO $$
DECLARE
    v_asignatura BIGINT;
    v_nivel BIGINT;
    v_categoria BIGINT;
    v_pregunta BIGINT;
    v_opcion BIGINT;
    v_opcion_correcta BIGINT;
    v_posicion_correcta INT;
    v_erradas INT;
    v_texto TEXT;
    i INT;
    pos INT;

    -- Matematicas: codigo, nombre, minimo, maximo, activa
    operaciones TEXT[]  := ARRAY['suma','resta','multiplicacion','division'];
    nombres TEXT[]      := ARRAY['Sumas','Restas','Multiplicaciones','Divisiones'];
    minimos INT[]       := ARRAY[1,1,2,2];
    maximos INT[]       := ARRAY[20,20,9,9];
    activas BOOLEAN[]   := ARRAY[TRUE,TRUE,FALSE,FALSE];

    -- Lenguaje: 10 preguntas de ortografia con una opcion correcta y dos erradas
    correctas TEXT[]    := ARRAY['Hacer','Excelente','Jirafa','Llave','Examen','Quizá','Bicicleta','Hermano','Ciudad','Escuela'];
    erradas_a TEXT[]    := ARRAY['Hazer','Eselente','Girafa','Yave','Eksamen','Kizá','Vicicleta','Ermano','Siudad','Ezcuela'];
    erradas_b TEXT[]    := ARRAY['Aser','Ecselente','Jiraffa','Llabe','Egzamen','Quisá','Bisicleta','Hermanno','Cuidad','Escuéla'];
BEGIN
    -- ---------------------------------------------------------------- Matematicas
    SELECT id INTO STRICT v_asignatura FROM asignaturas WHERE nombre = 'Matematicas';

    INSERT INTO niveles_educativos (asignatura_id, nombre, numero_orden)
    VALUES (v_asignatura, 'Nivel 1 [PRUEBA]', 1)
    ON CONFLICT (asignatura_id, numero_orden) DO NOTHING;
    SELECT id INTO STRICT v_nivel FROM niveles_educativos WHERE asignatura_id = v_asignatura AND numero_orden = 1;

    FOR i IN 1..4 LOOP
        INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden, activa)
        VALUES (v_nivel, operaciones[i], nombres[i], 'Rango numerico PROVISIONAL', i, activas[i])
        ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
        SELECT id INTO STRICT v_categoria FROM categorias WHERE nivel_educativo_id = v_nivel AND codigo = operaciones[i];

        INSERT INTO reglas_generacion_preguntas (categoria_id, codigo, nombre, version, dificultad, parametros)
        VALUES (v_categoria, operaciones[i] || '_basica', nombres[i] || ' basicas [PRUEBA]', 1, 'basica',
                jsonb_build_object('operacion', operaciones[i], 'minimo', minimos[i], 'maximo', maximos[i], 'provisional', TRUE))
        ON CONFLICT (categoria_id, codigo, version) DO NOTHING;
    END LOOP;

    -- ---------------------------------------------------------------- Lenguaje
    SELECT id INTO STRICT v_asignatura FROM asignaturas WHERE nombre = 'Lenguaje';

    INSERT INTO niveles_educativos (asignatura_id, nombre, numero_orden)
    VALUES (v_asignatura, 'Nivel 1 [PRUEBA]', 1)
    ON CONFLICT (asignatura_id, numero_orden) DO NOTHING;
    SELECT id INTO STRICT v_nivel FROM niveles_educativos WHERE asignatura_id = v_asignatura AND numero_orden = 1;

    INSERT INTO categorias (nivel_educativo_id, codigo, nombre, descripcion, numero_orden)
    VALUES (v_nivel, 'ortografia_prueba', 'Ortografia [PRUEBA]', 'Preguntas de prueba', 1)
    ON CONFLICT (nivel_educativo_id, codigo) DO NOTHING;
    SELECT id INTO STRICT v_categoria FROM categorias WHERE nivel_educativo_id = v_nivel AND codigo = 'ortografia_prueba';

    FOR i IN 1..10 LOOP
        -- preguntas no tiene clave natural unica: se comprueba antes de insertar
        IF EXISTS (SELECT 1 FROM preguntas WHERE categoria_id = v_categoria AND codigo = 'prueba_ortografia_' || i) THEN
            CONTINUE;
        END IF;

        INSERT INTO preguntas (categoria_id, codigo, tipo_pregunta, enunciado, dificultad, fuente)
        VALUES (v_categoria, 'prueba_ortografia_' || i, 'opcion_multiple',
                '¿Cual palabra esta escrita correctamente? [PRUEBA]', 'basica', 'PRUEBA')
        RETURNING id INTO v_pregunta;

        v_posicion_correcta := (i % 3) + 1;
        v_erradas := 0;
        FOR pos IN 1..3 LOOP
            IF pos = v_posicion_correcta THEN
                v_texto := correctas[i];
            ELSE
                v_erradas := v_erradas + 1;
                v_texto := CASE WHEN v_erradas = 1 THEN erradas_a[i] ELSE erradas_b[i] END;
            END IF;
            INSERT INTO opciones_pregunta (pregunta_id, codigo_opcion, texto_opcion, orden_visual)
            VALUES (v_pregunta, CHR(64 + pos), v_texto, pos) RETURNING id INTO v_opcion;
            IF pos = v_posicion_correcta THEN v_opcion_correcta := v_opcion; END IF;
        END LOOP;

        INSERT INTO claves_respuesta (pregunta_id, respuesta_correcta)
        VALUES (v_pregunta, jsonb_build_object('opcionId', v_opcion_correcta));
    END LOOP;
END $$;

COMMIT;
