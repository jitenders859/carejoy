import 'package:flutter/material.dart';
import 'package:carejoy/theme.dart';

class ChooseProfession extends StatelessWidget {
  final String email;
  ChooseProfession({
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 60.0,
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 8.0, top: 8.0),
            child: RaisedButton(
              child: Text(
                "PARENT",
                style: TextStyle(
                  fontFamily: roboto,
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              color: blue,
              textColor: Colors.white,
              elevation: 2.0,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return null;
                  }
                ));
              },
            ),
          ),
          RaisedButton(
            child: Text("Log Out "),
            color: Colors.blue,
            textColor: Colors.white,
            elevation: 7.0,
            onPressed: () {
            },
          ),
          RaisedButton(
            child: Text("Log Out "),
            color: Colors.blue,
            textColor: Colors.white,
            elevation: 7.0,
            onPressed: () {
            },
          ),
        ],
      ),
    );
  }
}