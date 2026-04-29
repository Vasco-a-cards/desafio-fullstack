class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class BadRequestException extends ApiException {
  const BadRequestException({required super.message})
      : super(statusCode: 400);
}

class NotFoundException extends ApiException {
  const NotFoundException({required super.message})
      : super(statusCode: 404);
}

class ValidationException extends ApiException {
  const ValidationException({
    required super.message,
    required this.errors,
  }) : super(statusCode: 422);

  /// Field-level errors: { 'nickname': ['already taken'], ... }
  final Map<String, List<String>> errors;

  @override
  String toString() => 'ValidationException: $message | errors: $errors';
}
