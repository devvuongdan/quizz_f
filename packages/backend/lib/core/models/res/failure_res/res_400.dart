import 'package:backend/core/models/res/failure_res/failure_res.dart';

///
class Response400 extends FailureResponse {
  ///
  const Response400({
    required super.time,
    required super.result,
  }) : super(
          code: 400,
        );
}
