// import 'dart:io';

// class NetworkChecker {
//   /// Very simple check - attempts to lookup a well-known domain.
//   /// Returns true when the device has internet access.
//   static Future<bool> hasConnection() async {
//     try {
//       final result = await InternetAddress.lookup('example.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } on SocketException {
//       return false;
//     }
//   }
// }

import 'dart:io';

class NetworkChecker {
  static Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 4));

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
