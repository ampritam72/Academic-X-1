import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';
import '../providers/notice_provider.dart';
import '../providers/auth_provider.dart';
import '../models/notice_model.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_Assignment> _assignments = [
    _Assignment('A1', 'CSE 301', 'DP Algorithm Tracing', 'Review the notes and submit a trace for the knapsack problem.', '2h 15m left', true),
    _Assignment('A2', 'MAT 201', 'Worksheet 4: Eigenvalues', 'Submit your handwritten worksheet as a PDF.', '3 days left', false),
  ];

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

  void _showAddNoticeModal(bool isDark) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    bool isImportant = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withAlpha(77), borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 24),
                Text('Post New Notice', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 20),
                _buildModalTextField('Notice Title', 'e.g. Mid-term Update', isDark, titleController),
                const SizedBox(height: 16),
                _buildModalTextField('Message Body', 'Details about the notice...', isDark, bodyController, maxLines: 3),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Mark as Important', style: GoogleFonts.outfit(fontSize: 14, color: isDark ? AppColors.darkText : AppColors.lightText)),
                    const Spacer(),
                    Switch.adaptive(
                      value: isImportant,
                      onChanged: (val) => setModalState(() => isImportant = val),
                      activeThumbColor: AppColors.warning,
                      activeTrackColor: AppColors.warning.withAlpha(120),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                GradientButton(
                  label: 'Post to Board',
                  icon: Icons.send_rounded,
                  onPressed: () async {
                    if (titleController.text.isEmpty || bodyController.text.isEmpty) return;
                    
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    final noticeProvider = Provider.of<NoticeProvider>(context, listen: false);
                    
                    await noticeProvider.addNotice(
                      titleController.text,
                      bodyController.text,
                      auth.userData?['name'] ?? 'CR',
                      isImportant,
                    );
                    
                    if (context.mounted) Navigator.pop(context);
                  },
                  colors: const [AppColors.warning, Color(0xFFF59E0B)],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalTextField(String label, String hint, bool isDark, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.outfit(color: isDark ? AppColors.darkText : AppColors.lightText),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.outfit(color: isDark ? Colors.white24 : Colors.black26, fontSize: 14),
            filled: true,
            fillColor: isDark ? Colors.white.withAlpha(13) : Colors.black.withAlpha(13),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
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
                  _buildNoticesTab(isDark),
                  _buildAssignmentsTab(isDark),
                  _buildArchiveTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Provider.of<AuthProvider>(context).isCR && _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddNoticeModal(isDark),
              backgroundColor: AppColors.warning,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: Text('Post Notice', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white)),
            ).animate().scale(curve: Curves.easeOutBack)
          : null,
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
                colors: [AppColors.warning, Color(0xFFF59E0B)],
              ),
            ),
            child: const Icon(Icons.campaign_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notice Board',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                Text(Provider.of<AuthProvider>(context).isCR ? 'CR (Admin) Mode' : 'Stay updated with your department',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: Provider.of<AuthProvider>(context).isCR ? FontWeight.w600 : FontWeight.w400,
                      color: Provider.of<AuthProvider>(context).isCR ? AppColors.warning : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
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
        onTap: (_) => setState(() {}), // Ensure FAB updates on tab switch
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: isDark ? AppColors.darkCard : Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.warning,
        unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        labelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: 'Notices', height: 38),
          Tab(text: 'Assignments', height: 38),
          Tab(text: 'Archive', height: 38),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildNoticesTab(bool isDark) {
    return Consumer<NoticeProvider>(
      builder: (context, noticeProvider, child) {
        return StreamBuilder<List<Notice>>(
          stream: noticeProvider.noticeStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            
            final notices = snapshot.data ?? [];
            if (notices.isEmpty) {
              return const PremiumEmptyState(
                icon: Icons.campaign_outlined,
                title: 'No Notices',
                subtitle: 'Everything is quiet on the campus...',
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                return _buildNoticeCard(notice, isDark, index, false);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildArchiveTab(bool isDark) {
    return const PremiumEmptyState(
      icon: Icons.archive_outlined,
      title: 'Empty Archive',
      subtitle: 'Archive feature coming soon.',
    ).animate().fadeIn();
  }

  Widget _buildNoticeCard(Notice notice, bool isDark, int index, bool isArchive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(notice.id),
        direction: isArchive ? DismissDirection.none : DismissDirection.horizontal,
        background: _buildSwipeAction(isDark, Icons.archive_rounded, 'Archive', AppColors.primaryBlueprint, Alignment.centerLeft),
        secondaryBackground: _buildSwipeAction(isDark, notice.isImportant ? Icons.star_border_rounded : Icons.star_rounded, notice.isImportant ? 'Unmark' : 'Important', AppColors.warning, Alignment.centerRight),
        onDismissed: (direction) {
          // Future: Impl archive/star in Firestore
        },
        confirmDismiss: (direction) async {
          return false; // Disable swipe for now until backend ready
        },
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: notice.isImportant ? AppColors.warning.withAlpha(26) : (isDark ? Colors.white.withAlpha(13) : Colors.black.withAlpha(13)),
                    ),
                    child: Icon(
                      notice.isImportant ? Icons.star_rounded : Icons.campaign_rounded,
                      color: notice.isImportant ? AppColors.warning : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(notice.title,
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: notice.isImportant ? FontWeight.w700 : FontWeight.w600,
                                    color: isDark ? AppColors.darkText : AppColors.lightText,
                                  )),
                            ),
                            Text(DateFormat('hh:mm a').format(notice.timestamp),
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                )),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isDark ? Colors.white.withAlpha(13) : Colors.black.withAlpha(13),
                          ),
                          child: Text(notice.sender,
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: isDark ? Colors.white.withAlpha(13) : Colors.black.withAlpha(13)),
              const SizedBox(height: 8),
              Text(notice.body,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  )),
            ],
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: 200 + index * 100)).slideX(begin: 0.1),
    );
  }

  Widget _buildSwipeAction(bool isDark, IconData icon, String label, Color color, Alignment alignment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(51)),
      ),
      alignment: alignment,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildAssignmentsTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: _assignments.length,
      itemBuilder: (context, index) {
        final assn = _assignments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColors.primaryBlueprint.withAlpha(isDark ? 51 : 26),
                      ),
                      child: Text(assn.course,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF60A5FA) : AppColors.primaryBlueprint,
                          )),
                    ),
                    Row(
                      children: [
                        Text('Remind Me', style: GoogleFonts.outfit(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                        const SizedBox(width: 8),
                        Switch.adaptive(
                          value: assn.hasReminder,
                          onChanged: (val) {
                            setState(() => assn.hasReminder = val);
                          },
                          activeThumbColor: AppColors.warning,
                          activeTrackColor: AppColors.warning.withAlpha(120),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(assn.title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                const SizedBox(height: 6),
                Text(assn.description,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    )),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: assn.isUrgent ? AppColors.error.withAlpha(20) : AppColors.secondaryEmerald.withAlpha(20),
                        border: Border.all(color: assn.isUrgent ? AppColors.error.withAlpha(51) : AppColors.secondaryEmerald.withAlpha(51)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer_rounded, size: 14, color: assn.isUrgent ? AppColors.error : AppColors.secondaryEmerald),
                          const SizedBox(width: 6),
                          Text(assn.countdown, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: assn.isUrgent ? AppColors.error : AppColors.secondaryEmerald)),
                        ],
                      ),
                    ).animate(onPlay: (controller) {
                      if (assn.isUrgent) controller.repeat(reverse: true);
                    }).fade(end: 0.7, duration: 1000.ms),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 200 + index * 100)).slideY(begin: 0.1),
        );
      },
    );
  }
}

class _Assignment {
  final String id, course, title, description, countdown;
  final bool isUrgent;
  bool hasReminder = true;
  _Assignment(this.id, this.course, this.title, this.description, this.countdown, this.isUrgent);
}
