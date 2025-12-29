import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/core/errors/exceptions.dart';
import 'package:pokedex_serasa/core/platform/analytics_channel.dart';
import 'package:pokedex_serasa/core/platform/analytics_channel_impl.dart';
import 'package:pokedex_serasa/core/platform/analytics_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AnalyticsChannel channel;
  late MethodChannel methodChannel;

  setUp(() {
    methodChannel = const MethodChannel(AnalyticsConstants.channelName);
    channel = AnalyticsChannelImpl(channel: methodChannel);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });

  group('AnalyticsChannelImpl', () {
    group('logEvent', () {
      const tEventName = 'test_event';
      final tParameters = {'key': 'value', 'count': 42};

      test(
        'should call invokeMethod with correct method and arguments',
        () async {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
                methodChannel,
                (MethodCall methodCall) async {
                  expect(methodCall.method, AnalyticsConstants.methodLogEvent);
                  expect(
                    methodCall.arguments[AnalyticsConstants.keyEventName],
                    tEventName,
                  );
                  expect(
                    methodCall.arguments[AnalyticsConstants.keyParameters],
                    tParameters,
                  );
                  return null;
                },
              );

          await channel.logEvent(
            eventName: tEventName,
            parameters: tParameters,
          );
        },
      );

      test(
        'should throw AnalyticsChannelException on PlatformException',
        () async {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
                methodChannel,
                (MethodCall methodCall) async {
                  throw PlatformException(
                    code: 'ERROR_CODE',
                    message: 'Test error',
                  );
                },
              );

          expect(
            () => channel.logEvent(
              eventName: tEventName,
              parameters: tParameters,
            ),
            throwsA(
              isA<AnalyticsChannelException>()
                  .having(
                    (e) => e.message,
                    'message',
                    contains('Erro ao logar evento'),
                  )
                  .having(
                    (e) => e.code,
                    'code',
                    'ERROR_CODE',
                  ),
            ),
          );
        },
      );

      test(
        'should throw AnalyticsMethodNotImplementedException on MissingPluginException',
        () async {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
                methodChannel,
                (MethodCall methodCall) async {
                  throw MissingPluginException();
                },
              );

          expect(
            () => channel.logEvent(
              eventName: tEventName,
              parameters: tParameters,
            ),
            throwsA(
              isA<AnalyticsMethodNotImplementedException>().having(
                (e) => e.message,
                'message',
                contains('Método não implementado'),
              ),
            ),
          );
        },
      );

      test('should handle empty parameters', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              methodChannel,
              (MethodCall methodCall) async {
                expect(methodCall.method, AnalyticsConstants.methodLogEvent);
                expect(
                  methodCall.arguments[AnalyticsConstants.keyEventName],
                  tEventName,
                );
                expect(
                  methodCall.arguments[AnalyticsConstants.keyParameters],
                  {},
                );
                return null;
              },
            );

        await channel.logEvent(
          eventName: tEventName,
          parameters: {},
        );
      });
    });

    group('logScreenView', () {
      const tScreenName = 'HomeScreen';
      const tScreenClass = 'HomePage';

      test(
        'should call invokeMethod with correct method and arguments',
        () async {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
                methodChannel,
                (MethodCall methodCall) async {
                  expect(
                    methodCall.method,
                    AnalyticsConstants.methodLogScreenView,
                  );
                  expect(
                    methodCall.arguments[AnalyticsConstants.keyScreenName],
                    tScreenName,
                  );
                  expect(
                    methodCall.arguments[AnalyticsConstants.keyScreenClass],
                    tScreenClass,
                  );
                  return null;
                },
              );

          await channel.logScreenView(
            screenName: tScreenName,
            screenClass: tScreenClass,
          );
        },
      );

      test(
        'should throw AnalyticsChannelException on PlatformException',
        () async {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
                methodChannel,
                (MethodCall methodCall) async {
                  throw PlatformException(
                    code: 'ERROR_CODE',
                    message: 'Test error',
                  );
                },
              );

          expect(
            () => channel.logScreenView(
              screenName: tScreenName,
              screenClass: tScreenClass,
            ),
            throwsA(
              isA<AnalyticsChannelException>()
                  .having(
                    (e) => e.message,
                    'message',
                    contains('Erro ao logar visualização de tela'),
                  )
                  .having(
                    (e) => e.code,
                    'code',
                    'ERROR_CODE',
                  ),
            ),
          );
        },
      );

      test(
        'should throw AnalyticsMethodNotImplementedException on MissingPluginException',
        () async {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
                methodChannel,
                (MethodCall methodCall) async {
                  throw MissingPluginException();
                },
              );

          expect(
            () => channel.logScreenView(
              screenName: tScreenName,
              screenClass: tScreenClass,
            ),
            throwsA(
              isA<AnalyticsMethodNotImplementedException>().having(
                (e) => e.message,
                'message',
                contains('Método não implementado'),
              ),
            ),
          );
        },
      );

      test('should complete successfully without errors', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              methodChannel,
              (MethodCall methodCall) async {
                return null;
              },
            );

        await expectLater(
          channel.logScreenView(
            screenName: tScreenName,
            screenClass: tScreenClass,
          ),
          completes,
        );
      });
    });

    group('isAnalyticsEnabled', () {
      test('should call invokeMethod and return true', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              methodChannel,
              (MethodCall methodCall) async {
                expect(methodCall.method, AnalyticsConstants.methodIsEnabled);
                return true;
              },
            );

        final result = await channel.isAnalyticsEnabled();

        expect(result, true);
      });

      test('should call invokeMethod and return false', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              methodChannel,
              (MethodCall methodCall) async {
                expect(methodCall.method, AnalyticsConstants.methodIsEnabled);
                return false;
              },
            );

        final result = await channel.isAnalyticsEnabled();

        expect(result, false);
      });

      test('should return false when result is null', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              methodChannel,
              (MethodCall methodCall) async {
                expect(methodCall.method, AnalyticsConstants.methodIsEnabled);
                return null;
              },
            );

        final result = await channel.isAnalyticsEnabled();

        expect(result, false);
      });

      test(
        'should throw AnalyticsChannelException on PlatformException',
        () async {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
                methodChannel,
                (MethodCall methodCall) async {
                  throw PlatformException(
                    code: 'ERROR_CODE',
                    message: 'Test error',
                  );
                },
              );

          expect(
            () => channel.isAnalyticsEnabled(),
            throwsA(
              isA<AnalyticsChannelException>()
                  .having(
                    (e) => e.message,
                    'message',
                    contains('Erro ao verificar status'),
                  )
                  .having(
                    (e) => e.code,
                    'code',
                    'ERROR_CODE',
                  ),
            ),
          );
        },
      );

      test('should call correct method on channel', () async {
        bool methodCalled = false;
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              methodChannel,
              (MethodCall methodCall) async {
                methodCalled = true;
                expect(methodCall.method, AnalyticsConstants.methodIsEnabled);
                return true;
              },
            );

        await channel.isAnalyticsEnabled();

        expect(methodCalled, true);
      });
    });

    group('setAnalyticsEnabled', () {
      test('should call invokeMethod with enabled=true', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              methodChannel,
              (MethodCall methodCall) async {
                expect(methodCall.method, AnalyticsConstants.methodSetEnabled);
                expect(methodCall.arguments['enabled'], true);
                return null;
              },
            );

        await channel.setAnalyticsEnabled(true);
      });

      test('should call invokeMethod with enabled=false', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              methodChannel,
              (MethodCall methodCall) async {
                expect(methodCall.method, AnalyticsConstants.methodSetEnabled);
                expect(methodCall.arguments['enabled'], false);
                return null;
              },
            );

        await channel.setAnalyticsEnabled(false);
      });

      test(
        'should throw AnalyticsChannelException on PlatformException',
        () async {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
                methodChannel,
                (MethodCall methodCall) async {
                  throw PlatformException(
                    code: 'ERROR_CODE',
                    message: 'Test error',
                  );
                },
              );

          expect(
            () => channel.setAnalyticsEnabled(true),
            throwsA(
              isA<AnalyticsChannelException>()
                  .having(
                    (e) => e.message,
                    'message',
                    contains('Erro ao alterar status'),
                  )
                  .having(
                    (e) => e.code,
                    'code',
                    'ERROR_CODE',
                  ),
            ),
          );
        },
      );

      test('should complete successfully without errors', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              methodChannel,
              (MethodCall methodCall) async {
                return null;
              },
            );

        await expectLater(
          channel.setAnalyticsEnabled(true),
          completes,
        );
      });
    });
  });
}
