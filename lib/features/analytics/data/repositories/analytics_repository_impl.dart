import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/analytics_event.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_native_datasource.dart';
import '../models/analytics_event_model.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsNativeDataSource _nativeDataSource;

  const AnalyticsRepositoryImpl({
    required AnalyticsNativeDataSource nativeDataSource,
  }) : _nativeDataSource = nativeDataSource;

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    try {
      final model = AnalyticsEventModel.fromEntity(event);
      await _nativeDataSource.logEvent(
        eventName: model.name,
        parameters: model.parameters,
      );
    } on AnalyticsException catch (e) {
      throw AnalyticsFailure(message: e.message);
    }
  }

  @override
  Future<void> logScreenView(String screenName, String screenClass) async {
    try {
      await _nativeDataSource.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } on AnalyticsException catch (e) {
      throw AnalyticsFailure(message: e.message);
    }
  }

  @override
  Future<void> logPokemonView(
    int pokemonId,
    String pokemonName, {
    List<String>? types,
  }) async {
    try {
      await _nativeDataSource.logEvent(
        eventName: 'pokemon_view',
        parameters: {
          'pokemon_id': pokemonId,
          'pokemon_name': pokemonName,
          if (types != null) 'pokemon_types': types.join(','),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } on AnalyticsException catch (e) {
      throw AnalyticsFailure(message: e.message);
    }
  }

  @override
  Future<void> logSearch(
    String searchTerm, {
    int? resultsCount,
  }) async {
    try {
      await _nativeDataSource.logEvent(
        eventName: 'search_performed',
        parameters: {
          'search_term': searchTerm,
          if (resultsCount != null) 'results_count': resultsCount,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } on AnalyticsException catch (e) {
      throw AnalyticsFailure(message: e.message);
    }
  }

  @override
  Future<void> logFilterApplied(
    List<String> types, {
    String? sortBy,
  }) async {
    try {
      await _nativeDataSource.logEvent(
        eventName: 'filter_applied',
        parameters: {
          'filter_types': types.join(','),
          if (sortBy != null) 'sort_by': sortBy,
          'filter_count': types.length,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } on AnalyticsException catch (e) {
      throw AnalyticsFailure(message: e.message);
    }
  }
}
