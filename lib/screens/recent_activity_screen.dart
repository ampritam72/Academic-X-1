import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';

class RecentActivityScreen extends StatelessWidget {
  const RecentActivityScreen({super.key});

  static final List<_Act> _items = [
    _Act('Data Structures Notes', 'AI generated • 2h ago', Icons.description_rounded,
        AppColors.primaryCyan),
    _Act('Python Code Review', 'Explained • 5h ago', Icons.code_rounded,
        AppColors.accentPurple),
    _Act('CGPA Updated', 'Semester 6 • 1d ago', Icons.trending_up_rounded,
        AppColors.success),
    _Act('Research Paper', 'Bookmarked • 2d ago', Icons.bookmark_rounded,
        AppColors.warning),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  children: [
                    if (canPop) ...[
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
                    ],
                    Text(
                      'Recent Activity',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final a = _items[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: a.color.withAlpha(26),
                              ),
                              child: Icon(a.icon, color: a.color, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.darkText
                                          : AppColors.lightText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    a.subtitle,
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
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(
                            delay: Duration(milliseconds: 80 * i),
                            duration: 400.ms)
                        .slideX(begin: 0.04, end: 0);
                  },
                  childCount: _items.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Act {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  _Act(this.title, this.subtitle, this.icon, this.color);
}
