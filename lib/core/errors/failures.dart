import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class FileFailure extends Failure {
  const FileFailure({required super.message});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}

class AnalyticsFailure extends Failure {
  const AnalyticsFailure({required super.message});
}

class AnalyticsChannelFailure extends Failure {
  const AnalyticsChannelFailure({required super.message});
}

class AnalyticsInvalidParametersFailure extends Failure {
  const AnalyticsInvalidParametersFailure({required super.message});
}
