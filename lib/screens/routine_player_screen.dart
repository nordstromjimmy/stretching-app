import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_scope.dart';
import '../l10n/app_localizations.dart';
import '../models/exercise.dart';
import '../utils/labels.dart';

/// One exercise in a running session, with the hold time to use.
class SessionExercise {
  final Exercise exercise;
  final int holdSeconds;

  const SessionExercise({required this.exercise, required this.holdSeconds});

  int get totalSeconds => holdSeconds * exercise.dose.sides;
}

/// One timed block: an exercise, or one side of a per-side exercise.
class _Step {
  final int exerciseIndex;
  final int side; // 1 or 2
  final int sides; // 1 or 2
  final int seconds;

  const _Step({
    required this.exerciseIndex,
    required this.side,
    required this.sides,
    required this.seconds,
  });
}

class RoutinePlayerScreen extends StatefulWidget {
  final String routineName;
  final List<SessionExercise> exercises;
  final FigureGender gender;

  const RoutinePlayerScreen({
    super.key,
    required this.routineName,
    required this.exercises,
    required this.gender,
  });

  @override
  State<RoutinePlayerScreen> createState() => _RoutinePlayerScreenState();
}

class _RoutinePlayerScreenState extends State<RoutinePlayerScreen> {
  /// Countdown before each exercise and between sides.
  static const int _prepSeconds = 5;

  late final List<_Step> _steps = [
    for (var i = 0; i < widget.exercises.length; i++)
      for (
        var side = 1;
        side <= widget.exercises[i].exercise.dose.sides;
        side++
      )
        _Step(
          exerciseIndex: i,
          side: side,
          sides: widget.exercises[i].exercise.dose.sides,
          seconds: widget.exercises[i].holdSeconds,
        ),
  ];

  int _stepIndex = 0;
  bool _preparing = true;
  int _remaining = _prepSeconds;
  bool _paused = false;
  bool _finished = false;
  Timer? _timer;

  _Step get _step => _steps[_stepIndex];
  SessionExercise get _current => widget.exercises[_step.exerciseIndex];
  int get _phaseLength => _preparing ? _prepSeconds : _step.seconds;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (_paused || _finished) return;
    setState(() {
      _remaining--;
      if (_remaining <= 0) _advance();
    });
  }

  /// Moves to the next phase: prep → exercise → next step's prep → ...
  /// Must be called inside setState.
  void _advance() {
    HapticFeedback.mediumImpact();
    if (_preparing) {
      _preparing = false;
      _remaining = _step.seconds;
    } else {
      _goToStep(_stepIndex + 1);
    }
  }

  void _goToStep(int index) {
    if (index >= _steps.length) {
      _finished = true;
      _timer?.cancel();
      _recordSession();
      return;
    }
    _stepIndex = index;
    _preparing = true;
    _remaining = _prepSeconds;
  }

  /// Saves the finished session, which marks today in the calendar.
  void _recordSession() {
    final totalSeconds = widget.exercises.fold(
      0,
      (sum, e) => sum + e.totalSeconds,
    );
    AppScope.read(context).history.record(
      routineName: widget.routineName,
      exerciseCount: widget.exercises.length,
      seconds: totalSeconds,
    );
  }

  void _skip() => setState(_advance);

  void _previous() => setState(() {
    _goToStep(_stepIndex > 0 ? _stepIndex - 1 : 0);
  });

  void _togglePause() => setState(() => _paused = !_paused);

  Future<bool> _confirmQuit() async {
    final t = AppLocalizations.of(context);
    final wasPaused = _paused;
    setState(() => _paused = true);

    final quit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.quitTitle),
        content: Text(t.quitBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.keepGoing),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.quit),
          ),
        ],
      ),
    );

    if (quit != true && mounted) setState(() => _paused = wasPaused);
    return quit == true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _finished,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final quit = await _confirmQuit();
        if (quit && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.routineName)),
        body: SafeArea(
          child: _finished ? _buildFinished(context) : _buildSession(context),
        ),
      ),
    );
  }

  Widget _buildSession(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final exercise = _current.exercise;

    // Text above the timer during the prep countdown.
    String? phaseLabel;
    if (_preparing) {
      if (_stepIndex == 0) {
        phaseLabel = t.getReady;
      } else if (_step.side == 2) {
        phaseLabel = t.switchSide;
      } else {
        phaseLabel = t.upNext;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        children: [
          // Progress
          Row(
            children: [
              Text(
                t.playerExerciseOf(
                  _step.exerciseIndex + 1,
                  widget.exercises.length,
                ),
                style: textTheme.labelLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              if (_step.sides == 2)
                Text(
                  t.sideOf(_step.side),
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _stepIndex / _steps.length,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),

          // Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                exercise.imagePath(widget.gender),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported_outlined, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name and phase
          if (phaseLabel != null)
            Text(
              phaseLabel,
              style: textTheme.titleSmall?.copyWith(color: colors.secondary),
            ),
          Text(
            exercise.name.of(lang),
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Timer
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: _remaining / _phaseLength,
                  strokeWidth: 10,
                  strokeCap: StrokeCap.round,
                  backgroundColor: colors.surfaceContainerHighest,
                  color: _preparing ? colors.secondary : colors.primary,
                ),
                Center(
                  child: Text(
                    formatClock(_remaining),
                    style: textTheme.displayMedium?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: t.previous,
                iconSize: 32,
                onPressed: _previous,
                icon: const Icon(Icons.skip_previous),
              ),
              const SizedBox(width: 24),
              IconButton.filled(
                tooltip: _paused ? t.resume : t.pause,
                iconSize: 40,
                style: IconButton.styleFrom(minimumSize: const Size(72, 72)),
                onPressed: _togglePause,
                icon: Icon(_paused ? Icons.play_arrow : Icons.pause),
              ),
              const SizedBox(width: 24),
              IconButton(
                tooltip: t.skip,
                iconSize: 32,
                onPressed: _skip,
                icon: const Icon(Icons.skip_next),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinished(BuildContext context) {
    final t = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final totalSeconds = widget.exercises.fold(
      0,
      (sum, e) => sum + e.totalSeconds,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 96, color: colors.primary),
            const SizedBox(height: 16),
            Text(t.finishedTitle, style: textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(t.finishedBody, style: textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(
              '${t.routineExerciseCount(widget.exercises.length)}'
              ' · ${t.totalTime(formatDuration(t, totalSeconds))}',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(200, 52)),
              onPressed: () {
                // Switch to the Home tab and close every screen above the main view.
                AppScope.read(context).currentTab.value = AppTab.home;
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(t.done),
            ),
          ],
        ),
      ),
    );
  }
}
