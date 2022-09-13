import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sqflite/sqflite.dart';

import 'second.dart';
import 'update.dart';

class first extends StatefulWidget {
  Database? database;

  first(this.database);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  List title = [];
  List content = [];

  Future get() async {
    String sql = "SELECT * FROM note_book";
    List<Map> lm = await widget.database!.rawQuery(sql);
    return lm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SUPER NOTE"),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        actions: [
          IconButton(
              onPressed: () {
                // showSearch(delegate: ,context: context)
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                // showSearch(delegate: ,context: context)
              },
              icon: Icon(Icons.cloud_upload_outlined)),
          PopupMenuButton(
            offset: Offset(10, 55),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("First")),
              PopupMenuItem(child: Text("Second")),
              PopupMenuItem(child: Text("Thirid")),
            ],
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        curve: Curves.bounceIn,
        overlayColor: Colors.black45,
        overlayOpacity: 0.4,
        children: [
          SpeedDialChild(
            child: Image.asset(
              "my_img/checklist.png",
              scale: 2.5,
            ),
            label: "Checklist",
            foregroundColor: Colors.white,
            labelBackgroundColor: Colors.black,
            labelStyle: TextStyle(color: Colors.white),
            backgroundColor: Colors.blue,
          ),
          SpeedDialChild(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return second(widget.database);
                },
              ));
            },
            child: Image.asset("my_img/note.png"),
            label: "Note",
            foregroundColor: Colors.white,
            labelBackgroundColor: Colors.black,
            labelStyle: TextStyle(color: Colors.white),
            backgroundColor: Colors.blue,
          ),
        ],
      ),
      body: Center(
          child: FutureBuilder(
              future: get(),
              builder: (context, snapshot) {
                title.clear();
                content.clear();
                if (snapshot.connectionState == ConnectionState.done) {
                  // print("hellohellohellohellohellohellohellohellohello");
                  List? list;
                  if (snapshot.hasData) {
                    // print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
                    list = snapshot.data as List<Map>;
                    list.forEach((element) {
                      title.add(element['title']);
                      content.add(element['content']);
                    });
                  }
                  return list!.isEmpty
                      ? InkWell(
                          child: Image.asset(
                            "my_img/create_note.png",
                            scale: 2.5,
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return second(widget.database);
                              },
                            ));
                          },
                        )
                      : ListView.builder(
                          itemCount: title.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onLongPress: () {
                                showDialog(
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Delete"),
                                        actions: [
                                          Text(
                                            "Are you sure! you want to delete this note ",
                                            textAlign: TextAlign.center,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "cancel",
                                                    textAlign: TextAlign.center,
                                                  )),
                                              TextButton(
                                                  onPressed: () async {
                                                    String sql =
                                                        "delete from note_book where title='${title[index]}'";
                                                    await widget.database!
                                                        .rawDelete(sql);
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                    "delete",
                                                    textAlign: TextAlign.center,
                                                  ))
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                    context: context);
                              },
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Update(widget.database, title[index],
                                        content[index]);
                                  },
                                ));
                              },
                              title: Text("${title[index]}"),
                              leading: Icon(Icons.note_alt_sharp, size: 25),
                            );
                          },
                        );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                        color: Colors.blue, strokeWidth: 2),
                  );
                }
              })),
    );
  }
}
