// ignore_for_file: leading_newlines_in_multiline_strings, unnecessary_cast, avoid_dynamic_calls, lines_longer_than_80_chars, inference_failure_on_collection_literal, public_member_api_docs

import 'package:backend/core/exception/database_exceptions.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/models/model_db.dart';

class PostgresDbHelper {
  PostgresDbHelper();

  ///
  Future<Result> createTableIfNotExist<T extends ModelDb>({
    required String tableName,
    required Connection connection,
    required T objectDb,
  }) async {
    final parameters = objectDb.toMap() as Map<String, dynamic>;
    final queries = <String>[];
    for (final key in parameters.keys) {
      switch (parameters[key].runtimeType) {
        case int:
          queries.add(' $key INTEGER NOT NULL ');
        case bool:
          queries.add(' $key BOOL NOT NULL ');
        default:
          queries.add(' $key TEXT NOT NULL ');
      }
    }

    final queryString = '''
    CREATE TABLE IF NOT EXISTS $tableName (
    ${queries.join(",")}
    )
    ''';

    final result = await connection.execute(
      queryString,
    );
    return result;
  }

  ///
  Future<Result> getListEqual({
    required String tableName,
    required Connection connection,
    Map<String, dynamic> parameters = const {},
  }) async {
    final queries = <String>[];
    for (final key in parameters.keys) {
      queries.add(
        '$key=@$key',
      );
    }
    final paramString = queries.join(',');

    final queryString =
        'SELECT * FROM $tableName ${queries.isEmpty ? "" : "WHERE $paramString"}';

    final result = await connection.execute(
      Sql.named(queryString),
      parameters: parameters,
    );
    await connection.close();
    return result;
  }

  // NEED TEST!!!
  ///
  Future<Result> getListLike({
    required String tableName,
    required Connection connection,
    required String query,

    ///OR / AND
    required String condition,
    required Map<String, String> parameters,
  }) async {
    final queryString = 'SELECT * FROM $tableName WHERE $condition';

    final result = await connection.execute(
      Sql.named(queryString),
      parameters: parameters,
    );
    await connection.close();
    return result;
  }

  Future<Result> getList({
    required String tableName,
    required Connection connection,
  }) async {
    final queryString = 'SELECT * FROM $tableName';

    final result = await connection.execute(
      Sql.named(queryString),
    );
    await connection.close();
    return result;
  }

  // NEED TEST!!!
  ///
  Future<Result> insert<T extends ModelDb>({
    required String tableName,
    required Connection connection,
    required T newObject,
  }) async {
    await createTableIfNotExist(
      tableName: tableName,
      connection: connection,
      objectDb: newObject,
    );
    final keyString = newObject.toMap().keys.join(',');
    final keyParams = <String>[];
    final valueParams = [];
    for (var i = 0; i <= newObject.toMap().keys.length - 1; i++) {
      keyParams.add(r'$' '${i + 1}');
      valueParams.add(newObject.toMap()[newObject.toMap().keys.toList()[i]]);
    }

    newObject.toMap().keys.map((e) => '@$e').toList().join(',');
    final queryString =
        'INSERT INTO $tableName ( $keyString ) VALUES ( ${keyParams.join(",")} )';

    final result = await connection.execute(
      queryString,
      parameters: valueParams,
    );

    await connection.close();
    return result;
  }

  // NEED TEST!!!
  ///
  Future<Result?> update<T extends ModelDb>({
    required String tableName,
    required Connection connection,
    required Map<String, dynamic> newObject,
    required T Function(String source) fromJsonT,
  }) async {
    final result = await connection.execute(
      Sql.named('SELECT * FROM $tableName WHERE uid=@uid'),
      parameters: {'uid': newObject['uid']},
    );

    if (result.isEmpty) {
      await connection.close();
      throw NotFoundException(time: DateTime.now().toIso8601String());
    } else {
      final queries = <String>[];
      for (final key in newObject.keys) {
        if (key != 'uid' && key != 'created_at') {
          queries.add(
            '$key=@$key',
          );
        }
      }
      final paramString = queries.join(',');

      final queryString = 'UPDATE $tableName SET $paramString WHERE uid=@uid';

      final updateResult = await connection.execute(
        Sql.named(queryString),
        parameters: newObject
          ..removeWhere(
            (key, value) => key == 'created_at',
          ),
      );

      await connection.close();
      return updateResult;
    }
  }

  ///
  Future<Result> delete<T extends ModelDb>({
    required String tableName,
    required Connection connection,
    required String uid,
  }) async {
    final result = await connection.execute(
      Sql.named('DELETE FROM $tableName WHERE uid=@uid'),
      parameters: {'uid': uid},
    );
    return result;
  }
}
