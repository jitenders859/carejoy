import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carejoy/children.dart';
import 'package:carejoy/theme.dart';
import 'package:carejoy/tools/app_data.dart';

class ChildListWidget extends StatelessWidget {
 
  final list;
  final Function(DocumentSnapshot) action;

  ChildListWidget({
    this.list,
    this.action
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
          margin: EdgeInsets.all(0.0),
          elevation: 0.0,
          child: Container(
            alignment: Alignment.center,
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              
            ),
            padding: EdgeInsets.all(0.0),
            margin: EdgeInsets.all(0.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChildrenPage(childId: list[index]['childId'], back: true,)));
                    
                  },
                  onLongPress: () {
                    action(list[index]);
                  },
                  child: Container(
                    width: 65.0,
                    height: 65.0,

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(list[index]['childImage']),
                      ),
                      shape: BoxShape.circle
                                                              
                    ),
                    child: Text(
                      "child",
                      style: TextStyle(
                        color: Colors.transparent
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    
                     Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChildrenPage(childId: list[index]['childId'], back: true,)));
                  }, 
                  onLongPress: () {
                    action(list[index]);
                  },
                  child: Text(
                    list[index][childFirstName],
                    style: TextStyle(
                      color: black,
                      fontSize: 14.0
                    ),
                  ),
                )
              ],
            )
          )
        );
      }
    );
  }
}