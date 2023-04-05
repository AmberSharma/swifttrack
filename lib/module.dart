import 'package:flutter/material.dart';
import 'package:swifttrack/evidence_notes.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class Module extends StatefulWidget {
  final Color moduleColor;
  const Module({super.key, required this.moduleColor});

  @override
  State<Module> createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  String dropdownValue = list.first;
  final List<String> items = List<String>.generate(8, (i) => 'Item $i');

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
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Assesment module 47 Direct tug operations",
                        style: TextStyle(
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
                        Container(
                          color: Colors.grey[300],
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "1. Be Able to direct preparations for tug operations",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "1.1 Use reliable, up to date information to plan tug operations",
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
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
                                      DropdownButton<String>(
                                        value: dropdownValue,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String? value) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            dropdownValue = value!;
                                          });
                                        },
                                        items: list
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                      const Text(
                                        "15 points",
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
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
                                    iconSize: 50,
                                    icon: const Icon(
                                      Icons.check_circle,
                                      color: Colors.orange,
                                    ),
                                    // the method which is called
                                    // when button is pressed
                                    onPressed: () {},
                                  ),
                                  const Text(
                                    "Aware",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const Text("Processing"),
                                  const Text("Satisfactory"),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    );
                  },
                  itemCount: items.length,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
