import 'package:flutter/services.dart';
import '../errors/exceptions.dart';
import 'analytics_channel.dart';
import 'analytics_constants.dart';

class AnalyticsChannelImpl implements AnalyticsChannel {
  final MethodChannel _channel;

  const AnalyticsChannelImpl({required MethodChannel channel})
    : _channel = channel;

  @override
  Future<void> logEvent({
    required String eventName,
    required Map<String, dynamic> parameters,
  }) async {
    try {
      await _channel.invokeMethod(
        AnalyticsConstants.methodLogEvent,
        {
          AnalyticsConstants.keyEventName: eventName,
          AnalyticsConstants.keyParameters: parameters,
        },
      );
    } on PlatformException catch (e) {
      throw AnalyticsChannelException(
        'Erro ao logar evento: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } on MissingPluginException catch (e) {
      throw AnalyticsMethodNotImplementedException(
        'Método não implementado na plataforma nativa',
        originalError: e,
      );
    } catch (e) {
      throw AnalyticsException(
        'Erro desconhecido ao logar evento',
        originalError: e,
      );
    }
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    required String screenClass,
  }) async {
    try {
      await _channel.invokeMethod(
        AnalyticsConstants.methodLogScreenView,
        {
          AnalyticsConstants.keyScreenName: screenName,
          AnalyticsConstants.keyScreenClass: screenClass,
        },
      );
    } on PlatformException catch (e) {
      throw AnalyticsChannelException(
        'Erro ao logar visualização de tela: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } on MissingPluginException catch (e) {
      throw AnalyticsMethodNotImplementedException(
        'Método não implementado na plataforma nativa',
        originalError: e,
      );
    } catch (e) {
      throw AnalyticsException(
        'Erro desconhecido ao logar visualização de tela',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> isAnalyticsEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        AnalyticsConstants.methodIsEnabled,
      );
      return result ?? false;
    } on PlatformException catch (e) {
      throw AnalyticsChannelException(
        'Erro ao verificar status do Analytics: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw AnalyticsException(
        'Erro desconhecido ao verificar status do Analytics',
        originalError: e,
      );
    }
  }

  @override
  Future<void> setAnalyticsEnabled(bool enabled) async {
    try {
      await _channel.invokeMethod(
        AnalyticsConstants.methodSetEnabled,
        {'enabled': enabled},
      );
    } on PlatformException catch (e) {
      throw AnalyticsChannelException(
        'Erro ao alterar status do Analytics: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw AnalyticsException(
        'Erro desconhecido ao alterar status do Analytics',
        originalError: e,
      );
    }
  }
}
