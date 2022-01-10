import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  late User user;
  late String name;
  late String type;

  AppUser(this.user, this.name, this.type);
}
