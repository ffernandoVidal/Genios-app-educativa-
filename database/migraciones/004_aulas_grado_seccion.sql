-- ============================================================================
-- GENIOS - Aulas: grado y sección + índice de partidas válidas por fecha.
-- ADITIVA e idempotente: no modifica ni borra datos. Aprobada por el usuario (2026-10-15).
-- Reversión:
--   DROP INDEX IF EXISTS idx_partidas_valida_fecha;
--   ALTER TABLE aulas DROP COLUMN IF EXISTS seccion, DROP COLUMN IF EXISTS grado;
-- ============================================================================
BEGIN;
ALTER TABLE aulas ADD COLUMN IF NOT EXISTS grado smallint;
ALTER TABLE aulas ADD COLUMN IF NOT EXISTS seccion varchar(10);
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_aula_grado') THEN
        ALTER TABLE aulas ADD CONSTRAINT ck_aula_grado CHECK (grado IS NULL OR grado BETWEEN 1 AND 6);
    END IF;
END $$;
CREATE INDEX IF NOT EXISTS idx_partidas_valida_fecha ON partidas (usuario_id, finalizada_en) WHERE es_partida_valida;
COMMIT;
