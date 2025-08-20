  import 'package:connectivity_plus/connectivity_plus.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  final CheckInternetProvider = Provider<CheckInternet>((ref) {
    return CheckInternet(
    );
  });
  class CheckInternet {
    final Connectivity _connectivity = Connectivity();

    static Future<bool> isConnected() async {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    }
    Future<bool> IsConnected() async {
      var result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    }
  }