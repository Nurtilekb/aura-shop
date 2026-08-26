# Lib architecture

The project uses a feature-first structure with a small shared foundation.

## Application layers

- `main.dart` - application bootstrap and top-level providers.
- `core/` - app-wide infrastructure: routing, constants, and utilities.
- `features/` - customer-facing domains. Each domain owns its presentation code.
- `admin_features/` - admin-facing domains, isolated from the customer UI.
- `bloc/` - shared application state managers used by more than one feature.
- `repositories/` - data access and Firebase integration.
- `shared/models/` - domain models shared by multiple features.
- `shared/widgets/` - reusable UI components with no feature-specific behavior.

## Dependency direction

`presentation -> bloc/repositories -> models`.

`core` and `shared` must not import screens from `features` or `admin_features`.
Feature screens may use shared widgets and repositories, but reusable widgets should
not know about a particular screen.

## Folder rules

- Put a new customer flow under `features/<domain>/presentation/`.
- Put admin-only UI under `admin_features/<domain>/presentation/`.
- Put state in `bloc/<domain>/` only when it is shared by multiple screens.
- Keep Firebase reads and writes in `repositories/`.
- Do not keep empty placeholder folders or files; create a folder together with its first file.
