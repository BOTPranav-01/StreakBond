import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../client.dart';
import '../theme/streak_colors.dart';
import '../theme/streak_text_styles.dart';
import '../widgets/glassmorphism_card.dart';
import '../widgets/scanline_background.dart';

class CreatePactScreen extends StatefulWidget {
  const CreatePactScreen({super.key});

  @override
  State<CreatePactScreen> createState() => _CreatePactScreenState();
}

class _CreatePactScreenState extends State<CreatePactScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Create Form State
  final _titleController = TextEditingController();
  TimeOfDay _startTime = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 23, minute: 0);
  bool _isCreating = false;
  String? _createdInviteCode;

  // Join Form State
  final _inviteCodeController = TextEditingController();
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final utc = dt.toUtc();
    return '${utc.hour.toString().padLeft(2, '0')}:${utc.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _createPact() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a commitment title')),
      );
      return;
    }

    final startUtc = _formatTimeOfDay(_startTime);
    final endUtc = _formatTimeOfDay(_endTime);

    setState(() => _isCreating = true);
    try {
      final pact = await client.pact.createPact(title, startUtc, endUtc);
      if (mounted) {
        setState(() {
          _isCreating = false;
          _createdInviteCode = pact.inviteCode;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCreating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize pact: $e'),
            backgroundColor: StreakColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _joinPact() async {
    final code = _inviteCodeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an invite code')),
      );
      return;
    }

    setState(() => _isJoining = true);
    try {
      await client.pact.acceptPact(code);
      if (mounted) {
        setState(() => _isJoining = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pact activated! The bond is sealed.'),
            backgroundColor: StreakColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isJoining = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept pact: $e'),
            backgroundColor: StreakColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreakColors.background,
      appBar: AppBar(
        title: Text(
          'ESTABLISH BOND',
          style: StreakTextStyles.displayMedium.copyWith(
            fontSize: 20,
            letterSpacing: 1.5,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: StreakColors.primary,
          indicatorWeight: 3,
          labelColor: StreakColors.primary,
          unselectedLabelColor: StreakColors.textSecondary,
          labelStyle: StreakTextStyles.button,
          tabs: const [
            Tab(text: 'NEW PACT'),
            Tab(text: 'JOIN PACT'),
          ],
        ),
      ),
      body: ScanlineBackground(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildCreateTab(),
            _buildJoinTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateTab() {
    if (_createdInviteCode != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: StreakColors.accent.withValues(alpha: 0.1),
                  border: Border.all(color: StreakColors.accent),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: StreakColors.accent,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'PACT INITIALIZED',
                style: StreakTextStyles.displayMedium.copyWith(
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Share this access key with your partner to seal the bond.',
                textAlign: TextAlign.center,
                style: StreakTextStyles.bodyMedium.copyWith(
                  color: StreakColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              GlassmorphismCard(
                borderColor: StreakColors.accent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _createdInviteCode!,
                      style: StreakTextStyles.displayLarge.copyWith(
                        color: StreakColors.accent,
                        letterSpacing: 4,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.copy, color: StreakColors.accent),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: _createdInviteCode!),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Access key copied to clipboard'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('RETURN TO PACTS'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SHARED COMMITMENT',
            style: StreakTextStyles.labelSmall.copyWith(
              color: StreakColors.primary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            style: StreakTextStyles.bodyLarge,
            decoration: const InputDecoration(
              hintText: 'e.g. 20 pushups, 30 min study, no sugar',
              prefixIcon: Icon(
                Icons.fitness_center,
                color: StreakColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'DAILY CHECK-IN WINDOW',
            style: StreakTextStyles.labelSmall.copyWith(
              color: StreakColors.primary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Both members must check in between these hours daily or the streak will die.',
            style: StreakTextStyles.bodyMedium.copyWith(
              color: StreakColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GlassmorphismCard(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _startTime,
                    );
                    if (picked != null) setState(() => _startTime = picked);
                  },
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'WINDOW OPEN',
                        style: StreakTextStyles.labelSmall.copyWith(
                          color: StreakColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _startTime.format(context),
                        style: StreakTextStyles.displayMedium.copyWith(
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.arrow_forward,
                  color: StreakColors.textSecondary,
                ),
              ),
              Expanded(
                child: GlassmorphismCard(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _endTime,
                    );
                    if (picked != null) setState(() => _endTime = picked);
                  },
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'WINDOW CLOSE',
                        style: StreakTextStyles.labelSmall.copyWith(
                          color: StreakColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _endTime.format(context),
                        style: StreakTextStyles.displayMedium.copyWith(
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isCreating ? null : _createPact,
              child: _isCreating
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: StreakColors.background,
                      ),
                    )
                  : const Text('GENERATE PACT'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'JOIN EXISTING PACT',
            style: StreakTextStyles.labelSmall.copyWith(
              color: StreakColors.primary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the access key provided by your accountability partner.',
            style: StreakTextStyles.bodyMedium.copyWith(
              color: StreakColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _inviteCodeController,
            textCapitalization: TextCapitalization.characters,
            style: StreakTextStyles.displayMedium.copyWith(
              fontSize: 22,
              letterSpacing: 3,
            ),
            decoration: const InputDecoration(
              hintText: 'BOND-XXXX',
              prefixIcon: Icon(Icons.vpn_key, color: StreakColors.primary),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isJoining ? null : _joinPact,
              child: _isJoining
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: StreakColors.background,
                      ),
                    )
                  : const Text('LOCK IN'),
            ),
          ),
        ],
      ),
    );
  }
}
