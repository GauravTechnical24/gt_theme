/// GT Theme - A production-ready Flutter theme management package.
///
/// This package provides a complete theme management solution with:
/// - Material 3 and Cupertino theme support
/// - System theme detection and real-time sync
/// - Light/Dark/System mode switching
/// - Theme persistence via SharedPreferences
/// - Zero-dependency state management (works with any or no state management)
/// - Minimal widget rebuilds using ValueNotifier
///
/// ## Quick Start
///
/// ```dart
/// import 'package:gt_theme/gt_theme.dart';
///
/// void main() {
///   WidgetsFlutterBinding.ensureInitialized();
///   ThemeService.instance.startListening();
///   runApp(MyApp());
/// }
/// ```
///
/// ## Widgets Included
///
/// - [ThemeService] - Core singleton service for theme management
/// - [ThemeConsumer] - Widget for efficient theme consumption
/// - [ThemeModeSelector] - UI widget for theme mode selection
/// - [BrightnessIndicator] - Widget showing current system brightness
/// - [ThemeInfoCard] - Widget displaying current theme information
library;

export 'app_theme_handler/theme_service.dart';
export 'app_theme_handler/theme_provider.dart';
