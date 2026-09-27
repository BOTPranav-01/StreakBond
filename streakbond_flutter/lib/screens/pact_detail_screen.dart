import 'dart:async';
import 'package:flutter/material.dart';
import 'package:streakbond_client/streakbond_client.dart';
import '../client.dart';
import '../services/stream_service.dart';
import '../theme/streak_colors.dart';
import '../theme/streak_text_styles.dart';
import '../widgets/check_in_button.dart';
import '../widgets/countdown_ring.dart';
import '../widgets/flame_icon.dart';
import '../widgets/glassmorphism_card.dart';
import '../widgets/glitch_overlay.dart';
import '../widgets/partner_status_dot.dart';
import '../widgets/scanline_background.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/streak_counter.dart';
import 'history_screen.dart';

class PactDetailScreen extends StatefulWidget {
  final int pactId;
  const PactDetailScreen({super.key, required this.pactId});

  @override
  State<PactDetailScreen> createState() => _PactDetailScreenState();
}

class _PactDetailScreenState extends State<PactDetailScreen> {
  Pact? _pact;
  bool _isLoading = true;
  bool _hasCheckedInToday = false;
  int _todayCheckInCount = 0;
  bool _triggerGlitch = false;
  StreamSubscription<PactEvent>? _eventSubscription;
  Timer? _countdownTimer;

  // Countdown calculations
  double _windowProgress = 0.0;
  String _timeRemaining = '--:--';
  bool _isWithinWindow = true;

  @override
  void initState() {
    super.initState();
    _loadPactData();
    _setupRealtime();
    _startCountdown();
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _setupRealtime() {
    _eventSubscription = StreamService.instance.events.listen((event) {
      if (event.pactId == widget.pactId && mounted) {
        if (event.eventType == 'streakLost') {
          setState(() {
            _triggerGlitch = true;
          });
          Future.delayed(const Duration(milliseconds: 900), () {
            if (mounted) setState(() => _triggerGlitch = false);
          });
        }
        _loadPactData(silent: true);
      }
    });
  }

  void _startCountdown() {
    _updateWindowCalculations();
    _countdownTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() {
          _updateWindowCalculations();
        });
      }
    });
  }

  void _updateWindowCalculations() {
    if (_pact == null) return;
    final now = DateTime.now().toUtc();
    final startParts = _pact!.checkInWindowStartUtc.split(':').map(int.parse).toList();
    final endParts = _pact!.checkInWindowEndUtc.split(':').map(int.parse).toList();

    final startTime = DateTime.utc(now.year, now.month, now.day, startParts[0], startParts[1]);
    final endTime = DateTime.utc(now.year, now.month, now.day, endParts[0], endParts[1]);

    if (now.isBefore(startTime)) {
      _isWithinWindow = false;
      final diff = startTime.difference(now);
      _timeRemaining = 'Opens ${diff.inHours}h ${diff.inMinutes % 60}m';
      _windowProgress = 0.0;
    } else if (now.isAfter(endTime)) {
      _isWithinWindow = false;
      _timeRemaining = 'Closed';
      _windowProgress = 1.0;
    } else {
      _isWithinWindow = true;
      final totalDuration = endTime.difference(startTime).inSeconds;
      final elapsed = now.difference(startTime).inSeconds;
      _windowProgress = (elapsed / totalDuration).clamp(0.0, 1.0);
      final remaining = endTime.difference(now);
      _timeRemaining = '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    }
  }

  Future<void> _loadPactData({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);

    try {
      final pacts = await client.pact.getMyPacts();
      final currentPact = pacts.firstWhere((p) => p.id == widget.pactId);
      final hasCheckedIn = await client.pact.hasCheckedInToday(widget.pactId);
      final count = await client.pact.getTodayCheckInCount(widget.pactId);

      if (mounted) {
        setState(() {
          _pact = currentPact;
          _hasCheckedInToday = hasCheckedIn;
          _todayCheckInCount = count;
          _isLoading = false;
          _updateWindowCalculations();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleCheckIn() async {
    try {
      final success = await client.pact.checkIn(widget.pactId);
      if (success) {
        await _loadPactData(silent: true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('CHECK-IN CONFIRMED. DISCIPLINE LOGGED.'),
              backgroundColor: StreakColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Check-in failed: $e'), backgroundColor: StreakColors.danger),
        );
      }
    }
  }

  Future<void> _breakPact() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: StreakColors.surface,
        title: Text('TERMINATE BOND?', style: StreakTextStyles.displayMedium.copyWith(color: StreakColors.danger)),
        content: Text(
          'This will permanently break the accountability pact and reset all streaks.',
          style: StreakTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: StreakColors.danger),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('TERMINATE'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await client.pact.breakPact(widget.pactId);
        if (mounted) Navigator.of(context).pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: $e'), backgroundColor: StreakColors.danger),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlitchOverlay(
      show: _triggerGlitch,
      child: Scaffold(
        backgroundColor: StreakColors.background,
        appBar: AppBar(
          title: Text(
            _pact?.title.toUpperCase() ?? 'PACT DETAIL',
            style: StreakTextStyles.displayMedium.copyWith(fontSize: 18, letterSpacing: 1.5),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month, color: StreakColors.primary),
              tooltip: 'Heatmap History',
              onPressed: () {
                if (_pact != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HistoryScreen(pactId: _pact!.id!, pactTitle: _pact!.title),
                    ),
                  );
                }
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: StreakColors.textSecondary),
              color: StreakColors.surface,
              onSelected: (val) {
                if (val == 'break') _breakPact();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'break',
                  child: Row(
                    children: [
                      Icon(Icons.link_off, color: StreakColors.danger, size: 20),
                      SizedBox(width: 8),
                      Text('Break Pact', style: TextStyle(color: StreakColors.danger)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: ScanlineBackground(
          child: _isLoading ? _buildLoading() : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          SkeletonLoader(height: 200),
          SizedBox(height: 24),
          SkeletonLoader(height: 80),
          SizedBox(height: 24),
          SkeletonLoader(height: 64),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_pact == null) {
      return const Center(child: Text('Pact not found.'));
    }

    final partnerCheckedIn = _todayCheckInCount == 2 || (!_hasCheckedInToday && _todayCheckInCount == 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Best Streak Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: StreakColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: StreakColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, size: 16, color: StreakColors.accent),
                const SizedBox(width: 6),
                Text(
                  'BEST: ${_pact!.bestStreak} DAYS',
                  style: StreakTextStyles.labelSmall.copyWith(
                    color: StreakColors.accent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Giant Streak Hero Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlameIcon(streak: _pact!.streak, baseSize: 42),
              const SizedBox(width: 12),
              StreakCounter(
                streak: _pact!.streak,
                color: _pact!.streak > 0 ? StreakColors.primary : StreakColors.textSecondary,
              ),
            ],
          ),
          Text(
            'DAY STREAK',
            style: StreakTextStyles.labelSmall.copyWith(
              color: StreakColors.textSecondary,
              letterSpacing: 3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 32),

          // Countdown Ring + Time left
          CountdownRing(
            progress: _windowProgress,
            timeRemaining: _timeRemaining,
            size: 130,
            strokeWidth: 5,
          ),
          const SizedBox(height: 32),

          // Partner Status Matrix
          GlassmorphismCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PartnerStatusDot(hasCheckedIn: _hasCheckedInToday),
                          const SizedBox(width: 8),
                          Text('YOU', style: StreakTextStyles.labelSmall.copyWith(letterSpacing: 1.5)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _hasCheckedInToday ? 'CHECKED IN' : 'PENDING',
                        style: StreakTextStyles.bodyMedium.copyWith(
                          color: _hasCheckedInToday ? StreakColors.success : StreakColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 40, width: 1, color: StreakColors.glassBorder),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PartnerStatusDot(hasCheckedIn: partnerCheckedIn),
                          const SizedBox(width: 8),
                          Text('PARTNER', style: StreakTextStyles.labelSmall.copyWith(letterSpacing: 1.5)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _pact!.partnerId == null
                            ? 'UNLINKED'
                            : partnerCheckedIn
                                ? 'CHECKED IN'
                                : 'PENDING',
                        style: StreakTextStyles.bodyMedium.copyWith(
                          color: partnerCheckedIn ? StreakColors.success : StreakColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Big CHECK IN Button
          CheckInButton(
            onPressed: _handleCheckIn,
            hasCheckedIn: _hasCheckedInToday,
            isWithinWindow: _isWithinWindow,
          ),
          const SizedBox(height: 16),

          // Check-in window info footer
          Text(
            'WINDOW: ${_pact!.checkInWindowStartUtc} — ${_pact!.checkInWindowEndUtc} UTC DAILY',
            style: StreakTextStyles.labelSmall.copyWith(
              color: StreakColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
