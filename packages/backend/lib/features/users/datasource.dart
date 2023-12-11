// ignore_for_file: public_member_api_docs

import 'package:backend/core/database/database_helper.dart';
import 'package:backend/core/exception/bad_request_exception.dart';
import 'package:backend/core/exception/database_exceptions.dart';
import 'package:backend/core/services/hashed_password.dart';
import 'package:backend/features/users/user_dto.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/models/users/user.dart';
import 'package:uuid/uuid.dart';

abstract class UserDatasource {
  Future<UserDB> createUser(
    CreateUserDto dto,
  );

  Future<UserDB> updateUser(
    UpdateUserDto dto,
    String id,
  );

  Future<UserDB> getUserByID(
    String id,
  );
  Future<UserDB?> getUserByUsername(
    String username, {
    bool init = false,
  });

  Future<UserDB> deleteUser(
    String id,
  );

  //ADMIN OR SEARCHING ONLY
  Future<List<UserDB>> getUsers();
}

class UserDatasourceImpl implements UserDatasource {
  final PostgresDbHelper database = PostgresDbHelper();
  static const String tableNameX = 'userV1Test2';
  @override
  Future<UserDB> createUser(CreateUserDto dto) async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      final newUser = UserDB(
        username: dto.username,
        password: const PasswordHasherService().hashPassword(dto.password),
        updated_pw_at: DateTime.now(),
        name: '',
        phone: '',
        status: -1,
        uid: const Uuid().v4(),
        created_at: DateTime.now(),
        updated_at: DateTime.now(),
      );
      await database.createTableIfNotExist<UserDB>(
        tableName: tableNameX,
        connection: connection,
        objectDb: newUser,
      );

      await database.insert(
        tableName: tableNameX,
        connection: connection,
        newObject: newUser,
      );
      await connection.close();

      return newUser.copyWithX(password: '');
    } catch (e) {
      throw BadRequestException(
        time: DateTime.now(),
        errorCode: 'bad-request',
      );
    }
  }

  @override
  Future<UserDB> deleteUser(String id) async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      final userDB = await getUserByID(id);
      await database.delete(
        tableName: tableNameX,
        connection: connection,
        uid: id,
      );
      return userDB;
    } catch (e) {
      throw NotFoundException(time: DateTime.now());
    }
  }

  @override
  Future<UserDB> getUserByID(String id) async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      final result = await database.getListEqual(
        tableName: tableNameX,
        connection: connection,
        parameters: {'uid': id},
      );

      final users = result
          .map(
            (element) => UserDB.fromMap(
              element.toColumnMap(),
            ).copyWithX(
              password: '',
            ),
          )
          .toList();

      await connection.close();

      return users.first;
    } catch (e) {
      throw NotFoundException(time: DateTime.now());
    }
  }

  @override
  Future<List<UserDB>> getUsers() async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      final result =
          await database.getList(tableName: tableNameX, connection: connection);
      final users = result
          .map(
            (element) => UserDB.fromMap(element.toColumnMap()).copyWithX(
              password: '',
            ),
          )
          .toList();
      return users;
    } catch (e) {
      throw BadRequestException(
        time: DateTime.now(),
        errorCode: 'bad-request',
      );
    }
  }

  @override
  Future<UserDB> updateUser(UpdateUserDto dto, String id) async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      final userDb = await getUserByID(id);

      final newUser = userDb.copyWithX(
        password: const PasswordHasherService().hashPassword(dto.password),
        updated_pw_at:
            const PasswordHasherService().hashPassword(dto.password) ==
                    const PasswordHasherService().hashPassword(userDb.password)
                ? userDb.updated_pw_at
                : DateTime.now(),
        name: dto.name,
        phone: dto.phone,
        status: dto.status,
        updated_at: DateTime.now(),
      );

      await database.update(
        tableName: tableNameX,
        connection: connection,
        newObject: newUser.toMap(),
        fromJsonT: UserDB.fromJson,
      );
      await connection.close();

      return newUser.copyWithX(
        password: '',
      );
    } catch (e) {
      throw BadRequestException(
        time: DateTime.now(),
        errorCode: 'bad-request',
      );
    }
  }

  @override
  Future<UserDB?> getUserByUsername(
    String username, {
    bool init = false,
  }) async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      final result = await database.getListEqual(
        tableName: tableNameX,
        connection: connection,
        parameters: {'username': username},
      );

      final users = result
          .map((element) => UserDB.fromMap(element.toColumnMap()))
          .toList();

      await connection.close();
      return users.first;
    } catch (e) {
      if (init) {
        return null;
      } else {
        throw DataBaseException(time: DateTime.now());
      }
    }
  }
}
