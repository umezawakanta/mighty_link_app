import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class FuncyButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;

  FuncyButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        fillColor: Colors.deepOrange,
        splashColor: Colors.orange,
        onPressed: onPressed,
        shape: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_upward, color: Colors.amber),
              Text(text, style: TextStyle(color: Colors.white)),
            ],
          ),
        ));
  }
}
