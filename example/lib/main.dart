import 'package:flutter/material.dart';
import 'package:gt_theme/gt_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeService.instance.startListening();
  runApp(const GTThemeExampleApp());
}

class GTThemeExampleApp extends StatelessWidget {
  const GTThemeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'GT Theme Example',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeService.instance.getMaterialTheme(Brightness.light),
          darkTheme: ThemeService.instance.getMaterialTheme(Brightness.dark),
          home: const ThemeExamplePage(),
        );
      },
    );
  }
}

class ThemeExamplePage extends StatelessWidget {
  const ThemeExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ThemeService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GT Theme Example'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header
          Text(
            'Welcome to GT Theme',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'A production-ready theme management package',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 32),

          // Theme Mode Selector
          _buildSection(
            context,
            title: 'Choose Theme Mode',
            child: ThemeModeSelector(
              themeService: service,
              onThemeModeChanged: () {
                debugPrint('Theme changed to: ${service.currentThemeMode}');
              },
            ),
          ),
          const SizedBox(height: 24),

          // System Brightness Indicator
          _buildSection(
            context,
            title: 'System Brightness',
            child: BrightnessIndicator(themeService: service),
          ),
          const SizedBox(height: 24),

          // Theme Info Card
          _buildSection(
            context,
            title: 'Theme Information',
            child: ThemeInfoCard(themeService: service),
          ),
          const SizedBox(height: 32),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () => service.setThemeMode(ThemeMode.light),
                icon: const Icon(Icons.light_mode),
                label: const Text('Light'),
              ),
              ElevatedButton.icon(
                onPressed: () => service.setThemeMode(ThemeMode.dark),
                icon: const Icon(Icons.dark_mode),
                label: const Text('Dark'),
              ),
              ElevatedButton.icon(
                onPressed: () => service.setThemeMode(ThemeMode.system),
                icon: const Icon(Icons.settings_suggest),
                label: const Text('System'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Performance Demo
          _buildPerformanceDemo(context),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceDemo(BuildContext context) {
    return ThemeConsumer(
      themeService: ThemeService.instance,
      builder: (context, service, child) {
        final isDark = service.effectiveBrightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ThemeConsumer Demo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              color: isDark
                  ? Colors.purple.shade900.withValues(alpha: 0.3)
                  : Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.speed,
                          color: isDark
                              ? Colors.purple.shade200
                              : Colors.purple.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Optimized Rebuilds',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.purple.shade200
                                : Colors.purple.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This card uses ThemeConsumer for efficient rebuilds. '
                      'Only this widget rebuilds when theme changes, '
                      'not the entire widget tree!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
