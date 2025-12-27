# GT Theme

[![pub package](https://img.shields.io/pub/v/gt_theme.svg)](https://pub.dev/packages/gt_theme)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A production-ready Flutter theme management package with Material 3 & Cupertino support, system theme detection, light/dark mode switching, and theme persistence.

## ✨ Features

- 🎨 **Material 3 & Cupertino Support** - Beautiful pre-configured themes for both design systems
- 🌓 **Light/Dark/System Modes** - Complete theme mode switching with persistence
- 📱 **System Theme Detection** - Real-time sync with device theme changes (no context needed!)
- 💾 **Theme Persistence** - Automatically saves user preference via SharedPreferences
- ⚡ **High Performance** - Minimal rebuilds using ValueNotifier pattern
- 🔌 **Zero-Dependency State Management** - Works with GetX, Provider, Bloc, Riverpod, or none!
- 🧩 **Ready-to-Use Widgets** - ThemeModeSelector, BrightnessIndicator, ThemeInfoCard

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  gt_theme: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Initialize in main()

```dart
import 'package:flutter/material.dart';
import 'package:gt_theme/gt_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeService.instance.startListening();
  runApp(const MyApp());
}
```

### 2. Configure MaterialApp

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'My App',
          themeMode: themeMode,
          theme: ThemeService.instance.getMaterialTheme(Brightness.light),
          darkTheme: ThemeService.instance.getMaterialTheme(Brightness.dark),
          home: const HomePage(),
        );
      },
    );
  }
}
```

### 3. Use Theme Widgets

```dart
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Theme mode selector (Light/Dark/System)
          ThemeModeSelector(
            themeService: ThemeService.instance,
            onThemeModeChanged: () => print('Theme changed!'),
          ),
          
          // Shows current system brightness
          BrightnessIndicator(themeService: ThemeService.instance),
          
          // Shows detailed theme info
          ThemeInfoCard(themeService: ThemeService.instance),
        ],
      ),
    );
  }
}
```

## 📖 API Reference

### ThemeService

The core singleton service for theme management.

| Property/Method | Description |
|----------------|-------------|
| `ThemeService.instance` | Global singleton instance |
| `startListening()` | Start listening to system brightness changes |
| `setThemeMode(ThemeMode)` | Set theme mode (light/dark/system) |
| `currentThemeMode` | Get current ThemeMode |
| `effectiveBrightness` | Get effective Brightness based on mode |
| `themeModeNotifier` | ValueNotifier for theme mode changes |
| `systemBrightnessNotifier` | ValueNotifier for system brightness |
| `getMaterialTheme(Brightness)` | Get Material ThemeData |
| `getCupertinoTheme(Brightness)` | Get CupertinoThemeData |

### Widgets

| Widget | Description |
|--------|-------------|
| `ThemeConsumer` | Efficiently consume theme data with minimal rebuilds |
| `ThemeModeSelector` | UI for switching between Light/Dark/System modes |
| `BrightnessIndicator` | Display current system brightness |
| `ThemeInfoCard` | Display current theme information |

## 🎯 Advanced Usage

### Manual Theme Switching

```dart
// Switch to dark mode
ThemeService.instance.setThemeMode(ThemeMode.dark);

// Switch to light mode
ThemeService.instance.setThemeMode(ThemeMode.light);

// Follow system theme
ThemeService.instance.setThemeMode(ThemeMode.system);
```

### Using ThemeConsumer for Optimized Rebuilds

```dart
ThemeConsumer(
  themeService: ThemeService.instance,
  builder: (context, service, child) {
    final isDark = service.effectiveBrightness == Brightness.dark;
    return Container(
      color: isDark ? Colors.black : Colors.white,
      child: child, // This child won't rebuild!
    );
  },
  child: const ExpensiveWidget(), // Won't rebuild on theme change
)
```

### Cupertino App Support

```dart
CupertinoApp(
  theme: ThemeService.instance.getCupertinoTheme(
    ThemeService.instance.effectiveBrightness,
  ),
  home: const HomePage(),
)
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Gaurav Technical**

- GitHub: [@AjayGauravTechnical](https://github.com/AjayGauravTechnical)
