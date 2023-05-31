import 'package:sqflite/sqflite.dart' as sql;

class AccountDbHelper {
  Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE account(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        csrftoken TEXT NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  Future<sql.Database> db() async {
    return sql.openDatabase(
      'studenthub.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  Future<int> saveCred(String email, String password, String csrftoken) async {
    final db = await this.db();

    final data = {'email': email, 'password': password, 'csrftoken': csrftoken};
    final id = await db.insert('account', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  Future<Map<String, dynamic>?> getCred(String email) async {
    var result;
    final db = await this.db();
    final response = await db.query('account',
        where: "email = ?", whereArgs: [email], limit: 1);
    if (response.length == 1) {
      result = response[0];
    }
    return result;
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
