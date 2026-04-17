import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';
import '../providers/routine_provider.dart';
import '../models/routine_model.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _dayController;
  final List<String> _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu'];

  @override
  void initState() {
    super.initState();
    _dayController = TabController(length: _days.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RoutineProvider>(context, listen: false).fetchRoutines();
    });
  }

  @override
  void dispose() {
    _dayController.dispose();
    super.dispose();
  }

  void _syncRoutine() {
    Provider.of<RoutineProvider>(context, listen: false).fetchRoutines();
    AppUtils.showPremiumSnackBar(
      context,
      'Syncing Routine...',
      color: AppColors.primaryBlue,
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
            _buildDayTabs(isDark),
            Expanded(
              child: Consumer<RoutineProvider>(
                builder: (context, routineProvider, child) {
                  if (routineProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return TabBarView(
                    controller: _dayController,
                    physics: const BouncingScrollPhysics(),
                    children: _days
                        .map(
                          (day) => _buildDaySchedule(
                            day,
                            isDark,
                            routineProvider,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _syncRoutine,
        backgroundColor: AppColors.primaryCyan,
        child: const Icon(Icons.sync_rounded, color: Colors.white),
      ).animate().scale(
            delay: 600.ms,
            begin: const Offset(0, 0),
            curve: Curves.easeOutBack,
          ),
    );
  }

  Widget _buildHeader(bool isDark) {
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
                color: isDark
                    ? Colors.white.withAlpha(8)
                    : Colors.black.withAlpha(8),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: isDark ? AppColors.darkText : AppColors.lightText,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
              ),
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Class Routine',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                Text(
                  'Spring 2026',
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
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildDayTabs(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8),
      ),
      child: TabBar(
        controller: _dayController,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDark ? AppColors.darkCard : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
            ),
          ],
        ),
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFFEC4899),
        unselectedLabelColor: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        labelStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: _days.map((d) => Tab(text: d, height: 44)).toList(),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildDaySchedule(
    String day,
    bool isDark,
    RoutineProvider provider,
  ) {
    final classes = provider.routines.where((r) => r.day == day).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildAIReminder(isDark, day, classes.length)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          sliver: classes.isEmpty
              ? SliverToBoxAdapter(
                  child: _buildEmptyState(isDark, day),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildClassCard(classes[index], isDark, index);
                    },
                    childCount: classes.length,
                  ),
                ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        ),
      ],
    );
  }

  Widget _buildAIReminder(bool isDark, String day, int classCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [AppColors.warning, Color(0xFFF59E0B)],
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$day Routine Overview',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    classCount == 0
                        ? 'No classes scheduled for this day.'
                        : 'You have $classCount class${classCount > 1 ? 'es' : ''} scheduled today. Tap any class card to view details.',
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
        .fadeIn(delay: 300.ms, duration: 500.ms)
        .slideX(begin: 0.1, delay: 300.ms, duration: 500.ms);
  }

  Widget _buildEmptyState(bool isDark, String day) {
    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue.withAlpha(18),
            ),
            child: const Icon(
              Icons.event_busy_rounded,
              color: AppColors.primaryBlue,
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'No Classes on $day',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Looks like your schedule is free for this day.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildClassCard(ClassRoutine data, bool isDark, int index) {
    final cardColor = _getRandomColor(index);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.startTime,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.endTime,
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
          const SizedBox(width: 12),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cardColor,
                  border: Border.all(
                    color: isDark ? AppColors.darkBg : AppColors.lightBg,
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 2,
                height: 94,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cardColor, cardColor.withAlpha(0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _showClassDetailsModal(data, isDark),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.courseCode,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: cardColor.withAlpha(20),
                          ),
                          child: Text(
                            data.location,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: cardColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.courseName,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 14,
                          color: cardColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Tap for details',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: cardColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 400 + index * 150),
          duration: 500.ms,
        )
        .slideY(
          begin: 0.1,
          delay: Duration(milliseconds: 400 + index * 150),
          duration: 500.ms,
        );
  }

  void _showClassDetailsModal(ClassRoutine data, bool isDark) {
    final teacherName = _extractTeacherName(data);
    final detailsLine = _extractDetailsLine(data);

    showGeneralDialog(
      context: context,
      barrierLabel: 'Routine Details',
      barrierDismissible: true,
      barrierColor: Colors.black.withAlpha(115),
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
                  color: Colors.black.withAlpha(40),
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
                  if (teacherName.isNotEmpty) ...[
                    _buildModalInfoRow(
                      icon: Icons.person_rounded,
                      value: teacherName,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),
                  ],
                  _buildModalInfoRow(
                    icon: Icons.book_rounded,
                    value: detailsLine.isNotEmpty
                        ? detailsLine
                        : data.courseCode,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _buildModalInfoRow(
                    icon: Icons.meeting_room_rounded,
                    value: 'Room: ${data.location}',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _buildModalInfoRow(
                    icon: Icons.access_time_filled_rounded,
                    value: '${data.startTime} - ${data.endTime}',
                    isDark: isDark,
                  ),
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

  Widget _buildModalInfoRow({
    required IconData icon,
    required String value,
    required bool isDark,
  }) {
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
          child: Icon(
            icon,
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

  String _extractTeacherName(ClassRoutine data) {
    try {
      final dynamic d = data;
      final value = d.teacherName?.toString() ?? '';
      if (value.trim().isNotEmpty) return value.trim();
    } catch (_) {}

    try {
      final dynamic d = data;
      final value = d.teacher?.toString() ?? '';
      if (value.trim().isNotEmpty) return value.trim();
    } catch (_) {}

    return '';
  }

  String _extractDetailsLine(ClassRoutine data) {
    try {
      final dynamic d = data;
      final semester = d.semester?.toString() ?? '';
      final section = d.section?.toString() ?? '';

      if (semester.trim().isNotEmpty && section.trim().isNotEmpty) {
        return '${data.courseCode} ($semester, $section)';
      }

      if (semester.trim().isNotEmpty) {
        return '${data.courseCode} ($semester)';
      }
    } catch (_) {}

    return data.courseCode;
  }

  Color _getRandomColor(int index) {
    final colors = [
      AppColors.primaryCyan,
      AppColors.primaryBlue,
      AppColors.accentPurple,
      AppColors.primaryTeal,
      const Color(0xFFF59E0B),
    ];
    return colors[index % colors.length];
  }
}
