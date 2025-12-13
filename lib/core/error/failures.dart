/// Failures used in domain layer or UI
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(String message) : super(message);
}
