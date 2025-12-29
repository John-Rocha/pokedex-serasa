class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;

  const AnalyticsEvent({
    required this.name,
    required this.parameters,
    required this.timestamp,
  });
}
