import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textcolor;
  const FollowButton({super.key, this.function, required this.backgroundColor, required this.borderColor, required this.text, required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2),
      child: TextButton(onPressed: function, child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(5)
        ),
        alignment: Alignment.center,
        child: Text(text,style:TextStyle(
          color: textcolor,
          fontWeight: FontWeight.bold,

        ),),
      )),
      height: 67,
      width: 257,
    );
  }
}