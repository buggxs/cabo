# GEMINI.md

## Project Overview

This is a Flutter application for the card game "Cabo". It serves as a digital scoreboard to track game statistics. The app is built with Flutter and Dart, and it uses Firebase for backend services, including authentication, database, and storage.

**Key Technologies:**

*   **Framework:** Flutter
*   **Language:** Dart
*   **State Management:** flutter_bloc (Cubit)
*   **Dependency Injection:** get_it
*   **Backend:** Firebase (Authentication, Firestore, Storage)
*   **Local Storage:** shared_preferences
*   **Testing:** flutter_test, bloc_test, mockito

## Building and Running

The project uses [FVM (Flutter Version Management)](https://fvm.app/) to ensure a consistent Flutter version.

**1. Install Dependencies:**

```bash
fvm flutter pub get
```

**2. Run the App:**

```bash
fvm flutter run
```

**3. Run Tests:**

```bash
fvm flutter test
```

**4. Lint and Format:**

```bash
fvm flutter analyze
dart format . --set-exit-if-changed
```

## Development Conventions

*   **State Management:** The project uses the Cubit pattern from the `flutter_bloc` library for managing state.
*   **Dependency Injection:** Services and repositories are registered and accessed using the `get_it` service locator.
*   **Navigation:** A custom `AppNavigator` and `NavigationService` are used for routing.
*   **Code Style:** The project follows the recommended lints from `package:flutter_lints/flutter.yaml`.
*   **CI:** A GitHub Actions workflow is set up to run tests, linting, and formatting on every pull request.
