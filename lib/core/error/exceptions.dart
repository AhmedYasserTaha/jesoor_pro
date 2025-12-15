class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);
}

class ConflictException implements Exception {
  final String message;
  const ConflictException(this.message);
}

class InternalServerErrorException implements Exception {
  final String message;
  const InternalServerErrorException(this.message);
}

class NoInternetConnectionException implements Exception {
  final String message;
  const NoInternetConnectionException(this.message);
}
