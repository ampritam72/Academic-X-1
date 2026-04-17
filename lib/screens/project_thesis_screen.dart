import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';

class ProjectThesisScreen extends StatefulWidget {
  const ProjectThesisScreen({super.key});

  @override
  State<ProjectThesisScreen> createState() => _ProjectThesisScreenState();
}

class _ProjectThesisScreenState extends State<ProjectThesisScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _aiQueryController = TextEditingController();

  bool _isSearching = false;
  bool _hasSearched = false;

  final List<String> _filters = ['All', 'Machine Learning', 'NLP', 'Computer Vision', '2024+', 'Highly Relevant'];
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _aiQueryController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    setState(() {
      _isSearching = true;
      _hasSearched = false;
    });
    // TODO_PAPER_SEARCH_API
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _hasSearched = true;
        });
      }
    });
  }

  void _handleAiQuery() {
    // TODO_AI_QUERY
    AppUtils.showPremiumSnackBar(context, 'AI Query Sent! Finding literature gap...', color: AppColors.primaryCyan);
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
                  _buildProjectRoadmapTab(isDark),
                  _buildPaperFinderTab(isDark),
                  _buildBookmarksTab(isDark),
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
                colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
              ),
            ),
            child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Project & Thesis',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                Text('Roadmaps & Paper Finder',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    )),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTabBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
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
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppColors.primaryCyan,
          unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w400),
          tabs: const [
            Tab(text: 'Roadmap', height: 38),
            Tab(text: 'Papers', height: 38),
            Tab(text: 'Saved', height: 38),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectRoadmapTab(bool isDark) {
    final milestones = [
      _Milestone('Literature Review', 'Find and review 20 base papers', true, 'Mar 15'),
      _Milestone('Proposal Defense', 'Present model architecture', true, 'Apr 02'),
      _Milestone('Data Collection', 'Gather 50k annotated samples', false, 'May 10'),
      _Milestone('Model Training', 'Train baseline models and optimize', false, 'Jun 05'),
      _Milestone('Final Defense', 'Write thesis and present findings', false, 'Jul 20'),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        // AI Suggestion Box
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: AppColors.accentGradient,
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text('AI Project Suggestion',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      )),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Based on your interest in "Transformer Models", consider a thesis on:\n"Efficient Local Attention Mechanisms for Low-Resource Languages".',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  GradientButton(
                    label: 'Generate Plan',
                    icon: Icons.account_tree_rounded,
                    onPressed: () {
                      // TODO_PROJECT_SUGGESTION_API
                    },
                    colors: const [AppColors.accentPurple, AppColors.accentIndigo],
                  ),
                ],
              )
            ],
          ),
        ).animate().fadeIn(duration: 400.ms),

        const SizedBox(height: 24),
        Text('Current Project: NLP Transformers',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            )),
        const SizedBox(height: 16),

        // Timeline
        ...milestones.asMap().entries.map((entry) {
          int idx = entry.key;
          _Milestone m = entry.value;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: m.isCompleted ? AppColors.success : (isDark ? AppColors.darkCard : Colors.white),
                      border: Border.all(
                        color: m.isCompleted ? AppColors.success : AppColors.primaryCyan,
                        width: 2,
                      ),
                    ),
                    child: m.isCompleted ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
                  ),
                  if (idx < milestones.length - 1)
                    Container(
                      width: 2,
                      height: 50,
                      color: m.isCompleted ? AppColors.success : (isDark ? Colors.white.withAlpha(26) : Colors.black.withAlpha(26)),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(m.title,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: m.isCompleted
                                    ? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                                    : (isDark ? AppColors.darkText : AppColors.lightText),
                                decoration: m.isCompleted ? TextDecoration.lineThrough : null,
                              )),
                          Text(m.date,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              )),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(m.description,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: Duration(milliseconds: 300 + idx * 150)).slideY(begin: 0.2);
        }),
      ],
    );
  }

  Widget _buildPaperFinderTab(bool isDark) {
    final mockPapers = [
      _PaperContent(
          title: 'Attention Is All You Need',
          authors: 'Vaswani et al.',
          abstract: 'We propose a new simple network architecture, the Transformer, based solely on attention mechanisms, dispensing with recurrence and convolutions entirely. Experiments on two machine translation tasks show these models to be superior in quality while being more parallelizable.',
          year: '2017',
          journal: 'NeurIPS',
          isSaved: true),
      _PaperContent(
          title: 'BERT: Pre-training of Deep Bidirectional Transformers',
          authors: 'Devlin et al.',
          abstract: 'We introduce a new language representation model called BERT, which stands for Bidirectional Encoder Representations from Transformers. Unlike recent language representation models, BERT is designed to pre-train deep bidirectional representations.',
          year: '2019',
          journal: 'NAACL',
          isSaved: false),
    ];

    return Column(
      children: [
        // AI Query & Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            children: [
              // AI Query Box
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: isDark
                      ? LinearGradient(colors: [Colors.white.withAlpha(13), AppColors.accentPurple.withAlpha(20)])
                      : LinearGradient(colors: [AppColors.accentPurple.withAlpha(13), Colors.white]),
                  border: Border.all(color: AppColors.accentPurple.withAlpha(51)),
                ),
                child: TextField(
                  controller: _aiQueryController,
                  style: GoogleFonts.outfit(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Ask AI to find papers (e.g. "Papers about Vision Transformers")',
                    hintStyle: GoogleFonts.outfit(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: GestureDetector(
                      onTap: _handleAiQuery,
                      child: const Icon(Icons.auto_awesome_rounded, color: AppColors.accentPurple),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Standard Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(5),
                        border: Border.all(color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(10)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.outfit(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search title, authors...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          prefixIcon: Icon(Icons.search_rounded, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, size: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _handleSearch,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(colors: [AppColors.primaryCyan, AppColors.primaryBlue]),
                      ),
                      child: const Icon(Icons.manage_search_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Filter Chips
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filters.length,
            itemBuilder: (context, i) {
              final selected = i == _selectedFilter;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFilter = i),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: selected
                          ? const LinearGradient(colors: [AppColors.primaryCyan, AppColors.primaryBlue])
                          : null,
                      color: selected ? null : (isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8)),
                      border: Border.all(color: selected ? Colors.transparent : (isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(15))),
                    ),
                    child: Center(
                      child: Text(_filters[i],
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                            color: selected ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          )),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Results Area
        Expanded(
          child: _isSearching
              ? _buildSkeletonLoader(isDark)
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _hasSearched ? mockPapers.length : 0,
                  itemBuilder: (context, index) {
                    final p = mockPapers[index];
                    return _buildPaperCard(p, isDark, index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPaperCard(_PaperContent paper, bool isDark, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(paper.title,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      )),
                ),
                StatefulBuilder(builder: (context, setStateLocal) {
                  return GestureDetector(
                    onTap: () {
                      // TODO_BOOKMARK_OFFLINE
                      setStateLocal(() {
                        paper.isSaved = !paper.isSaved;
                      });
                      AppUtils.showPremiumSnackBar(
                        context,
                        paper.isSaved ? 'Paper saved offline!' : 'Paper removed.',
                        color: paper.isSaved ? AppColors.success : AppColors.primaryBlueprint,
                      );
                    },
                    child: Icon(
                      paper.isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                      color: paper.isSaved ? AppColors.primaryCyan : (isDark ? Colors.white.withAlpha(77) : Colors.black.withAlpha(77)),
                      size: 22,
                    ).animate(target: paper.isSaved ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 150.ms).then().scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1)),
                  );
                }),
              ],
            ),
            const SizedBox(height: 6),
            Text(paper.authors,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentPurple,
                )),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: isDark ? Colors.white.withAlpha(26) : Colors.black.withAlpha(26), borderRadius: BorderRadius.circular(4)),
                  child: Text(paper.year, style: GoogleFonts.outfit(fontSize: 10)),
                ),
                const SizedBox(width: 8),
                Text(paper.journal,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    )),
              ],
            ),
            const SizedBox(height: 12),
            Text('Abstract:',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                )),
            const SizedBox(height: 4),
            Text(paper.abstract,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  height: 1.4,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                )),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(colors: [AppColors.primaryCyan, AppColors.primaryBlue]),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text('PDF', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 300 + index * 100)).slideY(begin: 0.1);
  }

  Widget _buildSkeletonLoader(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: isDark ? AppColors.darkCard : const Color(0xFFE2E8F0),
            highlightColor: isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
            child: Container(
              height: 160,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookmarksTab(bool isDark) {
    return const PremiumEmptyState(
      icon: Icons.cloud_done_rounded,
      title: 'Offline Library',
      subtitle: 'Your saved papers will appear here.',
    ).animate().fadeIn(duration: 400.ms).scale();
  }
}

class _Milestone {
  final String title, description, date;
  final bool isCompleted;
  _Milestone(this.title, this.description, this.isCompleted, this.date);
}

class _PaperContent {
  final String title, authors, abstract, year, journal;
  bool isSaved;
  _PaperContent({
    required this.title,
    required this.authors,
    required this.abstract,
    required this.year,
    required this.journal,
    required this.isSaved,
  });
}
