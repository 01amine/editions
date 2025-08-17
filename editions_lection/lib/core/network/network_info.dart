import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final InternetConnection connectionChecker;

  NetworkInfoImpl({
    required this.connectivity,
    required this.connectionChecker,
  });

  @override
  Future<bool> get isConnected async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }

      final hasInternet = await connectionChecker.hasInternetAccess
          .timeout(const Duration(seconds: 10));
      return hasInternet;
    } catch (e) {
      print('Network check error: $e');

      return false;
    }
  }
}
