import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Ghorbeh/authScreen/auth_secreen.dart';
import 'package:Ghorbeh/splashScreen/splash_secreen.dart';
import '../global/global.dart';
import '../mainScreens/home_Screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_dialog.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';
class ligin extends StatefulWidget {
  const ligin({super.key});

  @override
  State<ligin> createState() => _liginState();
}

class _liginState extends State<ligin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  validateForm() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      loginNow();
    } else {
      Fluttertoast.showToast(msg: "please provide email and password!!");
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return loaedingProg(
            message: "checking credentials",
          );
        });

    User? currentUser;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((errorMessage) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "$errorMessage");
    });

    if (currentUser != null) {
      checkIfUserExists(currentUser!);
    }
  }

  checkIfUserExists(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((record) async {
      if (record.exists) {
        sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!.setString("email", currentUser.email!);
        await sharedPreferences!.setString("name", record.data()!["name"]);
        await sharedPreferences!.setString("phone", record.data()!["phone"]);
        await sharedPreferences!.setString("photo", record.data()!["photo"]);

        List<String> usercartList = record.data()!["userCart"].cast<String>();
        await sharedPreferences!.setStringList("userCart", usercartList);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => spalshsecreen()));
      } else {
        Fluttertoast.showToast(msg: "this user do not exists !");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return

      SingleChildScrollView(
        child: Container(
          color: Colors.blueGrey[50],
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              const SizedBox(
                height: 40,
              ),
              Text("Login",
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold),),
      const SizedBox(
        height: 15,
     ),
      Form(
        key: formKey,
        child: Column(
          children: [
            customTextField(
              textEditingController: email,
              iconData: Icons.email,
              hintText: "Email",
              isObsec: false,
              enabled: true,
            ),
            const SizedBox(
              height: 15,
            ),
            customTextField(
              textEditingController: password,
              iconData: Icons.lock,
              hintText: "Password",
              isObsec: true,
              enabled: true,
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey[300],
                    padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 12)),
                onPressed: () {
                  validateForm();
                },
                child: Text(
                  "login",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    ])));
  }
}
