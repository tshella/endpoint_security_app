import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  // Checks if the device is connected to the internet
  static Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
  }

  // Subscribes to network status changes
  static Stream<ConnectivityResult> get connectivityStream => Connectivity().onConnectivityChanged;
}
