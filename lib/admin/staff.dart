import 'package:flutter/material.dart';
import 'package:carejoy/theme.dart';

class Anand extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Disco",
          style: TextStyle(
            fontFamily: roboto,
            fontSize: 22.0,
            color: Colors.green,
          ), 
          
          ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
              icon: Icon(Icons.laptop_mac),
            ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.laptop_mac),
            ),
            IconButton(
              icon: Icon(Icons.laptop_windows),
            ),
        ],           

      ),
      body: Center(
        child: Container(
          child: IconButton(
            icon: Icon(
              Icons.bubble_chart,
              size: 53.0,
              color: Colors.red,
            ),
          ),
        ),
      ), 
    );
  }

}


