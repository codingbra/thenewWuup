import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/views/screens/tryouts/tryOutUserModel.dart';

class TryoutsScreen extends StatefulWidget {
  const TryoutsScreen({Key? key}) : super(key: key);

  @override
  State<TryoutsScreen> createState() => _TryoutsScreenState();
}

Future createUser(
    {required String name,
    required String dataName,
    required String age,
    required String birthday}) async {
  final tryOutDocument =
      FirebaseFirestore.instance.collection("tryoutData").doc();
  final Map<String, dynamic> listOfActivity = {}; // initialize list
  // can also be replaced by the model e.g. user model
  final userModel = UserModelForTryOut(
      id: tryOutDocument.id, age: age, birthDay: birthday, name: name);

  final json = userModel.toJson(); // upload data

  await tryOutDocument.set(json); // here is reference to Firestore
}

class _TryoutsScreenState extends State<TryoutsScreen> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();
  String date = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Some Tryouts"),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerName,
              decoration: InputDecoration(hintText: "Name"),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controllerAge,
              decoration: InputDecoration(hintText: "Age"),
            ),
            SizedBox(
              height: 20,
            ),
            DateTimeFormField(
              // to be overtaken in form
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black45),
                errorStyle: TextStyle(color: Colors.redAccent),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.event_note),
                labelText: 'Please choose the time',
              ),
              firstDate: DateTime.now().add(const Duration(days: 10)),
              lastDate: DateTime.now().add(const Duration(days: 40)),
              initialDate: DateTime.now().add(const Duration(days: 20)),
              autovalidateMode: AutovalidateMode.always,
              validator: (DateTime? e) =>
                  (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
              onDateSelected: (DateTime value) {
                print(value);
                date = value.toString();
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  createUser(
                      name: controllerName.text,
                      dataName: date,
                      age: controllerAge.text,
                      birthday: date);
                },
                child: Text("Create User"))
          ],
        ),
      ),
    );
  }
}
