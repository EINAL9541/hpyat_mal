import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthMilestone {
  final String id;
  final String title;
  final String description;
  final Duration targetDuration;
  final String forestReward;
  final String iconKey;

  const HealthMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDuration,
    required this.forestReward,
    required this.iconKey,
  });

  double progress(Duration currentDuration) {
    if (targetDuration.inSeconds == 0) return 1.0;
    final ratio = currentDuration.inSeconds / targetDuration.inSeconds;
    return ratio.clamp(0.0, 1.0);
  }

  bool isCompleted(Duration currentDuration) {
    return currentDuration >= targetDuration;
  }

  String timeRemainingFormatted(Duration currentDuration) {
    if (isCompleted(currentDuration)) return 'Achieved';
    final remaining = targetDuration - currentDuration;
    if (remaining.inDays > 0) {
      return '${remaining.inDays}d ${remaining.inHours % 24}h left';
    }
    if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m left';
    }
    return '${remaining.inMinutes}m left';
  }
}

final healthMilestonesProvider = Provider<List<HealthMilestone>>((ref) {
  return const [
    HealthMilestone(
      id: 'pulse_rate',
      title: 'Pulse & Blood Pressure',
      description: 'Heart rate and blood pressure drop back to normal healthy levels.',
      targetDuration: Duration(minutes: 20),
      forestReward: 'Fresh Soil Springs',
      iconKey: 'heart',
    ),
    HealthMilestone(
      id: 'carbon_monoxide',
      title: 'Carbon Monoxide Purge',
      description: 'CO levels in your bloodstream drop by half. Oxygen levels return to normal.',
      targetDuration: Duration(hours: 8),
      forestReward: 'Morning Mist Clears',
      iconKey: 'wind',
    ),
    HealthMilestone(
      id: 'heart_risk',
      title: 'Cardiovascular Relief',
      description: 'Nicotine is cleared from the bloodstream. Heart attack risk begins decreasing.',
      targetDuration: Duration(hours: 24),
      forestReward: 'Seedling Roots Anchor',
      iconKey: 'shield',
    ),
    HealthMilestone(
      id: 'taste_smell',
      title: 'Senses Awaken',
      description: 'Damaged nerve endings start regrowing. Your smell and taste senses sharpen.',
      targetDuration: Duration(hours: 48),
      forestReward: 'Wildflowers Bloom',
      iconKey: 'sparkles',
    ),
    HealthMilestone(
      id: 'bronchial_relax',
      title: 'Easy Natural Breathing',
      description: 'Bronchial tubes relax, making breathing easier. Overall body energy surges.',
      targetDuration: Duration(hours: 72),
      forestReward: 'Gentle Breeze Whispers',
      iconKey: 'feather',
    ),
    HealthMilestone(
      id: 'circulation',
      title: 'Vascular Circulation',
      description: 'Blood flow to your extremities improves. Walking and running feel lighter.',
      targetDuration: Duration(days: 14),
      forestReward: 'Songbirds Arrive',
      iconKey: 'activity',
    ),
    HealthMilestone(
      id: 'cilia_regrowth',
      title: 'Lung Self-Cleaning Cilia',
      description: 'Lungs clean out residual mucus and reduce infection risk substantially.',
      targetDuration: Duration(days: 30),
      forestReward: 'Ancient Pine Forest',
      iconKey: 'trees',
    ),
  ];
});
