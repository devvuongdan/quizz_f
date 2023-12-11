// ignore_for_file: public_member_api_docs, sort_constructors_first
class DataBaseException implements Exception {
  final DateTime time;
  DataBaseException({
    required this.time,
  });
}

class NoTableExist extends DataBaseException {
  NoTableExist({
    required super.time,
  });
}

class NotFoundException extends DataBaseException {
  NotFoundException({
    required super.time,
  });
}
