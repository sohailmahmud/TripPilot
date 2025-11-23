/// Base failure class for handling errors throughout the app
abstract class Failure {
  final String message;
  final String? code;

  Failure({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}

/// Network failure
class NetworkFailure extends Failure {
  NetworkFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

/// Server/API failure
class ServerFailure extends Failure {
  final int statusCode;

  ServerFailure({
    required String message,
    String? code,
    this.statusCode = 500,
  }) : super(message: message, code: code);
}

/// Cache/Local storage failure
class CacheFailure extends Failure {
  CacheFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

/// Authentication failure
class AuthFailure extends Failure {
  AuthFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

/// Validation failure
class ValidationFailure extends Failure {
  ValidationFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

/// Not found failure
class NotFoundFailure extends Failure {
  NotFoundFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

/// Timeout failure
class TimeoutFailure extends Failure {
  TimeoutFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

/// Unknown failure
class UnknownFailure extends Failure {
  UnknownFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}
