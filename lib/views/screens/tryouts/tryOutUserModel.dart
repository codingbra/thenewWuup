import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiktokclone/views/screens/tryouts/tryOutUserModel.dart';

class UserModelForTryOut { // set what variables should be included
  String id;
  String name;
  String age;
  String birthDay;

  UserModelForTryOut( // create constructor to request above variables to be filled in
      {required this.id,
      required this.name,
      required this.age,
      required this.birthDay});

  Map<String, dynamic> toJson() => // have the data mapped
      {'id': id, "name": name, "age": age, "birthday": birthDay};


  static UserModelForTryOut fromJson(Map<String,dynamic> json) => UserModelForTryOut(
      id: json["id"], name: json["name"], age: json["age"],
      birthDay: json["birthday"]
  );

}


