import 'package:backend/core/models/res/failure_res/failure_res.dart';

///
class Response404 extends FailureResponse {
  ///
  const Response404({
    required super.time,
  }) : super(
          code: 404,
          result: const FailureResult(errorCode: 'not-found'),
        );
}
