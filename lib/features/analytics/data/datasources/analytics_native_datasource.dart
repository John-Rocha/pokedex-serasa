import '../../../../core/errors/exceptions.dart';
import '../../../../core/platform/analytics_channel.dart';

class AnalyticsNativeDataSource {
  final AnalyticsChannel _channel;

  const AnalyticsNativeDataSource({required AnalyticsChannel channel})
    : _channel = channel;

  Future<void> logEvent({
    required String eventName,
    required Map<String, dynamic> parameters,
  }) async {
    try {
      await _channel.logEvent(
        eventName: eventName,
        parameters: parameters,
      );
    } on AnalyticsException {
      rethrow;
    } catch (e) {
      throw AnalyticsException(
        'Erro inesperado ao logar evento',
        originalError: e,
      );
    }
  }

  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
  }) async {
    try {
      await _channel.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } on AnalyticsException {
      rethrow;
    } catch (e) {
      throw AnalyticsException(
        'Erro inesperado ao logar visualização de tela',
        originalError: e,
      );
    }
  }
}
