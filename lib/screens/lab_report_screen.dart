import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';

class LabReportScreen extends StatelessWidget {
  const LabReportScreen({super.key});

  final String _labCoverUrl =
      'https://vucover.vercel.app/?fbclid=IwZXh0bgNhZW0CMTAAYnJpZBExQ0dpODVZcWxqeUVuTVhodnNydGMGYXBwX2lkEDIyMjAzOTE3ODgyMDA4OTIAAR6hwSoFFMf1mESOPdQLN_OhiNOcrpXmsZhGwrCM7CRs2SHwTp-EV-JBN_2H6A_aem_8fEiAUqj0gUU7fXTQDpyjg';

  Future<void> _openExternalLink(BuildContext context) async {
    final Uri url = Uri.parse(_labCoverUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch the cover page maker.', style: GoogleFonts.outfit()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0EA5E9).withAlpha(26),
                        ),
                        child: const Icon(
                          Icons.science_rounded,
                          size: 64,
                          color: Color(0xFF0EA5E9),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
                      const SizedBox(height: 32),
                      Text('Lab Report Cover Maker',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          )).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                      const SizedBox(height: 12),
                      Text(
                        'Generate standard university lab report covers instantly using the external VUCover tool.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                      const SizedBox(height: 40),
                      GradientButton(
                        label: 'Open Helper Link',
                        icon: Icons.open_in_new_rounded,
                        onPressed: () => _openExternalLink(context),
                        colors: const [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
                      ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
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
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
