import 'package:backend/features/tasks/v1/datasource.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler
      .use(provider<TaskV1DataSourceImpl>((_) => TaskV1DataSourceImpl()));
}
