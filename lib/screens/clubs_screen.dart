import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen>
    with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildTabBar(isDark),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildMyClubsTab(isDark),
                  _buildEventsTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
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
                colors: [Color(0xFFF97316), Color(0xFFFB923C)],
              ),
            ),
            child: const Icon(Icons.groups_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Clubs & Societies',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                Text('Manage memberships & find events',
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
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: isDark ? AppColors.darkCard : Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFFF97316),
        unselectedLabelColor: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w400),
        tabs: const [
          Tab(text: 'My Clubs', height: 38),
          Tab(text: 'Explore Events', height: 38),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildMyClubsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildClubCard(
          isDark: isDark,
          name: 'Computer Programming Club',
          role: 'Executive Member',
          members: '1.2k',
          icon: Icons.code_rounded,
          color: AppColors.primaryCyan,
          delay: 300,
        ),
        const SizedBox(height: 12),
        _buildClubCard(
          isDark: isDark,
          name: 'Robotics Society',
          role: 'General Member',
          members: '850',
          icon: Icons.precision_manufacturing_rounded,
          color: AppColors.warning,
          delay: 400,
        ),
        const SizedBox(height: 12),
        _buildClubCard(
          isDark: isDark,
          name: 'Debate Club',
          role: 'General Member',
          members: '400',
          icon: Icons.mic_rounded,
          color: AppColors.accentPurple,
          delay: 500,
        ),
      ],
    );
  }

  Widget _buildClubCard({
    required bool isDark,
    required String name,
    required String role,
    required String members,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withAlpha(26),
              border: Border.all(color: color.withAlpha(77)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: isDark ? Colors.white.withAlpha(13) : Colors.black.withAlpha(13),
                      ),
                      child: Text(role,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          )),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.people_alt_rounded, size: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    const SizedBox(width: 4),
                    Text(members,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        )),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.white.withAlpha(51) : Colors.black.withAlpha(51)),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms)
        .slideX(begin: 0.1, delay: Duration(milliseconds: delay), duration: 400.ms);
  }

  Widget _buildEventsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        // AI Suggestion
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: AppColors.accentGradient,
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI Event Recommendation',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        )),
                    const SizedBox(height: 3),
                    Text(
                      'Based on your major, you might like the AI Hackathon 2026 this weekend.',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

        const SizedBox(height: 20),
        const SectionTitle(title: 'Upcoming Events'),

        // Event Cards
        _buildEventCard(
          isDark: isDark,
          title: 'Intra-University AI Hackathon',
          club: 'Computer Programming Club',
          date: '12th April 2026',
          location: 'Lab 3',
          color: AppColors.primaryTeal,
          delay: 400,
        ),
        const SizedBox(height: 12),
        _buildEventCard(
          isDark: isDark,
          title: 'Line Follower Robot Contest',
          club: 'Robotics Society',
          date: '15th April 2026',
          location: 'Auditorium',
          color: AppColors.warning,
          delay: 500,
        ),
      ],
    );
  }

  Widget _buildEventCard({
    required bool isDark,
    required String title,
    required String club,
    required String date,
    required String location,
    required Color color,
    required int delay,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: color.withAlpha(26),
                ),
                child: Text('Register',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(club,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              const SizedBox(width: 6),
              Text(date,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  )),
              const Spacer(),
              Icon(Icons.location_on_rounded, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              const SizedBox(width: 6),
              Text(location,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  )),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms)
        .slideY(begin: 0.1, delay: Duration(milliseconds: delay), duration: 400.ms);
  }
}
