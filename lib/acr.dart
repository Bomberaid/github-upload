import 'package:flutter_acrcloud/flutter_acrcloud.dart';

// Used to get around session limitation in local scopes.
class Acr {
  ACRCloudSession session;

  void createSession() {
    session = ACRCloud.startSession();
  }

  void endSession() {
    if (session != null) {
      session.cancel();
    }
  }
}
