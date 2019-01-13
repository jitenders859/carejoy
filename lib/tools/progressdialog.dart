import 'package:flutter/material.dart';
import 'package:carejoy/theme.dart';

class ProgressDialog extends StatelessWidget {
  final String networkImage;

  ProgressDialog(
    {
      this.networkImage
    }
  );
  
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.black.withAlpha(200),
      child: Center(
        child: new Container(
          height: double.infinity,
          width: double.infinity,
          color: black,
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
          child: new GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Image.network(
                networkImage,
                fit: BoxFit.cover,
              ),
            )
          ),
        ),
      ),
    );
  }
}