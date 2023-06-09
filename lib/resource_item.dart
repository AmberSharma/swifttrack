import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swifttrack/classes/video_player.dart';
import 'package:swifttrack/evidence_notes.dart';
import 'package:swifttrack/image_detail_screen.dart';
import 'package:swifttrack/inc/base_constants.dart';
import 'package:swifttrack/model/level.dart';
import 'package:swifttrack/model/module_element.dart';
import 'package:swifttrack/model/resource_element.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:swifttrack/pdf_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class ResourceItem extends StatefulWidget {
  final String resourceName;
  final List<ResourceElement> resourceElement;
  const ResourceItem(
      {super.key, required this.resourceName, required this.resourceElement});

  @override
  State<ResourceItem> createState() => _ResourceItemState();
}

class _ResourceItemState extends State<ResourceItem> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<ModuleElement> moduleElementListItems = [];
  List<ModuleLevel> moduleLevelListItems = [];
  List levelColor = [];
  String dropdownValue = list.first;
  final List<String> items = List<String>.generate(8, (i) => 'Item $i');
  bool additionalFlag = true;

  List changedSections = [];

  @override
  void initState() {
    super.initState();
    //getModuleInfo();
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
        title: const Text('Back'),
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
                    color: Colors.blue,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.resourceName,
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
                return Column(children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  8.0, 20.0, 0.0, 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.resourceElement[index].title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  8.0, 10.0, 0.0, 8.0),
                              child: Text(
                                widget.resourceElement[index].content
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.resourceElement[index].mediaUrl != null &&
                              widget.resourceElement[index].mediaUrl!.isNotEmpty
                          ? Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  getMediaBasedOnType(
                                      widget.resourceElement[index].mediaType,
                                      widget.resourceElement[index].mediaUrl),
                                ],
                              ),
                            )
                          : Container()
                    ],
                  )
                ]);
              },
              itemCount: widget.resourceElement.length,
            ),
          ],
        ),
      ),
    );
  }

  getMediaBasedOnType(mediaType, mediaUrl) {
    switch (mediaType) {
      case "1":
        // do something
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: Image.network(
              BaseConstants.firebaseStoragePath +
                  mediaUrl +
                  BaseConstants.firebaseFileAlt,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return ImageDetailScreen(
                      imageUrl: BaseConstants.firebaseStoragePath +
                          mediaUrl +
                          BaseConstants.firebaseFileAlt,
                      imageType: "external",
                    );
                  },
                ),
              );
            },
          ),
        );
      case "2":
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: const Icon(
              Icons.videocam,
              color: Colors.black,
              size: 50,
            ),
            onTap: () {
              Navigator.push(
                context,
                // Create the SelectionScreen in the next step.
                MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                          videoUrl: BaseConstants.firebaseStoragePath +
                              mediaUrl +
                              BaseConstants.firebaseFileAlt,
                        )),
              );
            },
          ),
        );
      case "3":
        AudioPlayer player = AudioPlayer();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: const Icon(
              Icons.play_circle,
              color: Colors.black,
              size: 50,
            ),
            onTap: () async {
              await player.play(DeviceFileSource(
                  BaseConstants.firebaseStoragePath +
                      mediaUrl +
                      BaseConstants.firebaseFileAlt));
            },
          ),
        );
      case "4":
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              child: Image.asset('images/pdf-icon.jpg'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return PdfDetailScreen(
                        pdfType: "external",
                        pdfUrl: BaseConstants.firebaseStoragePath +
                            mediaUrl +
                            BaseConstants.firebaseFileAlt,
                      );
                    },
                  ),
                );
              }),
        );
      case "5":
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              child: const Icon(
                Icons.description,
                color: Colors.black,
                size: 50,
              ),
              onTap: () async {
                final url = Uri.parse(BaseConstants.firebaseStoragePath +
                    mediaUrl +
                    BaseConstants.firebaseFileAlt);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  throw 'Unable to open url : $url';
                }
              }),
        );
      default:
        // do something else
        return Container();
    }
  }
}
