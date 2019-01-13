import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carejoy/home.dart';
import 'package:carejoy/theme.dart';

class EventActions extends StatelessWidget {
 final VoidCallback callback;
  final int time;

  EventActions({
    this.callback,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row( 
        children: <Widget>[
          Container(
            width: 70.0,
            height: 70.0,
            child: CircleAvatar(
              maxRadius: 35.0,
              minRadius: 35.0,
              backgroundColor: shadowGrey,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 35.0,
                  color: grey  
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),      
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2.0,
                  color: blue,

                )
              ),
              child: RawMaterialButton(
                
                padding: EdgeInsets.all(18.0),
                shape: new CircleBorder(),
                fillColor: blue,
                splashColor: darkBlue,
                highlightColor: blue.withOpacity(0.5),
                elevation: 10.0,
                highlightElevation: 5.0,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onPressed: null,
                child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text( 
                    time != null ? "${time}:00" :
                    DateFormat.Hm().format(DateTime.now().toUtc().add(Duration(hours: 1))),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                    ),
                  )
                ),
              ),
            ),
          ),
          Container(
            width: 70.0,
            height: 70.0,
            
            child: CircleAvatar(
              maxRadius: 35.0,
              minRadius: 35.0,
              backgroundColor: blue,
              
              child: IconButton(
                icon: Icon(
                  Icons.save,
                  size: 35.0,
                  color: Colors.white  
                ),
                onPressed: () async {
                  try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                        print('connected');
                      } else {
                        print(' not con connected');
                        Future.delayed(Duration(seconds: 55)).then((value) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Home()));
                        });
                      }
                    } on SocketException catch (error) {
                      print(' not con connected');
                      Future.delayed(Duration(seconds: 55)).then((value) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Home()));
                      });
                    }

                  callback();    
                  
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (BuildContext context) {
                  //     return LeavePage();
                  //   })
                  // );
                },
              ),
            ),      
          ),
        ],
      ),
    );
  }
}