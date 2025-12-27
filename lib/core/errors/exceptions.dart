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
