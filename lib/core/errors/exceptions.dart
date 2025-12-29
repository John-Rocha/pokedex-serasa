class PokemonException implements Exception {
  final String message;

  const PokemonException({required this.message});

  @override
  String toString() => message;
}

class NetworkException extends PokemonException {
  const NetworkException({required super.message});
}

class FileException extends PokemonException {
  const FileException({required super.message});
}

class AnalyticsException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AnalyticsException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() {
    var str = 'AnalyticsException: $message';
    if (code != null) str += ' (code: $code)';
    if (originalError != null) str += '\nOriginal error: $originalError';
    return str;
  }
}

class AnalyticsChannelException extends AnalyticsException {
  const AnalyticsChannelException(
    super.message, {
    super.code,
    super.originalError,
  });
}

class AnalyticsInvalidParametersException extends AnalyticsException {
  const AnalyticsInvalidParametersException(
    super.message, {
    super.code,
    super.originalError,
  });
}

class AnalyticsMethodNotImplementedException extends AnalyticsException {
  const AnalyticsMethodNotImplementedException(
    super.message, {
    super.code,
    super.originalError,
  });
}
