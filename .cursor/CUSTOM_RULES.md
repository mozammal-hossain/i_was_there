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

| Layer            | Path                      | Contents                                                |
| ---------------- | ------------------------- | ------------------------------------------------------- |
| **Data**         | `data/<feature>/`         | `data_source/`, `repositories/`, `models/`, `mappers/`  |
| **Domain**       | `domain/<feature>/`       | `entities/`, `repositories/` (interfaces), `use_cases/` |
| **Presentation** | `presentation/`           | **Screen-first:** see presentation structure below     |

### Presentation layer (screen-first, per page)

Presentation is organized **screen-first**: each page is a top-level folder; feature widgets compose pages and sit at presentation root.

**Page folder names use snake_case** (e.g. `add_edit_place/`, `history/`, `dashboard/`, `manual_attendance/`, `map/`, `no_place/`, `settings/`, `background_location/`, `onboarding_completion/`).

```
presentation/
  <page_name1>/              # snake_case, e.g. history/, add_edit_place/, dashboard/
    bloc/
      <page_name1>_bloc.dart
      <page_name1>_event.dart
      <page_name1>_state.dart
    widgets/
    utils/
    ui_models/
    <page_name1>_page.dart
  <page_name2>/
    bloc/
    ...
    <page_name2>_page.dart
  onboarding/
    bloc/                    # flow blocs (e.g. onboarding steps) when not page-scoped
  <feature>_feature.dart      # e.g. calendar_feature.dart, places_feature.dart
  main_shell.dart
```

- **Screen-first:** Page folders are direct children of `presentation/`. **Use snake_case for page folder names** (e.g. `history/`, `dashboard/`, `add_edit_place/`).
- Feature files (`calendar_feature.dart`, `places_feature.dart`, `settings_feature.dart`, `onboarding_feature.dart`) live at presentation root and import the page folders they use.
- **bloc/**: BLoC, events, and states scoped to the page (snake_case filenames).
- **widgets/**: Page-specific widgets. Put each in its own file under `presentation/<page_name>/widgets/` with filename `<page_name>_<section>.dart` (snake_case) and a public PascalCase class (e.g. `BackgroundLocationHeader`). The page file stays slim and only composes these widgets and Bloc wiring. Use package imports (`package:i_was_there/...`) for presentation imports when convenient.
- **utils/**: Page-specific helpers.

### Widget composition

- Create **StatelessWidget** or **StatefulWidget** classes for all UI; do not use widget methods (e.g. `Widget _buildHeader()`).
- **Widget class size:** A single widget class should not exceed **80–90 lines**. Break large widgets into smaller, focused widgets in the same page's **widgets/** folder (one file per widget, public class name).
- **Large widgets:** Prefer extracting sections into separate widget classes in the page's **widgets/** folder (e.g. `BackgroundLocationHeader`) rather than keeping many private classes in the page file.
- **ui_models/**: UI-only models (not domain entities).
- **&lt;page_name&gt;_page.dart**: Main page entry widget (e.g. `history_page.dart` → class `HistoryPage`).
- **core/** holds shared code: DI (get_it + injectable), router, error handling, constants.
- Features: **places**, **presence**, **calendar**, **sync**, **settings**, **onboarding**.

---

## 3. State management (BLoC)

- Use **flutter_bloc** only. No other state management (Provider, Riverpod, etc.) for feature state.
- **No logic within widgets.** Do not write or handle logic inside widget classes; write and handle all logic through Bloc, state, and events. Widgets only dispatch events and render from state.
- **No business logic in the presentation layer.** Keep it in domain (use cases) or data; presentation only dispatches events and displays state.
- **No UI logic outside the Bloc.** All decisions that affect what the UI shows or does (loading, errors, which data to show) live in the Bloc; widgets only render from state.
- **No UI updates without Bloc state.** The UI must not change based on local widget state, callbacks, or side effects; every visible change must come from a Bloc-emitted state.
- **StatefulWidget and Bloc:** If a screen or component is a **StatefulWidget**, its meaningful state must be driven by Bloc state (subscribe via `BlocBuilder`/`BlocListener`). Do not hold in local `State` what the Bloc already owns; prefer StatelessWidget + Bloc when possible.
- Put Bloc/Cubit, events, and states under **presentation/`<page_name>`/bloc/** (per-page; screen-first; folder name in snake_case).
- **Flow:** UI dispatches events → Bloc calls **use cases** (never repositories directly) → use case uses repository → Bloc emits states → UI rebuilds.
- Blocs must not import data layer (no Drift, no data models). Only domain (use cases, entities) and presentation (states/events).
- Catch exceptions from use cases in the Bloc and emit error states; show user-facing messages in the UI only.

---

## 4. Repositories and use cases

- **One repository per entity:** PlaceRepository, PresenceRepository, SyncRepository. Domain defines the interface; data implements it.
- Repository interfaces live in **domain/`<feature>`/repositories/**; implementations in **data/`<feature>`/repositories/**.
- Business logic lives in **use cases** in **domain/`<feature>`/use_cases/**. Use cases call repository interfaces and return entities or throw.
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
- **Inject services and use cases through DI only.** Resolve them from the DI container (e.g. `getIt<T>()`); do **not** pass them class by class (e.g. passing a use case or service through constructors from parent to child widgets or from one class to another). Each class that needs a dependency should obtain it from DI.
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

- **Calendar:** One **aggregated** view (day = present if present at any place); optional **per-place drill-down** (filter or secondary page).
- **Manual present:** Set presence to true; mark for sync if Google sync is on.
- **Manual not present:** Set presence to false and **delete** the corresponding "Present at [Place]" event from Google Calendar.

---

## 10. Permissions and onboarding

- **Single onboarding flow:** Request **foreground** location first, then **background** with clear rationale. Background only when user explicitly enables "background checks" (toggle or step). Include an in-app page explaining why background location is needed.

---

## 11. Settings (v1)

- **Minimal:** Only Google Calendar sync on/off. No check interval, place limit, or data export settings in v1.

---

## 12. Testing

- **Unit:** Repositories (Drift in-memory or mocks), presence/sync logic. Mock external deps.
- **Widget:** Key pages (places, calendar, settings, onboarding) with BlocProvider and mock use cases/repos.
- **Integration:** Full flows where useful; **mock** WorkManager, location, and Google APIs (e.g. fake SyncClient / location service).

---

## 13. Naming and files

- **Entities:** `Place`, `Presence`, `SyncRecord` (domain).
- **Models:** Suffix with `Model` or match Drift table name in data layer (e.g. `PlaceModel`).
- **Repositories:** Interface `PlaceRepository` in domain; implementation `PlaceRepositoryImpl` (or in a single file per repo) in data.
- **Use cases:** Verb-first, e.g. `GetPlaces`, `MarkDayPresent`, `SyncPendingToGoogle`.
- **Blocs:** `<Feature>Bloc` / `<Feature>Cubit`; events `<Feature>Event`, states `<Feature>State`.
- **Feature entry:** `<feature>_feature.dart` (e.g. `places_feature.dart`) for routes, BlocProvider, or main page.
- **Pages:** One folder per page in **snake_case** (e.g. `history/`, `add_edit_place/`, `dashboard/`); main file `<page_name>_page.dart` (snake_case), widget class **PascalCase** (e.g. `HistoryPage`, `AddEditPlacePage`).

---

## 14. Enums over hard-coded mapping

- **Do not use hard-coded maps** for status, type, or mode → label/icon/color. Prefer **enums** with extensions (e.g. `extension on MyEnum { String get label => ... }`) or enum values for type-safe, single-source mapping.
- Example: instead of `const map = { 'a': 'Label A', 'b': 'Label B' }`, use `enum Status { a, b }` and `extension on Status { String get label => ... }`.

---

_Reference: architecture plan in `docs/ARCHITECTURE_PLAN.md` (when present) and `docs/PRD.md`, `docs/TECHNICAL_ANALYSIS.md`._
