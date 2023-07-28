import 'dart:async';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Ghorbeh/adminPanel/addNewItem.dart';
import 'package:Ghorbeh/adminPanel/adminDashbpord.dart';
import 'package:Ghorbeh/authScreen/auth_secreen.dart';
import 'package:Ghorbeh/mainScreens/home_Screen.dart';

class spalshsecreen extends StatefulWidget {
  const spalshsecreen({super.key});

  @override
  State<spalshsecreen> createState() => _spalshsecreenState();
}

class _spalshsecreenState extends State<spalshsecreen> {
  spalshsecreenTimer() {
    Timer(const Duration(seconds: 4), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        if(FirebaseAuth.instance.currentUser?.email=="majed.estaita9495@gmail.com"){
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => adminDash()));
        }else
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => homePage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => authscreen()));
      }
    });
  }

  void initState() {
    super.initState();

    spalshsecreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 160,
        width: 160,
        child: Center(

          child:Text("welcome", style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold),
          )
        ),
      ),
    );
  }
}
