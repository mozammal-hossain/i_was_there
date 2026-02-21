# Custom Rules: I Was There

Project-specific architecture and coding rules. Follow these when adding or changing code.

---

## 0. Running the project (FVM)

- Use **FVM** (Flutter Version Management) when running the project.
- Run Flutter/Dart commands via `fvm`, e.g. `fvm flutter run`, `fvm flutter pub get`, `fvm dart run build_runner build`, so the project always uses the pinned Flutter version (e.g. from `.fvmrc` or `fvm_config.json`).

---

## 1. Clean architecture (layers)

- Use three layers: **data**, **domain**, **presentation**. Dependencies point inward: presentation → domain → data.
- **Domain** must not depend on Flutter, Drift, or any data source. Only pure Dart and entities.
- **Data** implements interfaces defined in domain (repositories). Use **mappers** to convert models ↔ entities; do not expose data models to domain or presentation.

---

## 2. Folder structure (layer-first, then feature)

Each feature follows this template under `lib/`:

| Layer        | Path                     | Contents |
|-------------|---------------------------|----------|
| **Data**    | `data/<feature>/`        | `data_source/`, `repositories/`, `models/`, `mappers/` |
| **Domain**  | `domain/<feature>/`       | `entities/`, `repositories/` (interfaces), `use_cases/` |
| **Presentation** | `presentation/<feature>/` | `bloc/`, `widgets/`, `utils/`, `<feature>_feature.dart` |

- **core/** holds shared code: DI (get_it + injectable), router, error handling, constants.
- Features: **places**, **presence**, **calendar**, **sync**, **settings**, **onboarding**.

---

## 3. State management (BLoC)

- Use **flutter_bloc** only. No other state management (Provider, Riverpod, etc.) for feature state.
- Put Bloc/Cubit, events, and states under **presentation/<feature>/bloc/**.
- **Flow:** UI dispatches events → Bloc calls **use cases** (never repositories directly) → use case uses repository → Bloc emits states → UI rebuilds.
- Blocs must not import data layer (no Drift, no data models). Only domain (use cases, entities) and presentation (states/events).
- Catch exceptions from use cases in the Bloc and emit error states; show user-facing messages in the UI only.

---

## 4. Repositories and use cases

- **One repository per entity:** PlaceRepository, PresenceRepository, SyncRepository. Domain defines the interface; data implements it.
- Repository interfaces live in **domain/<feature>/repositories/**; implementations in **data/<feature>/repositories/**.
- Business logic lives in **use cases** in **domain/<feature>/use_cases/**. Use cases call repository interfaces and return entities or throw.
- Presentation (Blocs) must not call repositories directly; always go through use cases.

---

## 5. Data layer (Drift, sync, location)

- **Local DB:** **Drift** (SQLite). Tables: Place, Presence (placeId, date, isPresent, source, firstDetectedAt), SyncRecord (placeId, date, syncedAt, eventId).
- **Sync split:** SyncState (DB), SyncClient (google_sign_in + googleapis Calendar v3), SyncScheduler (when to run). Sync runs after background run, on app open, and when connectivity_plus reports back online.
- **Google Calendar event:** Create at **time of first detection** that day (not all-day). Title: `"Present at [Place name]"`. When user marks day "not present", **delete** that day’s event from Google Calendar.
- **Background:** WorkManager every **15 minutes**; all logic (location → Haversine → update presence → trigger sync) in **Dart** only.
- **Maps:** **flutter_map** (OSM) for pin/current location; **geocoding** for address search. No Google Maps API for map UI.
- **Place limit:** More than one place requires subscription (feature gate); enforce in app logic.

---

## 6. Dependency injection

- Use **get_it** + **injectable**. Register repositories, use cases, SyncClient, SyncScheduler, location service, WorkManager callback in **core**.
- Blocs: register as factories (depending on use cases) or provide via **BlocProvider** in the widget tree. Prefer one approach per feature for consistency.

---

## 7. Navigation

- Use **GoRouter** for all routes. **Bottom navigation** for main tabs (e.g. Places, Calendar, Settings).
- Onboarding is a separate flow (full-screen steps) before the main shell; route to onboarding when not completed or first launch.

---

## 8. Errors and user feedback

- Repositories and services throw exceptions; no mandatory Result/Either pattern app-wide.
- Use a **global error handler** (e.g. Flutter zone or error widget) to map exceptions to user-facing messages.
- User-visible error messages are defined and shown only in the **presentation** layer (e.g. from Bloc error states).

---

## 9. Calendar UX and overrides

- **Calendar:** One **aggregated** view (day = present if present at any place); optional **per-place drill-down** (filter or secondary screen).
- **Manual present:** Set presence to true; mark for sync if Google sync is on.
- **Manual not present:** Set presence to false and **delete** the corresponding "Present at [Place]" event from Google Calendar.

---

## 10. Permissions and onboarding

- **Single onboarding flow:** Request **foreground** location first, then **background** with clear rationale. Background only when user explicitly enables "background checks" (toggle or step). Include an in-app screen explaining why background location is needed.

---

## 11. Settings (v1)

- **Minimal:** Only Google Calendar sync on/off. No check interval, place limit, or data export settings in v1.

---

## 12. Testing

- **Unit:** Repositories (Drift in-memory or mocks), presence/sync logic. Mock external deps.
- **Widget:** Key screens (places, calendar, settings, onboarding) with BlocProvider and mock use cases/repos.
- **Integration:** Full flows where useful; **mock** WorkManager, location, and Google APIs (e.g. fake SyncClient / location service).

---

## 13. Naming and files

- **Entities:** `Place`, `Presence`, `SyncRecord` (domain).
- **Models:** Suffix with `Model` or match Drift table name in data layer (e.g. `PlaceModel`).
- **Repositories:** Interface `PlaceRepository` in domain; implementation `PlaceRepositoryImpl` (or in a single file per repo) in data.
- **Use cases:** Verb-first, e.g. `GetPlaces`, `MarkDayPresent`, `SyncPendingToGoogle`.
- **Blocs:** `<Feature>Bloc` / `<Feature>Cubit`; events `<Feature>Event`, states `<Feature>State`.
- **Feature entry:** `<feature>_feature.dart` (e.g. `places_feature.dart`) for routes, BlocProvider, or main screen.

---

*Reference: architecture plan in `docs/ARCHITECTURE_PLAN.md` (when present) and `docs/PRD.md`, `docs/TECHNICAL_ANALYSIS.md`.*
