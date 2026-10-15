# Requisitos de GENIOS y estado de cumplimiento

Estado verificado el 2026-10-14. Leyenda: **OK** implementado y con evidencia; **Parcial** falta algo indicado; **Falta**; **Front** depende del frontend (aún no integrado). "Evidencia" = prueba automatizada (`dotnet test`: 31 unitarias + 22 de integración, 0 con error) o verificación manual documentada.

## Decisiones aprobadas
| Decisión | Regla |
|---|---|
| Invitación al registro | Se acumulan partidas válidas hasta reunir **tres** que superen individualmente el 61 % al primer intento (con 10 preguntas, ≥ 7). Una válida bajo el umbral no cuenta pero tampoco bloquea. |
| Progresión | Completar la categoría anterior de la misma ruta desbloquea la siguiente; estados bloqueada, disponible, en_progreso, completada; la regla vive en el servidor. No se desbloquean materias enteras automáticamente. |
| Estadísticas | Cuatro endpoints con pruebas de autorización y aislamiento. |
| Frontend | Flutter web/PWA conectado progresivamente a la API. |

## Requisitos funcionales
| ID | Estado | Evidencia / nota |
|---|---|---|
| RF-01.1 invitado | OK (API) · Front | `ModoInvitadoTests` |
| RF-01.2 registro estudiante | OK (API) · Front | verificación manual 48/48 + pruebas de partidas |
| RF-01.3 docente con Google | **Parcial** | implementado, **sin probar con token real** (falta Client ID). El rol docente exige dominio autorizado (lista vacía) |
| RF-01.4 cerrar sesión | OK (API) · Front | verificación manual |
| RF-01.5 funciones por rol | OK (API) · Front | `EstadisticasTests` (403/401) |
| RF-01.6 ofrecer registro | OK (API) | `GET /sesiones-juego/yo` · prueba de la regla |
| RF-01.7 sin transferir progreso | OK | `Registrarse_no_transfiere...` |
| RF-02.1 cuatro materias | **Parcial** | la BD las tiene; la materia se llama `Lenguaje`, el requisito dice "Comunicación y Lenguaje" → decidir nombre |
| RF-02.2 mapa temático | **Parcial** | hay categorías, pero el catálogo no tiene metadatos visuales (icono, color, posición en el mapa) |
| RF-02.3 estado de misión | OK | prueba de los cuatro estados |
| RF-02.4 requisitos visibles | OK | `requiereCategoriaId/Nombre` |
| RF-02.5 progreso, puntos, recompensas | **Parcial** | progreso y puntos OK; **logros** (tablas existentes) sin lógica ni endpoint |
| RF-02.6/02.7 solo desbloqueadas / validación API | OK | `403 categoria_bloqueada` probado |
| RF-02.8 ampliar sin tocar pantallas | **Parcial** | contenido por datos OK; faltan metadatos visuales (RF-02.2) |
| RF-03.1–03.3 partida, pregunta, respuesta | OK (API) · Front | |
| RF-03.4 retroalimentación | **Parcial** | se informa acierto/error; la **explicación** de la pregunta existe en BD pero no se devuelve |
| RF-03.5 intentos y primer intento | OK | pruebas de estadísticas |
| RF-03.6 reintentos | OK | |
| RF-03.7 mecha al 3.er error | OK | prueba (mecha de 2 s en pruebas; 30 s en producción) |
| RF-03.8 resultado | OK | |
| RF-03.9 reanudar (10 min) | OK | `Una_partida_se_reanuda...` |
| RF-03.10 una partida activa | OK | verificación manual (la nueva abandona la anterior) |
| RF-03.11 idempotencia | OK | `ModoInvitadoTests`, `PartidasEstudianteTests` |
| RF-04.1 desbloqueo siguiente | OK | |
| RF-04.2 avance por estudiante y categoría | OK | `progreso_estudiante` |
| RF-04.3 puntos 10/15/20 | OK | regla probada; el contenido actual solo tiene dificultad básica |
| RF-04.4 bono único | OK | `Los_puntos_los_calcula_el_servidor...` |
| RF-04.5 puntos y % primer intento | OK | `/estudiantes/yo/puntos`, `/estadisticas` |
| RF-04.6 bloqueo por API | OK | |
| RF-05.1/05.4/05.5 límite 90 min y cierre | OK | `Sin_tiempo_diario...` |
| RF-05.2 inactividad 60 s | OK | verificación manual (10 min de ausencia suman 60 s) |
| RF-05.3 reinicio a medianoche Guatemala | OK | verificación manual (cambio de día) |
| RF-05.6 mostrar tiempo y aviso | OK (API) · Front | `GET /estudiantes/yo/uso-diario` |
| RF-06.1–06.4 estadísticas del estudiante | OK | `El_estudiante_consulta_su_progreso...` |
| RF-06.5 aislamiento entre estudiantes | OK | `Un_estudiante_nunca_ve_los_datos_de_otro` |
| RF-07.1 docente ve sus aulas | OK | `GET /aulas/mi-aula` |
| RF-07.2 unirse con código | OK | verificación manual (concurrencia incluida) |
| RF-07.3/07.4 progreso y métricas del aula | OK | `El_docente_ve_solo...` |
| RF-07.5 solo sus aulas | OK | `Las_estadisticas_de_aula_rechazan...` |
| RF-07.6 registrar accesos no autorizados | **Parcial** | se audita el acceso a estadísticas de aula ajena; otros 403/404 no se registran |
| RF-08.1–08.6 integración Flutter | **Front** | ver `docs/diagnostico-frontend.md` |

## Requisitos no funcionales
| ID | Estado | Nota |
|---|---|---|
| RNF-01 HTTPS | **Pendiente de despliegue** | la API redirige a HTTPS fuera de desarrollo; no hay despliegue |
| RNF-02 hash de contraseñas | OK | `PasswordHasher` de ASP.NET Core Identity |
| RNF-03 autorización por recurso | OK | pruebas de propiedad y roles |
| RNF-04 privacidad entre usuarios/aulas | OK | pruebas de aislamiento |
| RNF-05 respuesta correcta no se envía | OK | los DTO no la incluyen; comprobado a mano; clave solo en tablas del servidor |
| RNF-06 puntos y estados en servidor | OK | |
| RNF-07 p95 < 2 s | **No medido** | no hay prueba de carga |
| RNF-08 mensajes y reintentos | **Front** | el API devuelve códigos estables |
| RNF-09/10/11/12 usabilidad, accesibilidad, compatibilidad, estructura front | **Front** | |
| RNF-13 ampliable por datos | **Parcial** | ver RF-02.8 |
| RNF-14 pruebas | OK | 53 pruebas; sin cobertura medida |
| RNF-15 trazabilidad | **Parcial** | auditoría de eventos de seguridad sin secretos; no hay registro estructurado de errores del servidor |
| RNF-16 zona horaria | OK | día calculado en America/Guatemala en el servidor |
| RNF-17 transaccional e idempotente | OK | |
| RNF-18 protección infantil | OK | sin datos personales innecesarios; sin funciones sociales |
