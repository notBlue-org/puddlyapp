import 'package:hive/hive.dart';

part 'user_stored.g.dart';

@HiveType(typeId: 0)
class UserStore extends HiveObject {
  @HiveField(0)
  late String username;
  @HiveField(1)
  late String id;
  @HiveField(2)
  late String qr;
  @HiveField(3)
  late String email;
  @HiveField(4)
  late String route;
}
