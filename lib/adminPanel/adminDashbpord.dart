import 'package:flutter/material.dart';
import 'package:Ghorbeh/adminPanel/Orders.dart';
import 'package:Ghorbeh/adminPanel/addNewItem.dart';
import 'package:Ghorbeh/adminPanel/addnewOrder.dart';

import 'fetchbook.dart';

class adminDash extends StatefulWidget {
  const adminDash({super.key});

  @override
  State<adminDash> createState() => _adminDashState();
}

class _adminDashState extends State<adminDash> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey[900],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => const addNewItem()));
          },
          child: Text("add new book"),
        ),
        SizedBox(height: 30,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey[900],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) =>  addNewOrder()));
          },
          child: Text("add new order"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey[900],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) =>  fetchBooks()));
          },
          child: Text("edit books"),
        ),
        SizedBox(height: 30,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey[900],
          ),
          onPressed: () {},
          child: Text("view users"),
        ),
        SizedBox(height: 30,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey[900],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => const order()));
          },
          child: Text("view orders"),
        )
      ],
    );
  }
}
