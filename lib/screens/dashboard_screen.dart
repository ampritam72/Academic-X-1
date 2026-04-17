import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:academic_x/config/theme.dart';
import 'package:academic_x/providers/auth_provider.dart';
import 'package:academic_x/providers/navigation_provider.dart';
import 'package:academic_x/providers/routine_provider.dart';
import 'package:academic_x/providers/settings_provider.dart';
import 'package:academic_x/screens/slide_analyzer_screen.dart';
import 'package:academic_x/widgets/shared_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

const String _kLabCoverUrl =
    'https://vucover.vercel.app/?fbclid=IwY2xjawRBJu9leHRuA2FlbQIxMABicmlkETF0Y09WUlZ4Q3NybFdLV3hGc3J0YwZhcHBfaWQQMjIyMDM5MTc4ODIwMDg5MgABHmRDJQ9ZvqC1OeIs8zqqEJcbyB5DRQxxVBZ_8yZtciMQ1LtXoJelDUe0YkPv_aem_GofVmDmXkXk7jy30eripjQ';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  double _animatedCGPA = 0;
  bool _cgpaAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(800.ms, () {
      if (!mounted) return;
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final target =
          (auth.userData?['cgpa'] as num?)?.toDouble() ?? 3.18;
      _animateCGPA(target);
    });
  }

  void _animateCGPA(double target) {
    setState(() => _cgpaAnimated = true);
    const steps = 60;
    for (int i = 0; i <= steps; i++) {
      Future.delayed(Duration(milliseconds: i * 20), () {
        if (mounted) {
          setState(() => _animatedCGPA = target * (i / steps));
        }
      });
    }
  }

  Map<String, String> get _strings {
    final isBangla = Provider.of<SettingsProvider>(context, listen: false).isBangla;
    return isBangla ? {
      'hello': 'হ্যালো',
      'greeting': 'হ্যালো, প্রীতম! 👋',
      'motto': 'আজ নতুন কিছু শিখি',
      'quick': 'দ্রুত এক্সেস',
      'edit': 'এডিট',
      'upcoming': 'পরবর্তী ক্লাস',
      'recent': 'সাম্প্রতিক কার্যক্রম',
      'attendance': 'উপস্থিতি ট্র্যাকার',
      'showAll': 'সব দেখুন',
    } : {
      'hello': 'Hello',
      'greeting': 'Hello, Pritam! 👋',
      'motto': "Let's achieve greatness today",
      'quick': 'Quick Access',
      'edit': 'Edit',
      'upcoming': 'Upcoming Classes',
      'recent': 'Recent Activity',
      'attendance': 'Attendance Tracker',
      'showAll': 'Show All',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Glow Decor
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryCyan.withAlpha(20),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7028E4).withAlpha(15),
                ),
              ),
            ),
            
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(child: _buildHeader(isDark)),
                // Routine Card
                SliverToBoxAdapter(child: _buildRoutineCard(isDark)),
                // Quick Access
                SliverToBoxAdapter(
                  child: SectionTitle(title: _strings['quick']!, actionText: _strings['edit']!),
                ),
                SliverToBoxAdapter(child: _buildQuickAccess(isDark)),
                // Recent Activity
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: _strings['recent']!,
                    actionText: _strings['showAll']!,
                    onAction: () => Navigator.of(context).pushNamed('/recent-activity'),
                  ),
                ),
                SliverToBoxAdapter(child: _buildRecentActivity(isDark)),
                // Smart Suggestions
                SliverToBoxAdapter(
                  child: const SectionTitle(title: 'Smart Suggestions'),
                ),
                SliverToBoxAdapter(child: _buildSmartSuggestions(isDark)),
                // Developer Credit
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.brandGreen.withAlpha(isDark ? 45 : 35),
                            AppColors.brandRed.withAlpha(isDark ? 40 : 28),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.brandGreen.withAlpha(90),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brandGreen.withAlpha(35),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Developed with ❤️ by',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary.withAlpha(200)
                                  : AppColors.lightTextSecondary.withAlpha(200),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Abir Mahmud Pritam',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ID: 231311070 · Batch: 32nd · Sec: B',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Execute the Unexpected..',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: AppColors.brandGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _strings['greeting']!,
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _strings['motto']!,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(6),
                    border: Border.all(
                      color: isDark ? Colors.white.withAlpha(18) : Colors.black.withAlpha(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school_rounded, size: 14, color: AppColors.primaryCyan),
                      const SizedBox(width: 6),
                      Text(
                        'CGPA ${_cgpaAnimated ? _animatedCGPA.toStringAsFixed(2) : '0.00'}',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Profile + streak
          GestureDetector(
            onTap: () => Provider.of<NavigationProvider>(context, listen: false).setIndex(4),
            child: Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    border: Border.all(color: AppColors.primaryCyan.withAlpha(77), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/profile.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Text('AMP',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkBg : AppColors.lightBg,
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text('🔥', style: TextStyle(fontSize: 9)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: -0.1, end: 0, duration: 500.ms);
  }

  Widget _buildRoutineCard(bool isDark) {
    final routineProvider = Provider.of<RoutineProvider>(context);
    final isBangla = Provider.of<SettingsProvider>(context).isBangla;

    // Smooth check for initial loading
    if (routineProvider.routines.isEmpty && !routineProvider.isLoading) {
      routineProvider.fetchRoutines();
    }

    final todayClasses = routineProvider.routines.take(2).toList(); // Show a couple for demo

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: GlassCard(
        onTap: () => Navigator.of(context).pushNamed('/routine'),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: AppColors.secondaryGradient,
                  ),
                  child: const Icon(Icons.calendar_today_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isBangla ? 'আজকের রুটিন' : 'Today\'s Schedule',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      Text(
                        '${todayClasses.length} ${isBangla ? 'টি ক্লাস আছে' : 'classes scheduled'}',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
            const SizedBox(height: 20),
            if (routineProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (todayClasses.isEmpty)
              const Text('No classes today! 🎉')
            else
              Column(
                children: todayClasses.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _showClassDetailsModal(r, isDark),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryCyan,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.courseName,
                                  style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.darkText : AppColors.lightText)),
                              Text('${r.startTime} • ${r.location}',
                                  style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                            ],
                          ),
                        ),
                        Icon(Icons.touch_app_rounded, size: 14, color: AppColors.primaryCyan),
                      ],
                    ),
                  ),
                )).toList(),
              ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 600.ms);
  }

  void _handleQuickAccessTap(_QuickItem item) {
    switch (item.route) {
      case '/slide_push':
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const SlideAnalyzerScreen(showBackToDashboard: true),
          ),
        );
        break;
      case '/code':
        Navigator.of(context).pushNamed('/code');
        break;
      case '/cgpa':
        Navigator.of(context).pushNamed('/cgpa');
        break;
      case '/all-slides':
        Navigator.of(context).pushNamed('/all-slides');
        break;
      case '/routine':
        Navigator.of(context).pushNamed('/routine');
        break;
      case '/projects':
        Navigator.of(context).pushNamed('/projects');
        break;
      case '/lab_cover':
        launchUrl(Uri.parse(_kLabCoverUrl), mode: LaunchMode.externalApplication);
        break;
      case '/scientific':
        Navigator.of(context).pushNamed('/scientific');
        break;
      default:
        break;
    }
  }

  void _showClassDetailsModal(dynamic data, bool isDark) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Class Details',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.courseName,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildDetailRow('Course Code', data.courseCode, isDark),
                  const SizedBox(height: 10),
                  _buildDetailRow('Room', 'Room: ${data.location}', isDark),
                  const SizedBox(height: 10),
                  _buildDetailRow('Time', '${data.startTime} - ${data.endTime}', isDark),
                  const SizedBox(height: 18),
                  Divider(
                    color: isDark
                        ? Colors.white.withAlpha(20)
                        : Colors.black.withAlpha(20),
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      label: Text(
                        'Close',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primaryTeal.withAlpha(18),
          ),
          child: const Icon(
            Icons.info_rounded,
            size: 18,
            color: AppColors.primaryTeal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkText : AppColors.lightText,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccess(bool isDark) {
    final isBangla = Provider.of<SettingsProvider>(context).isBangla;

    final items = [
      _QuickItem(
          Icons.auto_stories_rounded,
          isBangla ? 'স্লাইড\nঅ্যানালাইজার' : 'Slide\nAnalyzer',
          [const Color(0xFF00D2FF), const Color(0xFF3A7BD5)],
          '/slide_push'),
      _QuickItem(
          Icons.code_rounded,
          isBangla ? 'কোড\nব্যাখ্যাকারী' : 'Code\nExplainer',
          [const Color(0xFF7028E4), const Color(0xFFE5B2CA)],
          '/code'),
      _QuickItem(
          Icons.calculate_rounded,
          isBangla ? 'সিজিপিএ\nক্যালকুলেটর' : 'CGPA\nCalculator',
          [const Color(0xFFFF512F), const Color(0xFFDD2476)],
          '/cgpa'),
      _QuickItem(
          Icons.collections_bookmark_rounded,
          isBangla ? 'সব স্লাইড' : 'All\nSlides',
          [const Color(0xFF11998e), const Color(0xFF38ef7d)],
          '/all-slides'),
      _QuickItem(
          Icons.schedule_rounded,
          isBangla ? 'ক্লাস\nরুটিন' : 'Class\nRoutine',
          [const Color(0xFFFC466B), const Color(0xFF3F5EFB)],
          '/routine'),
      _QuickItem(
          Icons.search_rounded,
          isBangla ? 'পেপার\nফাইন্ডার' : 'Paper\nFinder',
          [
            const Color(0xFFFF6B6B),
            const Color(0xFFFFE66D),
            const Color(0xFF4ECDC4),
            const Color(0xFF556270),
          ],
          '/projects'),
      _QuickItem(
          Icons.menu_book_rounded,
          isBangla ? 'LR কভার/\nইনডেক্স' : 'LR Cover/\nIndex Maker',
          [const Color(0xFFF093FB), const Color(0xFFF5576C)],
          '/lab_cover'),
      _QuickItem(
          Icons.functions_rounded,
          isBangla ? 'বৈজ্ঞানিক\nক্যালকুলেটর' : 'Scientific\nCalculator',
          [AppColors.brandGreen, AppColors.primaryTeal],
          '/scientific'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _QuickAccessCard(
            icon: item.icon,
            label: item.label,
            colors: item.colors,
            onTap: () => _handleQuickAccessTap(item),
          )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 400 + index * 80),
                duration: 500.ms,
              )
              .slideY(
                begin: 0.2,
                end: 0,
                delay: Duration(milliseconds: 400 + index * 80),
                duration: 500.ms,
              );
        },
      ),
    );
  }

  Widget _buildRecentActivity(bool isDark) {
    final activities = [
      _Activity('Data Structures Notes', 'AI generated • 2h ago',
          Icons.description_rounded, AppColors.primaryCyan),
      _Activity('Python Code Review', 'Explained • 5h ago',
          Icons.code_rounded, AppColors.accentPurple),
      _Activity('CGPA Updated', 'Semester 6 • 1d ago',
          Icons.trending_up_rounded, AppColors.success),
      _Activity('Research Paper', 'Bookmarked • 2d ago',
          Icons.bookmark_rounded, AppColors.warning),
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final a = activities[index];
          return GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed('/recent-activity'),
            child: Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: a.color.withAlpha(26),
                    ),
                    child: Icon(a.icon, color: a.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          a.title,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          a.subtitle,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
          )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 700 + index * 100),
                duration: 500.ms,
              );
        },
      ),
    );
  }

  Widget _buildSmartSuggestions(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: AppColors.accentGradient,
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Review your Data Structures slides',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on your upcoming exam schedule',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 1000.ms, duration: 500.ms)
        .slideX(begin: 0.05, end: 0, delay: 1000.ms, duration: 500.ms);
  }
}

class _QuickItem {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final String route;
  _QuickItem(this.icon, this.label, this.colors, this.route);
}

class _QuickAccessCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
  });

  @override
  State<_QuickAccessCard> createState() => _QuickAccessCardState();
}

class _QuickAccessCardState extends State<_QuickAccessCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark
                ? widget.colors.first.withAlpha(20)
                : Colors.white,
            border: Border.all(
              color: widget.colors.first.withAlpha(51),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.colors.first.withAlpha(38),
                blurRadius: _pressed ? 16 : 10,
                offset: Offset(0, _pressed ? 2 : 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(colors: widget.colors),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Activity {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  _Activity(this.title, this.subtitle, this.icon, this.color);
}
