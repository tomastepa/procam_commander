class MissingParameterException implements Exception {
  final String message;

  MissingParameterException(this.message);

  @override
  String toString() {
    return 'MissingParameterException: $message';
  }
}
