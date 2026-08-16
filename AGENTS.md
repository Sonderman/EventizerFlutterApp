# AGENTS.md

Flutter social-event app ("Eventizer") backed by Firebase (Auth, Firestore, Storage, Analytics, Crashlytics).

## Commands

- Verify: `flutter analyze` (there is no test suite, no CI, and no `test/` directory)
- Run: `flutter run` (dev machine targets a wireless Android device; see scrcpy note in README.md)
- `flutterfire configure` regenerates `lib/firebase_options.dart` — never hand-edit it. Firebase project: `eventizer-app`; Android also needs `android/app/google-services.json`.

## Architecture

- **Routing**: GetX (`GetMaterialApp` with `AppPages.routes` in `lib/routes/`). Navigate exclusively via `NavigationUtils` helpers (`lib/utils/navigation_utils.dart`) — do not use `Navigator.push` (see `GETX_ROUTING_README.md`).
- **Mixed DI**:
  - `lib/locator.dart` (GetIt): `AppSettings`, `DatabaseWorks`, `StorageWorks`, `EventSettings`, `AuthService` singletons
  - `Get.put` in `lib/main.dart` `setupServices()`: `ThemeService`, `UserService`
  - Provider (`ChangeNotifierProvider`): `EventService`, `MessagingService`, `NavigationProvider`, `UserService`
- **Liquid glass UI**: the whole app is wrapped in `LiquidGlassWidgets.wrap` + `MyLiquidGlass.appShell` (`lib/components/liquidglass_widgets.dart`). New pages/shells must go through the glass wrapper; `LiquidGlassWidgets.initialize()` is required at startup (already in `main.dart`).
- Data flow: pages talk to services (`lib/services/`), which wrap Firestore/Storage operations; UI strings are Turkish.

## Gotchas

- `intl` is pinned to `^0.19.0` because `dash_chat_2` can't take 0.20.x — don't bump it.
- `firestore.rules` is maintained by hand and gates auth/user/event collections; model changes may require rule updates.
- Portrait-only + transparent status bar are enforced in `main.dart` — don't add per-page orientation code.
- Code style: `flutter_lints` defaults from `analysis_options.yaml`; comments and user-facing strings are Turkish.
