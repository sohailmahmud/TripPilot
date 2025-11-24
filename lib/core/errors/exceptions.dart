/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}

/// Exception for network-related errors
class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
  });
}

/// Exception for server/API errors
class ServerException extends AppException {
  final int statusCode;

  ServerException({
    required super.message,
    super.code,
    this.statusCode = 500,
  });
}

/// Exception for local storage errors
class CacheException extends AppException {
  CacheException({
    required super.message,
    super.code,
  });
}

/// Exception for authentication errors
class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
  });
}

/// Exception for validation errors
class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.code,
  });
}

/// Exception for not found errors
class NotFoundException extends AppException {
  NotFoundException({
    required super.message,
    super.code,
  });
}

/// Exception for timeout errors
class TimeoutException extends AppException {
  TimeoutException({
    required super.message,
    super.code,
  });
}
