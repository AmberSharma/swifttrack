import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifttrack/inc/base_constants.dart';
import 'package:swifttrack/login.dart';
import 'package:swifttrack/model/assessment.dart';
import 'package:swifttrack/model/assessment_list.dart';
import 'package:swifttrack/module.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Assessment> assessmentListItems = [];

  @override
  void initState() {
    super.initState();
    getDashboardInfo();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: TabBar(
                // indicatorWeight: 5,
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                      BaseConstants.homeLabel,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      BaseConstants.reviewsLabel,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      BaseConstants.resourcesLabel,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          title: const Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(8),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          assessmentListItems[index].name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "${"Points: ${assessmentListItems[index].pointsEarned}"}/${assessmentListItems[index].pointsRequired}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ListView.builder(
                      itemCount: assessmentListItems[index].module.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int moduleIndex) {
                        return Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Module(
                                      moduleColor: Color(
                                        int.parse(assessmentListItems[index]
                                            .module[moduleIndex]
                                            .color),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    // side: const BorderSide(
                                    //   color: Colors.orange,
                                    // ),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  Color(
                                    int.parse(assessmentListItems[index]
                                        .module[moduleIndex]
                                        .color),
                                  ),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  assessmentListItems[index]
                                      .module[moduleIndex]
                                      .name,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${assessmentListItems[index].module[moduleIndex].pointsEarned}/${assessmentListItems[index].module[moduleIndex].pointsRequired}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "${assessmentListItems[index].module[moduleIndex].progress1}: ${assessmentListItems[index].module[moduleIndex].progress1Count}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${assessmentListItems[index].module[moduleIndex].progress2}: ${assessmentListItems[index].module[moduleIndex].progress2Count}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${assessmentListItems[index].module[moduleIndex].progress3}: ${assessmentListItems[index].module[moduleIndex].progress3Count}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: assessmentListItems.length,
            ),
            // const Icon(Icons.directions_car),
            ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 15.0),
                            child: Text(
                              "Well done, Steve. You have applied yourself well this year",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.black)),
                                child: const Text(
                                  "Annabelle Watson",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("9:32am on 12 Mar 2023"),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: ['A', 'B', 'C'].length,
            ),
            Accordion(
              maxOpenSections: 1,
              contentBorderColor: Colors.black,
              headerBackgroundColor: Colors.grey,
              headerBorderRadius: 1,
              contentBorderRadius: 1,
              // headerTextStyle: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              // leftIcon: const Icon(Icons.audiotrack, color: Colors.white),
              children: [
                AccordionSection(
                  isOpen: false,
                  header: const Text('Introduction: Using the app',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                  content:
                      const Text('This is the introduction right here ...'),
                ),
                AccordionSection(
                  isOpen: true,
                  header: const Text('Evidence required',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                  content: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: ['A', 'B', 'C'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        color: Colors.amber,
                        child: const Center(child: Text('Entry')),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
                // AccordionSection(
                //   isOpen: true,
                //   header: const Text('Company Info',
                //       style: TextStyle(color: Colors.white, fontSize: 17)),
                //   content:
                //       Icon(Icons.airplay, size: 70, color: Colors.green[200]),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getDashboardInfo() async {
    var prefs = await SharedPreferences.getInstance();
    var uuid = prefs.getString(BaseConstants.uuid)!;
    var url = "${BaseConstants.baseUrl}${BaseConstants.getDashboardUrl}$uuid/";

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print(responseData);
      // var responseData = jsonDecode(
      // '{"status":"success","status_msg":"","type":1,"data":{"assessments":[{"name":"Competency name 1","uuid":"2eb97b3a-dcc4-4b18-977b-4926f17c1772","points_target":150,"points_earned":50,"modules":[{"name":"Assessment module 47 Direct tug operations 1","uuid":"5ca1637d-9098-4e9e-90a1-b8ea788c8938","points_target":15,"points_earned":50,"points_spill":0,"prog_1_title":"Aware","prog_1_color":"#f0c600","prog_1_count":5,"prog_2_title":"Progressing","prog_2_color":"#2475ad","prog_2_count":2,"prog_3_title":"Satisfactory","prog_3_color":"#67b931","prog_3_count":1,"color":"#ff0000","perc":null,"disabled_levels":""},{"name":"Example learning module","uuid":"8f482277-0c5b-4642-b579-dd10456fc5b2","points_target":10,"points_earned":50,"points_spill":0,"prog_1_title":"Aware","prog_1_color":"#f0c600","prog_1_count":5,"prog_2_title":"Progressing","prog_2_color":"#2475ad","prog_2_count":2,"prog_3_title":"Satisfactory","prog_3_color":"#67b931","prog_3_count":1,"color":"#2475ad","perc":null,"disabled_levels":""}]},{"name":"Competency name 2","uuid":"a79db0cc-e707-4141-a6a3-1b141deeae98","points_target":100,"points_earned":50,"modules":[{"name":"Another Example learning module 2 name","uuid":"9g982342-3c5b-4642-b579-dd10456fc5b2","points_target":15,"points_earned":50,"points_spill":0,"prog_1_title":"Aware","prog_1_color":"#f0c600","prog_1_count":5,"prog_2_title":"Progressing","prog_2_color":"#2475ad","prog_2_count":2,"prog_3_title":"Satisfactory","prog_3_color":"#67b931","prog_3_count":1,"color":"#ff6600","perc":null,"disabled_levels":""},{"name":"Assessment module 47 Direct tug operations 2","uuid":"b82785f2-a5a7-4b2c-97b0-16be0d43e5f0","points_target":15,"points_earned":50,"points_spill":0,"prog_1_title":"Aware","prog_1_color":"#f0c600","prog_1_count":5,"prog_2_title":"Progressing","prog_2_color":"#2475ad","prog_2_count":2,"prog_3_title":"Satisfactory","prog_3_color":"#67b931","prog_3_count":1,"color":"#ccff73","perc":null,"disabled_levels":""}]}]}}');
      if (responseData["status"] == "error") {
        print("Here");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Login();
            },
          ),
          (Route route) => false,
        );
      } else {
        final assessmentList =
            AssessmentList.fromJson(responseData["data"]["assessments"]);

        setState(() {
          assessmentListItems = assessmentList.assessments;
        });
      }
    }
  }
}
