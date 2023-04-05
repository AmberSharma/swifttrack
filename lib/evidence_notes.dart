import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:swifttrack/image_detail_screen.dart';
import 'package:swifttrack/inc/base_constants.dart';
import 'package:swifttrack/pdf_detail_screen.dart';

import 'inc/custom_snack_bar.dart';
import 'inc/file_picker_camera.dart';
import 'inc/show_custom_dialog_popup.dart';

class EvidenceNotes extends StatefulWidget {
  const EvidenceNotes({super.key});

  @override
  State<EvidenceNotes> createState() => _EvidenceNotesState();
}

class _EvidenceNotesState extends State<EvidenceNotes> {
  List files = [];
  late final List _platformFile;

  @override
  void initState() {
    super.initState();
    _platformFile = [];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Center(
                        child: Text(
                          "1.1 Use reliable, up to date information to plan tug operations",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  TabBar(
                    indicatorColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    // indicatorWeight: 5,
                    isScrollable: true,
                    tabs: [
                      Container(
                        // color: Colors.grey,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.zoom_in,
                                color: Colors.black,
                                size: 30.0,
                              ),
                              Text(
                                BaseConstants.evidenceLabel,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.description,
                              color: Colors.black,
                              size: 30.0,
                            ),
                            Text(
                              BaseConstants.notesLabel,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          title: const Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 4,
              children: [
                ...files.map(
                  (file) => Stack(
                    fit: StackFit.expand,
                    // alignment: AlignmentDirectional.topEnd,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Image border
                        child: file.indexOf('pdf##') != 0
                            ? GestureDetector(
                                child: Image.asset(
                                  "images/pdf-icon.jpg",
                                  fit: BoxFit.fill,
                                ),
                                onTap: () {
                                  print(file.split("##")[1]);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return PdfDetailScreen(
                                          pdfUrl: file.split("##")[1],
                                        );
                                      },
                                    ),
                                  );
                                },
                              )
                            : GestureDetector(
                                child: Hero(
                                  tag: 'imageHero',
                                  child: Image.file(
                                    File(file),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return ImageDetailScreen(
                                          imageUrl: file,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            padding: EdgeInsets.zero,
                            height: 30,
                            width: 30,
                            child: GestureDetector(
                                onTap: () {
                                  var fileIndex = files.indexOf(file);
                                  setState(() {
                                    files.removeAt(fileIndex);
                                    _platformFile.removeAt(fileIndex);
                                  });
                                },
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                  size: 30.0,
                                ))),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffE5E5E5),
                    ),
                    color: const Color(0xffE5E5E5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 50.0,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      var allowedExtensions = ['jpg', 'pdf', 'jpeg', 'png'];
                      var imageExtensions = ['jpg', 'png', 'jpeg'];

                      final filesList = await showCustomDialogPopup<String?>(
                          context, const FilePickerOrCamera());
                      //print(filesList);
                      if (filesList != null && filesList[0]['name'] == "file") {
                        FilePickerResult filesPicked = filesList[0]['data'];

                        for (var element in filesPicked.files) {
                          setState(() {
                            print(files.length);
                            if (files.length == 7) {
                              const CustomSnackBar(
                                      data: "Maximum 7 files can be added")
                                  .showSnackBar(context);
                            } else {
                              if (allowedExtensions
                                  .contains(element.extension)) {
                                if (element.extension == 'pdf') {
                                  files.add("filepdf##${element.path}");
                                } else {
                                  files.add(element.path.toString());
                                }
                                print(files);
                                _platformFile.add(element);
                              } else {
                                const CustomSnackBar(
                                        data:
                                            "Only .jpg, .jpeg, .png and .pdf are allowed")
                                    .showSnackBar(context);
                              }
                            }
                          });
                        }
                      }

                      if (filesList != null &&
                          filesList[0]['name'] == "camera") {
                        final file = filesList[0]["data"];
                        setState(() {
                          if (files.length == 7) {
                            const CustomSnackBar(
                                    data: "Maximum 7 files can be added")
                                .showSnackBar(context);
                          } else {
                            files.add(file.path.toString());
                            _platformFile.add(file);
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
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
                              "I enjoyed doing this task. It was really interesting to learn how to plan operations and put it into practice.",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Column(
                        //   children: [
                        //     Padding(
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 10.0),
                        //       child: TextButton(
                        //         onPressed: () {},
                        //         style: ButtonStyle(
                        //             shape: MaterialStateProperty.all<
                        //                 RoundedRectangleBorder>(
                        //               RoundedRectangleBorder(
                        //                 borderRadius:
                        //                     BorderRadius.circular(5.0),
                        //                 side: BorderSide(color: Colors.black),
                        //               ),
                        //             ),
                        //             backgroundColor: MaterialStateProperty.all(
                        //                 Colors.black)),
                        //         child: const Text(
                        //           "Annabelle Watson",
                        //           style: TextStyle(
                        //               fontSize: 15,
                        //               color: Colors.white,
                        //               fontWeight: FontWeight.normal),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
          ],
        ),
      ),
    );
  }
}
