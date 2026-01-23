import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:url_launcher/url_launcher.dart';

SizedBox hSpace({double height = 10}) {
  return SizedBox(height: height);
}

SizedBox wSpace({double width = 10}) {
  return SizedBox(width: width);
}

TextStyle textStyle({
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  String fontFamily = AppFonts.interRegular,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    fontFamily: fontFamily,
  );
}

enum toastType { success, error, info }

Future<void> showToast(String message, {required toastType type}) async {
  try {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: type == toastType.error 
          ? Colors.red 
          : type == toastType.success 
              ? Colors.green 
              : Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } catch (e) {
    debugPrint('Toast error: $e');
  }
}

/// Opens an external URL in a new browser tab (web) or external browser (mobile)
/// 
/// This function handles URL validation, platform-specific behavior, and error handling.
/// It's designed to work reliably on both localhost and production deployments.
/// 
/// Parameters:
/// - [url]: The URL to open. If it doesn't start with http:// or https://, 
///          https:// will be automatically prepended.
/// 
/// Returns:
/// - [bool]: true if the URL was successfully launched, false otherwise
/// 
/// Example usage:
/// ```dart
/// onTap: () async {
///   await openExternalLink('meet.google.com/abc-defg-hij');
/// }
/// ```
Future<bool> openExternalLink(String url) async {
  try {
    // Validate and format URL
    String formattedUrl = url.trim();
    
    // Check if URL is empty
    if (formattedUrl.isEmpty) {
      debugPrint('❌ Cannot open empty URL');
      await showToast('Invalid link', type: toastType.error);
      return false;
    }
    
    // Add https:// if no protocol is specified
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }
    
    // Parse URL
    final Uri uri = Uri.parse(formattedUrl);
    
    // Validate URI
    if (!uri.hasScheme || uri.host.isEmpty) {
      debugPrint('❌ Invalid URL format: $formattedUrl');
      await showToast('Invalid link format', type: toastType.error);
      return false;
    }
    
    debugPrint('🔗 Attempting to open: $formattedUrl');
    
    // Launch URL with platform-specific behavior
    // Web: Opens in new tab
    // Mobile: Opens in external browser
    final bool launched = await launchUrl(
      uri,
      mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
      webOnlyWindowName: '_blank', // Force new tab on web
    );
    
    if (launched) {
      debugPrint('✅ Successfully opened: $formattedUrl');
      return true;
    } else {
      debugPrint('❌ Failed to launch: $formattedUrl');
      await showToast('Could not open link', type: toastType.error);
      return false;
    }
  } catch (e) {
    debugPrint('❌ Error opening URL: $e');
    await showToast('Failed to open link: ${e.toString()}', type: toastType.error);
    return false;
  }
}