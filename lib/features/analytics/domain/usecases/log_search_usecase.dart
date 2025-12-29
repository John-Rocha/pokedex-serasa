import '../repositories/analytics_repository.dart';

class LogSearchUseCase {
  final AnalyticsRepository _repository;

  const LogSearchUseCase({required AnalyticsRepository repository})
    : _repository = repository;

  Future<void> call({
    required String searchTerm,
    int? resultsCount,
  }) async {
    await _repository.logSearch(
      searchTerm,
      resultsCount: resultsCount,
    );
  }
}
