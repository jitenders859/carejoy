import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:carejoy/add_child_dialog.dart';
import 'package:carejoy/buildgridview.dart';
import 'package:carejoy/child_list_widget.dart';
import 'package:carejoy/children.dart';
import 'package:carejoy/commentbox.dart';
import 'package:carejoy/diapers_change.dart';
import 'package:carejoy/eventactions.dart';
import 'package:carejoy/home.dart';
import 'package:carejoy/leave.dart';
import 'package:carejoy/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import 'package:carejoy/localization/localization.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


class PlayPage extends StatefulWidget {
  final childList;
  final int time;
  PlayPage({
    this.childList,
    this.time,
  });

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  bool notify = true;
  bool share = true;
  var time;
  
  bool reading = false;
  bool singing = false;
  bool painting = false;
  bool jumping = false;
  bool free = false;
  String tab = "";
  
  ScrollController scrollController = new ScrollController();
  List<Event> eventList = [
    Event(image: "assets/images/reading.png", text: "READING"),
    Event(image: "assets/images/painting.png", text: "PAINTING"),
    Event(image: "assets/images/singing.png", text: "SINGING"),
    Event(image: "assets/images/jumping.png", text: "JUMPING"),
    Event(image: "assets/images/free.png", text: "FREE"),
  ];
  double vertOffset  = 0.0;

  List<Asset> uploadImages = List<Asset>();
  String multiImageError;

  
              

  FocusNode _focus = new FocusNode();
  bool showBottomBar = true;
  
  TextEditingController _commentController = TextEditingController();
  String _comment = "";
  var currentMonth = DateFormat.M().format(DateTime.now().toUtc());
  var currentYear = DateFormat.y().format(DateTime.now().toUtc());
  var currentday = DateFormat.d().format(DateTime.now().toUtc());
  var hour = DateFormat.H().format(DateTime.now().toUtc());
  var minute = DateFormat.m().format(DateTime.now().toUtc());
  var second = DateFormat.s().format(DateTime.now().toUtc());
  
  var todayUtcTimestamp;
  bool imageLoading = false;
  var sampleImage;
  var todayHourTimestamp;
  bool saveData = false;  
  var staffId;
  var dayCare;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
    time = widget.time;
    var timestamp = new DateTime.now().toUtc().millisecondsSinceEpoch;   
    todayUtcTimestamp = new DateTime.utc(int.parse(currentYear), int.parse(currentMonth), int.parse(currentday)).millisecondsSinceEpoch;
    todayHourTimestamp = timestamp - todayUtcTimestamp;  
    _commentController.addListener(onChange);
    _focus.addListener(focusChange);
    fetchLocalData();
  }

  fetchLocalData() async {
    staffId = await getDataLocally(key: userId);
    dayCare =  await getDataLocally(key: 'dayCare');
  
  }

  void onChange() {
    _comment = _commentController.text;
      
  }

  void focusChange() {
    if(_focus.hasFocus) {
      setState(() {
        showBottomBar = false;           
      });
    } else {
      setState(() {
        showBottomBar = true;              
      });
    }
  }

  Future getImage() async {

    setState(() {
      imageLoading = true;      
    });
    
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      sampleImage = tempImage;
      imageLoading = false;
    });
     
  }  

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var fields = AppLocalizations.of(context);
    return Scaffold(
       
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        iconTheme: new IconThemeData(color: black),  
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: new Text(
          fields.play.toLowerCase(),
          
          style: TextStyle(
            fontSize: 20.0,
            color: black,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              
            },
            alignment: Alignment.centerRight,
            icon: Icon(
              Icons.calendar_today,
              color: black,
              size: 22.0,
            ),
          ),
          new IconButton(
            alignment: Alignment.center,
            onPressed: null,
            padding: EdgeInsets.all(0.0),
            icon: Icon(
              Icons.more_vert,
              color: black,
              size: 22.0,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              
            ),
          ),
          ListView(
            shrinkWrap: true,
            controller: scrollController,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0, bottom: 10.0),
                
                height: 85.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    
                    Expanded(
                      child: Container(
                        
                        child: ChildListWidget(
                          list: widget.childList,
                          action: (childData) {
                            setState(() {
                              widget.childList.remove(childData);                              
                            });
                          },
                        ),
                      ),
                    ),
                    AddChildDialogButton(
                      childList: widget.childList,
                      action: (document) {
                        setState(() {
                          widget.childList.add(document);                                                    
                        });
                        
                      },
                      
                    ),
                  ],
                ),  
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0, top: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                  ),
                ),
              ),
              Container(
                height: (eventList.length /2 ).round() * screenSize.width/4,
                child: Padding(

                  padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                  child: new StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemCount: eventList.length,
                    itemBuilder: (BuildContext context, int index) => 
                      new GestureDetector(
                        onTap: () {
                          
                          if(eventList[index].text.toLowerCase() == 'reading') {
                            setState(() {
                              reading = true;
                              painting = false;
                              singing = false;
                              jumping = false;
                              free = false;                              
                              tab = eventList[index].text;
                            });

                            
                          } else if(eventList[index].text.toLowerCase() == 'painting') {
                              setState(() {
                                reading = false;
                                painting = true;
                                singing = false;
                                jumping = false;
                                free = false;             
                                tab = eventList[index].text;                 
                              });
                            
                          }
                          else if (eventList[index].text.toLowerCase() == 'singing') {
                            setState(() {
                              reading = false;
                              painting = false;
                              singing = true;
                              jumping = false;
                              free = false;                 
                              tab = eventList[index].text;             
                            });
                             
                          } else if (eventList[index].text.toLowerCase() == 'jumping') {
                            setState(() {
                              reading = false;
                              painting = false;
                              singing = false;
                              jumping = true;
                              free = false;               
                              tab = eventList[index].text;               
                            });
                            
                          } else if (eventList[index].text.toLowerCase() == 'free') {
                            setState(() {
                              reading = false;
                              painting = false;
                              singing = false;
                              jumping = false;
                              free = true;                
                              tab = eventList[index].text;              
                            });
                            
                          }
                          print(eventList[index].image);

                        },
                        child:Container(
                        
                        decoration: BoxDecoration(
                          border: Border.all(width: 2.0, color: shadowGrey, style: BorderStyle.solid),
                          color: tab == eventList[index].text ? blue : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2.0,
                              color: shadowGrey,
                              spreadRadius: 0.0
                            )
                          ] 
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 5.0),
                              height: 30.0,
                              width: 30.0,  
                              child: Image.asset(
                                eventList[index].image,
                                color: tab == eventList[index].text ? Colors.white : null
                              )
                            ),
                            Text(
                              eventList[index].text.toLowerCase() == 'reading' ? fields.reading.toUpperCase() : 
                              eventList[index].text.toLowerCase() == 'painting' ? fields.painting.toUpperCase() :
                              eventList[index].text.toLowerCase() == 'singing' ? fields.singing.toUpperCase() :
                              eventList[index].text.toLowerCase() == 'jumping' ? fields.jumping.toUpperCase() :
                              eventList[index].text,

                              style: TextStyle(
                                color: tab == eventList[index].text ? Colors.white : black,
                                fontSize: 18.0
                              ),
                            )
                          ],
                        )
                      ),
                      ),
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(2, 1),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              ),
              CommentBox(
                imageLoading: imageLoading,
                imageCallback: (images) {
                  setState(() {
                    uploadImages = images;                                      
                  });
                },
                commentController: _commentController,
                focus: _focus,
              ),
              Container(
                height: sampleImage == null ? 0.0 : 100.0,
                width: double.infinity,
                alignment:Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: sampleImage != null ? FileImage(sampleImage) : AssetImage("assets/images/add_photo.png"),
                    fit: BoxFit.contain,
                    alignment: Alignment.center
                  )
                ),
              ),
              Container(
                height: 20.0,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      
                      value: notify,
                      onChanged: (value) {
                        notify = !value;
                      },
                      activeColor: darkBlue,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    
                    Text(
                      fields.notify,
                      style: TextStyle(
                        color: black,
                        fontSize: 14.0
                      )
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Checkbox(
                      
                      value: share,
                      onChanged: (value) {
                        share = !value;
                      },
                      activeColor: darkBlue,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    
                    Text(
                      fields.share,
                      style: TextStyle(
                        color: black,
                        fontSize: 14.0
                      )
                    ),
                  ],
                ),
              ),
              BuildPhotoGridView(
                uploadImages: uploadImages,
              ),
              SizedBox(
                height: 140.0,
              )
              
              
            ]
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container()
              ),
              Container(
                child: showBottomBar ? EventActions(
                  callback: () => onPressed(),
                  time: widget.time,
                ) : Container(),
              ),
            ],
          ),
          Center(
            child: saveData ? CircularProgressIndicator(backgroundColor: blue,) : Container(
              height: 0,
              width: 0,
            ),
          )
        ],
      ),
    );
  }

  void onPressed() async {
    setState(() {
      saveData = true;
    });
    int timestamp = new DateTime.now().millisecondsSinceEpoch;

              

    List<String> imagesUrl = [];
    if(uploadImages.isNotEmpty) {
      for(var i = 0; i < uploadImages.length; i++) {
              ByteData imageData = await uploadImages[i].requestOriginal(quality: 35);
              List<int> byteData = imageData.buffer.asUint8List();
              
              // final Directory tempDir = Directory.systemTemp;
              // final String fileName = "${timestamp}${i}.png";
              // final File file = File('${tempDir.path}/$fileName');
              // file.writeAsBytes(byteData, mode: FileMode.write);

      
              final StorageReference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child('play_${timestamp}${i}.png');
              final StorageUploadTask task =
                          firebaseStorageRef.putData(byteData);
              
              StorageTaskSnapshot taskSnapshot = await task.onComplete;
      
              var uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();
              imagesUrl.add(uploadedImageUrl);    
              uploadImages[i].requestOriginal();
            }
          }

          

    String downloadUrl = "";
    if(sampleImage != null) {
    final StorageReference firebaseStorageRef =
                FirebaseStorage.instance.ref().child('play_${timestamp}.jpg');
    final StorageUploadTask task =
                firebaseStorageRef.putFile(sampleImage);
    
    StorageTaskSnapshot taskSnapshot = await task.onComplete;

    downloadUrl = await taskSnapshot.ref.getDownloadURL();
    }
    double hour = todayHourTimestamp / 3600000;
    var hourTransform;
    if(widget.time != null) {
      hourTransform = widget.time;
    } else {
      hourTransform = hour.toStringAsFixed(0);
      hourTransform = int.parse(hourTransform) + 1;
    }

    for(var i = 0; i < widget.childList.length; i++) {
      print(todayUtcTimestamp);
      print(todayHourTimestamp);
      await Firestore.instance.collection('events').document(dayCare.toString()).collection("${todayUtcTimestamp.toString()}/${widget.childList[i]['childId']}/eventData").document("${hourTransform}").setData({
        
        'play': reading ? 'reading' : painting ? 'painting' : singing ? 'singing' : jumping ? 'jumping' : free ? 'free' : 'free',
        "time": int.parse(hourTransform.toString()),
        "hour": int.parse(hour.toStringAsFixed(0)),
        "minute": int.parse(minute.toString()),
        "comment": _comment,
        'picture': downloadUrl,
        'notify': notify,
        'share': share,
        'moreImages': imagesUrl,
        'createdBy': staffId,
        'type': "play",
      }).then((value) {
        if(widget.childList.length == i+1) {
          setState(() {
            saveData = false;      
          });
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Home()));
        }
        print("value set"); 

      }).catchError((e) {
        print(e);
      });  
    }
           
  }

}

class Event {
  final String image;
  final String text;

  Event({
    this.image,
    this.text
  });

}

