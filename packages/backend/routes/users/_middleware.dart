import 'package:backend/features/users/datasource.dart';
import 'package:backend/features/users/repository.dart';
import 'package:dart_frog/dart_frog.dart';

final userDatasource = UserDatasourceImpl();

Handler middleware(Handler handler) {
  return handler
      .use(
        provider<UserRepositoryImpl>(
          (_) => UserRepositoryImpl(datasource: userDatasource),
        ),
      )
      .use(provider<UserDatasourceImpl>((_) => UserDatasourceImpl()));
}
