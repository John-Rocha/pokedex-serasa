import '../../domain/entities/analytics_event.dart';

class AnalyticsEventModel extends AnalyticsEvent {
  const AnalyticsEventModel({
    required super.name,
    required super.parameters,
    required super.timestamp,
  });

  factory AnalyticsEventModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsEventModel(
      name: json['name'] as String,
      parameters: Map<String, dynamic>.from(json['parameters'] as Map),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'parameters': parameters,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AnalyticsEventModel.fromEntity(AnalyticsEvent entity) {
    return AnalyticsEventModel(
      name: entity.name,
      parameters: entity.parameters,
      timestamp: entity.timestamp,
    );
  }

  Map<String, dynamic> toMethodChannelMap() {
    return {
      'eventName': name,
      'parameters': {
        ...parameters,
        'timestamp': timestamp.toIso8601String(),
      },
    };
  }
}
