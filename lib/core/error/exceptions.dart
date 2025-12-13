/// Exceptions used on the data layer
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection']);
  @override
  String toString() => 'NetworkException: $message';
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Unauthorized']);
  @override
  String toString() => 'UnauthorizedException: $message';
}
