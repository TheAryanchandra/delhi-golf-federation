import 'dart:io';
import 'package:flutter/foundation.dart';

/// SSL Certificate Override for Debug Mode
/// This allows the app to bypass SSL certificate verification during development
/// NEVER use in production!
class SSLOverride {
  /// Configure HttpClient to accept all certificates in debug mode
  static void enableDebugSSLBypass() {
    if (kDebugMode) {
      HttpOverrides.global = _DebugHttpOverrides();
      print('🔓 SSL Certificate Verification DISABLED (Debug Mode Only)');
    }
  }
}

/// Custom HttpOverrides that bypasses certificate verification
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
