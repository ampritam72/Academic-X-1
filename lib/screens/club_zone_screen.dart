import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';
import '../providers/club_provider.dart';
import 'club_detail_screen.dart';

class ClubZoneScreen extends StatefulWidget {
  const ClubZoneScreen({super.key});

  @override
  State<ClubZoneScreen> createState() => _ClubZoneScreenState();
}

class _ClubZoneScreenState extends State<ClubZoneScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                  _buildAllClubsTab(isDark),
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
          if (Navigator.of(context).canPop()) ...[
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
                Text('Club Zone',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                Text('Join clubs & explore activities',
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
        labelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w400),
        tabs: const [
          Tab(text: 'My Club', height: 38),
          Tab(text: 'All Clubs', height: 38),
          Tab(text: 'Events', height: 38),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildMyClubsTab(bool isDark) {
    final myClubs = Provider.of<ClubProvider>(context).myClubs;
    
    if (myClubs.isEmpty) {
      return const PremiumEmptyState(
        title: 'No Joined Clubs',
        subtitle: 'Go to "All Clubs" to find and join clubs that interest you.',
        icon: Icons.group_add_rounded,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: myClubs.length,
      itemBuilder: (context, index) {
        final club = myClubs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildClubCard(isDark, club),
        );
      },
    );
  }

  Widget _buildAllClubsTab(bool isDark) {
    final allClubs = Provider.of<ClubProvider>(context).allClubs;
    
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: allClubs.length,
      itemBuilder: (context, index) {
        final club = allClubs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildClubCard(isDark, club),
        );
      },
    );
  }

  Widget _buildClubCard(bool isDark, Club club) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClubDetailScreen(club: club)),
        );
      },
      child: Row(
        children: [
          Hero(
            tag: 'club_logo_${club.id}',
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: club.color.withAlpha(26),
                border: Border.all(color: club.color.withAlpha(77)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(27),
                child: Image.asset(
                  club.logo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(club.icon, color: club.color, size: 24),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(club.name,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                const SizedBox(height: 4),
                Text(
                  club.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? Colors.white.withAlpha(51) : Colors.black.withAlpha(51)),
        ],
      ),
    );
  }

  Widget _buildEventsTab(bool isDark) {
    final provider = Provider.of<ClubProvider>(context);
    final events = provider.allUpcomingEvents;

    if (events.isEmpty) {
      return const PremiumEmptyState(
        title: 'No Upcoming Events',
        subtitle: 'Check back later for new events and workshops.',
        icon: Icons.event_busy_rounded,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildEventCard(isDark, event, provider),
        );
      },
    );
  }

  Widget _buildEventCard(bool isDark, ClubEvent event, ClubProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: () {
        // Navigate to the specific club's detail screen
        final club = provider.allClubs.firstWhere((c) => c.id == event.clubId);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClubDetailScreen(club: club)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(event.title,
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
                  color: AppColors.primaryTeal.withAlpha(26),
                ),
                child: Text('Join',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTeal,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(event.clubName,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryCyan,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              const SizedBox(width: 6),
              Text(event.date,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  )),
              const Spacer(),
              Icon(Icons.location_on_rounded, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              const SizedBox(width: 6),
              Text(event.location,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
