import 'package:carejoy/theme.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:carejoy/tools/app_tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:carejoy/chat/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rooms extends StatefulWidget {
  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  
  
  // parent parameters
  int type;
  String dayCare;
  String childId;
  String staffId;
  bool edit = false;
  String editValue;
  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  
  @override
  void initState() {
    super.initState();
  
     readLocal();
  }

  

  readLocal() async {
    type = await getIntDataLocally(key: 'type');
    dayCare = await getStringDataLocally(key: 'dayCare');
    staffId = await getStringDataLocally(key: userId);
   var timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    var documentReference = await Firestore.instance
      .collection('rooms')
      .document(dayCare)
      .collection(dayCare);
      


    documentReference.getDocuments().then((onValue) {
      bool noRoomExist;
      for(var i = 0; i < onValue.documents.length; i++) {
      
        if(onValue.documents[i].documentID == 'no room') {
          noRoomExist = true;
        }
      }
       if(noRoomExist == null) {
          Firestore.instance.runTransaction((transaction) async {
            await transaction.set(
              documentReference.document('no room'),
              {
                'id': 'no room',
                'createdBy': dayCare, 
                'status': 1,
                'timestamp': timestamp
              },
            );
          });
          listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut); 
        }
             
    });
    setState(() {
          
    });
  } 

  void onSendMessage({@required String roomName, int status = 1}) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (roomName.trim() != '') {
      textEditingController.clear();
      var timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
      var documentReference = Firestore.instance
          .collection('rooms')
          .document(dayCare)
          .collection(dayCare)
          .document(roomName);
 
        if(edit == false ) {
          print(true);
          Firestore.instance.runTransaction((transaction) async {
            await transaction.set(
              documentReference,
              {
                'id': roomName,
                'createdBy': staffId, 
                'status': status,
                'timestamp': timestamp
              },
            );
          });
          listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        } else {
          print('false');
          print(editValue);
          Firestore.instance.collection('rooms').document(dayCare).collection(dayCare).document(editValue).delete();      
          Firestore.instance.runTransaction((transaction) async {
            await transaction.set(
              documentReference,
              {
                'id': roomName,
                'createdBy': staffId, 
                'status': status,
                'timestamp': timestamp
              },
            );
          }).then((value) {
            
                         
            
            Firestore.instance
            .collection('children')
            .where('room', isEqualTo:  editValue).where('dayCare', isEqualTo: dayCare).getDocuments().then((value) {
              for(var i = 0; i < value.documents.length; i++) {
                var changeReference = Firestore.instance.collection('children').document(value.documents[i].documentID).updateData(
                  {
                    'room': roomName
                  }
                );
              }
            });

            editValue = '';
            edit = false; 

          });
        } 
        
    } else {
      Fluttertoast.showToast(msg: 'Enter room name');
    }
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Rooms"),
      ),
      body: Column(
        children: <Widget>[
          // List of messages
           buildListMessage(),

          
          // // Input content
           buildInput(),
           
        ],
      ),
    );
  }

  onBackPress() {
    print('hot');
  }


  Widget buildItem(int index, DocumentSnapshot document) {
      // Right (my message)
    return Container(
      height: 50.0,
      child: ListTile(
        title: Text(
          document['id']
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_forever,
            color: grey,
            size: 24.0,
          ),
          onPressed: () => deleteRoom(document['id']),
        ),
        onTap: () {
          setState(() {
            edit = true;
            editValue = document['id']; 
            textEditingController.text = document['id'];
                       
          });
        },
      ),
    );
  }
  


  void deleteRoom(roomId) {
    if(roomId == 'no room') {
      Fluttertoast.showToast(msg: "can't be deleted.");
      return;
    }
     var documentReference = Firestore.instance
      .collection('children')
      .where('room', isEqualTo:  roomId).where('dayCare', isEqualTo: dayCare).getDocuments().then((value) {
        for(var i = 0; i < value.documents.length; i++) {
          var changeReference = Firestore.instance.collection('children').document(value.documents[i].documentID).updateData(
            {
              'room': 'no room'
            }
          );
        }
      });
      
    Firestore.instance.collection('rooms').document(dayCare).collection(dayCare).document(roomId).delete();
  }


  Widget buildInput() {
    return Container(
      height: 50.0,
      child: Row(
        children: <Widget>[
          // Button send image
          SizedBox(
            width: 10.0,
          ),
          // Edit text
          Flexible(
            child: Container(
              height: 45.0,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: shadowGrey, style: BorderStyle.solid)
              ),
              child: TextField(
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                scrollPadding: EdgeInsets.all(10.0),
                
                decoration: InputDecoration.collapsed(
                  
                  hintText: 'Room Name...',
                  hintStyle: TextStyle(color: grey),
                ),
                
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(roomName: textEditingController.text, status: 1),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Expanded(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('rooms')
            .document(dayCare)
            .collection(dayCare)
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
          } else {
            var listRooms = snapshot.data.documents;
            print(listRooms);
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index){
                return Card(
                  child: buildItem(index, listRooms[index])
                );
              }, 
              itemCount: snapshot.data.documents.length,
              reverse: false,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

}

