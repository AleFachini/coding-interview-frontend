# App Architecture Overview

This document describes the architecture used in this app and how responsibilities are separated across layers and modules.

## Architecture style

The project follows:

- clean architecture
- feature-first modular organization
- dependency inversion
- bloc-based state management
- constructor-based dependency injection with `get_it`

Main goal: keep business rules independent from UI, framework details, and external services.

## High-level module layout

Code is organized by feature under `lib/features/` and shared code under `lib/core/`.

Typical feature layout:

- `domain/`
  - `entities/`
  - `value_objects/`
  - `repositories/` (contracts)
  - `usecases/`
  - `failures/`
- `data/`
  - `models/`
  - `datasources/`
  - `repositories/` (implementations)
  - `mappers/`
- `presentation/`
  - `bloc/`
  - `pages/`
  - `widgets/`
  - `listeners/`

Shared modules in `lib/core/` include:

- `di/` for dependency registration
- `errors/` for exception types
- `utils/` for helpers and catalogs
- `services/` for reusable infrastructure/services

## Layer Responsibilities

### Domain layer

The domain layer contains business rules and abstractions:

- pure dart (no flutter dependencies)
- entities and value objects
- repository interfaces
- use cases orchestrating business operations
- domain failures

Domain does not know data source details (api/db/etc).

### Data layer

The data layer implements domain contracts:

- datasources call external systems (api, platform, persistence)
- models parse/serialize raw data
- repository implementations convert external responses into domain-friendly outputs
- mappers transform model <-> entity when needed

Data depends on domain abstractions, not on presentation.

### Presentation layer

The presentation layer manages UI behavior:

- blocs process user intents and emit view state
- pages/widgets render UI from state
- no direct networking or persistence logic inside widgets

Presentation depends on domain use cases and entities, not on data models.

## Dependency direction

Dependency flow is inward:

- presentation -> domain
- data -> domain
- domain -> no feature-layer dependency

This preserves replaceability and testability of infrastructure and UI.

## State management strategy

The app uses `bloc` as configured in `architecture_config.yaml`.

Standard flow:

1. UI dispatches an event.
2. Bloc validates/transforms input and calls use case.
3. Use case delegates to repository interface.
4. Repository implementation fetches from datasource(s).
5. Bloc emits loading/success/error states for UI rendering.

## Dependency injection

Dependency wiring is centralized in `lib/core/di/injection.dart`.

Rules used in this architecture:

- services, repositories, and use cases are registered in `get_it`
- consumers receive dependencies via constructors
- avoid creating repository/use case instances inside widgets

This allows easy mocking and replacement in tests.

## Error handling model

Error flow is normalized across layers:

- external errors are converted to app-level exceptions in data layer
- repository translates exceptions into domain failures
- bloc maps failures into user-facing state (`errorMessage`)

This avoids leaking transport-level details into UI.

## Testing strategy

Testing mirrors architecture boundaries:

- unit tests for use cases and repository behavior
- bloc tests for event -> state transitions and business rules
- widget tests for ui rendering and interactions

Mocking (`mocktail`) is used to isolate external dependencies and keep tests deterministic.

## Example feature flow (conversion)

Conversion demonstrates this architecture clearly:

- presentation bloc receives amount/currency events
- bloc calls conversion use case
- use case calls repository contract
- repository implementation fetches rate from remote datasource
- bloc applies direction-specific rules and emits quote/error states

This keeps UI simple while concentrating conversion behavior in testable business logic.

## Benefits of this architecture

- predictable code ownership by layer
- easier unit and widget testing
- safer refactoring with clear boundaries
- reduced coupling between ui and external services
- scalable feature growth with consistent structure

