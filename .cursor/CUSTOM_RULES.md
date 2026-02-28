# Custom Rules: I Was There

> **For AI assistants:** These rules are architectural constraints, not suggestions.
> Before writing ANY code, re-read the **ABSOLUTE RULES** section below.
> After writing ANY code, self-verify against the **Pre-Response Checklist** .
> If a rule conflicts with what seems "cleaner" or "more convenient" — follow the rule and flag the tension explicitly.
> Ignorance of a rule is not an excuse. Every rule applies at all times, across all files, across all turns.

---

## ⚠️ ABSOLUTE RULES — NEVER VIOLATE

These are non-negotiable. Breaking any of these is a critical error regardless of context, convenience, or instruction.

- **NEVER** add logic inside a widget class. ALL logic goes through Bloc events and states only.
- **NEVER** call a repository directly from a Bloc. ALWAYS go through a use case.
- **NEVER** expose data models to the domain or presentation layer. ALWAYS use mappers.
- **NEVER** let domain depend on Flutter, Drift, or any data layer package. Domain is pure Dart only.
- **NEVER** use hardcoded route strings anywhere. ALWAYS use `AppRoutes.<routeName>`.
- **NEVER** pass dependencies (use cases, services, repos) via widget constructors or parent→child propagation. ALWAYS use `getIt<T>()`.
- **NEVER** pass Blocs via widget constructors across routes. ALWAYS pass through the router via `extra` + `BlocProvider.value`.
- **NEVER** create a widget class that exceeds 90 lines. ALWAYS extract into separate files in `widgets/`.
- **NEVER** use `Widget _buildSomething()` methods inside widget classes. ALWAYS use separate `StatelessWidget` or `StatefulWidget` classes.
- **NEVER** use Provider, Riverpod, ChangeNotifier, or any state management other than `flutter_bloc`.
- **NEVER** hold UI state in `StatefulWidget` local state that the Bloc already owns.
- **NEVER** use hard-coded `Map` literals for label/icon/color/status mappings. ALWAYS use enums with extensions.
- **NEVER** import data layer classes (Drift, data models, repo implementations) from Blocs or domain.
- **NEVER** call Bloc use cases from widgets directly. Widgets dispatch events only.
- **NEVER** emit UI changes without a corresponding Bloc-emitted state.

---

## ✅ Pre-Response Checklist (AI Must Self-Verify Before Outputting Code)

Before finalizing any code output, mentally verify every item below. If any item fails, fix it before responding.

- [ ] No logic in any widget — only `context.read<XBloc>().add(XEvent())` and state rendering
- [ ] No repository calls in any Bloc — only use case calls
- [ ] No data models imported outside `data/` layer
- [ ] No Flutter or Drift imports inside any `domain/` file
- [ ] No hardcoded route strings — `AppRoutes` is used everywhere
- [ ] No dependencies passed via widget tree; Bloc deps from `getIt<T>()` (in Bloc or at composition root)
- [ ] No Bloc passed through widget constructors across routes — router `extra` used
- [ ] No widget class exceeds 90 lines — large widgets are extracted to `widgets/` folder
- [ ] No `Widget _buildX()` methods — all sub-widgets are separate classes
- [ ] No `Map` literals used for type/status/mode → label/icon/color — enums with extensions used
- [ ] All new files are in the correct layer/feature folder (see decision tree below)
- [ ] Only `flutter_bloc` used for state management
- [ ] Bloc only imports domain (use cases, entities) — never data layer
- [ ] All route paths defined in `AppRoutes`; all screen arguments passed via router

---

## 📁 Where Does This File Go? (Decision Tree)

When adding a new class or file, use this tree — do not guess:

```
What kind of class is it?
│
├── Domain entity                  → lib/domain/<feature>/entities/
├── Domain repository interface    → lib/domain/<feature>/repositories/
├── Use case                       → lib/domain/<feature>/use_cases/
├── Data model (DB/API)            → lib/data/<feature>/models/
├── Repository implementation      → lib/data/<feature>/repositories/
├── Mapper (model ↔ entity)        → lib/data/<feature>/mappers/
├── Data source                    → lib/data/<feature>/data_source/
│
├── Bloc                           → lib/presentation/<page_name>/bloc/<page_name>_bloc.dart
├── Bloc event                     → lib/presentation/<page_name>/bloc/<page_name>_event.dart
├── Bloc state                     → lib/presentation/<page_name>/bloc/<page_name>_state.dart
├── Page entry widget              → lib/presentation/<page_name>/<page_name>_page.dart
├── Page sub-widget                → lib/presentation/<page_name>/widgets/<page_name>_<section>.dart
├── Page UI model                  → lib/presentation/<page_name>/ui_models/
├── Page helper/util               → lib/presentation/<page_name>/utils/
│
├── Feature entry (routes, BlocProvider) → lib/presentation/<feature>_feature.dart
├── Shared DI / router / constants → lib/core/
├── Route paths                    → lib/core/router/app_routes.dart
└── Route args model (3+ values)   → lib/core/router/route_args.dart
```

**Page folder names are always snake_case:** `history/`, `add_edit_place/`, `dashboard/`, `manual_attendance/`, `map/`, `no_place/`, `settings/`, `background_location/`, `onboarding_completion/`

---

## ❌ / ✅ Code Examples (Most Common Violations)

### 1. Logic inside a widget — NEVER

```dart
// ❌ BAD — logic inside widget
class PlaceCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (place.isActive) { // ← logic in widget!
          Navigator.push(...);
        }
      },
    );
  }
}

// ✅ GOOD — dispatch event, Bloc decides
class PlaceCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<PlacesBloc>().add(PlaceTapped(place.id)),
    );
  }
}
```

---

### 2. Calling a repository directly from a Bloc — NEVER

```dart
// ❌ BAD — Bloc calls repo directly
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final PresenceRepository _repo; // ← NEVER import repo in Bloc
  Future<void> _onLoad(LoadHistory event, Emitter emit) async {
    final list = await _repo.getAll(); // ← direct repo call
  }
}

// ✅ GOOD — Bloc calls use case
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetPresenceHistory _getPresenceHistory; // ← use case only
  Future<void> _onLoad(LoadHistory event, Emitter emit) async {
    final list = await _getPresenceHistory();
  }
}
```

---

### 3. Hardcoded route strings — NEVER

```dart
// ❌ BAD — hardcoded strings
context.go('/places/edit/123');
GoRoute(path: '/places/edit/:id', ...);

// ✅ GOOD — AppRoutes constants
context.go(AppRoutes.placeEdit(place.id));
GoRoute(path: AppRoutes.placeEditPath, ...);
```

---

### 4. Passing dependencies via constructors — NEVER

```dart
// ❌ BAD — injecting deps through widget constructor
class PlacesPage extends StatelessWidget {
  final GetPlaces getPlaces; // ← NEVER pass use cases via constructors
  const PlacesPage({required this.getPlaces});
}

// ✅ GOOD — resolve from DI (inside Bloc or at composition root and inject)
class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  PlacesBloc({GetPlaces? getPlaces}) : _getPlaces = getPlaces ?? getIt<GetPlaces>(), super(...);
  final GetPlaces _getPlaces;
}
```

---

### 5. Widget class too long / using build methods — NEVER

```dart
// ❌ BAD — long widget with private build methods
class DashboardPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(children: [_buildHeader(), _buildBody()]);
  }
  Widget _buildHeader() => ...; // ← method, not a class
  Widget _buildBody() => ...;   // ← and the class is 150 lines
}

// ✅ GOOD — slim page file, extracted widget classes
// dashboard_page.dart (~30 lines)
class DashboardPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(children: [DashboardHeader(), DashboardBody()]);
  }
}
// widgets/dashboard_header.dart — its own file, public class
class DashboardHeader extends StatelessWidget { ... }
// widgets/dashboard_body.dart — its own file, public class
class DashboardBody extends StatelessWidget { ... }
```

---

### 6. Hardcoded maps for labels/icons/colors — NEVER

```dart
// ❌ BAD — hardcoded map
const statusLabels = {'present': 'Present', 'absent': 'Absent'};
Text(statusLabels[status]!);

// ✅ GOOD — enum + extension
enum PresenceStatus { present, absent }
extension PresenceStatusX on PresenceStatus {
  String get label => switch (this) {
    PresenceStatus.present => 'Present',
    PresenceStatus.absent  => 'Absent',
  };
}
Text(status.label);
```

---

### 7. Passing a Bloc across routes via constructor — NEVER

```dart
// ❌ BAD — Bloc passed via widget constructor
PlacesPage(bloc: myBloc);

// ✅ GOOD — pass through router extra, provide via BlocProvider.value
// In GoRoute builder:
builder: (context, state) {
  final bloc = state.extra as PlacesBloc;
  return BlocProvider.value(value: bloc, child: PlacesPage());
}
```

---

### 8. Domain importing Flutter or Drift — NEVER

```dart
// ❌ BAD — domain entity importing Flutter
import 'package:flutter/foundation.dart'; // ← NEVER in domain
import 'package:drift/drift.dart';        // ← NEVER in domain

// ✅ GOOD — pure Dart only in domain
class Place {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  const Place({required this.id, required this.name, ...});
}
```

---

## 0. Running the Project (FVM)

- Use **FVM** (Flutter Version Management) for all Flutter/Dart commands.
- Always prefix with `fvm`: `fvm flutter run`, `fvm flutter pub get`, `fvm dart run build_runner build`.
- Never run bare `flutter` or `dart` commands — the project uses a pinned Flutter version.

---

## 1. Clean Architecture (Layers)

Three layers: **data** , **domain** , **presentation** . Dependencies point strictly inward:

```
presentation  →  domain  →  (nothing — pure Dart only)
data          →  domain  →  (nothing)
```

- **Domain** : pure Dart. No Flutter, no Drift, no HTTP, no external packages that aren't pure Dart. Contains entities, repository interfaces, and use cases only.
- **Data** : implements domain interfaces. Uses Drift, HTTP, location APIs. Converts data models ↔ entities via mappers. Never exposes data models upward.
- **Presentation** : Flutter widgets + Blocs. Calls use cases only. Never imports data layer.

---

## 2. Folder Structure

### Full structure overview

```
lib/
├── core/
│   ├── di/
│   ├── router/
│   │   ├── app_routes.dart       ← ALL route paths here, NOWHERE else
│   │   └── route_args.dart       ← Route args models (3+ values)
│   ├── error/
│   └── constants/
│
├── domain/
│   ├── place/
│   │   ├── entities/             ← Place entity
│   │   ├── repositories/         ← PlaceRepository interface
│   │   └── use_cases/            ← GetPlaces, AddPlace, DeletePlace, etc.
│   ├── presence/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── use_cases/
│   ├── sync/
│   └── settings/
│
├── data/
│   ├── place/
│   │   ├── data_source/
│   │   ├── models/               ← PlaceModel (Drift table)
│   │   ├── mappers/              ← PlaceMapper: model ↔ entity
│   │   └── repositories/        ← PlaceRepositoryImpl
│   ├── presence/
│   ├── sync/
│   └── settings/
│
└── presentation/
    ├── dashboard/
    │   ├── bloc/
    │   │   ├── dashboard_bloc.dart
    │   │   ├── dashboard_event.dart
    │   │   └── dashboard_state.dart
    │   ├── widgets/
    │   │   ├── dashboard_header.dart
    │   │   └── dashboard_body.dart
    │   └── dashboard_page.dart
    ├── add_edit_place/
    ├── history/
    ├── manual_attendance/
    ├── map/
    ├── no_place/
    ├── settings/
    ├── background_location/
    ├── onboarding_completion/
    ├── onboarding/
    │   └── bloc/
    ├── calendar_feature.dart
    ├── places_feature.dart
    ├── settings_feature.dart
    ├── onboarding_feature.dart
    └── main_shell.dart
```

### Presentation layer rules

- **Page folder names:** always `snake_case` (e.g. `add_edit_place/`, not `AddEditPlace/`).
- **Main page file:** `<page_name>_page.dart`, class name `PascalCase` (e.g. `AddEditPlacePage`).
- **Bloc files:** `<page_name>_bloc.dart`, `<page_name>_event.dart`, `<page_name>_state.dart` — all in `bloc/` subfolder.
- **Sub-widgets:** one file per widget in `widgets/`, named `<page_name>_<section>.dart`, public class `PascalCase`.
- **Feature files:** `<feature>_feature.dart` at presentation root — handles routes and BlocProvider setup.

---

## 3. State Management (BLoC)

- Use **flutter_bloc only** . No other state management anywhere.
- **Widgets dispatch events. Blocs emit states. Widgets render states.** Nothing else.
- No logic in widgets — not even simple `if` guards, navigation decisions, or data transformations.
- No business logic in presentation — keep it in domain use cases.
- All decisions affecting what the UI shows live in the Bloc.
- Every visible UI change must originate from a Bloc-emitted state.
- `StatefulWidget` is allowed only when required; its meaningful state must still be driven by Bloc state via `BlocBuilder`/`BlocListener`.
- Blocs are registered as factories in DI or provided via `BlocProvider` in the widget tree.
- Blocs catch exceptions from use cases and emit error states. Widgets show error messages from state only.
- Blocs must never import from the data layer.

**Flow (enforced, no exceptions):**

```
Widget dispatches event
  → Bloc receives event
  → Bloc calls use case
  → Use case calls repository interface
  → Repository implementation fetches/stores data
  → Bloc receives result
  → Bloc emits new state
  → Widget rebuilds from state
```

---

## 4. Repositories and Use Cases

- **One repository interface per entity:** `PlaceRepository`, `PresenceRepository`, `SyncRepository`.
- Repository interfaces live in `domain/<feature>/repositories/`.
- Repository implementations live in `data/<feature>/repositories/`.
- **Use cases** live in `domain/<feature>/use_cases/`. Named verb-first: `GetPlaces`, `MarkDayPresent`, `SyncPendingToGoogle`, `DeletePlace`.
- Use cases call repository interfaces. They may call multiple repositories if needed.
- Blocs call use cases. Blocs never call repositories. No exceptions.

---

## 5. Data Layer (Drift, Sync, Location)

- **Local DB:** Drift (SQLite). Tables: `Place`, `Presence` (placeId, date, isPresent, source, firstDetectedAt), `SyncRecord` (placeId, date, syncedAt, eventId).
- **Sync split:** `SyncState` (DB state), `SyncClient` (google_sign_in + googleapis Calendar v3), `SyncScheduler` (trigger timing).
- Sync runs: after background run, on app open, when connectivity_plus reports back online.
- **Google Calendar:** Create event at time of first detection (not all-day). Title: `"Present at [Place name]"`. When user marks "not present", delete the calendar event.
- **Background:** WorkManager every 15 minutes. All logic (location → Haversine → update presence → trigger sync) in Dart only.
- **Maps:** `flutter_map` (OSM) for pin/current location. `geocoding` for address search. No Google Maps API for map UI.
- **Place limit:** More than one place requires subscription. Enforce in app logic.

---

## 6. Dependency Injection

- Use **get_it + injectable** . Register repositories, use cases, `SyncClient`, `SyncScheduler`, location service, and WorkManager callback in `core/di/`.
- **All dependencies resolved via `getIt<T>()`** . Do not pass dependencies from parent widgets down the tree (e.g. page → child widget).
- **Blocs:** Dependencies may be resolved at the composition root (e.g. in the route builder or feature file) via `getIt<T>()` and passed into the Bloc constructor, or the Bloc may resolve them internally. Both are acceptable.
- Blocs registered as factories (scoped to their page) or provided via `BlocProvider` in feature files.

---

## 7. Navigation

- Use **GoRouter** for all navigation. No `Navigator.push/pop` directly.
- **Bottom navigation** for main tabs (Places, Calendar, Settings).
- Onboarding is a full-screen flow before main shell; redirect when not completed.
- **All route paths defined in `AppRoutes`** (in `core/router/app_routes.dart`). No raw strings.
- Use `AppRoutes.root`, `AppRoutes.placeAdd`, `AppRoutes.placeEdit(id)`, etc. in `context.go`, `context.push`, redirects, and `GoRoute.path`.

### Passing through the router

- **Blocs:** Pass via `extra`, provide via `BlocProvider.value` in the route builder.
- **Arguments:** Pass via path params, query params, or `extra`. Route builder reads from `GoRouterState`.
- **Route-args model:** When a route needs 3 or more distinct values, define a dedicated model (e.g. `PlaceEditArgs`) in `core/router/route_args.dart` and pass as `state.extra`.

---

## 8. Errors and User Feedback

- Repositories and services throw exceptions. No mandatory `Result`/`Either` pattern app-wide.
- Use a **global error handler** (Flutter zone or error widget) for unexpected exceptions.
- User-visible error messages are defined and shown only in the presentation layer (from Bloc error states).
- Never swallow exceptions silently. Always emit an error state.

---

## 9. Calendar UX and Overrides

- **Aggregated view:** One calendar view where a day = present if present at any place.
- **Per-place drill-down:** Optional filter or secondary page.
- **Manual present:** Set presence to true; mark for sync if Google sync is on.
- **Manual not present:** Set presence to false and delete the Google Calendar event for that day/place.

---

## 10. Permissions and Onboarding

- **Single onboarding flow:** Foreground location first, then background with clear rationale.
- Background location only when user explicitly enables "background checks".
- Include an in-app page explaining why background location is needed before requesting it.

---

## 11. Settings (v1 — Minimal)

- Only Google Calendar sync on/off in v1.
- No check interval, place limit, or data export settings in v1.

---

## 12. Testing

- **Unit:** Repositories (Drift in-memory or mocks), presence/sync logic. Mock all external deps.
- **Widget:** Key pages (places, calendar, settings, onboarding) with `BlocProvider` and mock use cases/repos.
- **Integration:** Full flows; mock WorkManager, location, and Google APIs (fake `SyncClient` / location service).

---

## 13. Naming Conventions

| Thing            | Convention              | Example                      |
| ---------------- | ----------------------- | ---------------------------- |
| Dart files       | snake_case              | `add_edit_place_page.dart`   |
| Page folder      | snake_case              | `add_edit_place/`            |
| Widget class     | PascalCase              | `AddEditPlacePage`           |
| Entity           | PascalCase, no suffix   | `Place`,`Presence`           |
| Data model       | suffix `Model`          | `PlaceModel`                 |
| Repo interface   | PascalCase              | `PlaceRepository`            |
| Repo impl        | suffix `Impl`           | `PlaceRepositoryImpl`        |
| Use case         | Verb-first, PascalCase  | `GetPlaces`,`MarkDayPresent` |
| Bloc             | suffix `Bloc`/`Cubit`   | `DashboardBloc`              |
| Bloc event       | suffix `Event`          | `DashboardEvent`             |
| Bloc state       | suffix `State`          | `DashboardState`             |
| Feature entry    | suffix `_feature.dart`  | `places_feature.dart`        |
| Route args model | suffix `Args`or `Extra` | `PlaceEditArgs`              |

---

## 14. Enums Over Hard-coded Mappings

Never use `Map` literals to map status/type/mode → label/icon/color. Always use enums with extensions.

```dart
// ❌ NEVER
const statusLabels = {'present': 'Present ✓', 'absent': 'Absent'};

// ✅ ALWAYS
enum PresenceStatus { present, absent }

extension PresenceStatusX on PresenceStatus {
  String get label => switch (this) {
    PresenceStatus.present => 'Present ✓',
    PresenceStatus.absent  => 'Absent',
  };
  Color get color => switch (this) {
    PresenceStatus.present => Colors.green,
    PresenceStatus.absent  => Colors.grey,
  };
}
```

---

## 15. Features Reference

Active features in this project: **places** , **presence** , **calendar** , **sync** , **settings** , **onboarding** .

---

_Reference: `docs/ARCHITECTURE_PLAN.md`, `docs/PRD.md`, `docs/TECHNICAL_ANALYSIS.md`_
