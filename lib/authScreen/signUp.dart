import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Ghorbeh/authScreen/auth_secreen.dart';
import 'package:Ghorbeh/global/global.dart';
import 'package:Ghorbeh/mainScreens/home_Screen.dart';
import 'package:Ghorbeh/splashScreen/splash_secreen.dart';
import 'package:Ghorbeh/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:Ghorbeh/widgets/loading_dialog.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController Confirmpassword = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String imageUrl = "";

  XFile? xFile;
  final ImagePicker imagePicker = ImagePicker();

  getImageFromGellary() async {
    xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      xFile;
    });
  }

  formValidation() async {
    if (xFile == null) {
      Fluttertoast.showToast(msg: "please select an image");
    } else {
      if (password.text == Confirmpassword.text) {
        if (password.text.isNotEmpty &&
            Confirmpassword.text.isNotEmpty &&
            name.text.isNotEmpty &&
            email.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (c) {
                return loaedingProg(
                  message: "Registering your account",
                );
              });

          String fileName = DateTime.now().microsecondsSinceEpoch.toString();

          fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
              .ref()
              .child("UsersImage")
              .child(fileName);
          fStorage.UploadTask uploadTask =
              storageRef.putFile(File(xFile!.path));

          fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
          taskSnapshot.ref.getDownloadURL().then((urlImage) {
            imageUrl = urlImage;
          });

          saveInfodatabase();
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "please complete the form");
        }
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Password and confirm password do not match");
      }
    }
  }

  saveInfodatabase() async {
    User? currentUser;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((errorMessage) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "$errorMessage");
    });
    if (currentUser != null) {
      saveInfoInFire(currentUser!);
    }
  }

  saveInfoInFire(User currentUser) async {
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": name.text.trim(),
      "phone": phone.text.trim(),
      "photo": imageUrl,
      "status": "approved",
      "userCart": ["initialValue"]
    });

    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email!);
    await sharedPreferences!.setString("name", name.text.trim());
    await sharedPreferences!.setString("phone", phone.text.trim());
    await sharedPreferences!.setString("photo", imageUrl);
    await sharedPreferences!.setStringList("userCart", ["initialValue"]);

    Navigator.push(context, MaterialPageRoute(builder: (c) => spalshsecreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.blueGrey[50],
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                getImageFromGellary();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.grey,
                backgroundImage:
                    xFile == null ? null : FileImage(File(xFile!.path)),
                child: xFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white70,
                        size: MediaQuery.of(context).size.width * 0.20,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    customTextField(
                      textEditingController: name,
                      iconData: Icons.person,
                      hintText: "Name",
                      isObsec: false,
                      enabled: true,
                    ),
                    customTextField(
                      textEditingController: email,
                      iconData: Icons.email,
                      hintText: "Email",
                      isObsec: false,
                      enabled: true,
                    ),
                    customTextField(
                      textEditingController: password,
                      iconData: Icons.lock,
                      hintText: "Password",
                      isObsec: true,
                      enabled: true,
                    ),
                    customTextField(
                      textEditingController: Confirmpassword,
                      iconData: Icons.lock,
                      hintText: "Confirm Password",
                      isObsec: true,
                      enabled: true,
                    ),
                    customTextField(
                      textEditingController: phone,
                      iconData: Icons.phone,
                      hintText: "phone",
                      isObsec: false,
                      enabled: true,
                    )
                  ],
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey[900],
                    padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 12)),
                onPressed: () {
                  formValidation();
                },
                child: Text(
                  "SignUp",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
