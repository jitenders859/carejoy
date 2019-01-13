import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carejoy/children.dart';
import 'package:carejoy/theme.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:carejoy/tools/app_tools.dart';

  class BackChildren extends StatefulWidget {
    @override
    _BackChildrenState createState() => _BackChildrenState();
  }
  
  class _BackChildrenState extends State<BackChildren> {

    var dayCare = '';

    @override
    initState() {
      super.initState();
      
      fetchLocalData();
    }

    fetchLocalData() async {
      dayCare = await getDataLocally(key: 'dayCare');
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Children"),
        ),
        body: new StreamBuilder<QuerySnapshot>  (
          stream: Firestore.instance.collection(childCollection).where('dayCare', isEqualTo: dayCare).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            
            if (!snapshot.hasData) {
              return new Text("No Children.");
            } else {
              
              var listData = snapshot.data.documents;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                
                itemCount: listData.length,
                itemBuilder: (BuildContext context, int index) {
                  
                  return ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(listData[index][childImage]),
                      radius: 35.0,
                      backgroundColor: Colors.white,
                        
                    ),
                    title: Text(
                      listData[index][childFirstName],
                      style: TextStyle(
                        color: black,
                        fontFamily: roboto,
                        fontSize: 18.0
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: grey,
                        size: 24.0,
                      
                      ),
                      onPressed: () {
                        Firestore.instance.collection(childCollection).document(listData[index]['childId']).delete();
                      },
                    ),
                    onTap: () {
                      bool exist = false;
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChildrenPage(childId: listData[index]['childId'])));
                      // for(var i = 0; i < widget.childList.length; i++) {
                        
                      //   if(widget.childList[i]['childId'] == listData[index]['childId']) {
                          
                      //       exist = true;                              
                          
                      //   }
                      // }
                      // if(exist == false) {
                      //   widget.action(listData[index]);
                      // }
                    },
                    onLongPress: () {
                      // bool exist = false;
              
                      // for(var i = 0; i < widget.childList.length; i++) {
                        
                      //   if(widget.childList[i]['childId'] == listData[index]['childId']) {
                          
                      //       exist = true;                              
                          
                      //   }
                      // }
                      // if(exist == false) {
                      //   widget.action(listData[index]);
                      // }
                      
                      
                    },
                  );
                  
                  
                  
                }
              );
            }
            
          }
        ),
      );
    }
  }