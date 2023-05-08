import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifttrack/evidence_notes.dart';
import 'package:swifttrack/login.dart';
import 'package:swifttrack/model/element_list.dart';
import 'package:swifttrack/model/level.dart';
import 'package:swifttrack/model/level_list.dart';
import 'package:swifttrack/model/module_element.dart';
import 'inc/base_constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class Module extends StatefulWidget {
  final Color moduleColor;
  final String moduleUUID;
  final String moduleName;
  const Module(
      {super.key,
      required this.moduleColor,
      required this.moduleUUID,
      required this.moduleName});

  @override
  State<Module> createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  List<ModuleElement> moduleElementListItems = [];
  List<ModuleLevel> moduleLevelListItems = [];
  List levelColor = [];
  String dropdownValue = list.first;
  final List<String> items = List<String>.generate(8, (i) => 'Item $i');

  @override
  void initState() {
    super.initState();
    getModuleInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Tabs Demo'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                // flex: 1,
                child: Container(
                  color: widget.moduleColor,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.moduleName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 400,
                margin: const EdgeInsets.only(top: 20),
                child: ListView.builder(
                  // shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        if (moduleElementListItems[index].type ==
                            "heading") ...[
                          Container(
                            color: Colors.grey[300],
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Html(
                                    data:
                                        "<b>${moduleElementListItems[index].label}.</b>&nbsp;&nbsp;${moduleElementListItems[index].content}",
                                    style: {
                                      "b": Style(
                                          //fontWeight: FontWeight.bold,
                                          fontSize: FontSize.large,
                                          color: Colors.black),
                                    },
                                  )

                                  // Text(
                                  //   moduleElementListItems[index].content,
                                  //   //"1. Be Able to direct preparations for tug operations",
                                  //   style: const TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 22,
                                  //     color: Colors.black,
                                  //   ),
                                  // ),
                                  ),
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Html(
                                          data:
                                              "${moduleElementListItems[index].label}. ${moduleElementListItems[index].content}",
                                          style: {
                                            "p": Style(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                            ),
                                          },
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Stack(children: [
                                              IconButton(
                                                iconSize: 25,
                                                icon: const Icon(
                                                  Icons.zoom_in,
                                                  // color: Colors.orange,
                                                ),
                                                // the method which is called
                                                // when button is pressed
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const EvidenceNotes(),
                                                    ),
                                                  );
                                                },
                                              ),

                                              // AppBarAction.notificationCounter !=
                                              //         0
                                              //     ?
                                              Positioned(
                                                right: 2,
                                                top: 2,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  constraints:
                                                      const BoxConstraints(
                                                    minWidth: 14,
                                                    minHeight: 14,
                                                  ),
                                                  child: const Text(
                                                    "15",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              //: Container(),
                                            ]),
                                            Stack(children: [
                                              IconButton(
                                                iconSize: 25,
                                                icon: const Icon(
                                                  Icons.description,
                                                  // color: Colors.orange,
                                                ),
                                                // the method which is called
                                                // when button is pressed
                                                onPressed: () {},
                                              ),
                                              Positioned(
                                                right: 2,
                                                top: 2,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  constraints:
                                                      const BoxConstraints(
                                                    minWidth: 14,
                                                    minHeight: 14,
                                                  ),
                                                  child: const Text(
                                                    "15",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              //: Container(),
                                            ]),
                                          ],
                                        ),
                                        moduleElementListItems[index]
                                                    .duration ==
                                                ""
                                            ? Container()
                                            : Row(
                                                children: [
                                                  DropdownButton<String>(
                                                    //value: dropdownValue,
                                                    icon: const Icon(
                                                        Icons.arrow_downward),
                                                    elevation: 16,
                                                    style: const TextStyle(
                                                        color:
                                                            Colors.deepPurple),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                    ),
                                                    onChanged: (String? value) {
                                                      print(value);
                                                      // This is called when the user selects an item.
                                                      // setState(() {
                                                      //   dropdownValue = value!;
                                                      // });
                                                    },
                                                    items: moduleElementListItems[
                                                            index]
                                                        .duration
                                                        .split(",")
                                                        .map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                  Text(
                                                    "${moduleElementListItems[index].points!} points",
                                                    style: const TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    IconButton(
                                      iconSize: 40,
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: getLevelColor(
                                            moduleElementListItems[index]),
                                      ),
                                      // the method which is called
                                      // when button is pressed
                                      onPressed: () {
                                        var level =
                                            moduleElementListItems[index]
                                                .setLevel;
                                        var firstSelectableValue = '';
                                        var inFlag = 0;
                                        for (var i = 0;
                                            i < moduleLevelListItems.length;
                                            i++) {
                                          if (moduleLevelListItems[i]
                                                  .selectable !=
                                              0) {
                                            if (firstSelectableValue.isEmpty) {
                                              firstSelectableValue =
                                                  moduleLevelListItems[i].level;
                                            }

                                            if (level == null ||
                                                int.parse(
                                                        moduleLevelListItems[i]
                                                            .level) >
                                                    level) {
                                              level = int.parse(
                                                  moduleLevelListItems[i]
                                                      .level);
                                              inFlag = 1;
                                              break;
                                            }
                                          }
                                        }
                                        if (inFlag == 0) {
                                          level =
                                              int.parse(firstSelectableValue);
                                        }
                                        setState(() {
                                          moduleElementListItems[index]
                                              .setLevel = level;
                                        });
                                      },
                                    ),
                                    ...moduleLevelListItems
                                        .map<Widget>((element) {
                                      return getFormattedLevelText(
                                          moduleElementListItems[index],
                                          element);
                                    }).toList(),
                                    // moduleLevelListItems
                                    //     .asMap()
                                    //     .entries
                                    //     .map((entry) {
                                    //   print(entry);
                                    //   // Text(
                                    //   //   entry.name,
                                    //   //   style: TextStyle(
                                    //   //       fontWeight: FontWeight.bold),
                                    //   // );
                                    // }),
                                    // const Text(
                                    //   "Aware",
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // const Text("Processing"),
                                    // const Text("Satisfactory"),
                                  ],
                                ),
                              )
                            ],
                          )
                        ]
                      ],
                    );
                  },
                  itemCount: moduleElementListItems.length,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getModuleInfo() async {
    print(widget.moduleUUID);
    var prefs = await SharedPreferences.getInstance();
    var uuid = prefs.getString(BaseConstants.uuid)!;
    // ignore: unused_local_variable
    var url =
        "${BaseConstants.baseUrl}${BaseConstants.getModuleUrl}${widget.moduleUUID}/$uuid/1/";
    print(url);
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print(responseData["data"]["elements"]);
      //   // var responseData = jsonDecode(
      //   // '{"status":"success","status_msg":"","type":1,"data":{"assessments":[{"name":"Competency name 1","uuid":"2eb97b3a-dcc4-4b18-977b-4926f17c1772","points_target":150,"points_earned":50,"modules":[{"name":"Assessment module 47 Direct tug operations 1","uuid":"5ca1637d-9098-4e9e-90a1-b8ea788c8938","points_target":15,"points_earned":50,"points_spill":0,"prog_1_title":"Aware","prog_1_color":"#f0c600","prog_1_count":5,"prog_2_title":"Progressing","prog_2_color":"#2475ad","prog_2_count":2,"prog_3_title":"Satisfactory","prog_3_color":"#67b931","prog_3_count":1,"color":"#ff0000","perc":null,"disabled_levels":""},{"name":"Example learning module","uuid":"8f482277-0c5b-4642-b579-dd10456fc5b2","points_target":10,"points_earned":50,"points_spill":0,"prog_1_title":"Aware","prog_1_color":"#f0c600","prog_1_count":5,"prog_2_title":"Progressing","prog_2_color":"#2475ad","prog_2_count":2,"prog_3_title":"Satisfactory","prog_3_color":"#67b931","prog_3_count":1,"color":"#2475ad","perc":null,"disabled_levels":""}]},{"name":"Competency name 2","uuid":"a79db0cc-e707-4141-a6a3-1b141deeae98","points_target":100,"points_earned":50,"modules":[{"name":"Another Example learning module 2 name","uuid":"9g982342-3c5b-4642-b579-dd10456fc5b2","points_target":15,"points_earned":50,"points_spill":0,"prog_1_title":"Aware","prog_1_color":"#f0c600","prog_1_count":5,"prog_2_title":"Progressing","prog_2_color":"#2475ad","prog_2_count":2,"prog_3_title":"Satisfactory","prog_3_color":"#67b931","prog_3_count":1,"color":"#ff6600","perc":null,"disabled_levels":""},{"name":"Assessment module 47 Direct tug operations 2","uuid":"b82785f2-a5a7-4b2c-97b0-16be0d43e5f0","points_target":15,"points_earned":50,"points_spill":0,"prog_1_title":"Aware","prog_1_color":"#f0c600","prog_1_count":5,"prog_2_title":"Progressing","prog_2_color":"#2475ad","prog_2_count":2,"prog_3_title":"Satisfactory","prog_3_color":"#67b931","prog_3_count":1,"color":"#ccff73","perc":null,"disabled_levels":""}]}]}}');
      if (responseData["status"] == "error") {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Login();
            },
          ),
          (Route route) => false,
        );
      } else {
        final moduleElementList =
            ElementList.fromJson(responseData["data"]["elements"]);
        final moduleLevelList =
            LevelList.fromJson(responseData["data"]["levels"]);

        setState(() {
          moduleElementListItems = moduleElementList.moduleElement;
          moduleLevelListItems = moduleLevelList.level;
          moduleLevelListItems.asMap().entries.map((entry) {
            print(entry);
          });
          //print(moduleLevelListItems);
        });
      }
    }
    //else {
    //   Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (BuildContext context) {
    //         return const Login();
    //       },
    //     ),
    //     (Route route) => false,
    //   );
    // }
  }

  getLevelColor(ModuleElement moduleElementListItem) {
    for (var i = 0; i < moduleLevelListItems.length; i++) {
      if (moduleLevelListItems[i].level ==
          moduleElementListItem.setLevel.toString()) {
        return Color(int.parse(moduleLevelListItems[i].color));
      }
    }
  }

  Widget getFormattedLevelText(
      ModuleElement moduleElementListItem, ModuleLevel element) {
    return Text(
      element.name,
      style: TextStyle(
          color: moduleElementListItem.setLevel.toString() != element.level
              ? Colors.blueGrey
              : Colors.black,
          fontWeight: moduleElementListItem.setLevel.toString() != element.level
              ? FontWeight.normal
              : FontWeight.bold),
    );
  }
}
