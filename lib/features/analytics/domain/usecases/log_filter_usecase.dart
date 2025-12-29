import '../repositories/analytics_repository.dart';

class LogFilterUseCase {
  final AnalyticsRepository _repository;

  const LogFilterUseCase({required AnalyticsRepository repository})
    : _repository = repository;

  Future<void> call({
    required List<String> types,
    String? sortBy,
  }) async {
    await _repository.logFilterApplied(
      types,
      sortBy: sortBy,
    );
  }
}
