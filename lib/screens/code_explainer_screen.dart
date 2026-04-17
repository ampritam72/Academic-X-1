import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';

class CodeExplainerScreen extends StatefulWidget {
  const CodeExplainerScreen({super.key});

  @override
  State<CodeExplainerScreen> createState() => _CodeExplainerScreenState();
}

class _CodeExplainerScreenState extends State<CodeExplainerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _codeController = TextEditingController();
  String _selectedLang = 'Python';
  bool _isProcessing = false;
  bool _hasResult = false;

  final _languages = ['C', 'C++', 'Java', 'Python', 'JavaScript'];

  final _sampleCode = '''def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1''';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _codeController.text = _sampleCode;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _handleExplain() {
    // TODO_CODE_EXPLAINER_API
    setState(() {
      _isProcessing = true;
      _hasResult = false;
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _hasResult = true;
          _tabController.animateTo(1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildLanguageSelector(isDark),
            _buildTabBar(isDark),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCodeTab(isDark),
                  _buildExplanationTab(isDark),
                  _buildFlowchartTab(isDark),
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
                colors: [AppColors.accentPurple, AppColors.accentIndigo],
              ),
            ),
            child: const Icon(Icons.code_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Code Explainer',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                Text('Paste code → Get explanation + flowchart',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
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

  Widget _buildLanguageSelector(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _languages.length,
          itemBuilder: (context, i) {
            final lang = _languages[i];
            final selected = lang == _selectedLang;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedLang = lang),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: selected
                        ? const LinearGradient(
                            colors: [AppColors.accentPurple, AppColors.accentIndigo])
                        : null,
                    color: selected
                        ? null
                        : (isDark
                            ? Colors.white.withAlpha(8)
                            : Colors.black.withAlpha(8)),
                    border: Border.all(
                      color: selected
                          ? Colors.transparent
                          : (isDark
                              ? Colors.white.withAlpha(10)
                              : Colors.black.withAlpha(10)),
                    ),
                  ),
                  child: Center(
                    child: Text(lang,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected
                              ? Colors.white
                              : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                        )),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildTabBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 4),
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
          labelColor: AppColors.primaryCyan,
          unselectedLabelColor: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w400),
          tabs: const [
            Tab(text: 'Code', height: 38),
            Tab(text: 'Explanation', height: 38),
            Tab(text: 'Flowchart', height: 38),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildCodeTab(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark
                    ? const Color(0xFF0D1117)
                    : const Color(0xFFF6F8FA),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withAlpha(10)
                      : Colors.black.withAlpha(8),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: TextField(
                  controller: _codeController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: GoogleFonts.firaCode(
                    fontSize: 13,
                    color: isDark ? const Color(0xFFE6EDF3) : const Color(0xFF24292E),
                    height: 1.6,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Paste your code here...',
                    hintStyle: GoogleFonts.firaCode(
                      fontSize: 13,
                      color: isDark
                          ? Colors.white.withAlpha(51)
                          : Colors.black.withAlpha(51),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  label: _isProcessing ? 'Analyzing...' : 'Explain Code',
                  icon: Icons.auto_awesome_rounded,
                  isLoading: _isProcessing,
                  onPressed: _isProcessing ? null : _handleExplain,
                  colors: [AppColors.accentPurple, AppColors.accentIndigo],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  _codeController.clear();
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: isDark
                        ? Colors.white.withAlpha(8)
                        : Colors.black.withAlpha(8),
                  ),
                  child: Icon(Icons.delete_outline_rounded,
                      color: AppColors.error, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationTab(bool isDark) {
    if (_isProcessing) {
      return _buildSkeletonList(isDark);
    }

    if (!_hasResult) {
      return const PremiumEmptyState(
        icon: Icons.lightbulb_outline_rounded,
        title: 'Ready',
        subtitle: 'Run the code explainer to see results',
      );
    }

    final explanations = [
      _Explanation('Function Definition', 'Defines a function `binary_search` that takes a sorted array and a target value to search for.',
          Icons.functions_rounded, AppColors.primaryCyan),
      _Explanation('Initialization', 'Sets two pointers: `left` at the beginning (0) and `right` at the end of the array.',
          Icons.start_rounded, AppColors.accentPurple),
      _Explanation('While Loop', 'Continues searching as long as the search space is valid (left ≤ right).',
          Icons.loop_rounded, AppColors.warning),
      _Explanation('Middle Calculation', 'Calculates the middle index to compare with the target. Uses integer division to avoid overflow.',
          Icons.calculate_rounded, AppColors.primaryTeal),
      _Explanation('Comparison Logic', 'If middle element equals target → found! If less → search right half. If greater → search left half.',
          Icons.compare_arrows_rounded, AppColors.secondaryEmerald),
      _Explanation('Time Complexity', 'O(log n) — halves the search space each iteration. Space: O(1) — uses constant extra space.',
          Icons.speed_rounded, AppColors.error),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: explanations.length,
      itemBuilder: (context, i) {
        final e = explanations[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: e.color.withAlpha(26),
                  ),
                  child: Icon(e.icon, color: e.color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.title,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          )),
                      const SizedBox(height: 6),
                      Text(e.description,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            height: 1.5,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: 200 + i * 100),
              duration: 500.ms,
            )
            .slideX(
              begin: 0.05,
              delay: Duration(milliseconds: 200 + i * 100),
              duration: 500.ms,
            );
      },
    );
  }

  Widget _buildFlowchartTab(bool isDark) {
    if (!_hasResult) {
      return const PremiumEmptyState(
        icon: Icons.account_tree_rounded,
        title: 'Awaiting Code',
        subtitle: 'Flowchart will appear after code analysis',
      );
    }

    // TODO_FLOWCHART_API — Show a visual placeholder
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple visual flowchart representation
            _flowchartNode('Start', AppColors.primaryCyan, isDark),
            _flowchartArrow(isDark),
            _flowchartNode('Set left=0, right=n-1', AppColors.accentPurple, isDark),
            _flowchartArrow(isDark),
            _flowchartNode('left ≤ right?', AppColors.warning, isDark, isDiamond: true),
            _flowchartArrow(isDark),
            _flowchartNode('Calculate mid', AppColors.primaryTeal, isDark),
            _flowchartArrow(isDark),
            _flowchartNode('arr[mid] == target?', AppColors.warning, isDark, isDiamond: true),
            _flowchartArrow(isDark),
            _flowchartNode('Return mid / Adjust bounds', AppColors.secondaryEmerald, isDark),
            _flowchartArrow(isDark),
            _flowchartNode('End / Return -1', AppColors.error, isDark),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                AppUtils.showPremiumSnackBar(context, 'TODO_EXPORT_CODE_NOTES');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [AppColors.accentPurple, AppColors.accentIndigo],
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text('Export Flowchart',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildSkeletonList(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: List.generate(
          4,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Shimmer.fromColors(
              baseColor: isDark ? AppColors.darkCard : const Color(0xFFE2E8F0),
              highlightColor:
                  isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}

class _Explanation {
  final String title, description;
  final IconData icon;
  final Color color;
  _Explanation(this.title, this.description, this.icon, this.color);
}

Widget _flowchartNode(String label, Color color, bool isDark,
    {bool isDiamond = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(isDiamond ? 4 : 12),
      color: color.withAlpha(20),
      border: Border.all(color: color.withAlpha(77)),
    ),
    child: Text(label,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        )),
  )
      .animate()
      .fadeIn(duration: 400.ms)
      .scale(begin: const Offset(0.9, 0.9), duration: 400.ms);
}

Widget _flowchartArrow(bool isDark) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Icon(Icons.arrow_downward_rounded,
        size: 18,
        color: isDark ? Colors.white.withAlpha(38) : Colors.black.withAlpha(38)),
  );
}
