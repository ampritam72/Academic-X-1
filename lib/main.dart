import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Config and Services
import 'package:academic_x/config/theme.dart';
import 'package:academic_x/providers/theme_provider.dart';
import 'package:academic_x/providers/auth_provider.dart';
import 'package:academic_x/providers/routine_provider.dart';
import 'package:academic_x/providers/cgpa_provider.dart';
import 'package:academic_x/providers/chat_provider.dart';
import 'package:academic_x/providers/settings_provider.dart';
import 'package:academic_x/providers/notice_provider.dart';
import 'package:academic_x/providers/navigation_provider.dart';
import 'package:academic_x/providers/club_provider.dart';
import 'package:academic_x/providers/slides_provider.dart';
import 'package:academic_x/services/notification_service.dart';

// Screens
import 'package:academic_x/screens/splash_screen.dart';
import 'package:academic_x/screens/login_screen.dart';
import 'package:academic_x/screens/main_shell.dart';
import 'package:academic_x/screens/code_explainer_screen.dart';
import 'package:academic_x/screens/cgpa_calculator_screen.dart';
import 'package:academic_x/screens/placeholder_screen.dart';
import 'package:academic_x/screens/routine_screen.dart';
import 'package:academic_x/screens/chat_screen.dart';
import 'package:academic_x/screens/club_zone_screen.dart';
import 'package:academic_x/screens/notices_screen.dart';
import 'package:academic_x/screens/slide_analyzer_screen.dart';
import 'package:academic_x/screens/project_thesis_screen.dart';
import 'package:academic_x/screens/scientific_calculator_screen.dart';
import 'package:academic_x/screens/recent_activity_screen.dart';
import 'package:academic_x/screens/dept_cse_about_screen.dart';
import 'package:academic_x/screens/all_slides_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('✓ Firebase initialized successfully');
  } catch (e) {
    debugPrint('✗ Firebase init error: $e');
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Notifications
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, RoutineProvider>(
          create: (context) => RoutineProvider(),
          update: (context, settings, routine) => (routine ?? RoutineProvider())..setSettings(settings),
        ),
        ChangeNotifierProvider(create: (_) => CGPAProvider()),
        ChangeNotifierProvider(create: (_) => ClubProvider()),
        ChangeNotifierProvider(create: (_) => SlidesProvider()),
        ChangeNotifierProxyProvider<AuthProvider, NoticeProvider>(
          create: (context) => NoticeProvider(
            authProvider: Provider.of<AuthProvider>(context, listen: false),
          ),
          update: (context, auth, previous) =>
              (previous ?? NoticeProvider(authProvider: auth))
                ..setAuthProvider(auth),
        ),
        ChangeNotifierProxyProvider2<AuthProvider, RoutineProvider, ChatProvider>(
          create: (context) => ChatProvider(
            Provider.of<AuthProvider>(context, listen: false),
            Provider.of<RoutineProvider>(context, listen: false),
          ),
          update: (context, auth, routine, previous) => ChatProvider(auth, routine),
        ),
      ],
      child: const AcademicXApp(),
    ),
  );
}

class AcademicXApp extends StatelessWidget {
  const AcademicXApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    return MaterialApp(
      title: settingsProvider.isBangla ? 'অ্যাকাডেমিক এক্স' : 'Academic X',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainShell(),
        '/notices': (context) => const NoticesScreen(),
        '/routine': (context) => const RoutineScreen(),
        '/cgpa': (context) => const CGPACalculatorScreen(),
        '/explainer': (context) => const CodeExplainerScreen(),
        '/chat': (context) => const ChatScreen(),
        '/clubs': (context) => const ClubZoneScreen(),
        '/study': (context) => const SlideAnalyzerScreen(),
        '/code': (context) => const CodeExplainerScreen(),
        '/projects': (context) => const ProjectThesisScreen(),
        '/all-slides': (context) => const AllSlidesScreen(),
        '/lab-report': (context) => const PlaceholderScreen(
          title: 'Lab Report Assistant',
          subtitle: 'Generate professional reports from your experiment data using AI.',
          icon: Icons.science_rounded,
          colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
        ),
        '/coming-soon': (context) => const PlaceholderScreen(
          title: 'Coming Soon',
          subtitle: 'We are working hard to bring this feature to life. Stay tuned!',
          icon: Icons.rocket_launch_rounded,
          colors: [AppColors.warning, Color(0xFFF59E0B)],
        ),
        '/scientific': (context) => const ScientificCalculatorScreen(),
        '/recent-activity': (context) => const RecentActivityScreen(),
        '/dept-cse': (context) => const DeptCseAboutScreen(),
      },
    );
  }
}
