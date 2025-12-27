# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-27

### Added

- **ThemeService** - Production-ready singleton service for theme management
  - Material 3 light and dark themes with `ColorScheme.fromSeed`
  - Cupertino light and dark themes
  - System brightness detection without BuildContext
  - Theme mode persistence via SharedPreferences
  - ValueNotifier-based reactive updates for minimal rebuilds

- **ThemeConsumer** - Widget for efficient theme consumption with child optimization

- **ThemeModeSelector** - Ready-to-use UI widget for theme mode selection (Light/Dark/System)

- **BrightnessIndicator** - Widget displaying current system brightness

- **ThemeInfoCard** - Widget showing detailed theme information (mode, system brightness, effective brightness)

### Features

- Zero-dependency state management (works with GetX, Provider, Bloc, Riverpod, or none)
- Context-free system brightness listening via `WidgetsBindingObserver`
- Cached ThemeData for optimal performance
- Full Material 3 design system support
- Complete Cupertino design system support
