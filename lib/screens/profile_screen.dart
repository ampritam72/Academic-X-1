import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/theme_provider.dart';
import '../widgets/shared_widgets.dart';

import '../providers/auth_provider.dart';
import '../providers/cgpa_provider.dart';
import '../providers/settings_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _aiTranslationEnabled = false;

  // Personal Info Constants
  static const String userName = 'Abir Mahmud Pritam';
  static const String studentId = '231311070';
  static const String section = 'B';
  static const String batch = '32nd';
  static const String dept = 'Dept of CSE, VU';
  static const String profileImagePath = 'assets/images/profile.png';

  void _showEditProfileModal(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withAlpha(77), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              Text('Edit Profile', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.lightText)),
              const SizedBox(height: 20),
              _buildModalTextField('Full Name', userName, isDark),
              const SizedBox(height: 16),
              _buildModalTextField('Student ID', studentId, isDark),
              const SizedBox(height: 24),
              GradientButton(
                label: 'Save Changes',
                icon: Icons.save_rounded,
                onPressed: () {
                  Navigator.pop(context);
                },
                colors: const [AppColors.primaryCyan, AppColors.primaryBlue],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ).animate().fadeIn().slideY(begin: 0.1),
    );
  }

  void _showLogoutModal(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.error.withAlpha(26)),
            child: Icon(Icons.logout_rounded, color: AppColors.error, size: 32),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Log Out', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.lightText)),
            const SizedBox(height: 8),
            Text('Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: GoogleFonts.outfit(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, fontWeight: FontWeight.w600)),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.error),
                  child: TextButton(
                    onPressed: () async {
                      await Provider.of<AuthProvider>(context, listen: false).logout();
                      if (!context.mounted) return;
                      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    child: Text('Log Out', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.9, 0.9), duration: 300.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildModalTextField(String label, String hint, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark ? Colors.white.withAlpha(13) : Colors.black.withAlpha(8),
          ),
          child: TextField(
            style: GoogleFonts.outfit(fontSize: 14, color: isDark ? AppColors.darkText : AppColors.lightText),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.outfit(fontSize: 14, color: isDark ? Colors.white.withAlpha(77) : Colors.black.withAlpha(77)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final cgpaProvider = Provider.of<CGPAProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(isDark),
              const SizedBox(height: 16),

              // Profile header
              _buildProfileCard(isDark, authProvider, cgpaProvider),

              const SizedBox(height: 20),

              // Stats row
              _buildStatsRow(isDark),

              const SizedBox(height: 24),

              // Settings Sections
              _SettingsSection(
                title: 'Account Settings',
                isDark: isDark,
                items: [
                  _SettingsItem(
                    icon: Icons.edit_rounded,
                    label: 'Edit Profile',
                    color: AppColors.primaryBlueprint,
                    onTap: () => _showEditProfileModal(isDark),
                  ),
                  _SettingsItem(
                    icon: Icons.lock_rounded,
                    label: 'Change Password',
                    color: AppColors.accentPurple,
                    onTap: () {
                      // TODO: Password Change Logic
                    },
                  ),
                ],
                delay: 200,
              ),

              const SizedBox(height: 20),

              _SettingsSection(
                title: 'Settings & Preferences',
                isDark: isDark,
                items: [
                  _SettingsItem(
                    icon: Icons.dark_mode_rounded,
                    label: 'Dark Mode',
                    color: AppColors.warning,
                    trailing: Switch.adaptive(
                      value: themeProvider.isDark,
                      onChanged: (_) => themeProvider.toggleTheme(),
                      activeTrackColor: AppColors.warning.withAlpha(100),
                      activeThumbColor: AppColors.warning,
                    ),
                  ),
                  _SettingsItem(
                    icon: Icons.language_rounded,
                    label: 'Language',
                    color: AppColors.primaryTeal,
                    trailing: Switch.adaptive(
                      value: settingsProvider.isBangla,
                      onChanged: (val) {
                        settingsProvider.toggleLanguage(val);
                      },
                      activeTrackColor: AppColors.primaryTeal.withAlpha(100),
                      activeThumbColor: AppColors.primaryTeal,
                    ),
                    subtitle: settingsProvider.isBangla ? 'Bangla' : 'English',
                  ),
                  _SettingsItem(
                    icon: Icons.translate_rounded,
                    label: 'AI Notes Translation',
                    color: AppColors.primaryCyan,
                    trailing: Switch.adaptive(
                      value: _aiTranslationEnabled,
                      onChanged: (val) {
                        setState(() => _aiTranslationEnabled = val);
                      },
                      activeTrackColor: AppColors.primaryCyan.withAlpha(100),
                      activeThumbColor: AppColors.primaryCyan,
                    ),
                  ),
                  _SettingsItem(
                    icon: Icons.notifications_rounded,
                    label: 'Class Reminders',
                    color: AppColors.error,
                    trailing: Switch.adaptive(
                      value: settingsProvider.isClassReminderEnabled,
                      onChanged: (val) {
                        settingsProvider.toggleClassReminder(val);
                      },
                      activeTrackColor: AppColors.error.withAlpha(100),
                      activeThumbColor: AppColors.error,
                    ),
                  ),
                  _SettingsItem(
                    icon: Icons.school_rounded,
                    label: 'About Dept. of CSE, VU',
                    color: AppColors.brandGreen,
                    onTap: () {
                      Navigator.of(context).pushNamed('/dept-cse');
                    },
                  ),
                ],
                delay: 300,
              ),

              const SizedBox(height: 24),

              // Logout Button
              GestureDetector(
                onTap: () => _showLogoutModal(isDark),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Text('Sign Out',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          )),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.1, delay: 500.ms, duration: 400.ms),

              const SizedBox(height: 24),

              Text('Academic X v1.0.0',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  )),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.brandGreen.withAlpha(isDark ? 42 : 32),
                      AppColors.brandRed.withAlpha(isDark ? 38 : 26),
                    ],
                  ),
                  border: Border.all(color: AppColors.brandGreen.withAlpha(85)),
                ),
                child: Column(
                  children: [
                    Text('Developed by $userName',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        )),
                    const SizedBox(height: 6),
                    Text('Batch: $batch · CGPA: 3.18',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        )),
                    const SizedBox(height: 8),
                    Text(
                      'Execute the Unexpected..',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8),
            ),
            child: Icon(Icons.arrow_back_rounded, color: isDark ? AppColors.darkText : AppColors.lightText, size: 20),
          ),
        ),
        const Spacer(),
      ],
    ).animate().fadeIn();
  }

  Widget _buildProfileCard(bool isDark, AuthProvider auth, CGPAProvider cgpa) {
    final initials = userName.split(' ').map((e) => e[0]).take(3).join().toUpperCase();

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primaryTeal, AppColors.primaryBlueprint],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlueprint.withAlpha(51),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(55),
              child: Image.asset(
                profileImagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 36)),
                ),
              ),
            ),
          ).animate().scale(begin: const Offset(0.5, 0.5), duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Text(userName,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              )),
          const SizedBox(height: 4),
          // Developer Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryCyan.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryCyan.withAlpha(51)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, size: 12, color: AppColors.primaryCyan),
                const SizedBox(width: 4),
                Text('APP DEVELOPER',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: AppColors.primaryCyan,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Info Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCompactInfo(Icons.badge_rounded, 'ID: $studentId', isDark),
              const SizedBox(width: 12),
              _buildCompactInfo(Icons.layers_rounded, 'Batch: $batch', isDark),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCompactInfo(Icons.grid_view_rounded, 'Sec: $section', isDark),
              const SizedBox(width: 12),
              _buildCompactInfo(Icons.school_rounded, dept, isDark),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.success.withAlpha(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events_rounded, size: 16, color: AppColors.success),
                const SizedBox(width: 8),
                Text(
                    'CGPA: ${cgpa.overallCGPA.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    )),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.1, duration: 500.ms);
  }

  Widget _buildCompactInfo(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          const SizedBox(width: 4),
          Text(text,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              )),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    final stats = [
      _Stat('🔥 Streak', '12 Days'),
      _Stat('📝 Notes', '47 Saved'),
      _Stat('⭐ Points', '1,250 xp'),
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: stats.indexOf(s) < stats.length - 1 ? 10 : 0),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Text(s.label,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      )),
                  const SizedBox(height: 6),
                  Text(s.value,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      )),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, delay: 200.ms, duration: 400.ms);
  }
}

class _Stat {
  final String label, value;
  _Stat(this.label, this.value);
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;
  final bool isDark;
  final int delay;

  const _SettingsSection({
    required this.title,
    required this.items,
    required this.isDark,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(title,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              )),
        ),
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: items.map((item) => _buildItemTile(item, context)).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms).slideX(begin: 0.1, delay: Duration(milliseconds: delay), duration: 400.ms);
  }

  Widget _buildItemTile(_SettingsItem item, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: item.color.withAlpha(20),
                ),
                child: Icon(item.icon, size: 20, color: item.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.label,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        )),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(item.subtitle!,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          )),
                    ]
                  ],
                ),
              ),
              if (item.trailing != null)
                item.trailing!
              else if (item.onTap != null)
                Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white.withAlpha(77) : Colors.black.withAlpha(77), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final Color color;
  final Widget? trailing;
  final String? subtitle;
  final VoidCallback? onTap;

  _SettingsItem({required this.icon, required this.label, required this.color, this.trailing, this.subtitle, this.onTap});
}
