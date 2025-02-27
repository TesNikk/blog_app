import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker{
  Future<bool> get isConnected;
}
class ConnectionCheckerImpl implements ConnectionChecker{
  final InternetConnection internetConnection;
  ConnectionCheckerImpl(this.internetConnection);
  @override
  Future<bool> get isConnected async => await internetConnection.hasInternetAccess;
  // final listener = InternetConnection().onStatusChange.listen((InternetStatus status) {
  //   switch (status) {
  //     case InternetStatus.connected:
  //     // The internet is now connected
  //       break;
  //     case InternetStatus.disconnected:
  //     // The internet is now disconnected
  //       break;
  //   }
  // });
}