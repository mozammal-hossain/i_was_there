# I Was There

Android app that tracks your presence at chosen places. A background job runs on a schedule (e.g. every 10 min), checks your location against saved places (within a radius), and marks each day as **present** or **not present**. Optional one-way sync to Google Calendar.

**Target:** Android 12+ (API 31). Built with Flutter.

---

## Goal

Let users define “places” (home, office, gym, etc.), automatically record whether they were at those places each day, and optionally reflect that in Google Calendar so “I was there” is visible in one place.

---

## High-level project structure

```
lib/
├── main.dart                 # Entry, DI setup
├── core/                     # Shared infra: router, theme, background tasks, utils
├── data/                     # DB (Drift), repos, data sources, mappers
├── domain/                   # Entities, repositories (interfaces), use cases
└── presentation/            # Features and UI
    ├── main_shell.dart       # Bottom nav shell
    ├── onboarding/          # First-run flow (permissions, place setup)
    ├── places/               # Places CRUD, map, dashboard
    ├── calendar/             # History, manual attendance, (future) Google sync
    └── settings/             # App settings
```

- **Feature slices:** Each feature (onboarding, places, calendar, settings) owns its routes, screens, and (where used) Blocs.
- **Clean-ish layering:** UI → use cases → repositories; data layer implements repos and talks to DB/location/APIs.

---

## Tech (high level)

- **Flutter** (Dart), **Bloc** for state, **go_router** for navigation, **GetIt + Injectable** for DI.
- **Drift** + SQLite for places and presence; **Workmanager** for periodic location checks; **Geolocator** for position.
- **Google Sign-In** and **Google APIs** for optional Calendar sync (one-way).
- **flutter_map** (OpenStreetMap) for the map UI — no API key required.

---

## Getting started

1. **Prerequisites:** Flutter SDK (e.g. via [FVM](https://fvm.app)), Android SDK, Android 12+ device/emulator.
2. **Install:** `fvm flutter pub get`
3. **Code gen (if needed):** `fvm dart run build_runner build --delete-conflicting-outputs`
4. **Run:** `fvm flutter run`

For more on Flutter: [flutter.dev](https://docs.flutter.dev/).
