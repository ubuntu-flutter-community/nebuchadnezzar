import 'package:matrix/matrix.dart';

extension UserX on User {
  bool get isLoggedInUser => id == room.client.userID;
}
