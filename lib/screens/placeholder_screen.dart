import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

/// Generic placeholder screen for routes not yet fully built
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;

  const PlaceholderScreen({
    super.key,
    required this.title,
    this.subtitle = 'This feature is currently under development.',
    this.icon = Icons.auto_awesome_rounded,
    this.colors = const [AppColors.primaryBlue, AppColors.primaryCyan],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(colors: colors),
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Text(title,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      )),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.first.withAlpha(20),
                      ),
                      child: Icon(icon, size: 56, color: colors.first),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(begin: const Offset(0.8, 0.8), duration: 600.ms, curve: Curves.easeOutBack),

                    const SizedBox(height: 24),

                    Text(title,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        )).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          )),
                    ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.warning.withAlpha(20),
                      ),
                      child: Text('Coming Soon',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning,
                          )),
                    ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
