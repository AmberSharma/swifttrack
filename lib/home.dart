import 'package:flutter/material.dart';
import 'package:swifttrack/inc/base_constants.dart';
import 'package:swifttrack/module.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                      children: const [
                        Text(
                          "Competancy Name 1",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: const [
                        Text(
                          "Points: 25/100",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Module(
                                    moduleColor: Colors.orange,
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: const BorderSide(
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange),
                            ),
                            child: const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Example learning module 1",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                        // Text(
                        //   "Example learning module",
                        //   style: TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: const [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "10/20",
                                  style: TextStyle(
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
                                children: const [
                                  Text(
                                    "Aware: 4",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Processing: 2",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Satisfactory: 0",
                                    style: TextStyle(
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
                    Container(
                      // height: 40,
                      color: Colors.lightBlueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: const [
                            Flexible(
                              child: Text(
                                "Assessment module 47 Direct tug operations",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
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
                            children: const [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "10/20",
                                  style: TextStyle(
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
                                children: const [
                                  Text(
                                    "Aware: 4",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Processing: 2",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Satisfactory: 0",
                                    style: TextStyle(
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
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: ['A', 'B'].length,
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
            const Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
