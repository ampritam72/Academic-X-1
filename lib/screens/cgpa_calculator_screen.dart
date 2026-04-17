import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';
import '../providers/cgpa_provider.dart';

class CGPACalculatorScreen extends StatefulWidget {
  const CGPACalculatorScreen({super.key});

  @override
  State<CGPACalculatorScreen> createState() => _CGPACalculatorScreenState();
}

class _CGPACalculatorScreenState extends State<CGPACalculatorScreen> {
  // We will now group data dynamically from the provider
  List<_Semester> _getGroupedSemesters(CGPAProvider provider) {
    Map<String, List<_Course>> grouped = {};
    for (var g in provider.grades) {
      if (!grouped.containsKey(g.term)) grouped[g.term] = [];
      final name = g.courseName.isNotEmpty ? g.courseName : g.courseCode;
      grouped[g.term]!.add(_Course(g.courseCode, name, g.creditHours, _gradeFromPoint(g.gradePoint)));
    }
    return grouped.entries.map((e) => _Semester(e.key, e.value)).toList();
  }

  String _gradeFromPoint(double point) {
    if (point >= 4.0) return 'A+';
    if (point >= 3.75) return 'A';
    if (point >= 3.5) return 'A-';
    if (point >= 3.25) return 'B+';
    if (point >= 3.0) return 'B';
    if (point >= 2.75) return 'B-';
    if (point >= 2.5) return 'C+';
    if (point >= 2.25) return 'C';
    if (point >= 2.0) return 'D';
    return 'F';
  }

  bool _showWhatIf = false;
  double _animatedCGPA = 0;
  int _expandedSemester = -1;

  final _gradeMap = {
    'A+': 4.0, 'A': 3.75, 'A-': 3.5,
    'B+': 3.25, 'B': 3.0, 'B-': 2.75,
    'C+': 2.5, 'C': 2.25, 'D': 2.0,
    'F': 0.0,
  };

  double _totalCredits(List<_Semester> semesters) {
    return semesters.fold(0, (sum, sem) => sum + sem.courses.fold(0.0, (s, c) => s + c.credits));
  }

  List<double> _semesterGpasFrom(List<_Semester> semesters) {
    return semesters.map((sem) {
      double tp = 0, tc = 0;
      for (final c in sem.courses) {
        tp += (_gradeMap[c.grade] ?? 0) * c.credits;
        tc += c.credits;
      }
      return tc > 0 ? tp / tc : 0.0;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CGPAProvider>(context, listen: false).fetchGrades();
    });
  }

  void _animateCGPA(double target) {
    const steps = 50;
    for (int i = 0; i <= steps; i++) {
      Future.delayed(Duration(milliseconds: i * 20), () {
        if (mounted) setState(() => _animatedCGPA = target * (i / steps));
      });
    }
  }

  Color _gradeColor(String grade) {
    if (grade.startsWith('A')) return AppColors.success;
    if (grade.startsWith('B')) return AppColors.primaryCyan;
    if (grade.startsWith('C')) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cgpaProvider = Provider.of<CGPAProvider>(context);
    final semesters = _getGroupedSemesters(cgpaProvider);
    final chartGpas = _semesterGpasFrom(semesters);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(isDark)),
            SliverToBoxAdapter(child: _buildCGPAOverview(isDark, cgpaProvider, semesters)),
            SliverToBoxAdapter(child: _buildChart(isDark, chartGpas)),
            SliverToBoxAdapter(child: _buildAISuggestion(isDark)),
            SliverToBoxAdapter(
              child: SectionTitle(
                title: 'Semesters',
                actionText: _showWhatIf ? 'Normal' : 'What-If',
                onAction: () => setState(() => _showWhatIf = !_showWhatIf),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _buildSemesterCard(i, semesters, isDark),
                childCount: semesters.length,
              ),
            ),
            SliverToBoxAdapter(child: _buildAddSemester(isDark)),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
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
                colors: [AppColors.primaryTeal, AppColors.secondaryEmerald],
              ),
            ),
            child: const Icon(Icons.calculate_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CGPA Calculator',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                Text('Track and simulate your grades',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    )),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              AppUtils.showPremiumSnackBar(context, 'TODO_EXPORT_CGPA_REPORT');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8),
              ),
              child: const Icon(Icons.download_rounded, size: 20),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildCGPAOverview(bool isDark, CGPAProvider provider, List<_Semester> semesters) {
    if (_animatedCGPA == 0 && provider.overallCGPA > 0) {
      _animateCGPA(provider.overallCGPA);
    }
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            // CGPA display
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current CGPA',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    _animatedCGPA.toStringAsFixed(2),
                    style: GoogleFonts.outfit(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.success.withAlpha(26),
                    ),
                    child: Text(
                      'Dean\'s List ⭐',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Summary stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _statItem('Semesters', '${semesters.length}', isDark),
                const SizedBox(height: 8),
                _statItem('Credits', '${_totalCredits(semesters).toInt()}', isDark),
                const SizedBox(height: 8),
                _statItem('Courses', '${provider.grades.length}', isDark),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideY(begin: 0.1, delay: 200.ms, duration: 600.ms);
  }

  Widget _statItem(String label, String value, bool isDark) {
    return Row(
      children: [
        Text(label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            )),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8),
          ),
          child: Text(value,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              )),
        ),
      ],
    );
  }

  Widget _buildChart(bool isDark, List<double> gpas) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GPA Trend',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                )),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 4.0,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (val, meta) => Text(
                          val.toInt().toString(),
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, meta) => Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'S${val.toInt() + 1}',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (val) => FlLine(
                      color: isDark
                          ? Colors.white.withAlpha(8)
                          : Colors.black.withAlpha(8),
                      strokeWidth: 1,
                    ),
                  ),
                  barGroups: List.generate(gpas.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: gpas[i],
                          width: 24,
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryCyan,
                              AppColors.primaryTeal.withAlpha(179),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                duration: const Duration(milliseconds: 1200),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 600.ms);
  }

  Widget _buildAISuggestion(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: AppColors.accentGradient,
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Target Grade',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      )),
                  const SizedBox(height: 3),
                  Text(
                    'To reach 3.80 CGPA, aim for A- average next semester',
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
        .fadeIn(delay: 600.ms, duration: 500.ms)
        .slideX(begin: 0.05, delay: 600.ms, duration: 500.ms);
  }

  Widget _buildSemesterCard(int index, List<_Semester> semesters, bool isDark) {
    final sem = semesters[index];
    final expanded = _expandedSemester == index;
    
    double tp = 0, tc = 0;
    for (final c in sem.courses) {
      tp += (_gradeMap[c.grade] ?? 0) * c.credits;
      tc += c.credits;
    }
    final gpa = tc > 0 ? tp / tc : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        onTap: () {
          setState(() {
            _expandedSemester = expanded ? -1 : index;
          });
        },
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryCyan.withAlpha(20),
                  ),
                  child: Center(
                    child: Text('S${index + 1}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryCyan,
                        )),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sem.name,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          )),
                      Text('${sem.courses.length} courses',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
                Text(gpa.toStringAsFixed(2),
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: gpa >= 3.5
                          ? AppColors.success
                          : gpa >= 3.0
                              ? AppColors.primaryCyan
                              : AppColors.warning,
                    )),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: 250.ms,
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                ),
              ],
            ),
            AnimatedSize(
              duration: 300.ms,
              curve: Curves.easeInOut,
              child: expanded
                  ? Column(
                      children: [
                        const SizedBox(height: 12),
                        Divider(
                          color: isDark
                              ? Colors.white.withAlpha(10)
                              : Colors.black.withAlpha(10),
                        ),
                        const SizedBox(height: 8),
                        ...sem.courses.map((c) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(c.code,
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextSecondary,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(c.name,
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          color: isDark
                                              ? AppColors.darkText
                                              : AppColors.lightText,
                                        )),
                                  ),
                                  Text('${c.credits.toInt()} cr',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      )),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: _gradeColor(c.grade).withAlpha(20),
                                    ),
                                    child: Text(c.grade,
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: _gradeColor(c.grade),
                                        )),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 700 + index * 100),
          duration: 400.ms,
        )
        .slideY(
          begin: 0.05,
          delay: Duration(milliseconds: 700 + index * 100),
          duration: 400.ms,
        );
  }

  Widget _buildAddSemester(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _showAddCourseSheet(isDark),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryCyan.withAlpha(51),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, color: AppColors.primaryCyan, size: 20),
              const SizedBox(width: 8),
              Text('Add course (up to 8 semesters)',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryCyan,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCourseSheet(bool isDark) {
    int semester = 1;
    final nameCtl = TextEditingController();
    final codeCtl = TextEditingController();
    final creditCtl = TextEditingController(text: '3');
    String gradeKey = 'A';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Add course result',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          )),
                      const SizedBox(height: 16),
                      Text('Semester (1–8)',
                          style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: semester.toDouble(),
                              min: 1,
                              max: 8,
                              divisions: 7,
                              label: 'Semester $semester',
                              activeColor: AppColors.primaryCyan,
                              onChanged: (v) =>
                                  setModal(() => semester = v.round()),
                            ),
                          ),
                          Text('S$semester',
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryCyan)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameCtl,
                        decoration: InputDecoration(
                          labelText: 'Course name',
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withAlpha(13)
                              : Colors.black.withAlpha(8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: codeCtl,
                        decoration: InputDecoration(
                          labelText: 'Course code',
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withAlpha(13)
                              : Colors.black.withAlpha(8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: creditCtl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Credit hours',
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withAlpha(13)
                              : Colors.black.withAlpha(8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Grade / result',
                          style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _gradeMap.keys.map((k) {
                          final sel = gradeKey == k;
                          return ChoiceChip(
                            label: Text(k),
                            selected: sel,
                            onSelected: (_) =>
                                setModal(() => gradeKey = k),
                            selectedColor: AppColors.primaryCyan.withAlpha(60),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        label: 'Save course',
                        icon: Icons.check_rounded,
                        onPressed: () async {
                          final name = nameCtl.text.trim();
                          final code = codeCtl.text.trim();
                          final cr =
                              double.tryParse(creditCtl.text.trim()) ?? 0;
                          if (name.isEmpty || code.isEmpty || cr <= 0) {
                            AppUtils.showPremiumSnackBar(
                                context, 'Fill course name, code & credits');
                            return;
                          }
                          final gp = _gradeMap[gradeKey] ?? 0;
                          await Provider.of<CGPAProvider>(context,
                                  listen: false)
                              .addCourseToSemester(
                            semesterNumber: semester,
                            courseName: name,
                            courseCode: code,
                            creditHours: cr,
                            gradePoint: gp,
                          );
                          if (context.mounted) Navigator.pop(context);
                          if (mounted) setState(() {});
                        },
                        colors: const [
                          AppColors.primaryTeal,
                          AppColors.secondaryEmerald
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Semester {
  final String name;
  final List<_Course> courses;
  _Semester(this.name, this.courses);
}

class _Course {
  final String code, name;
  final double credits;
  String grade;
  _Course(this.code, this.name, this.credits, this.grade);
}
