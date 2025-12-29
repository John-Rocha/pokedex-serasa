import '../entities/analytics_event.dart';
import '../repositories/analytics_repository.dart';

class LogEventUseCase {
  final AnalyticsRepository _repository;

  const LogEventUseCase({required AnalyticsRepository repository})
    : _repository = repository;

  Future<void> call({
    required String eventName,
    required Map<String, dynamic> parameters,
  }) async {
    final event = AnalyticsEvent(
      name: eventName,
      parameters: parameters,
      timestamp: DateTime.now(),
    );

    await _repository.logEvent(event);
  }
}
