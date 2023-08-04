import 'package:flutter/material.dart';

class SettingWidget extends StatelessWidget {
  const SettingWidget(
      this.imagePath, this.color, this.text, this.textColor, this.imageColor,this.onPressed,
      {Key? key})
      : super(key: key);
  final String imagePath;
  final String text;
  final Color color;
  final Color textColor;
  final Color imageColor;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap:onPressed as void Function() ,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: color,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                spreadRadius: 0.05,
                blurRadius: 3,
                offset: Offset(2, 2), // shadow direction: bottom right
              )
            ],
          ),
          width: 400,
          height: 50,
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Image(
                    image: AssetImage(imagePath),
                    color: imageColor,
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
