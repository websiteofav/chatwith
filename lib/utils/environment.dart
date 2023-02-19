import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get giphyKey {
    return dotenv.get('GIPHY_KEY', fallback: '');
  }

  static String get agoraAppId {
    return dotenv.get('AGORA_APP_ID', fallback: '');
  }

  static String get agoraAppCertificateId {
    return dotenv.get('AGORA_APP_CERTIFICATE_ID', fallback: '');
  }

  static String get goServerUrl {
    return dotenv.get('GO_SERVER_URL', fallback: '');
  }
}
