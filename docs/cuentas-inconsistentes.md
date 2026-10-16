# Cuentas con roles o perfiles inconsistentes (Neon)

Informe de **solo lectura** del 2026-10-16. No se modificó ni se migró ninguna cuenta. Los identificadores son los 8 primeros caracteres del UUID; no se incluyen nombres ni correos.

Regla vigente (decisión del propietario): los roles de estudiante y docente son exclusivos y permanentes. Una cuenta Google nueva queda sin rol hasta confirmar que es docente, y el perfil docente se crea solo al confirmar.

## Casos

### A. Docente y estudiante a la vez (2 cuentas)
| id | método | aulas propias | partidas |
|---|---|---|---|
| 46d45cb8 | google | 1 | 0 |
| 668336b4 | google | 1 | 0 |

Tienen perfil docente y perfil estudiante, y ambos roles. Son las cuentas con el alta abierta de las pruebas. La app las trata como docente.

### B. Cuenta Google con rol estudiante y perfil docente sin rol docente (8 cuentas)
| id | partidas | aulas como miembro |
|---|---|---|
| 32d1bbec | 0 | 0 |
| d560fa15 | 0 | 0 |
| 9feb0688 | 0 | 0 |
| 27730579 | 1 | 0 |
| 236f6770 | 2 | 0 |
| 7c4b79bd | 3 | 0 |
| b687ca94 | 5 | 0 |
| 2a0b67bb | 6 | 0 |

Entraron por «Soy docente» cuando el alta abierta estaba desactivada: la API les creó el rol estudiante y un `perfiles_docente` huérfano. Cinco tienen partidas (progreso que no se debe perder).

### C. Perfiles docentes sin rol docente
Son los mismos 8 del caso B (perfil docente huérfano). No hay otros.

## Estrategia propuesta (requiere tu autorización específica por caso)

1. **Respaldo previo:** exportar con `COPY` las filas de `usuarios_roles`, `perfiles_docente` y `perfiles_estudiante` de estas 10 cuentas.
2. **Caso A (2 cuentas):** son docentes con aulas. Quitar solo la fila de `usuarios_roles` del rol estudiante. Conservar `perfiles_estudiante` (no hay partidas que perder) o eliminarlo si lo prefieres.
3. **Caso B/C (8 cuentas):** conservar el rol estudiante y todo su progreso. Eliminar únicamente el `perfiles_docente` huérfano (no tiene rol ni aulas). Esas cuentas **no** pasan a docente (regla 4).
4. Ejecutar en una transacción, con `SELECT` de verificación antes y después, y reversión documentada con el respaldo del paso 1.
5. Si alguien de esas cuentas realmente es docente, debe usar otra identidad de Google (el rol no se cambia).

Mientras tanto el código nuevo no crea más casos: una identidad nueva de Google nace sin rol ni perfiles, y `POST /autenticacion/docente/confirmar` rechaza (403) a quien ya tenga otro rol.
