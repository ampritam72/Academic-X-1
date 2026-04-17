import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';

/// About Department of CSE, Varendra University — opens from Settings.
class DeptCseAboutScreen extends StatelessWidget {
  const DeptCseAboutScreen({super.key});

  static const _vu = 'https://vu.edu.bd';
  static const _overview = 'https://vu.edu.bd/academics/programs/6/b-sc-in-cse';
  static const _cse = 'https://vu.edu.bd/academics/departments/computer-science-and-engineering';
  static const _studentPortal = 'http://160.187.25.3:8083/front/student/login';

  Future<void> _open(String url) async {
    final u = Uri.parse(url);
    if (await canLaunchUrl(u)) {
      await launchUrl(u, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8),
                            ),
                            child: Icon(Icons.arrow_back_rounded,
                                color: isDark ? AppColors.darkText : AppColors.lightText, size: 20),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Dept. of CSE, VU',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Computer Science & Engineering at Varendra University — programs, resources, and links.',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        height: 1.45,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _AboutCard(
                    title: 'Overview',
                    subtitle: 'Program details & curriculum',
                    icon: Icons.info_rounded,
                    colors: [AppColors.primaryCyan, AppColors.primaryBlue],
                    delay: 0,
                    onTap: () => _open(_overview),
                  ),
                  _AboutCard(
                    title: 'Visit Website',
                    subtitle: 'Official VU & department pages',
                    icon: Icons.language_rounded,
                    colors: [AppColors.brandGreen, AppColors.primaryTeal],
                    delay: 80,
                    onTap: () => _open(_cse),
                  ),
                  _AboutCard(
                    title: 'Student Log In',
                    subtitle: 'Portal for results, notices & more',
                    icon: Icons.login_rounded,
                    colors: [AppColors.primaryBlueprint, AppColors.primaryCyan],
                    delay: 160,
                    onTap: () => _open(_studentPortal),
                  ),
                  _AboutCard(
                    title: 'University Home',
                    subtitle: 'Varendra University main site',
                    icon: Icons.school_rounded,
                    colors: [AppColors.brandRed, AppColors.warning],
                    delay: 240,
                    onTap: () => _open(_vu),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '— Abir Mahmud Pritam · Batch 32nd · Dept. of CSE, VU',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final int delay;
  final VoidCallback onTap;

  const _AboutCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(colors: colors),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
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
              Icon(Icons.chevron_right_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 450.ms)
        .slideX(begin: 0.06, end: 0, delay: Duration(milliseconds: delay));
  }
}
