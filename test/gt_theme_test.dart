import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_theme/gt_theme.dart';

void main() {
  group('ThemeService', () {
    test('instance returns singleton', () {
      final instance1 = ThemeService.instance;
      final instance2 = ThemeService.instance;
      final instance3 = ThemeService();

      expect(identical(instance1, instance2), isTrue);
      expect(identical(instance1, instance3), isTrue);
    });

    test('default theme mode is system', () {
      final service = ThemeService.instance;
      expect(service.currentThemeMode, ThemeMode.system);
    });

    test('getMaterialTheme returns correct theme for brightness', () {
      final service = ThemeService.instance;

      final lightTheme = service.getMaterialTheme(Brightness.light);
      final darkTheme = service.getMaterialTheme(Brightness.dark);

      expect(lightTheme.brightness, Brightness.light);
      expect(darkTheme.brightness, Brightness.dark);
    });

    test('getCupertinoTheme returns correct theme for brightness', () {
      final service = ThemeService.instance;

      final lightTheme = service.getCupertinoTheme(Brightness.light);
      final darkTheme = service.getCupertinoTheme(Brightness.dark);

      expect(lightTheme.brightness, Brightness.light);
      expect(darkTheme.brightness, Brightness.dark);
    });

    test('themeModeNotifier is not null', () {
      final service = ThemeService.instance;
      expect(service.themeModeNotifier, isNotNull);
      expect(service.themeModeNotifier, isA<ValueNotifier<ThemeMode>>());
    });

    test('systemBrightnessNotifier is not null', () {
      final service = ThemeService.instance;
      expect(service.systemBrightnessNotifier, isNotNull);
      expect(
          service.systemBrightnessNotifier, isA<ValueNotifier<Brightness>>());
    });

    test('effectiveBrightness returns correct value for light mode', () {
      final service = ThemeService.instance;
      service.setThemeMode(ThemeMode.light);

      expect(service.effectiveBrightness, Brightness.light);
    });

    test('effectiveBrightness returns correct value for dark mode', () {
      final service = ThemeService.instance;
      service.setThemeMode(ThemeMode.dark);

      expect(service.effectiveBrightness, Brightness.dark);
    });

    test('setThemeMode updates currentThemeMode', () {
      final service = ThemeService.instance;

      service.setThemeMode(ThemeMode.dark);
      expect(service.currentThemeMode, ThemeMode.dark);

      service.setThemeMode(ThemeMode.light);
      expect(service.currentThemeMode, ThemeMode.light);

      service.setThemeMode(ThemeMode.system);
      expect(service.currentThemeMode, ThemeMode.system);
    });

    test('setThemeMode updates themeModeNotifier', () {
      final service = ThemeService.instance;

      service.setThemeMode(ThemeMode.dark);
      expect(service.themeModeNotifier.value, ThemeMode.dark);

      service.setThemeMode(ThemeMode.light);
      expect(service.themeModeNotifier.value, ThemeMode.light);
    });

    test('toString returns readable representation', () {
      final service = ThemeService.instance;
      final str = service.toString();

      expect(str, contains('ThemeService'));
      expect(str, contains('mode:'));
    });
  });

  group('Widgets', () {
    testWidgets('ThemeModeSelector renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemeModeSelector(
              themeService: ThemeService.instance,
            ),
          ),
        ),
      );

      expect(find.text('Theme Mode'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
    });

    testWidgets('BrightnessIndicator renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrightnessIndicator(
              themeService: ThemeService.instance,
            ),
          ),
        ),
      );

      expect(find.textContaining('System:'), findsOneWidget);
    });

    testWidgets('ThemeInfoCard renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemeInfoCard(
              themeService: ThemeService.instance,
            ),
          ),
        ),
      );

      expect(find.text('Theme Information'), findsOneWidget);
      expect(find.text('Theme Mode'), findsOneWidget);
      expect(find.text('System Brightness'), findsOneWidget);
      expect(find.text('Effective Brightness'), findsOneWidget);
    });

    testWidgets('ThemeConsumer rebuilds on theme change', (tester) async {
      final service = ThemeService.instance;
      int buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemeConsumer(
              themeService: service,
              builder: (context, themeService, child) {
                buildCount++;
                return Text('Build count: $buildCount');
              },
            ),
          ),
        ),
      );

      expect(buildCount, 1);

      service.setThemeMode(ThemeMode.dark);
      await tester.pump();

      expect(buildCount, 2);
    });
  });
}
