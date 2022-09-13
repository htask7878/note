import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;


import 'first.dart';

void main() {
  runApp(MaterialApp(
    home: slplash(),
  ));
}

class slplash extends StatefulWidget {
  const slplash({Key? key}) : super(key: key);

  @override
  State<slplash> createState() => _slplashState();
}

class _slplashState extends State<slplash> {
  Database? database;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      nt();
      slps();
    });

  }

  slps() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return first(database);
    },));
  }
  nt() async {
    var databasesPath = await getDatabasesPath();
    String path = Path.join(databasesPath, 'dp.db');

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE note_book (title TEXT,content TEXT)');
        });
    print(database);
  }


  @override
  Widget build(BuildContext context) {
    // double statusbar = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Ink(
        color: Colors.blue,
        child: Center(
            child: Image.asset(
          "my_img/splash.png",
          scale: 4,
          height: 100,
          width: 100,
        )),
      ),
    );
  }
}
