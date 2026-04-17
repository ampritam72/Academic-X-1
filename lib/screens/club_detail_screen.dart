import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';
import '../providers/club_provider.dart';

class ClubDetailScreen extends StatelessWidget {
  final Club club;

  const ClubDetailScreen({super.key, required this.club});

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clubProvider = Provider.of<ClubProvider>(context);
    final isMember = clubProvider.isMember(club.id);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(isDark, context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActionButtons(clubProvider, isMember, isDark),
                  const SizedBox(height: 24),
                  _buildAboutSection(isDark),
                  const SizedBox(height: 24),
                  _buildLeadershipSection(isDark),
                  const SizedBox(height: 24),
                  _buildEventSection('Upcoming Events', club.upcomingEvents, isDark),
                  const SizedBox(height: 24),
                  _buildEventSection('Previous Events', club.previousEvents, isDark),
                  const SizedBox(height: 24),
                  _buildContactSection(isDark),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(bool isDark, BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withAlpha(100) : Colors.white.withAlpha(100),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : Colors.black, size: 20),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          club.name,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black,
            shadows: [const Shadow(blurRadius: 10, color: Colors.black26)],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [club.color.withAlpha(200), club.color.withAlpha(100)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: Hero(
                tag: 'club_logo_${club.id}',
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 20)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      club.logo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(club.icon, size: 40, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ClubProvider provider, bool isMember, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: GradientButton(
            label: isMember ? 'Member' : 'Add To My Club',
            icon: isMember ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
            onPressed: () => provider.toggleMembership(club.id),
            colors: isMember 
              ? [AppColors.secondaryEmerald, AppColors.success] 
              : [AppColors.primaryCyan, AppColors.primaryBlue],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About Club',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            )),
        const SizedBox(height: 8),
        Text(
          club.description,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLeadershipSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Leadership',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            )),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildMentorCard(isDark),
              const SizedBox(width: 12),
              _buildLeadCard(isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMentorCard(bool isDark) {
    return Container(
      width: 260,
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    club.mentorImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      color: club.color.withAlpha(30),
                      child: Icon(Icons.person_rounded, color: club.color),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Club Mentor', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w600, color: club.color)),
                      Text(club.mentorName, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.lightText)),
                      Text(club.mentorDesignation, style: GoogleFonts.outfit(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.account_balance_rounded, club.mentorDept, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadCard(bool isDark) {
    return Container(
      width: 260,
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    club.leadImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      color: club.color.withAlpha(30),
                      child: Icon(Icons.stars_rounded, color: club.color),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(club.leadDesignation, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w600, color: club.color)),
                      Text(club.leadName, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.lightText)),
                      Text('ID: ${club.leadId}', style: GoogleFonts.outfit(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildInfoRow(Icons.layers_rounded, 'Batch: ${club.leadBatch}', isDark)),
                Expanded(child: _buildInfoRow(Icons.grid_view_rounded, 'Sec: ${club.leadSection}', isDark)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: _buildInfoRow(Icons.school_rounded, club.leadDept, isDark)),
                Expanded(child: _buildInfoRow(Icons.phone_rounded, club.leadContact, isDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 12, color: club.color.withAlpha(180)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildEventSection(String title, List<ClubEvent> events, bool isDark) {
    if (events.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            )),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Container(
                width: 240,
                margin: const EdgeInsets.only(right: 16),
                child: GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            image: DecorationImage(
                              image: AssetImage(event.image),
                              fit: BoxFit.cover,
                              onError: (_, __) {},
                            ),
                            color: club.color.withAlpha(30),
                          ),
                          child: (event.image.isEmpty)
                            ? Center(child: Icon(Icons.event_available_rounded, color: club.color.withAlpha(100), size: 40))
                            : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkText : AppColors.lightText)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_month_rounded, size: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                const SizedBox(width: 4),
                                Text(event.date, style: GoogleFonts.outfit(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact & Location',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            )),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildContactItem(Icons.location_on_rounded, 'Room', club.room, isDark, null),
              Divider(height: 24, color: isDark ? Colors.white.withAlpha(26) : Colors.black.withAlpha(26)),
              _buildContactItem(Icons.facebook_rounded, 'Facebook', 'fb.com/club_page', isDark, () => _launchUrl(club.fbUrl)),
              if (club.websiteUrl.isNotEmpty) ...[
                Divider(height: 24, color: isDark ? Colors.white.withAlpha(26) : Colors.black.withAlpha(26)),
                _buildContactItem(Icons.language_rounded, 'Website', 'www.clubsite.com', isDark, () => _launchUrl(club.websiteUrl)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, bool isDark, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: onTap != null ? AppColors.primaryCyan : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.outfit(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
              Text(value, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? AppColors.darkText : AppColors.lightText)),
            ],
          ),
          if (onTap != null) ...[
            const Spacer(),
            Icon(Icons.open_in_new_rounded, size: 14, color: isDark ? AppColors.darkTextSecondary.withAlpha(100) : AppColors.lightTextSecondary.withAlpha(100)),
          ]
        ],
      ),
    );
  }
}
