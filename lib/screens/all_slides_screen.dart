import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:academic_x/config/theme.dart';
import 'package:academic_x/widgets/shared_widgets.dart';
import 'package:academic_x/providers/slides_provider.dart';

class AllSlidesScreen extends StatefulWidget {
  const AllSlidesScreen({super.key});

  @override
  State<AllSlidesScreen> createState() => _AllSlidesScreenState();
}

class _AllSlidesScreenState extends State<AllSlidesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleSlideTap(BuildContext context, int semester) async {
    final provider = Provider.of<SlidesProvider>(context, listen: false);
    
    if (provider.isDownloaded(semester)) {
      final path = await provider.getLocalPath(semester);
      final result = await OpenFile.open(path);
      if (result.type != ResultType.done) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open file: ${result.message}')),
          );
        }
      }
    } else {
      // Current placeholder URL, replace with your actual Drive links
      final url = 'https://www.google.com'; 
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open link')),
          );
        }
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
            _buildTabBar(isDark),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSlidesTab(context, isDark),
                  _buildSavedTab(context, isDark),
                ],
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
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
              ),
            ),
            child: const Icon(Icons.collections_bookmark_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('All Slides',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                Text('Academic Materials Repository',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    )),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withAlpha(5) : Colors.black.withAlpha(5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13),
        tabs: const [
          Tab(text: 'Slides (1st-8th)'),
          Tab(text: 'Saved Slides'),
        ],
      ),
    );
  }

  Widget _buildSlidesTab(BuildContext context, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildSemesterCard(context, index + 1, isDark)
            .animate()
            .fadeIn(delay: Duration(milliseconds: 50 * index), duration: 400.ms)
            .slideX(begin: 0.05, end: 0, delay: Duration(milliseconds: 50 * index), duration: 400.ms);
      },
    );
  }

  Widget _buildSavedTab(BuildContext context, bool isDark) {
    return Consumer<SlidesProvider>(
      builder: (context, provider, child) {
        final savedIds = provider.getSavedSlides();
        
        if (savedIds.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off_rounded, size: 60, color: isDark ? Colors.white10 : Colors.black12),
                const SizedBox(height: 16),
                Text(
                  'No Saved Slides',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Download slides to view them here',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          physics: const BouncingScrollPhysics(),
          itemCount: savedIds.length,
          itemBuilder: (context, index) {
            return _buildSemesterCard(context, savedIds[index], isDark)
                .animate()
                .fadeIn(delay: Duration(milliseconds: 50 * index), duration: 400.ms)
                .slideX(begin: 0.05, end: 0, delay: Duration(milliseconds: 50 * index), duration: 400.ms);
          },
        );
      },
    );
  }

  Widget _buildSemesterCard(BuildContext context, int semester, bool isDark) {
    String suffix = 'th';
    if (semester == 1) suffix = 'st';
    if (semester == 2) suffix = 'nd';
    if (semester == 3) suffix = 'rd';

    return Consumer<SlidesProvider>(
      builder: (context, provider, child) {
        final isSaved = provider.isDownloaded(semester);
        final isDownloading = provider.isDownloading(semester);
        final progress = provider.getProgress(semester);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            onTap: () => _handleSlideTap(context, semester),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFF11998e).withAlpha(20),
                      ),
                      child: Center(
                        child: Text(
                          '$semester',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF11998e),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$semester$suffix Semester Slides',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                            ),
                          ),
                          Text(
                            isSaved ? 'Available Offline' : 'Click to open Drive',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: isSaved 
                                ? const Color(0xFF11998e)
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isSaved) {
                          provider.removeDownloaded(semester);
                        } else if (!isDownloading) {
                          // Placeholder URL - replace with your actual file URL
                          provider.downloadSlide(semester, 'https://www.google.com');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSaved 
                            ? const Color(0xFF11998e).withAlpha(30)
                            : (isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5)),
                        ),
                        child: isDownloading 
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 2,
                                color: const Color(0xFF11998e),
                              ),
                            )
                          : Icon(
                              isSaved ? Icons.check_circle_rounded : Icons.download_for_offline_rounded,
                              size: 20,
                              color: isSaved ? const Color(0xFF11998e) : (isDark ? Colors.white38 : Colors.black26),
                            ),
                      ),
                    ),
                  ],
                ),
                if (isDownloading)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: isDark ? Colors.white.withAlpha(5) : Colors.black.withAlpha(5),
                      color: const Color(0xFF11998e),
                      borderRadius: BorderRadius.circular(2),
                      minHeight: 2,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
