import 'dart:io';
import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:swifttrack/classes/sound_recorder.dart';
import 'package:swifttrack/image_detail_screen.dart';
import 'package:swifttrack/inc/base_constants.dart';
import 'package:swifttrack/model/evidence.dart';
import 'package:swifttrack/model/note.dart';
import 'package:swifttrack/pdf_detail_screen.dart';

import 'inc/custom_snack_bar.dart';
import 'inc/file_picker_camera.dart';
import 'inc/show_custom_dialog_popup.dart';

class EvidenceNotes extends StatefulWidget {
  final int tabNumber;
  final String moduleId;
  final List<Evidence> evidence;
  final List<Note> note;
  const EvidenceNotes({
    super.key,
    required this.tabNumber,
    required this.moduleId,
    required this.evidence,
    required this.note,
  });

  @override
  State<EvidenceNotes> createState() => _EvidenceNotesState();
}

class _EvidenceNotesState extends State<EvidenceNotes> {
  List files = [];
  late final List _platformFile;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _platformFile = [];

    for (var item in widget.evidence) {
      files.add(item.url);
    }
  }

  TabBar get _tabBar => TabBar(
        isScrollable: true,
        // indicatorSize: TabBarIndicatorSize.label,
        indicator: const BoxDecoration(
            //borderRadius: BorderRadius.circular(50),
            color: Color.fromARGB(255, 196, 194, 194)),
        tabs: [
          Tab(
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
      );

  Widget getGestureButtonWithIcon(file) {
    //if (file.indexOf('image##') != -1) {
    var imagePath = file.indexOf('image##') != -1 ? file.split("##")[1] : file;
    var gestureButton = GestureDetector(
      child: Hero(
        tag: 'imageHero${Random().nextInt(1000)}',
        child: Image.file(
          File(
            imagePath,
          ),
          fit: BoxFit.cover,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ImageDetailScreen(
                imageUrl: imagePath,
              );
            },
          ),
        );
      },
    );
    //}
    if (file.indexOf('pdf##') != -1) {
      gestureButton = GestureDetector(
        child: Image.asset(
          "images/pdf-icon.jpg",
          fit: BoxFit.fill,
        ),
        onTap: () {
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
      );
    }

    if (file.indexOf('audio##') != -1) {
      gestureButton = GestureDetector(
        child: const Icon(
          Icons.library_music,
          size: 50,
        ),
        onTap: () async {
          await player.play(DeviceFileSource(file.split("##")[1]));
          // await player.play(
          //   file.split("##")[1],
          // );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) {
          //       await player.play(file.split("##")[1], isLocal: true);
          //       // return PdfDetailScreen(
          //       //   pdfUrl: file.split("##")[1],
          //       // );
          //     },
          //   ),
          // );
        },
      );
    }

    return Stack(
      fit: StackFit.expand,
      // alignment: AlignmentDirectional.topEnd,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10), // Image border
            child: gestureButton),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.tabNumber,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[900],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                Container(
                  height: 50.0,
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Flexible(
                      child: Text(
                        "1.1 Use reliable, up to date information to plan tug operations",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.white,
                  child: Theme(
                    //<-- SEE HERE
                    data: ThemeData().copyWith(splashColor: Colors.redAccent),
                    child:
                        Align(alignment: Alignment.centerLeft, child: _tabBar),
                  ),
                ),
              ],
            ),

            // Align(
            //   alignment: AlignmentDirectional.centerStart,
            //   child: Column(
            //     children: [
            //       Container(
            //         decoration: const BoxDecoration(color: Colors.blue),
            //         child: const Padding(
            //           padding:
            //               EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            //           child: Center(
            //             child: Text(
            //               "1.1 Use reliable, up to date information to plan tug operations",
            //               style: TextStyle(fontSize: 18),
            //             ),
            //           ),
            //         ),
            //       ),
            //       Align(
            //         alignment: Alignment.centerLeft,
            //         child: TabBar(
            //           indicatorColor: Colors.white,
            //           unselectedLabelColor: Colors.grey,
            //           // indicatorWeight: 5,
            //           isScrollable: true,
            //           tabs: [
            //             Tab(
            //               child: Row(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: const [
            //                   Icon(
            //                     Icons.zoom_in,
            //                     color: Colors.black,
            //                     size: 30.0,
            //                   ),
            //                   Text(
            //                     BaseConstants.evidenceLabel,
            //                     style: TextStyle(color: Colors.black),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             Tab(
            //               child: Row(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: const [
            //                   Icon(
            //                     Icons.description,
            //                     color: Colors.black,
            //                     size: 30.0,
            //                   ),
            //                   Text(
            //                     BaseConstants.notesLabel,
            //                     style: TextStyle(color: Colors.black),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
          title: const Text('Close'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 20.0, 0.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  print(_platformFile);
                  print(files);
                  var prefs = await SharedPreferences.getInstance();
                  var username = prefs.getString(BaseConstants.username)!;
                  print(username);

                  Reference referenceRoot = _firebaseStorage.ref();
                  Reference referenceDirImages = referenceRoot
                      .child(BaseConstants.participantsLabel + "/" + username);

                  try {
                    for (var item in files) {
                      if (item.indexOf("##") != -1) {
                        item = item.split("##")[1];
                      }

                      String uniqueFileName =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);

                      TaskSnapshot taskSnapshot =
                          await referenceImageToUpload.putFile(File(item));
                      var imageUrl = await taskSnapshot.ref.getDownloadURL();
                      print(item);
                      print(imageUrl.toString());
                      print(referenceImageToUpload.name);
                      // CollectionReference collectionRef =
                      //     FirebaseFirestore.instance.collection('user_uploads');

                      // Map<String, String> dataToSave = {
                      //   'date': DateTime.now().toString(),
                      //   'module_id': widget.moduleId,
                      //   'session_id': auth.currentUser!.refreshToken.toString(),
                      //   'user_id': auth.currentUser!.uid,
                      //   'image_url': imageUrl.toString()
                      // };
                      // collectionRef.add(dataToSave);
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
                ...files.map((file) => getGestureButtonWithIcon(file)),
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
                      //var imageExtensions = ['jpg', 'png', 'jpeg'];

                      final filesList = await showCustomDialogPopup<String?>(
                          context, const FilePickerOrCamera());
                      // print(filesList);
                      if (filesList != null &&
                          filesList[0]['name'] == "file" &&
                          filesList[0]["data"] != null) {
                        FilePickerResult filesPicked = filesList[0]['data'];

                        for (var element in filesPicked.files) {
                          setState(() {
                            //print(files.length);
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
                                  files.add("fileimage##${element.path}");
                                }
                                //print(files);
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
                            files.add("fileimage##${file.path}");
                            _platformFile.add(file);
                          }
                        });
                      }

                      if (filesList != null &&
                          filesList[0]['name'] == "audio") {
                        final file = filesList[0]["data"];
                        setState(() {
                          if (files.length == 7) {
                            const CustomSnackBar(
                                    data: "Maximum 7 files can be added")
                                .showSnackBar(context);
                          } else {
                            files.add("fileaudio##$file");
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 9,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Text(
                              widget.note[index].content +
                                  "Check out the Flutter API docs to customize icon size and color. Check out the Flutter API docs to customize icon size and color.",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        widget.note[index].editable
                            ? Flexible(
                                flex: 1,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 20.0,
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {},
                                ),
                              )
                            : Container()
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            widget.note[index].author == null ||
                                    widget.note[index].author!.isEmpty
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: TextButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
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
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.note[index].date),
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
              itemCount: widget.note.length,
            ),
          ],
        ),
      ),
    );
  }
}
