import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/core/network/dio_client.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late DioClient dioClient;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dioClient = DioClient(dio: mockDio);
  });

  group('DioClient', () {
    const tPath = '/test-path';
    final tResponse = Response(
      data: {'test': 'data'},
      statusCode: 200,
      requestOptions: RequestOptions(path: tPath),
    );

    test('should implement RestClient', () {
      expect(dioClient, isA<RestClient>());
    });

    group('get', () {
      test('should delegate to Dio.get with correct path', () async {
        // Arrange
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => tResponse);

        // Act
        await dioClient.get(tPath);

        // Assert
        verify(() => mockDio.get(
              tPath,
              queryParameters: null,
              options: null,
            )).called(1);
      });

      test('should return Response from Dio.get', () async {
        // Arrange
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => tResponse);

        // Act
        final result = await dioClient.get(tPath);

        // Assert
        expect(result, tResponse);
        expect(result.data, {'test': 'data'});
        expect(result.statusCode, 200);
      });

      test('should pass queryParameters to Dio.get', () async {
        // Arrange
        final tQueryParams = {'key': 'value', 'page': '1'};
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => tResponse);

        // Act
        await dioClient.get(tPath, queryParameters: tQueryParams);

        // Assert
        verify(() => mockDio.get(
              tPath,
              queryParameters: tQueryParams,
              options: null,
            )).called(1);
      });

      test('should pass options to Dio.get', () async {
        // Arrange
        final tOptions = Options(headers: {'Authorization': 'Bearer token'});
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => tResponse);

        // Act
        await dioClient.get(tPath, options: tOptions);

        // Assert
        verify(() => mockDio.get(
              tPath,
              queryParameters: null,
              options: tOptions,
            )).called(1);
      });

      test('should pass both queryParameters and options to Dio.get', () async {
        // Arrange
        final tQueryParams = {'search': 'pikachu'};
        final tOptions = Options(headers: {'Content-Type': 'application/json'});
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => tResponse);

        // Act
        await dioClient.get(
          tPath,
          queryParameters: tQueryParams,
          options: tOptions,
        );

        // Assert
        verify(() => mockDio.get(
              tPath,
              queryParameters: tQueryParams,
              options: tOptions,
            )).called(1);
      });

      test('should throw DioException when Dio.get throws', () async {
        // Arrange
        final tDioException = DioException(
          requestOptions: RequestOptions(path: tPath),
          message: 'Network error',
        );
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenThrow(tDioException);

        // Act
        final call = dioClient.get(tPath);

        // Assert
        expect(call, throwsA(isA<DioException>()));
      });
    });
  });
}
