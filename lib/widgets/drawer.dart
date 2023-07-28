import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Ghorbeh/global/global.dart';
import 'package:Ghorbeh/mainScreens/home_Screen.dart';
import 'package:Ghorbeh/mainScreens/profile/mainProfile.dart';
import 'package:Ghorbeh/splashScreen/splash_secreen.dart';
import 'package:Ghorbeh/mainScreens/serach.dart';

import '../mainScreens/cart.dart';
import '../mainScreens/category.dart';
import '../mainScreens/contactUs.dart';

class drawer extends StatefulWidget {
  const drawer({super.key});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black45,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 26, bottom: 12),
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      sharedPreferences!.getString("photo")!,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(sharedPreferences!.getString("name")!,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              children: [
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.grey),
                  title: const Text(
                    "profile",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => mainProfile()));

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.grey),
                  title: const Text(
                    "home",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => homePage()));                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.book, color: Colors.grey),
                  title: const Text(
                    "library",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => CategoryView()));

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.search, color: Colors.grey),
                  title: const Text(
                    "search",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => SearchScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_bag, color: Colors.grey),
                  title: const Text(
                    "cart",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => CartPage()));

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.contact_page, color: Colors.grey),
                  title: const Text(
                    "contact us",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => ContactUsPage()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.grey),
                  title: const Text(
                    "sign out",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => spalshsecreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
