    import 'dart:io';

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
        if (connectivityResult == ConnectivityResult.none) {
          return false;
        }

        try {
          final result = await InternetAddress.lookup('example.com')
              .timeout(const Duration(seconds: 3));

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          } else {
            return false;
          }
        } on SocketException catch (_) {
          return false;
        } on Exception catch (_) {
          return false;
        }
      }

      Future<bool> IsConnected() async {
        var connectivityResult = await _connectivity.checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          return false;
        }
        try {
          final result = await InternetAddress.lookup('example.com')
              .timeout(const Duration(seconds: 3));

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          } else {
            return false;
          }
        } on SocketException catch (_) {
          return false;
        } on Exception catch (_) {
          return false;
        }
      }
    }