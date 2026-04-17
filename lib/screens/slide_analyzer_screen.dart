import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/settings_provider.dart';
import '../widgets/shared_widgets.dart';

class SlideAnalyzerScreen extends StatefulWidget {
  /// When opened from Dashboard quick access, show back and return to dashboard.
  final bool showBackToDashboard;

  const SlideAnalyzerScreen({super.key, this.showBackToDashboard = false});

  @override
  State<SlideAnalyzerScreen> createState() => _SlideAnalyzerScreenState();
}

class _SlideAnalyzerScreenState extends State<SlideAnalyzerScreen> {
  bool _isUploaded = false;
  bool _isProcessing = false;
  bool _hasResults = false;
  bool _showMindMap = false;
  String? _uploadedFileName;
  final List<bool> _expandedNotes = [true, false, false, false];

  void _handleUpload() {
    // TODO_PDF_ANALYZER_API
    setState(() {
      _isUploaded = true;
      _isProcessing = true;
      _uploadedFileName = 'Data_Structures_Ch5.pdf';
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _hasResults = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(child: _buildHeader(isDark)),

            // Upload Section
            if (!_hasResults)
              SliverToBoxAdapter(child: _buildUploadSection(isDark)),

            // Processing
            if (_isProcessing)
              SliverToBoxAdapter(child: _buildProcessing(isDark)),

            // Results
            if (_hasResults) ...[
              SliverToBoxAdapter(child: _buildActionBar(isDark)),
              SliverToBoxAdapter(
                child: _showMindMap
                    ? _buildMindMap(isDark)
                    : _buildNotes(isDark),
              ),
            ],

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final canPop = Navigator.of(context).canPop();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          if (canPop) ...[
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
                colors: [AppColors.primaryBlue, AppColors.primaryCyan],
              ),
            ),
            child: const Icon(Icons.auto_stories_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Slide Analyzer',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                Text('AI-powered notes from your slides',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    )),
              ],
            ),
          ),
          if (_hasResults)
            IconButton(
              onPressed: () {
                setState(() {
                  _isUploaded = false;
                  _isProcessing = false;
                  _hasResults = false;
                });
              },
              icon: Icon(Icons.refresh_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, duration: 400.ms);
  }

  Widget _buildUploadSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: _isProcessing ? null : _handleUpload,
        child: AnimatedContainer(
          duration: 300.ms,
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? Colors.white.withAlpha(5) : Colors.white.withAlpha(128),
            border: Border.all(
              color: _isUploaded
                  ? AppColors.primaryCyan.withAlpha(77)
                  : (isDark
                      ? Colors.white.withAlpha(15)
                      : AppColors.primaryCyan.withAlpha(38)),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryCyan.withAlpha(_isUploaded ? 15 : 0),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: _isUploaded
              ? _buildUploadedState(isDark)
              : _buildEmptyUpload(isDark),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 500.ms)
        .slideY(begin: 0.1, delay: 200.ms, duration: 500.ms);
  }

  Widget _buildEmptyUpload(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryCyan.withAlpha(20),
          ),
          child: Icon(Icons.cloud_upload_rounded,
              size: 40, color: AppColors.primaryCyan.withAlpha(179)),
        ),
        const SizedBox(height: 16),
        Text('Drop your slides here',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            )),
        const SizedBox(height: 6),
        Text('Supports PDF, PNG, JPG',
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            )),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.primaryCyan],
            ),
          ),
          child: Text('Browse Files',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  Widget _buildUploadedState(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.description_rounded,
            size: 48, color: AppColors.primaryCyan),
        const SizedBox(height: 12),
        Text(_uploadedFileName ?? '',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            )),
        const SizedBox(height: 6),
        Text('2.4 MB • Ready to analyze',
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppColors.success,
            )),
      ],
    );
  }

  Widget _buildProcessing(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              backgroundColor: isDark
                  ? Colors.white.withAlpha(10)
                  : AppColors.primaryCyan.withAlpha(26),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryCyan),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 24),
          // Skeleton cards
          ...List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Shimmer.fromColors(
                baseColor: isDark
                    ? AppColors.darkCard
                    : const Color(0xFFE2E8F0),
                highlightColor: isDark
                    ? AppColors.darkSurface
                    : const Color(0xFFF1F5F9),
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
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildActionBar(bool isDark) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isBangla = settingsProvider.isBangla;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          // Translation toggle
          GestureDetector(
            onTap: () => settingsProvider.toggleLanguage(!isBangla),
            child: AnimatedContainer(
              duration: 250.ms,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isBangla
                    ? AppColors.primaryCyan.withAlpha(26)
                    : (isDark
                        ? Colors.white.withAlpha(8)
                        : Colors.black.withAlpha(8)),
                border: Border.all(
                  color: isBangla
                      ? AppColors.primaryCyan.withAlpha(77)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.translate_rounded,
                      size: 16,
                      color: isBangla
                          ? AppColors.primaryCyan
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary)),
                  const SizedBox(width: 6),
                  Text(isBangla ? 'বাংলা' : 'English',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isBangla
                            ? AppColors.primaryCyan
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Mind Map toggle
          GestureDetector(
            onTap: () => setState(() => _showMindMap = !_showMindMap),
            child: AnimatedContainer(
              duration: 250.ms,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _showMindMap
                    ? AppColors.accentPurple.withAlpha(26)
                    : (isDark
                        ? Colors.white.withAlpha(8)
                        : Colors.black.withAlpha(8)),
                border: Border.all(
                  color: _showMindMap
                      ? AppColors.accentPurple.withAlpha(77)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.hub_rounded,
                      size: 16,
                      color: _showMindMap
                          ? AppColors.accentPurple
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary)),
                  const SizedBox(width: 6),
                  Text('Mind Map',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Export
          GestureDetector(
            onTap: () {
              AppUtils.showPremiumSnackBar(context, 'TODO_EXPORT_PDF');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isDark
                    ? Colors.white.withAlpha(8)
                    : Colors.black.withAlpha(8),
              ),
              child: Icon(Icons.download_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildNotes(bool isDark) {
    final notes = [
      _Note('Binary Search Trees', 'A BST is a node-based binary tree where each node has a comparable key and satisfies the property that the key in each node must be greater than all keys stored in the left sub-tree, and smaller than all keys in the right sub-tree.', ['Self-balancing', 'O(log n) average', 'In-order traversal gives sorted'], true),
      _Note('Tree Traversals', 'There are three main types of tree traversal: In-order (Left, Root, Right), Pre-order (Root, Left, Right), and Post-order (Left, Right, Root).', ['DFS-based', 'Recursive or iterative', 'Time: O(n)'], false),
      _Note('AVL Trees', 'AVL tree is a self-balancing BST where the difference between heights of left and right subtrees cannot be more than one for all nodes.', ['Balance factor: -1, 0, 1', 'Rotations: LL, RR, LR, RL', 'Height: O(log n)'], false),
      _Note('Red-Black Trees', 'A Red-Black tree is a kind of self-balancing BST. Each node has an extra bit for color (red or black) used to ensure the tree remains balanced during insertions and deletions.', ['Root is always black', 'No two adjacent red nodes', 'Used in Java TreeMap'], false),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(notes.length, (i) {
          final note = notes[i];
          final expanded = _expandedNotes[i];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              onTap: () {
                setState(() => _expandedNotes[i] = !_expandedNotes[i]);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryCyan,
                              AppColors.primaryCyan.withAlpha(77),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          note.title,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: 250.ms,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                    child: expanded
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              Text(
                                note.content,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  height: 1.6,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: note.keyPoints.map((kp) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(8),
                                      color: AppColors.primaryCyan
                                          .withAlpha(20),
                                    ),
                                    child: Text(kp,
                                        style: GoogleFonts.outfit(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryCyan,
                                        )),
                                  );
                                }).toList(),
                              ),
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
                delay: Duration(milliseconds: 300 + i * 120),
                duration: 500.ms,
              )
              .slideY(
                begin: 0.1,
                delay: Duration(milliseconds: 300 + i * 120),
                duration: 500.ms,
              );
        }),
      ),
    );
  }

  Widget _buildMindMap(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.hub_rounded,
                size: 64, color: AppColors.accentPurple.withAlpha(179)),
            const SizedBox(height: 16),
            Text('Mind Map View',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                )),
            const SizedBox(height: 8),
            Text('Interactive mind map visualization\nTODO_MINDMAP_API',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                )),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95), duration: 500.ms);
  }
}

class _Note {
  final String title, content;
  final List<String> keyPoints;
  final bool initialExpanded;
  _Note(this.title, this.content, this.keyPoints, this.initialExpanded);
}
