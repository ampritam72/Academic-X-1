import 'package:flutter_test/flutter_test.dart';
import 'package:academic_x/main.dart';
import 'package:provider/provider.dart';
import 'package:academic_x/providers/theme_provider.dart';
import 'package:academic_x/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
        child: const AcademicXApp(),
      ),
    );

    // Splash screen has ongoing animations; don't use pumpAndSettle().
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Academic X'), findsOneWidget);
  });
}
