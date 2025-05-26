import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  var ontap;
  String title;
  var color;
  var borderColor;
  var textcolor;
  var radius;
  var fontsize;
  FontWeight fontweigth;
  double height;
  Button(
      {super.key,
      required this.ontap,
      required this.title,
      required this.color,
      this.radius = 50.0,
      this.borderColor,
      this.height=45,
      this.fontweigth=FontWeight.w600,
      this.fontsize=16.0,
      required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: ontap,
      //  hoverColor: Colors.transparent,
        child: Ink(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor==null? color: borderColor),
              color: color,
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Center(
                child: Text(
              title,
              style: TextStyle(
                  fontSize: fontsize, color: textcolor, fontWeight: fontweigth),
            ))),
      ),
    );
  }
}
