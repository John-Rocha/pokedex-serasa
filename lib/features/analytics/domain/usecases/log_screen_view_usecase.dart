import 'package:pokedex_serasa/features/analytics/domain/repositories/analytics_repository.dart';

class LogScreenViewUseCase {
  final AnalyticsRepository repository;

  LogScreenViewUseCase({required this.repository});

  Future<void> call({
    required String screenName,
    required String screenClass,
  }) {
    return repository.logScreenView(screenName, screenClass);
  }
}
