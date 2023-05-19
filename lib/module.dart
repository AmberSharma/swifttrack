import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth auth = FirebaseAuth.instance;
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

  Widget _dropdownList(moduleElement) {
    return SizedBox(
      width: 100.0,
      child: DropdownButtonFormField<String>(
        // isDense: true,
        isExpanded: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.unfold_more),
        ),
        // hint: Text('Please choose account type'),
        items: moduleElement.duration
            .split(",")
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "$value ${moduleElement.durationSuffix!}",
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }).toList(),
        icon:
            const Visibility(visible: false, child: Icon(Icons.arrow_downward)),
        onChanged: (_) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Tabs Demo'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 20.0, 0.0),
            child: TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                FirebaseFirestore.instance.settings =
                    const Settings(persistenceEnabled: false);

                try {
                  for (var item in moduleElementListItems) {
                    if (item.type != "heading" &&
                        item.uuid == "a6e2c2b4-8bbd-4acd-8ed7-26a76dca90ed") {
                      CollectionReference collectionRef = FirebaseFirestore
                          .instance
                          .collection('user_module_settings');

                      Map<String, String> dataToSave = {
                        'dropdown_value': "1",
                        'record_id': item.uuid,
                        'user_id': auth.currentUser!.uid,
                        'flag': item.setLevel.toString()
                      };
                      collectionRef.add(dataToSave);
                    }
                  }
                } catch (error) {
                  print(error);
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
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
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (moduleElementListItems[index].type == "heading") ...[
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
                            flex: 3,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Html(
                                      data:
                                          "${moduleElementListItems[index].label}. ${moduleElementListItems[index].content}",
                                      // style: {
                                      //   "p": Style(
                                      //     padding: const EdgeInsets.all(0.0),
                                      //   ),
                                      // },
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Stack(children: [
                                          IconButton(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 12.0),
                                            constraints: const BoxConstraints(),
                                            iconSize: 25,
                                            icon: const Icon(
                                              Icons.zoom_in,
                                              // color: Colors.orange,
                                            ),
                                            // the method which is called
                                            // when button is pressed
                                            onPressed: () {
                                              // if (moduleElementListItems[index]
                                              //     .note
                                              //     .isNotEmpty) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EvidenceNotes(
                                                    tabNumber: 0,
                                                    moduleId:
                                                        moduleElementListItems[
                                                                index]
                                                            .uuid,
                                                    evidence:
                                                        moduleElementListItems[
                                                                index]
                                                            .evidence,
                                                    note:
                                                        moduleElementListItems[
                                                                index]
                                                            .note,
                                                  ),
                                                ),
                                              );
                                              // }
                                            },
                                          ),
                                          moduleElementListItems[index]
                                                  .note
                                                  .isNotEmpty
                                              ? Positioned(
                                                  left: 22,
                                                  top: 6,
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
                                                    child: Text(
                                                      moduleElementListItems[
                                                              index]
                                                          .note
                                                          .length
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ]),
                                        Stack(children: [
                                          IconButton(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 8.0),
                                            constraints: const BoxConstraints(),
                                            iconSize: 25,
                                            icon: const Icon(
                                              Icons.description,
                                              // color: Colors.orange,
                                            ),
                                            // the method which is called
                                            // when button is pressed
                                            onPressed: () {
                                              // if (moduleElementListItems[index]
                                              //     .evidence
                                              //     .isNotEmpty) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EvidenceNotes(
                                                    tabNumber: 1,
                                                    moduleId:
                                                        moduleElementListItems[
                                                                index]
                                                            .uuid,
                                                    evidence:
                                                        moduleElementListItems[
                                                                index]
                                                            .evidence,
                                                    note:
                                                        moduleElementListItems[
                                                                index]
                                                            .note,
                                                  ),
                                                ),
                                              );
                                              // }
                                            },
                                          ),
                                          moduleElementListItems[index]
                                                  .evidence
                                                  .isNotEmpty
                                              ? Positioned(
                                                  left: 22,
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
                                                    child: Text(
                                                      moduleElementListItems[
                                                              index]
                                                          .evidence
                                                          .length
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ]),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        moduleElementListItems[index]
                                                    .duration ==
                                                ""
                                            ? Container()
                                            : _dropdownList(
                                                moduleElementListItems[index]),
                                        moduleElementListItems[index]
                                                    .duration ==
                                                ""
                                            ? Container()
                                            : Text(
                                                "${moduleElementListItems[index].points!} points",
                                                style: const TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 40,
                                  thickness: 2,
                                  indent: 20,
                                  //endIndent: 0,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                IconButton(
                                  iconSize: 35,
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: getLevelColor(
                                        moduleElementListItems[index]),
                                  ),
                                  // the method which is called
                                  // when button is pressed
                                  onPressed: () {
                                    var level =
                                        moduleElementListItems[index].setLevel;
                                    var firstSelectableValue = '';
                                    var inFlag = 0;
                                    for (var i = 0;
                                        i < moduleLevelListItems.length;
                                        i++) {
                                      if (moduleLevelListItems[i].selectable !=
                                          0) {
                                        if (firstSelectableValue.isEmpty) {
                                          firstSelectableValue =
                                              moduleLevelListItems[i].level;
                                        }

                                        if (level == null ||
                                            int.parse(moduleLevelListItems[i]
                                                    .level) >
                                                level) {
                                          level = int.parse(
                                              moduleLevelListItems[i].level);
                                          inFlag = 1;
                                          break;
                                        }
                                      }
                                    }
                                    if (inFlag == 0) {
                                      level = int.parse(firstSelectableValue);
                                    }
                                    setState(() {
                                      moduleElementListItems[index].setLevel =
                                          level;
                                    });
                                  },
                                ),
                                ...moduleLevelListItems.map<Widget>((element) {
                                  return getFormattedLevelText(
                                      moduleElementListItems[index], element);
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
          ],
        ),
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
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const Login();
          },
        ),
        (Route route) => false,
      );
    }
  }

  getLevelColor(ModuleElement moduleElementListItem) {
    if (moduleElementListItem.setLevel == null) {
      return const Color(0xFFE0E0E0);
    }
    for (var i = 0; i < moduleLevelListItems.length; i++) {
      if (moduleLevelListItems[i].level ==
          moduleElementListItem.setLevel.toString()) {
        var color = moduleLevelListItems[i].color;
        return Color(int.parse(color));
      }
    }
  }

  Widget getFormattedLevelText(
      ModuleElement moduleElementListItem, ModuleLevel element) {
    return Text(
      element.name,
      style: TextStyle(
          fontSize: 12,
          color: moduleElementListItem.setLevel.toString() != element.level
              ? Colors.blueGrey
              : Colors.black,
          fontWeight: moduleElementListItem.setLevel.toString() != element.level
              ? FontWeight.normal
              : FontWeight.bold),
    );
  }
}
