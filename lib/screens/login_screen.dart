import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameCtl = TextEditingController();
  final _studentIdCtl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLogin = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  Map<String, String> get _strings {
    final isBangla = Provider.of<SettingsProvider>(context, listen: false).isBangla;
    return isBangla ? {
      'subtitle': 'আপনার স্মার্ট এআই স্টাডি সঙ্গী',
      'signInTab': 'লগ ইন',
      'registerTab': 'রেজিস্টার',
      'nameHint': 'পুরো নাম',
      'emailHint': 'ইমেইল এড্রেস',
      'passwordHint': 'পাসওয়ার্ড',
      'rememberMe': 'মনে রাখুন',
      'forgotPass': 'পাসওয়ার্ড ভুলে গেছেন?',
      'signInBtn': 'লগ ইন করুন',
      'registerBtn': 'একাউন্ট তৈরি করুন',
      'oauthText': 'অথবা লগ ইন করুন',
      'noAccount': 'একাউন্ট নেই?',
      'hasAccount': 'আগে থেকেই একাউন্ট আছে?',
    } : {
      'subtitle': 'Your Smart AI Study Companion',
      'signInTab': 'Sign In',
      'registerTab': 'Register',
      'nameHint': 'Full Name',
      'emailHint': 'Email Address',
      'passwordHint': 'Password',
      'rememberMe': 'Remember me',
      'forgotPass': 'Forgot Password?',
      'signInBtn': 'Sign In',
      'registerBtn': 'Create Account',
      'oauthText': 'or continue with',
      'noAccount': "Don't have an account?",
      'hasAccount': 'Already have an account?',
    };
  }

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _studentIdFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameCtl.dispose();
    _studentIdCtl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _nameFocus.dispose();
    _studentIdFocus.dispose();
    super.dispose();
  }

  void _handleAuth() {
    _navigateToDashboard();
  }

  void _handleGoogleAuth() {
    _navigateToDashboard();
  }

  void _handleGithubAuth() {
    _navigateToDashboard();
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.outfit()),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF050B1F),
                    const Color(0xFF0A1628),
                    const Color(0xFF0D2847),
                  ]
                : [
                    const Color(0xFFE8F4FD),
                    const Color(0xFFF0F5FF),
                    const Color(0xFFFFFFFF),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Top row — theme & language
                  _buildTopControls(isDark),

                  const SizedBox(height: 20),

                  // Branding
                  _buildBranding(isDark),

                  const SizedBox(height: 30),

                  // Auth Card
                  _buildAuthCard(isDark),

                  const SizedBox(height: 24),

                  // OAuth buttons
                  _buildOAuthSection(isDark),

                  const SizedBox(height: 24),

                  // Toggle Login/Register
                  _buildToggleAuth(isDark),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopControls(bool isDark) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isBangla = settingsProvider.isBangla;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Language toggle
        GestureDetector(
          onTap: () => settingsProvider.toggleLanguage(!isBangla),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDark ? Colors.white.withAlpha(13) : Colors.black.withAlpha(8),
              border: Border.all(
                color: isDark ? Colors.white.withAlpha(13) : Colors.black.withAlpha(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language_rounded,
                    size: 16,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
                const SizedBox(width: 6),
                Text(
                  isBangla ? 'BN' : 'EN',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Theme toggle
        GestureDetector(
          onTap: () => themeProvider.toggleTheme(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isDark ? Colors.white.withAlpha(13) : Colors.black.withAlpha(8),
            ),
            child: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 18,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: -0.3, end: 0, duration: 500.ms);
  }

  Widget _buildBranding(bool isDark) {
    return Column(
      children: [
        // Logo - Increased size from 80 to 120
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryCyan.withAlpha(64),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.school_rounded, color: Colors.white, size: 48),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(
                begin: const Offset(0.6, 0.6),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.easeOutBack),

        const SizedBox(height: 20),

        Text(
          'Academic X',
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            letterSpacing: -0.5,
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0, duration: 600.ms),

        const SizedBox(height: 8),

        Text(
          _strings['subtitle']!,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            letterSpacing: 1,
          ),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildAuthCard(bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isDark
                  ? Colors.white.withAlpha(8)
                  : Colors.black.withAlpha(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isLogin = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: _isLogin
                            ? (isDark
                                ? AppColors.primaryCyan.withAlpha(26)
                                : Colors.white)
                            : Colors.transparent,
                        boxShadow: _isLogin
                            ? [
                                BoxShadow(
                                  color: Colors.black.withAlpha(13),
                                  blurRadius: 8,
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _strings['signInTab']!,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight:
                                _isLogin ? FontWeight.w600 : FontWeight.w400,
                            color: _isLogin
                                ? AppColors.primaryCyan
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isLogin = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: !_isLogin
                            ? (isDark
                                ? AppColors.primaryCyan.withAlpha(26)
                                : Colors.white)
                            : Colors.transparent,
                        boxShadow: !_isLogin
                            ? [
                                BoxShadow(
                                  color: Colors.black.withAlpha(13),
                                  blurRadius: 8,
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _strings['registerTab']!,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight:
                                !_isLogin ? FontWeight.w600 : FontWeight.w400,
                            color: !_isLogin
                                ? AppColors.primaryCyan
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Name field (register only)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isLogin
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      _buildInputField(
                        controller: _nameCtl,
                        focusNode: _nameFocus,
                        hint: _strings['nameHint']!,
                        icon: Icons.person_outline_rounded,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        controller: _studentIdCtl,
                        focusNode: _studentIdFocus,
                        hint: 'Student ID',
                        icon: Icons.badge_outlined,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
          ),

          // Email
          _buildInputField(
            controller: _emailController,
            focusNode: _emailFocus,
            hint: _strings['emailHint']!,
            icon: Icons.email_outlined,
            isDark: isDark,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 16),

          // Password
          _buildInputField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            hint: _strings['passwordHint']!,
            icon: Icons.lock_outline_rounded,
            isDark: isDark,
            isPassword: true,
          ),

          const SizedBox(height: 12),

          // Remember me + Forgot password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() => _rememberMe = !_rememberMe),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _rememberMe
                            ? AppColors.primaryCyan
                            : Colors.transparent,
                        border: Border.all(
                          color: _rememberMe
                              ? AppColors.primaryCyan
                              : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                          width: 1.5,
                        ),
                      ),
                      child: _rememberMe
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _strings['rememberMe']!,
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
              GestureDetector(
                onTap: () {
                  // TODO_FORGOT_PASSWORD
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('TODO_FORGOT_PASSWORD',
                          style: GoogleFonts.outfit()),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: Text(
                  _strings['forgotPass']!,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryCyan,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Login / Register button
          GradientButton(
            label: _isLogin ? _strings['signInBtn']! : _strings['registerBtn']!,
            isLoading: _isLoading,
            onPressed: _handleAuth,
            icon: _isLogin ? Icons.login_rounded : Icons.person_add_rounded,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 700.ms)
        .slideY(begin: 0.15, end: 0, delay: 300.ms, duration: 700.ms);
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    required bool isDark,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, child) {
        final isFocused = focusNode.hasFocus;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primaryCyan.withAlpha(38),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: AnimatedScale(
            scale: isFocused ? 1.01 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: isPassword && _obscurePassword,
              keyboardType: keyboardType,
              style: GoogleFonts.outfit(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.outfit(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 14,
                ),
                prefixIcon: Icon(icon,
                    color: isFocused
                        ? AppColors.primaryCyan
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                    size: 20),
                suffixIcon: isPassword
                    ? GestureDetector(
                        onTap: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          size: 20,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: isDark
                    ? Colors.white.withAlpha(8)
                    : Colors.white.withAlpha(204),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOAuthSection(bool isDark) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _strings['oauthText']!,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            // Google
            Expanded(
              child: _OAuthButton(
                icon: Icons.g_mobiledata_rounded,
                label: 'Google',
                color: const Color(0xFFDB4437),
                isDark: isDark,
                onTap: _handleGoogleAuth,
              ),
            ),
            const SizedBox(width: 14),
            // GitHub
            Expanded(
              child: _OAuthButton(
                icon: Icons.code_rounded,
                label: 'GitHub',
                color: isDark ? Colors.white : const Color(0xFF24292E),
                isDark: isDark,
                onTap: _handleGithubAuth,
              ),
            ),
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 600.ms, duration: 600.ms);
  }

  Widget _buildToggleAuth(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? _strings['noAccount']! : _strings['hasAccount']!,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => setState(() => _isLogin = !_isLogin),
          child: Text(
            _isLogin ? _strings['registerTab']! : _strings['signInTab']!,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryCyan,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 800.ms, duration: 600.ms);
  }
}

class _OAuthButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _OAuthButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_OAuthButton> createState() => _OAuthButtonState();
}

class _OAuthButtonState extends State<_OAuthButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: widget.isDark
                ? Colors.white.withAlpha(10)
                : Colors.white,
            border: Border.all(
              color: widget.isDark
                  ? Colors.white.withAlpha(15)
                  : Colors.black.withAlpha(13),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(_pressed ? 5 : 10),
                blurRadius: _pressed ? 4 : 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.color, size: 22),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: widget.isDark
                      ? AppColors.darkText
                      : AppColors.lightText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
