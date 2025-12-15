// lib/core/exceptions/exceptions.dart
class AppException implements Exception {
  final String message;
  AppException(this.message);
  @override
  String toString() => 'AppException: $message';
}

class ServerException extends AppException {
  final int statusCode;
  ServerException(String message, this.statusCode) : super(message);
}

class ClientException extends AppException {
  final int statusCode;
  ClientException(String message, this.statusCode) : super(message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message) : super(message);
}

class UnknownException extends AppException {
  UnknownException(String message) : super(message);
}