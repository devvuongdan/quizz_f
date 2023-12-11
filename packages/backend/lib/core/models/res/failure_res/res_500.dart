import 'package:backend/core/models/res/failure_res/failure_res.dart';

///
class Response500 extends FailureResponse {
  ///
  const Response500({
    required super.time,
  }) : super(
          code: 500,
          result: const FailureResult(errorCode: 'internal-server-error'),
        );
}
