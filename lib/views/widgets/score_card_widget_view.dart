import 'package:flutter/material.dart';

Color enabledColor = const Color.fromARGB(255, 6, 192, 12);
const Color disabledColor = Colors.redAccent;

class ScoreCardWidgetView extends StatelessWidget {
  final String title;
  final String description;
  final bool checker;
   ScoreCardWidgetView(
      {super.key,
      required this.title,
      required this.description,
      required this.checker});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25)),
      child: ExpansionTile(
          leading: const Icon(
            Icons.lock,
            color: Color.fromARGB(255, 44, 41, 41),
            size: 35,
          ),
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              children: [
                const TextSpan(
                  text: 'Screen Lock : ',
                  style: TextStyle(color: Colors.blue), // Keep the same color
                ),
                TextSpan(
                  text: title,
                  style: TextStyle(
                    color: checker ? enabledColor : disabledColor,
                  ),
                ),
              ],
            ),
          ),
          children: <Widget>[
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                description,
                style: const TextStyle(
                    color: Color.fromARGB(255, 1, 61, 84), fontSize: 15),
              ),
            ),
          ]),
    );
  }
}
