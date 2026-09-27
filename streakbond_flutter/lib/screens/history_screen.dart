import 'package:flutter/material.dart';
import 'package:streakbond_client/streakbond_client.dart';
import '../client.dart';
import '../theme/streak_colors.dart';
import '../theme/streak_text_styles.dart';
import '../widgets/glassmorphism_card.dart';
import '../widgets/scanline_background.dart';
import '../widgets/skeleton_loader.dart';

class HistoryScreen extends StatefulWidget {
  final int pactId;
  final String pactTitle;

  const HistoryScreen({
    super.key,
    required this.pactId,
    required this.pactTitle,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<CheckIn>? _history;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final checkIns = await client.pact.getCheckInHistory(widget.pactId);
      if (mounted) {
        setState(() {
          _history = checkIns;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreakColors.background,
      appBar: AppBar(
        title: Text(
          'HISTORY HEATMAP',
          style: StreakTextStyles.displayMedium.copyWith(
            fontSize: 18,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: ScanlineBackground(
        child: _isLoading ? _buildLoading() : _buildContent(),
      ),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          SkeletonLoader(height: 180),
          SizedBox(height: 24),
          SkeletonLoader(height: 120),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Generate the last 35 days (5 weeks)
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final days = List.generate(
      35,
      (index) => today.subtract(Duration(days: 34 - index)),
    );

    // Group check-ins by day
    final Map<String, int> checkInCountPerDay = {};
    if (_history != null) {
      for (final checkIn in _history!) {
        checkInCountPerDay[checkIn.day] =
            (checkInCountPerDay[checkIn.day] ?? 0) + 1;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.pactTitle.toUpperCase(),
            style: StreakTextStyles.displayMedium.copyWith(
              fontSize: 20,
              color: StreakColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'LAST 5 WEEKS COMMITMENT ARCHIVE',
            style: StreakTextStyles.labelSmall.copyWith(
              color: StreakColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Heatmap Matrix
          GlassmorphismCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final day = days[index];
                    final dateKey =
                        '${day.year.toString().padLeft(4, '0')}-'
                        '${day.month.toString().padLeft(2, '0')}-'
                        '${day.day.toString().padLeft(2, '0')}';
                    final count = checkInCountPerDay[dateKey] ?? 0;

                    Color cellColor;
                    Border? border;

                    if (count >= 2) {
                      cellColor = StreakColors.success;
                    } else if (count == 1) {
                      cellColor = StreakColors.accent;
                    } else {
                      cellColor = StreakColors.surface;
                      border = Border.all(color: StreakColors.glassBorder);
                    }

                    final isToday = day.isAtSameMomentAs(today);

                    return Tooltip(
                      message: '$dateKey: $count/2 checked in',
                      child: Container(
                        decoration: BoxDecoration(
                          color: cellColor.withValues(
                            alpha: count > 0 ? 0.8 : 0.3,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          border: isToday
                              ? Border.all(
                                  color: StreakColors.primary,
                                  width: 2,
                                )
                              : border,
                          boxShadow: count >= 2
                              ? [
                                  BoxShadow(
                                    color: StreakColors.success.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 6,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: count > 0
                                  ? StreakColors.background
                                  : StreakColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Divider(color: StreakColors.glassBorder),
                const SizedBox(height: 8),

                // Heatmap Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendItem(StreakColors.success, 'Both (2/2)'),
                    _buildLegendItem(StreakColors.accent, 'Solo (1/2)'),
                    _buildLegendItem(StreakColors.surface, 'Missed (0/2)'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Total Stats
          GlassmorphismCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('TOTAL CHECK-INS', '${_history?.length ?? 0}'),
                Container(
                  height: 36,
                  width: 1,
                  color: StreakColors.glassBorder,
                ),
                _buildStatItem(
                  'PERFECT DAYS',
                  '${checkInCountPerDay.values.where((c) => c >= 2).length}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: StreakColors.glassBorder),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: StreakTextStyles.labelSmall.copyWith(fontSize: 11)),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: StreakTextStyles.displayMedium.copyWith(
            fontSize: 24,
            color: StreakColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: StreakTextStyles.labelSmall.copyWith(
            color: StreakColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
