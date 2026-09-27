import 'dart:async';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:streakbond_client/streakbond_client.dart';
import '../client.dart';
import '../services/stream_service.dart';
import '../theme/streak_colors.dart';
import '../theme/streak_text_styles.dart';
import '../widgets/flame_icon.dart';
import '../widgets/glassmorphism_card.dart';
import '../widgets/scanline_background.dart';
import '../widgets/skeleton_loader.dart';
import 'create_pact_screen.dart';
import 'pact_detail_screen.dart';

class PactListScreen extends StatefulWidget {
  const PactListScreen({super.key});

  @override
  State<PactListScreen> createState() => _PactListScreenState();
}

class _PactListScreenState extends State<PactListScreen> {
  List<Pact>? _pacts;
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<PactEvent>? _eventSubscription;

  @override
  void initState() {
    super.initState();
    _loadPacts();
    StreamService.instance.startListening();
    _eventSubscription = StreamService.instance.events.listen((event) {
      if (mounted) {
        _loadPacts(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadPacts({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    try {
      final pacts = await client.pact.getMyPacts();
      if (mounted) {
        setState(() {
          _pacts = pacts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreakColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt, color: StreakColors.primary, size: 24),
            const SizedBox(width: 8),
            Text(
              'STREAKBOND',
              style: StreakTextStyles.displayMedium.copyWith(
                letterSpacing: 2,
                color: StreakColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: StreakColors.textSecondary),
            onPressed: () => _loadPacts(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: StreakColors.textSecondary),
            onPressed: () async {
              await client.auth.signOutDevice();
            },
          ),
        ],
      ),
      body: ScanlineBackground(
        child: RefreshIndicator(
          color: StreakColors.primary,
          backgroundColor: StreakColors.surface,
          onRefresh: () => _loadPacts(silent: true),
          child: _buildBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: StreakColors.primary,
        foregroundColor: StreakColors.background,
        elevation: 6,
        icon: const Icon(Icons.add, color: StreakColors.background),
        label: Text('NEW PACT', style: StreakTextStyles.button.copyWith(color: StreakColors.background)),
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const CreatePactScreen()),
          );
          if (created == true) {
            _loadPacts();
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        separatorBuilder: (_, index) => const SizedBox(height: 16),
        itemBuilder: (_, index) => const SkeletonLoader(height: 110),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: StreakColors.danger, size: 48),
              const SizedBox(height: 16),
              Text(
                'SYSTEM ERROR',
                style: StreakTextStyles.displayMedium.copyWith(color: StreakColors.danger),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: StreakTextStyles.bodyMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _loadPacts(),
                child: const Text('RETRY'),
              ),
            ],
          ),
        ),
      );
    }

    if (_pacts == null || _pacts!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: StreakColors.primary.withValues(alpha: 0.08),
                  border: Border.all(color: StreakColors.glassBorder),
                ),
                child: const Icon(Icons.link_off, size: 56, color: StreakColors.primary),
              ),
              const SizedBox(height: 24),
              Text(
                'NO PACTS LOCKED',
                style: StreakTextStyles.displayMedium.copyWith(letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Lock into a shared commitment with a partner.\nIf either misses, both streaks burn to zero.',
                textAlign: TextAlign.center,
                style: StreakTextStyles.bodyMedium.copyWith(color: StreakColors.textSecondary),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  final created = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(builder: (_) => const CreatePactScreen()),
                  );
                  if (created == true) _loadPacts();
                },
                icon: const Icon(Icons.add_link),
                label: const Text('INITIALIZE PACT'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _pacts!.length,
      separatorBuilder: (_, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final pact = _pacts![index];
        return _buildPactCard(pact);
      },
    );
  }

  Widget _buildPactCard(Pact pact) {
    Color statusColor;
    String statusText;
    switch (pact.status) {
      case PactStatus.active:
        statusColor = StreakColors.primary;
        statusText = 'ACTIVE';
        break;
      case PactStatus.pending:
        statusColor = StreakColors.accent;
        statusText = 'WAITING FOR PARTNER';
        break;
      case PactStatus.broken:
        statusColor = StreakColors.danger;
        statusText = 'BROKEN';
        break;
    }

    return GlassmorphismCard(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PactDetailScreen(pactId: pact.id!)),
        );
        _loadPacts(silent: true);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  pact.title.toUpperCase(),
                  style: StreakTextStyles.displayMedium.copyWith(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  statusText,
                  style: StreakTextStyles.labelSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FlameIcon(streak: pact.streak, baseSize: 22),
              const SizedBox(width: 8),
              Text(
                '${pact.streak}',
                style: StreakTextStyles.displayMedium.copyWith(
                  color: pact.streak > 0 ? StreakColors.primary : StreakColors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'DAYS',
                style: StreakTextStyles.labelSmall.copyWith(color: StreakColors.textSecondary),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16, color: StreakColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${pact.checkInWindowStartUtc} - ${pact.checkInWindowEndUtc} UTC',
                    style: StreakTextStyles.labelSmall.copyWith(color: StreakColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          if (pact.status == PactStatus.pending) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: StreakColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: StreakColors.accent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.share, size: 16, color: StreakColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    'INVITE CODE: ',
                    style: StreakTextStyles.labelSmall.copyWith(color: StreakColors.accent),
                  ),
                  SelectableText(
                    pact.inviteCode,
                    style: StreakTextStyles.labelSmall.copyWith(
                      color: StreakColors.accent,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
