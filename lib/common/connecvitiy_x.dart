import 'package:connectivity_plus/connectivity_plus.dart';

extension ConnectivityX on Connectivity {
  bool isOnline(List<ConnectivityResult>? res) => ConnectivityResult.values
      .where((e) => e != ConnectivityResult.none)
      .any((e) => res?.contains(e) == true);
}
