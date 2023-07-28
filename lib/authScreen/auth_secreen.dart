import 'package:flutter/material.dart';
import 'package:Ghorbeh/authScreen/signUp.dart';
import 'package:Ghorbeh/authScreen/login.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';
class authscreen extends StatefulWidget {
  const authscreen({super.key});

  @override
  State<authscreen> createState() => _authscreenState();
}

/*
 title: const Text("Ghorbeh BookShop"),
            titleSpacing: 00.0,
            centerTitle: true,
            toolbarHeight: 60.2,
            toolbarOpacity: 0.8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
            elevation: 0.00,
            backgroundColor: Colors.green[900],
 */
class _authscreenState extends State<authscreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[300],
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
            elevation: 7.00,
            title: Text(
              "Ghorbeh BookShop",
              style: TextStyle(fontSize: 20, letterSpacing: 1),
            ),
            centerTitle: true,
            bottom: const TabBar(
                indicatorColor: Colors.white70,
                indicatorWeight: 4,

                tabs: [
                  Tab(
                    text: "Login",
                    icon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                  ),
                  Tab(
                    text: "Sign Up",
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            children: [
              ligin(),
              signup(),
            ],
          ),
        ));
  }
}
