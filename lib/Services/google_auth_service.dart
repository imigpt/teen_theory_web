import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/calendar',
    ],
  );

  GoogleSignInAccount? _currentUser;
  String? _accessToken;

  GoogleSignInAccount? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isSignedIn => _currentUser != null;

  /// Initialize and attempt silent sign-in
  Future<void> initialize() async {
    try {
      _currentUser = await _googleSignIn.signInSilently();
      if (_currentUser != null) {
        await _refreshAccessToken();
      }
    } catch (e) {
      debugPrint('Error during silent sign-in: $e');
    }
  }

  /// Sign in with Google
  Future<GoogleSignInAccount?> signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser != null) {
        await _refreshAccessToken();
      }
      return _currentUser;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      _accessToken = null;
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  /// Refresh access token
  Future<String?> _refreshAccessToken() async {
    try {
      final GoogleSignInAuthentication auth = await _currentUser!.authentication;
      _accessToken = auth.accessToken;
      return _accessToken;
    } catch (e) {
      debugPrint('Error refreshing access token: $e');
      return null;
    }
  }

  /// Get current access token (refresh if needed)
  Future<String?> getAccessToken() async {
    if (_currentUser == null) {
      return null;
    }

    try {
      final GoogleSignInAuthentication auth = await _currentUser!.authentication;
      _accessToken = auth.accessToken;
      return _accessToken;
    } catch (e) {
      debugPrint('Error getting access token: $e');
      return null;
    }
  }

  /// Check if user is signed in and has valid token
  Future<bool> checkAuthStatus() async {
    if (_currentUser == null) {
      return false;
    }

    try {
      final token = await getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
