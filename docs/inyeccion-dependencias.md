# Inyección de dependencias con GetIt

FINDU usa [get_it](https://pub.dev/packages/get_it) como service locator. Ninguna pantalla crea repositorios ni casos de uso: le pide su Bloc o Cubit a `sl`.

## Dónde se registra

| Archivo | Qué registra |
| --- | --- |
| `lib/core/di/inyeccion.dart` | `sl`, el `SupabaseClient` y llama al registro de cada feature |
| `lib/features/auth/auth_di.dart` | `AuthRepository`, casos de uso de sesión y recuperación, `AuthBloc`, `UniversitiesCubit`, `RecoveryCubit` |
| `lib/features/posts/posts_di.dart` | `PostsRepository`, `ObtenerFeed`, `ObtenerPublicacion`, `CrearPublicacion`…, `FeedBloc`, `PostCubit`, `MyPostsCubit`, `PublishCubit` |
| `lib/features/verification/verification_di.dart` | `VerificationRepository`, `ObtenerPreguntas`, `VerificarRespuestas`, `ReportarHallazgo`, `VerificationCubit` (con el id de la publicación), `FoundReportCubit` |
| `lib/features/chat/chat_di.dart` | `ChatRepository`, casos de uso del chat y la entrega, `ChatsCubit`, `ChatCubit` (con el id de la conversación), `DeliveryProblemCubit` |
| `lib/features/notifications/notifications_di.dart` | `NotificationsRepository`, casos de uso, `NotificationsCubit` |
| `lib/features/communities/communities_di.dart` | `CommunitiesRepository`, `CrearComunidad`, `UnirseConCodigo`, `SolicitarIngreso`…, `CommunitiesCubit`, `JoinCommunityCubit`, `CreateCommunityCubit`, `AdminPanelCubit` (con el id de la comunidad) |
| `lib/features/payments/payments_di.dart` | `PaymentsRepository`, `ObtenerPlanesImpulso`, `ImpulsarPublicacion`, `AgregarMetodoPago`…, `BoostCubit` (con el id de la publicación), `PaymentMethodsCubit` |

`main.dart` llama `configurarDependencias()` después de iniciar Supabase.

## Tipos de registro

- `registerLazySingleton`: repositorios y casos de uso. Se crean una sola vez, la primera vez que se piden.
- `registerFactory`: Blocs y Cubits. Cada pantalla recibe uno nuevo.
- `registerFactoryParam`: Cubits que necesitan un dato de la ruta. Ejemplo: `sl<ChatCubit>(param1: conversationId)`.
- `AuthBloc` es singleton porque la sesión es una sola para toda la app.

## Capas

```
Pantalla ──sl<Cubit>()──▶ Cubit ──▶ Caso de uso ──▶ Repositorio (contrato) ──▶ SupabaseRepository
   ui                       ui        domain          domain                    data
```

Las pantallas solo importan `ui` y `domain`. `data` solo se importa en los archivos `*_di.dart`.

## Tests

Los tests registran un repositorio falso en `sl` antes de llamar al registro de la feature, y comprueban que el Cubit que entrega GetIt lo usa (`test/features/`).
