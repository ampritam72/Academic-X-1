import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  Timer? _autoNavigateTimer;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Auto navigate after 3 seconds
    _autoNavigateTimer = Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _navigateToLogin();
      }
    });
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _autoNavigateTimer?.cancel();
    _gradientController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToLogin,
      child: Scaffold(
        body: Stack(
          children: [
            // Animated gradient background
            _AnimatedGradientBackground(controller: _gradientController),

            // Floating particles
            _FloatingParticles(controller: _particleController),

            // Subtle grid pattern overlay
            _GridOverlay(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with glow
                  _LogoWidget(pulseController: _pulseController),

                  const SizedBox(height: 28),

                  

                  // App name
                  Text(
                    'Academic X',
                    style: GoogleFonts.outfit(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                      shadows: [
                        Shadow(
                          color: AppColors.primaryCyan.withAlpha(128),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: const Duration(milliseconds: 500),
                        duration: const Duration(milliseconds: 800),
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        delay: const Duration(milliseconds: 500),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: 12),

                  // Motto
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.primaryCyan.withAlpha(51),
                      ),
                      color: Colors.white.withAlpha(13),
                    ),
                    child: Text(
                      'Your Smart AI Study Companion',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withAlpha(204),
                        letterSpacing: 2,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: const Duration(milliseconds: 1000),
                        duration: const Duration(milliseconds: 800),
                      )
                      .slideY(
                        begin: 0.5,
                        end: 0,
                        delay: const Duration(milliseconds: 1000),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: 80),

                  // Loading indicator
                  SizedBox(
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white.withAlpha(26),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryCyan.withAlpha(179),
                        ),
                        minHeight: 3,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: const Duration(milliseconds: 1500),
                        duration: const Duration(milliseconds: 600),
                      ),
                ],
              ),
            ),

            // Bottom text
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tap anywhere to continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.white.withAlpha(77),
                      letterSpacing: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '"Low CGPA can never stop the desire to grow or the passion to create something."',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withAlpha(220),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: const Duration(milliseconds: 400),
                        duration: const Duration(milliseconds: 900),
                      ),

                  const SizedBox(height: 10),

                  Text(
                    '— Abir Mahmud Pritam · Batch 32nd · Dept. of CSE, Varendra University',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      height: 1.4,
                      color: Colors.white.withAlpha(160),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: const Duration(milliseconds: 700),
                        duration: const Duration(milliseconds: 800),
                      ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Animated Gradient Background ─────────────────────────────────────────

class _AnimatedGradientBackground extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedGradientBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                Color(0xFF050B1F),
                Color(0xFF0A1628),
                Color(0xFF0D2847),
                Color(0xFF0A3D5C),
                Color(0xFF072B40),
              ],
              begin: Alignment(
                -1 + controller.value * 0.5,
                -1 + controller.value * 0.3,
              ),
              end: Alignment(
                1 - controller.value * 0.3,
                1 - controller.value * 0.2,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Floating Particles ───────────────────────────────────────────────────

class _FloatingParticles extends StatelessWidget {
  final AnimationController controller;

  const _FloatingParticles({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _ParticlePainter(controller.value),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  static final List<_Particle> particles = List.generate(
    30,
    (i) => _Particle(
      x: Random(i).nextDouble(),
      y: Random(i * 7).nextDouble(),
      radius: Random(i * 3).nextDouble() * 3 + 1,
      speed: Random(i * 5).nextDouble() * 0.5 + 0.2,
      opacity: Random(i * 11).nextDouble() * 0.3 + 0.1,
    ),
  );

  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final x = (p.x * size.width + progress * p.speed * size.width) %
          size.width;
      final y = (p.y * size.height - progress * p.speed * size.height * 0.5) %
          size.height;

      final paint = Paint()
        ..color = AppColors.primaryCyan.withAlpha((p.opacity * 255).toInt())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Particle {
  final double x, y, radius, speed, opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
  });
}

// ─── Grid Overlay ─────────────────────────────────────────────────────────

class _GridOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.03,
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: _GridPainter(),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Logo Widget ──────────────────────────────────────────────────────────

class _LogoWidget extends StatelessWidget {
  final AnimationController pulseController;

  const _LogoWidget({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final pulseValue = 0.95 + pulseController.value * 0.05;
        return Transform.scale(
          scale: pulseValue,
          child: child,
        );
      },
      child: Container(
        width: 210,
        height: 210,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryCyan.withAlpha(77),
              blurRadius: 48,
              spreadRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(105),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
               // Fallback if image not found
               return Container(
                 color: AppColors.primaryBlue,
                 child: const Icon(Icons.school_rounded, color: Colors.white, size: 40),
               );
            },
          ),
        ),
      )
          .animate()
          .fadeIn(duration: const Duration(milliseconds: 800))
          .scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1.0, 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
          ),
    );
  }
}
