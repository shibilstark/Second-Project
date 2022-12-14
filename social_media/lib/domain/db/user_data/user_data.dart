import 'package:hive_flutter/adapters.dart';
import 'package:social_media/domain/db/db_values.dart';

part 'user_data.g.dart';

@HiveType(typeId: 3)
class UserData {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String name;

  UserData({required this.id, required this.email, required this.name});
}

class UserDataStore {
  static saveUserData(
      {required String id, required String email, required String name}) async {
    final db = await Hive.openBox<UserData>(DbVaues.userData);

    await db.clear();
    await db.add(UserData(id: id, email: email, name: name));
  }

  static Future<UserData?> getUserData() async {
    final db = await Hive.openBox<UserData>(DbVaues.userData);
    if (db.isEmpty) {
      return null;
    } else {
      return db.values.first;
    }
  }

  static clearUserData() async {
    final db = await Hive.openBox<UserData>(DbVaues.userData);
    await db.clear();
  }
}
