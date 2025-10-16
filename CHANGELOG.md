# Changelog
All notable changes to this module will be documented in this file.
 
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this module adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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