import 'package:flutter_family_budget/domain/repository/LoginUserData.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LoginUserDataRepositoryImplementation
    implements ILoginUserDataRepository {
  final String _appSupportDirectory =
      r'C:\Users\kolxz\AndroidStudioProjects\flutter_family_budget\database';

  late final String path;
  late var _database;
  final databaseFactory = databaseFactoryFfi;

  LoginUserDataRepositoryImplementation() {
    sqfliteFfiInit();
    path = "$_appSupportDirectory\\family_budget.db";
  }

  @override
  Future<bool> checkEnteredDate(String userLogin, String userPassword) async {
    _database = await databaseFactory.openDatabase(path);
    final List<Map<String, dynamic>> map = await _database.query('members');
    for (var item in map) {
      if (item["name"] == userLogin && item["password"] == userPassword) {
        return true;
      }
    }
    await _database.close();
    return false;
  }

  @override
  Future<Map<String, dynamic>> getEnteredUser(
      String userLogin, String userPassword) async {
    _database = await databaseFactory.openDatabase(path);
    final List<Map<String, dynamic>> map = await _database.query('members');
    for (var item in map) {
      if (item["name"] == userLogin && item["password"] == userPassword) {
        return item;
      }
    }
    await _database.close();
    throw UnimplementedError();
  }
}
