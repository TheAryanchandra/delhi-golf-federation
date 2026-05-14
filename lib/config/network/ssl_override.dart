import 'dart:io';
import 'package:flutter/foundation.dart';


class SSLOverride {

  static void enableDebugSSLBypass() {
    if (kDebugMode) {
      HttpOverrides.global = _DebugHttpOverrides();
      print('🔓 SSL Certificate Verification DISABLED (Debug Mode Only)');
    }
  }
}


class _DebugHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Always accept certificates in debug mode
        if (kDebugMode) {
          print('⚠️ Certificate bypassed for: $host:$port');
          return true;
        }
        return false;
      };
  }
}
