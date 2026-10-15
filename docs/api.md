# Contrato real de la API (v1)

Verificado contra el código (controladores) el 2026-10-14. Base: `/api/v1`. JSON en camelCase. Errores: Problem Details con `codigo` estable e `idCorrelacion`.

**Autenticación:** *Bearer* = JWT de acceso (15 min). *Cookie renovación* = `genios_renovacion` (HttpOnly) + cabecera `X-GENIOS-CSRF`. *Cookie invitado* = `genios_invitado` (HttpOnly) + `X-GENIOS-CSRF` en POST/DELETE. *Jugador* = estudiante (Bearer) **o** invitado (cookie).
El cliente web debe enviar credenciales (cookies) y el origen debe estar en `Cors:OrigenesPermitidos`.

| Método y ruta | Quién | Notas |
|---|---|---|
| `GET /health`, `GET /health/ready` | público | fuera de `/api/v1` |
| `POST /autenticacion/estudiante/iniciar-sesion` | público | `{nombreUsuario, contrasena}` → token de acceso; cookie de renovación |
| `POST /autenticacion/google` | público | `{idToken, solicitaRolDocente}`. Valida firma, vencimiento y audiencia (`Autenticacion__GoogleClientId`). Primer acceso: crea la cuenta sin aula; el rol docente se concede si el dominio está en `DominiosDocentes` o `Autenticacion__DocentePorGoogleAbierto=true` (solo desarrollo). Errores: `google_token_invalido` 401, `google_no_configurado` 503, `google_correo_no_verificado` 401, `correo_ya_registrado` 409. Probado con verificador simulado; **falta probar con un token real en el navegador** |
| `POST /autenticacion/renovar` | cookie renovación | rota el refresh token |
| `POST /autenticacion/cerrar-sesion` | cookie renovación | revoca la familia de tokens |
| `GET /usuarios/yo` | Bearer | id, nombre, roles |
| `GET /aulas/ranking?aulaId=&asignaturaId=` | docente | Ranking por puntos de los estudiantes activos de **sus** aulas (aula y materia opcionales; empates comparten posición; máx. 200; aula ajena → 404 + auditoría). Un estudiante en varias aulas del docente aparece una vez, con la lista de aulas |
| `POST /aulas/{aulaId}/estudiantes` | docente dueño del aula | `{nombreMostrar, nombreUsuario}` → `{id, nombreMostrar, nombreUsuario, codigoActivacion, expiraEn}`. Crea la cuenta del estudiante en el aula con una clave aleatoria desconocida (la tabla exige hash) y `debe_cambiar_contrasena=true`; el estudiante elige su contraseña con `POST /estudiantes/restablecimiento-confirmar`. Errores: 404 aula ajena, 409 usuario repetido, 400 usuario inválido |
| `POST /estudiantes/registro` | público | `{codigoAula?, nombreUsuario, contrasena, nombreMostrar}`; **`codigoAula` es opcional** (sin él la cuenta queda sin aula; se une después con `POST /aulas/unirse`) |
| `POST /estudiantes/validar-codigo-aula` | público | `{codigoAula}` → nombre del aula |
| `POST /estudiantes/restablecimiento-confirmar` | público | código temporal de un docente |
| `POST /sesiones-juego` | público | crea o reutiliza la sesión de invitado (cookie) |
| `GET /sesiones-juego/yo` | invitado | partidas válidas / que cuentan / `invitarARegistrarse` |
| `GET /asignaturas` | público | |
| `GET /asignaturas/{id}/niveles` | público | |
| `GET /niveles/{id}/categorias` | jugador | incluye `estado` (bloqueada, disponible, en_progreso, completada) y `requiereCategoria*` |
| `GET /categorias/{id}` | público | |
| `GET /categorias/{id}/progreso` | estudiante | |
| `POST /partidas` | jugador | `{categoriaId, claveOperacion?}`; `403 categoria_bloqueada`, `403 limite_diario_agotado` |
| `GET /partidas/{id}` · `.../pregunta-actual` · `.../resultado` | jugador (dueño) | 404 si es de otro |
| `POST /partidas/{id}/respuestas` | jugador (dueño) | `{preguntaPresentadaId, opcionSeleccionadaId, claveOperacion}` idempotente |
| `POST /partidas/{id}/reanudar` · `/finalizar` · `/abandonar` | jugador (dueño) | |
| `GET /estudiantes/yo/progreso` | estudiante | por materia y categoría |
| `GET /estudiantes/yo/estadisticas` | estudiante | primer intento aparte de reintentos; partidas recientes |
| `GET /estudiantes/yo/puntos` | estudiante | total, por tipo, recientes |
| `GET /estudiantes/yo/uso-diario` | estudiante | minutos usados/limite/restantes |
| `POST /estudiantes/yo/uso-diario/latido` | estudiante | registra actividad |
| `POST /aulas` | docente | |
| `GET /aulas/mi-aula` | autenticado | docente: sus aulas; estudiante: las suyas |
| `POST /aulas/unirse` | estudiante | `{codigoAula}` idempotente |
| `GET /aulas/{id}/estudiantes` | docente (dueño) | |
| `DELETE /aulas/{id}/estudiantes/{estudianteId}` | docente (dueño) | |
| `POST /aulas/{id}/estudiantes/{estudianteId}/restablecer-contrasena` | docente (dueño) | devuelve código temporal |
| `GET /aulas/{id}/estadisticas` | docente (dueño) | solo estudiantes activos de esa aula |

## Diferencias con la lista de rutas del documento de requisitos
| Documento | Ruta real |
|---|---|
| `GET /materias` | `GET /asignaturas` |
| `GET /niveles` | `GET /asignaturas/{id}/niveles` |
| `GET /categorias` | `GET /niveles/{id}/categorias` |
| `GET /estadisticas`, `GET /puntos` | `GET /estudiantes/yo/estadisticas`, `GET /estudiantes/yo/puntos` |
| el resto coincide | |

## Códigos de error relevantes
`categoria_bloqueada`, `limite_diario_agotado`, `partida_terminada_por_mecha`, `ventana_reanudacion_vencida`, `pregunta_no_vigente`, `opcion_invalida`, `clave_operacion_en_uso`, `partida_incompleta`, `credenciales_invalidas`, `sesion_invalida`, `nombre_usuario_en_uso`, `aula_no_encontrada`. Límite de intentos: `429` sin cuerpo.
