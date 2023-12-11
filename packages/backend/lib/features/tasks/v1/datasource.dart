// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:backend/core/database/database_helper.dart';
import 'package:backend/core/models/res/failure_res/failure_res.dart';
import 'package:backend/core/models/res/failure_res/res_500.dart';
import 'package:backend/features/tasks/v1/task_dto.dart';
import 'package:either_dart/either.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/models/tasks/v1/task_v1.dart';
import 'package:uuid/uuid.dart';

///
abstract class TaskV1DataSource {
  ///
  Future<Either<FailureResponse, List<TaskV1>>> getTasks({
    required bool Function(TaskV1) condition,
  });

  ///
  Future<Either<FailureResponse, TaskV1>> getTaskByID(String id);

  ///
  Future<Either<FailureResponse, TaskV1>> createTask(
    TaskDto createTaskDto,
  );

  // ///
  Future<Either<FailureResponse, TaskV1>> updateTask(
    TaskDto task,
    String uid,
  );

  ///
  Future<Either<FailureResponse, bool>> deleteTaskByID(String id);
}

class TaskV1DataSourceImpl implements TaskV1DataSource {
  final PostgresDbHelper database = PostgresDbHelper();
  static const String tableNameX = 'taskV1Test';
  TaskV1DataSourceImpl();

  @override
  Future<Either<FailureResponse, TaskV1>> getTaskByID(String id) async {
    try {
      final conn = await Connection.open(
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
        connection: conn,
        parameters: {'uid': id},
      );
      final tasks = result.map((e) => TaskV1.fromMap(e.toColumnMap())).toList();
      return Right(tasks.first);
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        Response500(time: DateTime.now()),
      );
    }
  }

  @override

  ///{orCondition :  {value: [key1, key2]}}
  Future<Either<FailureResponse, List<TaskV1>>> getTasks({
    required bool Function(TaskV1) condition,
  }) async {
    try {
      final conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      final result = await database.getList(
        tableName: tableNameX,
        connection: conn,
      );
      final tasks = result.map((e) => TaskV1.fromMap(e.toColumnMap())).toList()
        ..retainWhere(condition);
      return Right(tasks);
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        Response500(time: DateTime.now()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, TaskV1>> createTask(
    TaskDto createTaskDto,
  ) async {
    final newTask = TaskV1(
      uid: const Uuid().v4(),
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      title: createTaskDto.title,
      content: createTaskDto.content,
      status: createTaskDto.status,
    );
    try {
      final conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      await database.insert<TaskV1>(
        tableName: tableNameX,
        connection: conn,
        newObject: newTask,
      );
      return Right(
        newTask,
      );
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        Response500(time: DateTime.now()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, TaskV1>> updateTask(
    TaskDto task,
    String uid,
  ) async {
    try {
      final taskDb = await getTaskByID(uid);
      if (taskDb.isLeft) {
        return Left(
          Response500(time: DateTime.now()),
        );
      } else {
        final conn = await Connection.open(
          Endpoint(
            host: 'localhost',
            database: 'postgres',
            username: 'user',
            password: 'pass',
          ),
          settings: const ConnectionSettings(sslMode: SslMode.disable),
        );
        final newTask = TaskV1(
          status: task.status,
          title: task.title,
          content: task.content,
          uid: uid,
          created_at: taskDb.right.created_at,
          updated_at: DateTime.now(),
        );
        await database.update<TaskV1>(
          tableName: tableNameX,
          connection: conn,
          newObject: newTask.toMap(),
          fromJsonT: TaskV1.fromJson,
        );
        await conn.close();
        return Right(newTask);
      }
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        Response500(time: DateTime.now()),
      );
    }
  }

  @override
  Future<Either<FailureResponse, bool>> deleteTaskByID(String id) async {
    try {
      final conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'postgres',
          username: 'user',
          password: 'pass',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );
      await conn.execute(
        Sql.named('DELETE FROM $tableNameX WHERE uid=@uid'),
        parameters: {'uid': id},
      );
      await conn.close();
      return const Right(true);
    } catch (e, stacktree) {
      print('Err $e, StackTree $stacktree');

      return Left(
        Response500(time: DateTime.now()),
      );
    }
  }
}
