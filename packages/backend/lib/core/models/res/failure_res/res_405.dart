import 'package:backend/core/models/res/failure_res/failure_res.dart';

///
class Response405 extends FailureResponse {
  ///
  const Response405({
    required super.time,
  }) : super(
          code: 405,
          result: const FailureResult(errorCode: 'method-not-allowed'),
        );
}
