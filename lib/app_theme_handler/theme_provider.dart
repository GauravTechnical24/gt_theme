import 'package:flutter/material.dart';
import 'package:gt_theme/app_theme_handler/theme_service.dart';

/// ThemeConsumer widget for efficiently consuming theme data with minimal rebuilds.
///
/// This widget uses ValueListenableBuilder to rebuild only when the theme changes,
/// not when other parts of the widget tree rebuild. It provides access to ThemeService
/// and optionally accepts a child widget that won't be rebuilt.
///
/// This widget works independently without any state management dependency.
/// You can use it directly in your widgets to listen to theme changes.
///
/// Usage:
/// ```dart
/// ThemeConsumer(
///   themeService: themeService,
///   builder: (context, themeService, child) {
///     return Container(
///       color: themeService.getMaterialTheme(
///         MediaQuery.platformBrightnessOf(context)
///       ).scaffoldBackgroundColor,
///       child: child,
///     );
///   },
///   child: const StaticContent(),
/// )
/// ```
class ThemeConsumer extends StatelessWidget {
  final ThemeService themeService;
  final Widget Function(BuildContext, ThemeService, Widget?) builder;
  final Widget? child;

  const ThemeConsumer({
    super.key,
    required this.themeService,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeService.themeModeNotifier,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Brightness>(
          valueListenable: themeService.systemBrightnessNotifier,
          builder: (context, systemBrightness, _) {
            return builder(context, themeService, child);
          },
        );
      },
    );
  }
}

/// ThemeModeSelector widget for switching between light, dark, and system themes.
///
/// This widget provides a simple UI for users to select their preferred theme mode.
/// It demonstrates how to use ThemeService to change the theme mode at runtime.
///
/// This widget works independently without any state management dependency.
///
/// Usage:
/// ```dart
/// ThemeModeSelector(
///   themeService: themeService,
///   onThemeModeChanged: () {
///     print('Theme changed');
///   },
/// )
/// ```
class ThemeModeSelector extends StatelessWidget {
  /// The ThemeService instance
  final ThemeService themeService;

  /// Callback when theme mode is changed
  final VoidCallback? onThemeModeChanged;

  const ThemeModeSelector({
    super.key,
    required this.themeService,
    this.onThemeModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeService.themeModeNotifier,
      builder: (context, currentThemeMode, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Theme Mode',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildThemeModeButton(
                  context,
                  label: 'Light',
                  mode: ThemeMode.light,
                  isSelected: currentThemeMode == ThemeMode.light,
                  onPressed: () {
                    themeService.setThemeMode(ThemeMode.light);
                    onThemeModeChanged?.call();
                  },
                ),
                _buildThemeModeButton(
                  context,
                  label: 'Dark',
                  mode: ThemeMode.dark,
                  isSelected: currentThemeMode == ThemeMode.dark,
                  onPressed: () {
                    themeService.setThemeMode(ThemeMode.dark);
                    onThemeModeChanged?.call();
                  },
                ),
                _buildThemeModeButton(
                  context,
                  label: 'System',
                  mode: ThemeMode.system,
                  isSelected: currentThemeMode == ThemeMode.system,
                  onPressed: () {
                    themeService.setThemeMode(ThemeMode.system);
                    onThemeModeChanged?.call();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeModeButton(
    BuildContext context, {
    required String label,
    required ThemeMode mode,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;

    return Material(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? (isDark ? const Color(0xFFD0BCFF) : const Color(0xFF6750A4))
                  : (isDark
                        ? const Color(0xFF49454E)
                        : const Color(0xFFE7E0EC)),
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? (isDark
                      ? const Color(0xFF6750A4).withValues(alpha: 0.2)
                      : const Color(0xFF6750A4).withValues(alpha: 0.1))
                : Colors.transparent,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? const Color(0xFFD0BCFF) : const Color(0xFF6750A4))
                  : (isDark
                        ? const Color(0xFFB0B0B0)
                        : const Color(0xFF49454E)),
            ),
          ),
        ),
      ),
    );
  }
}

/// BrightnessIndicator widget that displays the current system brightness.
///
/// This widget demonstrates how to listen to system brightness changes
/// and update the UI accordingly.
///
/// This widget works independently without any state management dependency.
///
/// Usage:
/// ```dart
/// BrightnessIndicator(themeService: themeService)
/// ```
class BrightnessIndicator extends StatelessWidget {
  /// The ThemeService instance
  final ThemeService themeService;

  const BrightnessIndicator({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Brightness>(
      valueListenable: themeService.systemBrightnessNotifier,
      builder: (context, brightness, _) {
        final isDark = brightness == Brightness.dark;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark
                ? const Color(0xFF2B2930).withValues(alpha: 0.5)
                : const Color(0xFFF5EFF7).withValues(alpha: 0.5),
            border: Border.all(
              color: isDark ? const Color(0xFF49454E) : const Color(0xFFE7E0EC),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: isDark
                    ? const Color(0xFFD0BCFF)
                    : const Color(0xFF6750A4),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'System: ${isDark ? 'Dark' : 'Light'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFFE7E0EC)
                      : const Color(0xFF1C1B1F),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ThemeInfoCard widget that displays current theme information.
///
/// This widget shows the current theme mode and effective brightness,
/// useful for debugging and demonstration purposes.
///
/// This widget works independently without any state management dependency.
///
/// Usage:
/// ```dart
/// ThemeInfoCard(themeService: themeService)
/// ```
class ThemeInfoCard extends StatelessWidget {
  /// The ThemeService instance
  final ThemeService themeService;

  const ThemeInfoCard({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeService.themeModeNotifier,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Brightness>(
          valueListenable: themeService.systemBrightnessNotifier,
          builder: (context, systemBrightness, _) {
            final effectiveBrightness = themeService.effectiveBrightness;
            final isDark = effectiveBrightness == Brightness.dark;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark
                    ? const Color(0xFF2B2930)
                    : const Color(0xFFF5EFF7),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF49454E)
                      : const Color(0xFFE7E0EC),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Theme Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFFE7E0EC)
                          : const Color(0xFF1C1B1F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    context,
                    label: 'Theme Mode',
                    value: _getThemeModeLabel(themeMode),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context,
                    label: 'System Brightness',
                    value: systemBrightness == Brightness.dark
                        ? 'Dark'
                        : 'Light',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context,
                    label: 'Effective Brightness',
                    value: effectiveBrightness == Brightness.dark
                        ? 'Dark'
                        : 'Light',
                    isDark: isDark,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? const Color(0xFFC4C7C5) : const Color(0xFF49454E),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFFE7E0EC) : const Color(0xFF1C1B1F),
          ),
        ),
      ],
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}
