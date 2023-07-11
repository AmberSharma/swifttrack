import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
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
import 'package:uuid/uuid.dart';

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
  bool? waitingForApiResponse = false;

  final FirebaseAuth auth = FirebaseAuth.instance;
  List<ModuleElement> moduleElementListItems = [];
  List<ModuleLevel> moduleLevelListItems = [];
  List levelColor = [];
  String dropdownValue = list.first;
  final List<String> items = List<String>.generate(8, (i) => 'Item $i');
  int additionalFlag = 1;

  List changedSections = [];

  TextEditingController taskDescriptionController = TextEditingController();
  TextEditingController taskPointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getModuleInfo();
  }

  Widget _dropdownList(moduleElement) {
    print(moduleElement.duration);
    print(moduleElement.setDuration);
    var dropdownItems = moduleElement.duration.split(",");
    var pointItems = moduleElement.points.split(",");
    dropdownItems.insert(0, "");
    pointItems.insert(0, "0");

    return SizedBox(
      width: 70.0,
      child: DropdownButtonFormField<String>(
        // isDense: true,
        isExpanded: true,
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.unfold_more),
            prefixIconConstraints: BoxConstraints(maxWidth: 40)),
        value: moduleElement.setDuration,
        // hint: Text('Please choose account type'),
        items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
          // print(value);
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              "$value ${moduleElement.durationSuffix!}",
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          );
        }).toList(),
        icon:
            const Visibility(visible: false, child: Icon(Icons.arrow_downward)),
        onChanged: (value) {
          setState(() {
            moduleElement.setDuration = value.toString();
            // if (!changedSections.contains(moduleElement.uuid)) {
            //   changedSections.add(moduleElement.uuid);
            // }

            var index = dropdownItems.indexOf(value.toString());
            print(pointItems[index]);
            moduleElement.setPoints = int.parse(pointItems[index]);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 126, 199),
        //title: const Text('Tabs Demo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                  // looping through all the module elements
                  for (var i = 0; i < moduleElementListItems.length; i++) {
                    var item = moduleElementListItems[i];

                    // Get inside only if the current element has changed
                    if (item.type != "heading" &&
                        changedSections.contains(item.uuid)) {
                      // Create an instance of Firebase Module collection
                      CollectionReference collectionRef = FirebaseFirestore
                          .instance
                          .collection(BaseConstants.userModuleSettings);

                      var prefs = await SharedPreferences.getInstance();

                      var dateTimeNow = DateFormat('yyyy-MM-dd kk:mm:ss')
                          .format(DateTime.now());
                      Map<String, String> dataToSave = {
                        'duration': item.setDuration.toString(),
                        'record_id': item.uuid,
                        'firebase_user_id': auth.currentUser!.uid,
                        'user_id':
                            prefs.getString(BaseConstants.uuid).toString(),
                        'level': item.setLevel.toString(),
                        'updated': dateTimeNow
                      };

                      // SharedPreferences.getInstance().then((data) {
                      //   data.getKeys().forEach((key) {
                      //     print(key);
                      //     print(data.get(key));
                      //   });
                      // });
                      var savedModuleData = jsonDecode(
                          prefs.getString(BaseConstants.userModule).toString());

                      if (savedModuleData[i]
                              .containsKey("firebase_collection_id") &&
                          savedModuleData[i]["firebase_collection_id"]
                              .isNotEmpty) {
                        collectionRef
                            .doc(savedModuleData[i]["firebase_collection_id"])
                            .update(dataToSave);
                      } else {
                        DocumentReference docRef =
                            await collectionRef.add(dataToSave);
                        print(docRef.id);

                        savedModuleData[i]["firebase_collection_id"] =
                            docRef.id;

                        // prefs.setString(
                        //     "user_module_${item.uuid}", jsonEncode(element));
                      }

                      savedModuleData[i]["updated"] = dateTimeNow;
                      savedModuleData[i]["set_duration"] = item.setDuration;
                      savedModuleData[i]["set_level"] = item.setLevel;

                      print(savedModuleData[i]);
                      prefs.setString(BaseConstants.userModule,
                          jsonEncode(savedModuleData));
                      //collectionRef.update(dataToSave);
                    }
                  }
                } catch (error) {
                  print(error);
                }
              },
              child: Row(
                children: const [
                  Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.check, color: Colors.white),
                ],
              ),
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
                                    "<b>${moduleElementListItems[index].label}</b>&nbsp;&nbsp;${moduleElementListItems[index].content}",
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
                      if (moduleElementListItems[index].type == "additional" &&
                          additionalFlag == 1) ...[
                        additionalSection(),
                      ],
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
                                          "${moduleElementListItems[index].label} ${moduleElementListItems[index].content}",
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
                                              ).then((_) {
                                                getModuleInfo();
                                                setState(() {});
                                              });
                                              // }
                                            },
                                          ),
                                          moduleElementListItems[index]
                                                  .evidence
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
                                              ).then((_) {
                                                getModuleInfo();
                                                setState(() {});
                                              });
                                              // }
                                            },
                                          ),
                                          moduleElementListItems[index]
                                                  .note
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
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        moduleElementListItems[index].points ==
                                                ""
                                            ? Container()
                                            : Text(
                                                "${moduleElementListItems[index].setPoints!} points",
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
                                      if (!changedSections.contains(
                                          moduleElementListItems[index].uuid)) {
                                        changedSections.add(
                                            moduleElementListItems[index].uuid);
                                      }
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

      // print(responseData["data"]["elements"]);
      // print(responseData["data"]["elements"].length);
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
        if (!prefs.containsKey(BaseConstants.userModule)) {
          prefs.setString(BaseConstants.userModule,
              jsonEncode(responseData["data"]["elements"]));
        }

        var savedModuleData =
            jsonDecode(prefs.getString(BaseConstants.userModule).toString());

        var serverElementData = responseData["data"]["elements"];
        for (int i = 0; i < serverElementData.length; i++) {
          var itemIndex = savedModuleData
              .indexWhere((e) => e['uuid'] == serverElementData[i]['uuid']);

          if (itemIndex == -1) {
            savedModuleData.insert(i, serverElementData[i]);
            itemIndex = i;
          }
          if (savedModuleData[itemIndex].isNotEmpty) {
            // Set updated date to created date if not set
            // Else set to current date if both are not set
            savedModuleData[itemIndex]["updated"] = savedModuleData[itemIndex]
                    ["updated"] ??
                savedModuleData[itemIndex]["created"] ??
                DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now());

            serverElementData[i]["updated"] = serverElementData[i]["updated"] ??
                serverElementData[i]["created"];

            if (serverElementData[i]["updated"] == null ||
                DateTime.parse(savedModuleData[itemIndex]["updated"])
                    .isAfter(DateTime.parse(serverElementData[i]["updated"]))) {
              serverElementData[i] = savedModuleData[itemIndex];

              if (savedModuleData[itemIndex]["evidence"] != null) {
                for (int k = 0;
                    k < savedModuleData[itemIndex]["evidence"].length;
                    k++) {
                  print(savedModuleData[itemIndex]["evidence"][k]);
                }
              }
            } else {
              if (savedModuleData[itemIndex]
                      .containsKey("firebase_collection_id") &&
                  savedModuleData[itemIndex]["firebase_collection_id"]
                      .isNotEmpty) {
                FirebaseFirestore.instance
                    .collection(BaseConstants.userModuleSettings)
                    .doc(savedModuleData[itemIndex]["firebase_collection_id"])
                    .delete();
              }
              savedModuleData[itemIndex] = responseData["data"]["elements"][i];

              prefs.setString(
                  BaseConstants.userModule, jsonEncode(savedModuleData));
            }
          } else {
            savedModuleData.insert(i, serverElementData);
            prefs.setString(
                BaseConstants.userModule, jsonEncode(savedModuleData));
          }
        }

        // for (int i = 0; i < responseData["data"]["elements"].length; i++) {
        //   if (prefs.containsKey(
        //       '${BaseConstants.userModule}_${responseData["data"]["elements"][i]["uuid"]}')) {
        //     var specificModuleData = jsonDecode(prefs
        //         .getString(
        //             '${BaseConstants.userModule}_${responseData["data"]["elements"][i]["uuid"]}')
        //         .toString());

        //     specificModuleData["updated"] = specificModuleData["updated"] ??
        //         specificModuleData["created"] ??
        //         DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now());
        //     responseData["data"]["elements"][i]["updated"] =
        //         responseData["data"]["elements"][i]["updated"] ??
        //             responseData["data"]["elements"][i]["created"];

        //     if (responseData["data"]["elements"][i]["updated"] == null ||
        //         DateTime.parse(specificModuleData["updated"]).isAfter(
        //             DateTime.parse(
        //                 responseData["data"]["elements"][i]["updated"]))) {
        //       responseData["data"]["elements"][i] = specificModuleData;
        //     } else {
        //       if (specificModuleData.containsKey("firebase_collection_id") &&
        //           specificModuleData["firebase_collection_id"].isNotEmpty) {
        //         FirebaseFirestore.instance
        //             .collection(BaseConstants.userModuleSettings)
        //             .doc(specificModuleData["firebase_collection_id"])
        //             .delete();
        //       }
        //       specificModuleData = responseData["data"]["elements"][i];

        //       prefs.setString(
        //           '${BaseConstants.userModule}_${specificModuleData["uuid"]}',
        //           jsonEncode(specificModuleData));
        //     }
        //   } else {
        //     prefs.setString(
        //         '${BaseConstants.userModule}_${responseData["data"]["elements"][i]["uuid"]}',
        //         jsonEncode(responseData["data"]["elements"][i]));
        //   }
        // }
        // List savedUserModuleArray = [];
        // prefs
        //     .getKeys()
        //     .where((String key) => key.contains(BaseConstants.userModule))
        //     .map((key) {
        //   savedUserModuleArray.add(jsonDecode(prefs.getString(key).toString()));
        // }).toList();
        //prefs.clear();

        final moduleElementList = ElementList.fromJson(savedModuleData);
        final moduleLevelList =
            LevelList.fromJson(responseData["data"]["levels"]);

        setState(() {
          moduleElementListItems = moduleElementList.moduleElement;
          moduleLevelListItems = moduleLevelList.level;
          // moduleElementListIte
          //ms.asMap().entries.map((entry) {
          //   print(entry);
          // });
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

  additionalSection() {
    additionalFlag = additionalFlag + 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 7.0, 12.0, 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Additional Tasks",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 111, 26, 20),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    "Additional Tasks Description this is testign abfvbf asff hjaf",
                    style: TextStyle(
                      fontSize: 16.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      // padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _dialogBuilder(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text('Add Task'),
                        Icon(Icons.add_task, color: Colors.blueAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return waitingForApiResponse == true
            ? const SpinKitRing(
                color: Colors.green,
              )
            : AlertDialog(
                title: const Text('Add Additional Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: taskDescriptionController,
                      decoration:
                          const InputDecoration(hintText: "Description"),
                      keyboardType: TextInputType.multiline,
                      minLines: 2, //Normal textInputField will be displayed
                      maxLines: 5,
                    ),
                    TextField(
                      controller: taskPointController,
                      decoration: const InputDecoration(hintText: "Points"),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Cancel'),
                        onPressed: () {
                          taskDescriptionController.clear();
                          taskPointController.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text('Save'),
                            Icon(Icons.check, color: Colors.blueAccent),
                          ],
                        ),
                        onPressed: () async {
                          setState(() {
                            waitingForApiResponse = true;
                          });
                          var prefs = await SharedPreferences.getInstance();
                          var uuid = prefs.getString(BaseConstants.uuid)!;

                          FirebaseFirestore.instance.settings =
                              const Settings(persistenceEnabled: false);

                          try {
                            CollectionReference collectionRef =
                                FirebaseFirestore.instance
                                    .collection(BaseConstants.moduleTasks);

                            var dateTimeNow = DateFormat('yyyy-MM-dd kk:mm:ss')
                                .format(DateTime.now());

                            Map<String, dynamic> dataToSave = {
                              'uuid': const Uuid().v4().toString(),
                              "type": "additional",
                              "label": null,
                              "content":
                                  taskDescriptionController.text.toString(),
                              "duration": null,
                              "duration_suffix": null,
                              "points": taskPointController.text.toString(),
                              "validated": null,
                              "set_level": null,
                              "set_points": int.parse(taskPointController.text),
                              "set_duration": null,
                              "created": dateTimeNow,
                              "updated": dateTimeNow,
                              "creator_uuid": uuid,
                              "creator_type": null,
                              'firebase_user_id': auth.currentUser!.uid,
                            };

                            DocumentReference docRef =
                                await collectionRef.add(dataToSave);
                            print(docRef.id);

                            var moduleElement =
                                ModuleElement.fromJson(dataToSave);

                            setState(() {
                              var savedModuleData = jsonDecode(prefs
                                  .getString(BaseConstants.userModule)
                                  .toString());
                              savedModuleData.add(dataToSave);

                              prefs.setString(BaseConstants.userModule,
                                  jsonEncode(savedModuleData));
                              moduleElementListItems.add(moduleElement);
                            });
                            // var prefs = await SharedPreferences.getInstance();

                            // SharedPreferences.getInstance().then((data) {
                            //   data.getKeys().forEach((key) {
                            //     print(key);
                            //     print(data.get(key));
                            //   });
                            // });
                            // var element = jsonDecode(prefs
                            //     .getString("${BaseConstants.userModule}_${item.uuid}")
                            //     .toString());
                            // print(element);
                            // if (element.containsKey("firebase_collection_id") &&
                            //     element["firebase_collection_id"].isNotEmpty) {
                            //   collectionRef
                            //       .doc(element["firebase_collection_id"])
                            //       .update(dataToSave);
                            // } else {
                            //   DocumentReference docRef =
                            //       await collectionRef.add(dataToSave);
                            //   print(docRef.id);

                            //   element["firebase_collection_id"] = docRef.id;

                            //   // prefs.setString(
                            //   //     "user_module_${item.uuid}", jsonEncode(element));
                            // }

                            // element["updated"] = dateTimeNow;
                            // element["duration"] = item.setDuration;
                            // element["set_level"] = item.setLevel;

                            // print(element);
                            // prefs.setString(
                            //     "${BaseConstants.userModule}_${item.uuid}",
                            //     jsonEncode(element));
                            // //collectionRef.update(dataToSave);

                            taskDescriptionController.clear();
                            taskPointController.clear();
                            Navigator.of(context).pop();
                            setState(() {
                              waitingForApiResponse = false;
                            });
                          } catch (error) {
                            print(error);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
      },
    );
  }
}
