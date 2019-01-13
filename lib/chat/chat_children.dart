import 'package:carejoy/chat/chat.dart';
import 'package:carejoy/chat/group_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carejoy/children.dart';
import 'package:carejoy/theme.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:carejoy/tools/app_tools.dart';

  class ChatChildren extends StatefulWidget {
    @override
    _ChatChildrenState createState() => _ChatChildrenState();
  }
  
  class _ChatChildrenState extends State<ChatChildren> {

    String dayCare;
    List<String> childSelected;
    @override
    initState() {
      super.initState();
      childSelected = [];
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
              print(listData);
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
                      child: childSelected.contains(listData[index]['childId']) ? Container(
                        padding: EdgeInsets.only(bottom: 20.0, right: 20.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xAAAAAAAA),
                        ),
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(
                            Icons.check,
                            size: 60.0,
                            color: Colors.greenAccent,
                            
                          ),
                          onPressed: () {
                            setState(() {
                              childSelected.remove(listData[index]['childId']);                              
                            });
                          },
                        ),
                      ) : Opacity(
                        opacity: 0.0,
                        child: Text(""),
                      )
                    ),
                    title: Text(
                      listData[index][childFirstName],
                      style: TextStyle(
                        color: black,
                        fontFamily: roboto,
                        fontSize: 18.0
                      ),
                    ),
                    
                    onTap: () {
                      bool exist = false;
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>Chat(peerAvatar: listData[index]['childImage'], peerId: listData[index]['childId'],)));
                      
                    },
                    onLongPress: () {
                     
                      if(childSelected.contains(listData[index]['childId'])) {
                          
                      } else {
                        setState(() {
                          childSelected.add(listData[index]['childId']);                          
                        });
                      }  
                      
                    },
                  );
                  
                  
                  
                }
              );
            }
            
          }
        ),
        floatingActionButton: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            
            FloatingActionButton(
              onPressed: () {
                if(childSelected.length == 0) {
                    
                } else {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => GroupChat(peerId: childSelected,)));
                }
              },
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 28.0, 
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(0.0),
              height: 18.0,
              width: 18.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent
              ),
              child: Text(
                "${childSelected.length}",
                style: TextStyle(
                  fontFamily: roboto,
                  color: Colors.white,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }