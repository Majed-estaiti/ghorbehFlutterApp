import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Ghorbeh/adminPanel/adminDashbpord.dart';
import 'package:Ghorbeh/widgets/custom_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:Ghorbeh/widgets/loading_dialog.dart';


class addNewItem extends StatefulWidget {
  const addNewItem({super.key});

  @override
  State<addNewItem> createState() => _addNewItemState();
}

class _addNewItemState extends State<addNewItem> {
  TextEditingController bookName = TextEditingController();
  TextEditingController writerName = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController price = TextEditingController();
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
      if (bookName.text.isNotEmpty &&
          writerName.text.isNotEmpty &&
          desc.text.isNotEmpty &&
          price.text.isNotEmpty &&
          category.text.isNotEmpty) {
        showDialog(
            context: context,
            builder: (c) {
              return loaedingProg(
                message: "adding item",
              );
            });

        String fileName = DateTime.now().microsecondsSinceEpoch.toString();

        fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
            .ref()
            .child("bookImage")
            .child(fileName);
        fStorage.UploadTask uploadTask = storageRef.putFile(File(xFile!.path));

        fStorage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        taskSnapshot.ref.getDownloadURL().then((urlImage) {
          imageUrl = urlImage;

          saveInfoInFire();
        });
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "please complete the form");
      }
    }
  }

  saveInfoInFire() async {
    FirebaseFirestore.instance.collection("books").doc().set({
      "bookname": bookName.text.trim(),
      "bookwriter": writerName.text.trim(),
      "desc": desc.text.trim(),
      "category": category.text.trim(),
      "photo": imageUrl,
      "price": price.text.trim() as double
    });

    Navigator.push(context, MaterialPageRoute(builder: (c) => adminDash()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add item"),
      ),
      body:
      SingleChildScrollView(
        child: Container(
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
                        textEditingController: bookName,
                        iconData: Icons.book,
                        hintText: "bookname",
                        isObsec: false,
                        enabled: true,
                      ),
                      customTextField(
                        textEditingController: writerName,
                        iconData: Icons.edit,
                        hintText: "writer name",
                        isObsec: false,
                        enabled: true,

                      ),
                      customTextField(
                        textEditingController: desc,
                        iconData: Icons.description,
                        hintText: "description",
                        isObsec: false,
                        enabled: true,
                      ),
                      customTextField(
                        textEditingController: category,
                        iconData: Icons.category,
                        hintText: "category",
                        isObsec: false,
                        enabled: true,
                      ),
                      customTextField(
                        textEditingController: price,
                        iconData: Icons.price_change,
                        hintText: "price",
                        isObsec: false,
                        enabled: true,
                      )
                    ],
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 12)),
                  onPressed: () {
                    formValidation();
                  },
                  child: Text(
                    "add item",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
