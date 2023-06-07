import 'package:sqflite/sqflite.dart' as sql;

class AccountDbHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE account(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        csrftoken TEXT NOT NULL,
        sessionid TEXT NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'studenthub.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> saveCred(
      String email, String password, String csrftoken, String sessionid) async {
    final db = await AccountDbHelper.db();
    await db.rawDelete("DELETE FROM account");
    final data = {
      'email': email,
      'password': password,
      'csrftoken': csrftoken,
      'sessionid': sessionid
    };
    final id = await db.insert('account', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print("Saved Cred with id: $id");

    return id;
  }

  Future<Map<String, dynamic>?> getCred(String email) async {
    var result;
    final db = await AccountDbHelper.db();
    final response = await db.query('account',
        where: "email = ?", whereArgs: [email], limit: 1);
    if (response.length == 1) {
      result = response[0];
    }
    return result;
  }

  static Future<Map<String, dynamic>?> getCurrentUserCred() async {
    Map<String, Object?>? result;
    final db = await AccountDbHelper.db();
    final response = await db.query('account');
    print("response: $response");
    if (response.isNotEmpty) {
      result = response.last;
    }
    return result;
  }

  static Future<bool> clearAccountTable() async {
    try {
      final db = await AccountDbHelper.db();
      await db.rawDelete("DELETE FROM account");
      return true;
    } catch (e) {
      print("SOmething went Wrong in clearAccountTable: $e");
    }
    return false;
  }

  static getAllCred() async {
    final db = await AccountDbHelper.db();
    final data = await db.rawQuery("SELECT * FROM account");
    print(data);
  }
  // // Update an item by id
  // static Future<int> updateItem(
  //     int id, String title, String? descrption) async {
  //   final db = await AccountDbHelper.db();

  //   final data = {
  //     'title': title,
  //     'description': descrption,
  //     'createdAt': DateTime.now().toString()
  //   };

  //   final result =
  //       await db.update('items', data, where: "id = ?", whereArgs: [id]);
  //   return result;
  // }

  // // Delete
  // static Future<void> deleteItem(int id) async {
  //   final db = await AccountDbHelper.db();
  //   try {
  //     await db.delete("items", where: "id = ?", whereArgs: [id]);
  //   } catch (err) {
  //     debugPrint("Something went wrong when deleting an item: $err");
  //   }
  // }
}
