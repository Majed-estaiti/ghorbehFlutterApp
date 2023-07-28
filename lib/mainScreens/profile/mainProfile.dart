import 'package:flutter/material.dart';
import 'package:Ghorbeh/mainScreens/profile/myFav_card.dart';

import '../../global/global.dart';
import '../../widgets/drawer.dart';
import 'myorder_card.dart';

class mainProfile extends StatefulWidget {
  const mainProfile({super.key});

  @override
  State<mainProfile> createState() => _mainProfileState();
}

class _mainProfileState extends State<mainProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blueGrey[300],
      ),
      body: ListView(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.blueGrey[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 120,
                width: 120,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    sharedPreferences!.getString("photo")!,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 50,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey[900],
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const myFav_card()));
                      },
                      child: const Text("My Favorites")),
                  const SizedBox(
                    height: 12,
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey[900],
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const myOrder_card()));
                      },
                      child: const Text("My last order"))
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
