import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TestSQLite extends StatefulWidget {
  TestSQLite({Key key}) : super(key: key);

  @override
  _TestSQLiteState createState() => _TestSQLiteState();
}

class _TestSQLiteState extends State<TestSQLite> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Username"),
              TextField(
                controller: username,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter username'),
              ),
              Text("Password"),
              TextField(
                controller: password,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter password'),
              ),
              SizedBox(height: 10),
              RaisedButton(
                onPressed: () {
                  storeToSQlite();
                },
                color: Colors.blueAccent,
                child: Text("Submit", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
              RaisedButton(
                onPressed: () {
                  getListDataSQlite();
                },
                color: Colors.blueAccent,
                child: Text("Get list data",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> storeToSQlite() async {
    if (username.text != null && password.text != null) {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'demo.db');

      // open the database
      Database database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE User (id INTEGER PRIMARY KEY, username TEXT,  password TEXT)');
      });

      // Insert some records in a transaction
      await database.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO User(username, password) VALUES("${username.text}", "${password.text}")');
        print('inserted1: $id1');
      });
    }
  }

  Future<void> getListDataSQlite() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    Database database = await openDatabase(path);
    List<Map> list = await database.rawQuery('SELECT * FROM User');
    print(list);
  }
}
