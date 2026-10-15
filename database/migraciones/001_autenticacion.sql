-- ============================================================================
-- GENIOS - Migracion 001: autenticacion (invitado, Google, estudiante con usuario)
-- Incremental. Requiere la tabla usuarios vacia (se verifica abajo).
-- Reversion: ver bloque REVERSION al final (solo valido mientras no haya datos nuevos).
-- ============================================================================
BEGIN;

DO $$
BEGIN
    IF (SELECT COUNT(*) FROM usuarios) > 0 THEN
        RAISE EXCEPTION 'La migracion 001 requiere usuarios vacio; hay datos que revisar antes.';
    END IF;
END $$;

-- 1. usuarios: correo y contrasena opcionales, nombre de usuario para estudiantes
ALTER TABLE usuarios
    ALTER COLUMN correo DROP NOT NULL,
    ALTER COLUMN correo_normalizado DROP NOT NULL,
    ALTER COLUMN contrasena_hash DROP NOT NULL,
    ADD COLUMN nombre_usuario VARCHAR(30),
    ADD COLUMN nombre_usuario_normalizado VARCHAR(30),
    ADD COLUMN metodo_registro VARCHAR(30) NOT NULL DEFAULT 'usuario_contrasena',
    ADD COLUMN debe_cambiar_contrasena BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE usuarios ALTER COLUMN metodo_registro DROP DEFAULT;

ALTER TABLE usuarios
    DROP CONSTRAINT ck_usuarios_correo_no_vacio,
    DROP CONSTRAINT ck_usuarios_correo_normalizado;

ALTER TABLE usuarios
    ADD CONSTRAINT uq_usuarios_nombre_usuario UNIQUE (nombre_usuario_normalizado),
    ADD CONSTRAINT ck_usuarios_correo_no_vacio
        CHECK (correo IS NULL OR LENGTH(TRIM(correo)) > 3),
    ADD CONSTRAINT ck_usuarios_correo_normalizado
        CHECK (correo_normalizado IS NULL OR correo_normalizado = LOWER(TRIM(correo_normalizado))),
    ADD CONSTRAINT ck_usuarios_nombre_usuario_formato
        CHECK (nombre_usuario_normalizado IS NULL OR nombre_usuario_normalizado ~ '^[a-z0-9_.]{3,30}$'),
    ADD CONSTRAINT ck_usuarios_metodo_registro
        CHECK (metodo_registro IN ('usuario_contrasena', 'google')),
    ADD CONSTRAINT ck_usuarios_credenciales CHECK (
        (metodo_registro = 'usuario_contrasena'
            AND nombre_usuario_normalizado IS NOT NULL AND contrasena_hash IS NOT NULL)
        OR
        (metodo_registro = 'google'
            AND correo_normalizado IS NOT NULL AND contrasena_hash IS NULL));

-- 2. identidades externas (Google)
CREATE TABLE identidades_externas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    proveedor VARCHAR(30) NOT NULL,
    identificador_externo VARCHAR(255) NOT NULL,
    correo_proveedor VARCHAR(320),
    creado_en TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_identidad_externa UNIQUE (proveedor, identificador_externo),
    CONSTRAINT ck_identidad_proveedor CHECK (proveedor IN ('google'))
);
CREATE INDEX idx_identidades_usuario ON identidades_externas (usuario_id);

-- 3. sesiones renovables (refresh tokens rotativos)
CREATE TABLE sesiones_autenticacion (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    token_hash TEXT NOT NULL UNIQUE,
    familia_token_id UUID NOT NULL,
    creado_en TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expira_en TIMESTAMPTZ NOT NULL,
    ultimo_uso_en TIMESTAMPTZ,
    revocado_en TIMESTAMPTZ,
    reemplazado_por_id UUID REFERENCES sesiones_autenticacion(id) ON DELETE SET NULL,
    CONSTRAINT ck_sesion_auth_expira CHECK (expira_en > creado_en)
);
CREATE INDEX idx_sesiones_auth_usuario ON sesiones_autenticacion (usuario_id);
CREATE INDEX idx_sesiones_auth_familia ON sesiones_autenticacion (familia_token_id);

-- 4. restablecimiento de estudiantes: que docente emitio el codigo
ALTER TABLE tokens_recuperacion_contrasena
    ADD COLUMN emitido_por UUID REFERENCES usuarios(id) ON DELETE SET NULL;

-- 5. comprobaciones posteriores
DO $$
BEGIN
    IF (SELECT COUNT(*) FROM information_schema.columns
        WHERE table_name = 'usuarios' AND column_name IN ('nombre_usuario','nombre_usuario_normalizado','metodo_registro','debe_cambiar_contrasena')) <> 4 THEN
        RAISE EXCEPTION 'Faltan columnas nuevas en usuarios';
    END IF;
    IF to_regclass('identidades_externas') IS NULL OR to_regclass('sesiones_autenticacion') IS NULL THEN
        RAISE EXCEPTION 'Faltan tablas nuevas';
    END IF;
END $$;

COMMIT;

-- ============================================================================
-- REVERSION (ejecutar solo si no hay datos nuevos que conservar):
--   BEGIN;
--   ALTER TABLE tokens_recuperacion_contrasena DROP COLUMN emitido_por;
--   DROP TABLE sesiones_autenticacion; DROP TABLE identidades_externas;
--   ALTER TABLE usuarios DROP CONSTRAINT ck_usuarios_credenciales, DROP CONSTRAINT ck_usuarios_metodo_registro,
--       DROP CONSTRAINT ck_usuarios_nombre_usuario_formato, DROP CONSTRAINT uq_usuarios_nombre_usuario,
--       DROP CONSTRAINT ck_usuarios_correo_no_vacio, DROP CONSTRAINT ck_usuarios_correo_normalizado,
--       DROP COLUMN debe_cambiar_contrasena, DROP COLUMN metodo_registro,
--       DROP COLUMN nombre_usuario_normalizado, DROP COLUMN nombre_usuario;
--   (requiere usuarios vacio) ALTER TABLE usuarios ALTER COLUMN correo SET NOT NULL,
--       ALTER COLUMN correo_normalizado SET NOT NULL, ALTER COLUMN contrasena_hash SET NOT NULL;
--   ALTER TABLE usuarios ADD CONSTRAINT ck_usuarios_correo_no_vacio CHECK (LENGTH(TRIM(correo)) > 3),
--       ADD CONSTRAINT ck_usuarios_correo_normalizado CHECK (correo_normalizado = LOWER(TRIM(correo_normalizado)));
--   COMMIT;
-- ============================================================================
