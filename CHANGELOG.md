# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-02-03

### Updated
- Upgraded Tabler UI Framework from v1.2.0 to v1.4.0
- Core CSS: 648 KB → 619 KB (optimized)
- Core JavaScript: v1.4.0 (202 KB)
- Star Rating JS: v4.3.0 (15 KB, unchanged version but updated build)
- Updated CSS source maps

### Added
- Flags Add-on Module (19 KB CSS + 260 flag SVGs)
- Tabler Theme JS (1.4 KB) for enhanced dark mode support
- Asset paths for SVG images (flags)

### Notes
- Flags module is optional, activate with: `*= require tabler_ui/addons/tabler-flags`
- tabler-theme.js provides enhanced dark mode support complementary to existing dark_mode_controller.js

### Breaking Changes
- Verify custom CSS overrides against new v1.4.0 variables
- Test all components with updated Tabler UI v1.4.0

## [0.1.0] - 2026-02-03

### Added
- Initial gem structure with Rails Engine
- Core UI dispatcher with method_missing pattern
- Tabler UI helper for view access
- Navbar component with dropdown support
- Page Header component
- Avatar component with initials and image support
- Table component with sortable columns
- Button component with variants, sizes, and states
- Card component with slot support
- Dropdown component with items, dividers, and headers
- Bundled Tabler UI CSS (v1.2.0)
- Bundled Tabler UI JavaScript (v1.2.0)
- Stimulus controller for custom dropdown behavior
- Comprehensive README documentation
- Asset pipeline integration for Rails 8+
- Importmap configuration for JavaScript modules

## [0.1.0] - TBD

### Initial Release
- First version of the gem
- Core components extracted from WBB.NET project
- Full Tabler UI framework integration
