// ignore_for_file: file_names, unused_field, unused_element
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionDetector {
  static final ConnectionDetector _connectionDetector =
      ConnectionDetector._internal();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  static late StreamSubscription<List<ConnectivityResult>> subscription;

  final Connectivity _connectivity = Connectivity();

  factory ConnectionDetector() {
    return _connectionDetector;
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
  }

  ConnectionDetector._internal();

  static Future<bool> connectCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  static connectionListener(Function(bool) function) async {
    subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        function(true);
      } else {
        function(false);
      }
      // Got a new connectivity status!
    });
  }

  dispose() {
    subscription.cancel();
  }
}