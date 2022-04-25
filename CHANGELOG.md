# Changelog for Redmine Cumputable Custom Field

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## unreleased

### Fixed

* computable fields on custom field form to show up only when the field is
  computable
* usage of instance variables with self.(var_name) in initializer which throws
  an error in Ruby 2.6.x

## 3.0.3 - 2021-12-03

### Fixed

* Fix ComputableCustomFieldTest#test_create_computed_custom_field
* broken links in README

## 3.0.2 - 2021-10-11

### Added

* requirement for redmine_base_deface plugin
* configuration module

### Changed

* code to be cleaned up
* code documentation
* name of system test

## 3.0.1 - 2021-07-13

### Fixed

* calculation with key/value fields (consider also the Redmine patch #35557 on redmine.org)

## 3.0.0 - 2021-06-30

### Added

* explicit formula functions: sum(), min(), max(), division(), product(), custom()
* computable list fields for lists with numbers as entries (int, float) and
  enumeration lists where there position is used for calculation

### Changed

* plugin name to *redmine_computable_custom_field* in order to separate it from
  the original plugin due to the substantial reengineering
* the license to GNU GPL v2 due to substantial reengineering

## 2.0.0 - 2021-06-05

### Added

* support for formulas containing only custom fields and +, -, *, / operators

### Deleted

* support for arbitrary code evaluation in a formula in favour of security


## [1.0.7](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v1.0.7) - 2019-01-13
### Added
- Redmine 4.0.x support.

### Changed
- README.
- Refactor code.

### Fixed
- Tests.

### Removed
- hound.yml

## [1.0.6](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v1.0.6) - 2017-08-07
### Added
- Redmine 3.4.x support.

## [1.0.5](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v1.0.5) - 2017-03-21
### Changed
- PluginGemfile

## [1.0.4](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v1.0.4) - 2017-02-24
### Added
- pl translation from [Ralph Gutkowski](https://github.com/rgtk).

## [1.0.3](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v1.0.3) - 2017-02-20
### Added
- An additional information for available fields list.

## [1.0.2](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v1.0.2) - 2017-02-20
### Fixed
- Migration.

## [1.0.1](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v1.0.1) - 2017-02-20
### Fixed
- Migration.

## [1.0.0](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v1.0.0) - 2017-02-15
### Added
- New formula constructions `cfs[cf_id]`. Thanks to [ecanuto](https://github.com/ecanuto) for the idea.
- Tests.
- CHANGELOG.
- Redmine 2.5.x support.

### Changed
- Code has been rewritten from scratch.
- No backward compatibility with older versions.
- There is no separate computed format anymore. Custom field of any built-in format can be created as computed.
- README.

### Removed
- Old formula constructions `%{cf_id}`.
- Output formats.

## [0.0.8](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v0.0.8) - 2016-11-27
### Added
- Error handling to prevent internal server errors. From [swiehr](https://github.com/swiehr).
- zh  translation from [archonwang](https://github.com/archonwang).

### Changed
- README.

### Fixed
- Link formatting.

## [0.0.7](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v0.0.7) - 2016-08-29
### Added
- Markdown link format support.
- Grouping functionality for queries. From [plotterie](https://github.com/plotterie).

### Changed
- README.

### Fixed
- Typo in a custom field form. From [swiehr](https://github.com/swiehr).
- Error when validating DateTime.

## [0.0.6](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v0.0.6) - 2016-01-15
### Added
- Totalable support for Redmine 3.x.

### Fixed
- Error when trying to save iIssue from TimeEntry if Issue does not present.

## [0.0.5](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v0.0.5) - 2015-12-21
### Added
- Link output format.
- pt-br translation from [Adriano Ceccarelli](https://github.com/aceccarelli).

### Changed
- README.
- Error message about formula computing.

### Fixed
- Exclude Document class from list of classes for a patch.

## [0.0.4](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v0.0.4) - 2015-10-22
### Added
- Boolean and Percentage output formats.
- TimeEntry callbacks to re-save Issue.
- fr translation from [Atmis](https://github.com/Atmis).

### Removed
- Tests examples

### Fixed
- Bug when formula validation

## [0.0.3](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v0.0.3) - 2015-09-23
### Added
- String and Datetime output formats.
- Query filter options.

### Fixed
- Formula validation is evaluated in proper context.

## [0.0.2](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v0.0.2) - 2015-09-20
### Added
- Int and Float output formats.
- en translation.
- es translation from [lublasco](https://github.com/lublasco).
- Formula validation.

### Changed
- List of classes for a patch.
- README.
- Excluded CF own id from available fields list.

### Removed
- Groups of custom fields from creation form.

### Fixed
- Conversion error when formula computation

## [0.0.1](https://github.com/annikoff/redmine_plugin_computed_custom_field/releases/tag/v0.0.1) - 2015-08-13
### Added
- Base functionality.
