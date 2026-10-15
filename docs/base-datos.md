# Base de datos — GENIOS

**Motor:** PostgreSQL en Neon (BD `GENIOSPG`). **Esquema:** 37 tablas, 53 FK, 50 CHECK, 24 UNIQUE (observado 2026-10-14).

## Mapeo (PROPUESTO, implementado)
- Enfoque *database-first*: entidades generadas con `dotnet ef dbcontext scaffold` en
  `backend/src/GENIOS.Infrastructure/Persistence/{Entities,Context}`. Son entidades de persistencia;
  nunca se serializan al cliente (se usarán DTOs).
- Nombres en español, sin singularizar (`--no-pluralize`): `Usuarios`, `Partidas`, ...
- Columnas `jsonb` mapeadas como `string` por ahora.
- `DbContext` registrado sobre un `NpgsqlDataSource` compartido.

## Migraciones (PROPUESTO)
- El esquema ya existe: NO se genera una migración inicial que lo recree.
- Cambios futuros: scripts SQL versionados y revisados, probados en desarrollo antes de producción.
- Regenerar el scaffold solo tras un cambio de esquema y revisar el diff; `--force` sobrescribe archivos.

## Comando de scaffold
Con `ConnectionStrings__GeniosDatabase` definida (desde `.env`):
`dotnet dotnet-ef dbcontext scaffold "Name=ConnectionStrings:GeniosDatabase" Npgsql.EntityFrameworkCore.PostgreSQL --project src/GENIOS.Infrastructure --startup-project src/GENIOS.Api --context GeniosDbContext --context-dir Persistence/Context --output-dir Persistence/Entities --namespace GENIOS.Infrastructure.Persistence.Entities --context-namespace GENIOS.Infrastructure.Persistence.Context --no-onconfiguring --no-pluralize --force`
