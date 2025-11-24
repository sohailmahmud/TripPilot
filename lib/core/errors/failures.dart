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
    required super.message,
    super.code,
  });
}

/// Server/API failure
class ServerFailure extends Failure {
  final int statusCode;

  ServerFailure({
    required super.message,
    super.code,
    this.statusCode = 500,
  });
}

/// Cache/Local storage failure
class CacheFailure extends Failure {
  CacheFailure({
    required super.message,
    super.code,
  });
}

/// Authentication failure
class AuthFailure extends Failure {
  AuthFailure({
    required super.message,
    super.code,
  });
}

/// Validation failure
class ValidationFailure extends Failure {
  ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Not found failure
class NotFoundFailure extends Failure {
  NotFoundFailure({
    required super.message,
    super.code,
  });
}

/// Timeout failure
class TimeoutFailure extends Failure {
  TimeoutFailure({
    required super.message,
    super.code,
  });
}

/// Unknown failure
class UnknownFailure extends Failure {
  UnknownFailure({
    required super.message,
    super.code,
  });
}
