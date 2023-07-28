import 'package:flutter/material.dart';

class customTextField extends StatefulWidget {
  TextEditingController? textEditingController;
  IconData? iconData;
  String? hintText;
  bool? isObsec = true;
  bool? enabled = true;

  customTextField(
      {this.textEditingController,
      this.iconData,
      this.enabled,
      this.hintText,
      this.isObsec});

  @override
  State<customTextField> createState() => _customTextFieldState();
}

class _customTextFieldState extends State<customTextField> {
  @override
  Widget build(BuildContext context) {
    if(widget.hintText=="price"){
      return Container(
        decoration: const BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.all(Radius.circular(10))),

        padding: const EdgeInsets.all(8.0),
        margin:  const EdgeInsets.all(8.0),

        child: TextFormField(

          keyboardType: TextInputType.number,
          enabled: widget.enabled,
          controller: widget.textEditingController,
          obscureText: widget.isObsec!,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              widget.iconData,
              color: Colors.blueGrey,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: widget.hintText,

          ),
        ),
      );

    }else
      {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.all(Radius.circular(10))),

          padding: const EdgeInsets.all(8.0),
          margin:  const EdgeInsets.all(8.0),

          child: TextFormField(

            enabled: widget.enabled,
            controller: widget.textEditingController,
            obscureText: widget.isObsec!,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                widget.iconData,
                color: Colors.blueGrey,
              ),
              focusColor: Theme.of(context).primaryColor,
              hintText: widget.hintText,

            ),
          ),
        );

      }

  }
}
