# Changelog
All notable changes to this module will be documented in this file.
 
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this module adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added support for PIM-enabled Azure AD groups with customizable activation rules (for owner, contributor, and custom groups)
- Added support for individual PIM settings per custom group via `pim_settings` object in `custom_groups` variable
- Added conditional `approval_stage` blocks in PIM policies that only render when `require_approval` is `true`

### Changed

- Enhanced PIM policy resources to support group-specific PIM configurations with fallback to global defaults
- Improved `pim_custom_groups` local to filter groups based on `azuread_role_assignable`, `pim_settings`, and role assignments

### Required Permissions

- Service Principal requires `RoleManagementPolicy.ReadWrite.AzureADGroup` permission to manage PIM policies for Azure AD groups

## [2.1.1] - 2025-10-16

### Fixed

- Set default values in azuread groups

## [2.1.0] - 2025-10-10

### Added

- Added variable groups_config to be able to specify some parameters of the azuread_groups
 
## [2.0.0] - 2023-08-09
 
### Added
 - Changelog
 
### Changed
 - renamed optional property "pim_enabled" to "azuread_role_assignable", since it is no longer a requirement for a pim enabled group 
 - set parameter "assignable_to_role" to false in contributor and owner groups 

### Removed

### Fixed