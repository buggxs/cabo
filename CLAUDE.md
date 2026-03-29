# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies (requires Java 21 for Android builds)
fvm flutter pub get

# Run the app
fvm flutter run

# Run all tests
fvm flutter test

# Run a single test file
fvm flutter test test/path/to/test_file.dart

# Lint
fvm flutter analyze

# Format check (used in CI)
dart format . --set-exit-if-changed

# Regenerate JSON serialization / mocks after model changes
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Flutter version is managed via FVM; the pinned version is in `.fvmrc`.

## Architecture

Flutter app for the Cabo card game — a digital scoreboard with local persistence and optional Firebase cloud sync.

**Layer structure:**

- `lib/domain/` — business models and repository interfaces, organized by feature (`game`, `player`, `round`, `rule_set`, `rating`, `application`). Models use `json_serializable` (generated `.g.dart` files) and `equatable`.
- `lib/components/` — feature modules, each containing `screens/`, `cubit/`, and `widgets/`. State is managed with Cubit (flutter_bloc).
- `lib/core/` — cross-cutting infrastructure: `app_service_locator.dart` (GetIt DI setup), `app_navigator/` (route definitions + navigation service), `local_storage_service/` (SharedPreferences wrapper).
- `lib/common/` — shared widgets and the design system (`cabo_theme.dart`).
- `lib/l10n/` — ARB-based localizations for German and English.
- `lib/misc/utils/` — small helpers (logger mixin, dialogs, date parsing).

**Dependency injection:** All services and repositories are registered in `lib/core/app_service_locator.dart` using GetIt. Access them via `getIt<SomeService>()`.

**State management:** Each feature's Cubit lives in `components/<feature>/cubit/`. State classes use Equatable. Use `bloc_test` and `mockito` for tests.

**Persistence:**
- Local: SharedPreferences via `LocalStorageRepository`, with feature-specific repositories (`LocalGameRepository`, `LocalPlayerRepository`, etc.).
- Cloud: Firestore via `public_game_service.dart`; Firebase Auth supports anonymous sign-in and Google Sign-In (`ApplicationCubit` tracks auth state).

**Navigation:** Use `NavigationService` (registered in GetIt) rather than calling `Navigator` directly.

**Code generation:** After editing any model annotated with `@JsonSerializable` or after adding Mockito `@GenerateMocks`, run `build_runner` to regenerate `.g.dart` files.
