class BaseConstants {
  static const homeLabel = "Home";
  static const reviewsLabel = "Reviews";
  static const resourcesLabel = "Resources";
  static const evidenceLabel = "Evidence";
  static const notesLabel = "Notes & reflections";
  static const addEvidenceLabel = "Add evidence";
  static const addFromCameraLabel = "Add from camera";
  static const addAFileLabel = "Add a file";
  static const addAudioLabel = "Add audio";
  static const participantsLabel = "participants";
  static const logoutLabel = "logout";
  static const viewProgressLabel = "View progress";
  static const viewProfileLabel = "View profile";

  // URLS

  static const baseUrl = "https://api.swifttrack.app/";
  static const baseWebUrl = "https://swifttrack.app/";
  static const firebaseStoragePath =
      "https://firebasestorage.googleapis.com/v0/b/swifttrack-dam-27fda.appspot.com/o/";
  static const firebaseFileAlt = "?alt=media";
  static const firebaseParticipants = "participants";
  static const getInfoUrl = "get/user-info/";
  static const getDashboardUrl = "get/dashboard/";
  static const getModuleUrl = "get/module/";
  static const getResourcesUrl = "get/resources/";

  static const progressUrl = "progress/{user_id}/template/";

  // Fields
  static const uuid = "uuid";
  static const username = "user_name";

  // Firebase Table
  static const userModuleSettings = "user_module_settings";
  static const moduleTasks = "module_tasks";

  // Random
  static const userModule = "user_module";

  //Dropdown
  static const imageType = {"INTERNAL": "internal", "EXTERNAL": "external"};

  //File Type
  static const filePdf = "filepdf";
  static const fileImage = "fileimage";
  static const fileVideo = "filevideo";
  static const fileAudio = "fileaudio";
}
