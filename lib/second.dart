import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:sqflite/sqflite.dart';

import 'first.dart';

class second extends StatefulWidget {

  Database? database;


  second(this.database,);

  @override
  State<second> createState() => _secondState();
}

class _secondState extends State<second> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  int size = 14;
  Color text_pic_color = Colors.black45;
  bool text_color = false;
  Color? text_bg_color;
  bool text_bg = false;
  Color? theme_color;
  bool themec = false;

  // FontWeight bold_text = FontWeight.bold;
  bool bold_text = false;
  bool italic = false;
  TextBaseline? text_line;
  bool under_line = false;

  int b = 0;

  @override
  Widget build(BuildContext context) {
    double statusbar = MediaQuery.of(context).padding.top;
    double topside = MediaQuery.of(context).size.height;
    double screen_size = topside - statusbar;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themec ? theme_color : Colors.blue,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: TextField(
          controller: t1,
          decoration: InputDecoration(
            hintText: "Edit title...",
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                String title, content;
                title = t1.text;
                content = t2.text;
                String sql =
                    "insert into note_book values ('$title','$content')";
                print("sql= ${sql}");
                int qry = await widget.database!.rawInsert(sql);
                print("qry = $qry");
                t1.text = "";
                t2.text = "";
                print("hi");
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return first(widget.database);
                  },
                ));
              },
              icon: Icon(Icons.save_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
      ),
      body: Container(
        color: themec ? theme_color : Colors.white,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: screen_size,
            margin: EdgeInsets.only(top: statusbar, left: 7, right: 7),
            child: SingleChildScrollView(
              child: TextField(controller: t2,
                style: TextStyle(
                    fontSize: size.toDouble(),
                    fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                    fontWeight: bold_text ? FontWeight.bold : FontWeight.normal,
                    textBaseline: under_line
                        ? TextBaseline.ideographic
                        : TextBaseline.alphabetic,
                    backgroundColor:
                        text_bg ? text_bg_color : Colors.transparent,
                    color: text_pic_color),
                minLines: 1,
                maxLines: 100,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "No content",
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 250,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("Theme & Color",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17)),
                          ),
                          Expanded(
                            flex: 5,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                theme(Colors.white, "none"),
                                theme(Colors.amber, ""),
                                theme(Colors.teal, ""),
                                theme(Colors.red, ""),
                                theme(Colors.blue, ""),
                                theme(Colors.black12, ""),
                                theme(Colors.orange, ""),
                              ],
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        color: Colors.white,
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.color_lens, size: 25),
              color: Colors.black45),
          //TODO  ---  Bold Text ---
          IconButton(
            onPressed: () {
              setState(() {
                bold_text = !bold_text;
              });
            },
            icon: Icon(
              Icons.format_bold,
              size: 25,
              color: bold_text ? Colors.blue : Colors.black45,
            ),
          ),
          //TODO  ---  Italic Text ---
          IconButton(
              onPressed: () {
                setState(() {
                  italic = !italic;
                });
              },
              icon: Icon(Icons.format_italic_outlined, size: 25),
              color: italic ? Colors.blue : Colors.black45),
          //TODO  --- Text Baseline---
          IconButton(
              onPressed: () {
                setState(() {
                  under_line = !under_line;
                });
              },
              icon: Icon(Icons.format_underline, size: 25),
              color: under_line ? Colors.blue : Colors.black45),
          //TODO  --- TextBack Ground Color ---
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                builder: (context) {
                  return SizedBox(
                      height: 400,
                      child: ColorPicker(
                          pickerAreaHeightPercent: 0.5,
                          onColorChanged: (value) {
                            setState(() {
                              text_bg_color = value;
                              text_bg = true;
                            });
                          }, pickerColor: Colors.transparent,
                         ),);
                },
                context: context,
              );
            },
            icon: Icon(
              Icons.text_format_outlined,
              size: 25,
              color: (text_bg = true) ? text_bg_color : Colors.black45,
            ),
          ),
          //TODO  --- Text Color ---
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                builder: (context) {
                  return SizedBox(
                      height: 200,
                      child: MaterialPicker(
                        onColorChanged: (value) {
                          setState(() {
                            text_pic_color = value;
                          });
                        },
                        pickerColor: Colors.blue,
                      ));
                },
                context: context,
              );
            },
            icon: Icon(
              Icons.invert_colors_on,
              size: 25,
              color: text_pic_color,
            ),
          ),
          DropdownButton(
            dropdownColor: Colors.black12,
            elevation: 20,
            iconEnabledColor: Colors.black45,
            icon: Icon(Icons.keyboard_arrow_down),
            style: TextStyle(
              color: Colors.black45,
            ),
            value: size,
            onChanged: (value) {
              setState(() {
                size = value as int;
              });
            },
            items: [
              DropdownMenuItem(child: Text("10"), value: 10),
              DropdownMenuItem(child: Text("12"), value: 12),
              DropdownMenuItem(child: Text("14"), value: 14),
              DropdownMenuItem(child: Text("16"), value: 16),
              DropdownMenuItem(child: Text("18"), value: 18),
              DropdownMenuItem(child: Text("20"), value: 20),
              DropdownMenuItem(child: Text("22"), value: 22),
              DropdownMenuItem(child: Text("24"), value: 24),
              DropdownMenuItem(child: Text("26"), value: 26),
            ],
          ),
          SizedBox(
            width: 10,
          )
        ]),
      ),
    );
  }

  theme(Color c, String s) {
    return InkWell(
      onTap: () {
        setState(() {
          theme_color = c;
          themec = true;
        });
      },
      child: Container(
        margin: EdgeInsets.all(1),
        child: Center(child: Text("${s}")),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          color: c,
        ),
        // height: 50,
        width: 200,
      ),
    );
  }
}
