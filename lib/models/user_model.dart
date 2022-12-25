import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class UserModel {
  late String? uid;
  late String? name;
  late String? phone;
  late String? bio;
  late String? birthDay;
  String? image;
  String? cover;

  UserModel(
      {this.name,
      this.uid,
      this.phone,
      this.bio,
      this.birthDay,
      this.image,
      this.cover});

  UserModel.FromJson(Map<String, dynamic>? json) {
    uid = json!['Uid'];
    name = json['name'];
    phone = json['phone'];
    bio = json['bio'];
    birthDay = json['birthDay'];
    image = json['image'];
    cover = json['cover'];
  }

  Map<String, dynamic> ToJson() {
    return {
      'Uid': uid,
      'name': name,
      'phone': phone,
      'bio': bio,
      'birthDay': birthDay,
      'image': image,
      'cover': cover
    };
  }
}
