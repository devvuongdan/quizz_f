// ignore_for_file: public_member_api_docs, sort_constructors_first
class BadRequestException implements Exception {
  final DateTime time;
  final String errorCode;
  BadRequestException({
    required this.time,
    required this.errorCode,
  });
}
