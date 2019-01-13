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
import 'package:carejoy/eat.dart';
import 'package:carejoy/eventactions.dart';
import 'package:carejoy/home.dart';
import 'package:carejoy/play.dart';
import 'package:carejoy/theme.dart';
import 'package:carejoy/boxcontainers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'localization/localization.dart';

class ChangeDiapersPage extends StatefulWidget {
  final childList;
  final int time;
  ChangeDiapersPage({
    this.childList,
    this.time,
  });

  @override
  _ChangeDiapersPageState createState() => _ChangeDiapersPageState();
}

class _ChangeDiapersPageState extends State<ChangeDiapersPage> {
  
  var time;
  bool notify = true;
  bool share = true;
  bool beCareful = true;
  bool diaperSmall = false;
  bool diaperMedium = true;
  bool diaperLarge = false;
  bool tshirt = false;
  bool boxer = false;
  bool wash = false;
  bool potwash = false;  
  
  FocusNode _focus = new FocusNode();
  bool showBottomBar = true;

  List<Asset> uploadImages = List<Asset>();
  String multiImageError;

   
              

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
  bool saveData  = false;  

  var staffId;
  var dayCare;


  @override
  void initState() {
      // TODO: implement initState
      super.initState();
    var timestamp = new DateTime.now().toUtc().millisecondsSinceEpoch;   
    todayUtcTimestamp = new DateTime.utc(int.parse(currentYear), int.parse(currentMonth), int.parse(currentday)).millisecondsSinceEpoch;
    todayHourTimestamp = timestamp - todayUtcTimestamp;  
    _commentController.addListener(onChange);
    _focus.addListener(focusChange);
    time = widget.time;
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
          "${fields.diaper} ${fields.change}",
          
          style: TextStyle(
            fontSize: 20.0,
            color: black,
            fontFamily: roboto,
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
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0, right: 10.0, left: 10.0, bottom: 10.0),
                
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
                        )
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
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0.0, top: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 80.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                          color: shadowGrey,
                          width: 2.0,
                          style: BorderStyle.solid
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3.0,
                              color: shadowGrey
                            )
                          ]  
                        ),
                        child: Row(
                          children: <Widget>[
                            
                            TickBoxContainer(
                              containerSize: 80.0,
                              imageDimension: 30.0,
                              tickDimension: 14.0,
                              image: "assets/images/diaper_rating.png",
                              tickImage: "assets/images/green_tick.png",
                              action: () {
                                setState(() {
                                  diaperSmall = true;
                                  diaperMedium = false;
                                  diaperLarge = false;
                                                                                                    
                                });
                              },
                              value: diaperSmall,
                            ),
                            TickBoxContainer(
                              containerSize: 80.0,
                              imageDimension: 35.0,
                              tickDimension: 15.0,
                              image: "assets/images/diaper_rating.png",
                              tickImage: "assets/images/green_tick.png",
                              action: () {
                                setState(() {
                                  diaperSmall = false;
                                  diaperMedium = true;
                                  diaperLarge = false;
                                                                                                    
                                });
                              },
                              value: diaperMedium,
                            ),
                            TickBoxContainer(
                              containerSize: 80.0,
                              imageDimension: 40.0,
                              tickDimension: 16.0,
                              image: "assets/images/diaper_rating.png",
                              tickImage: "assets/images/green_tick.png",
                              action: () {
                                setState(() {
                                  diaperSmall = false;
                                  diaperMedium = false;
                                  diaperLarge = true;
                                                                                                    
                                });
                              },
                              value: diaperLarge,
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap:() {
                        setState(() {
                          tshirt = !tshirt;                          
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0),
                        height: 80.0,
                        width: 100.0,

                        decoration: BoxDecoration(
                          border: Border.all(
                            color: shadowGrey,
                            width: 2.0,
                            style: BorderStyle.solid
                          ),
                          color: tshirt ? blue : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3.0,
                              color: shadowGrey
                            )
                          ]
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/tshirt_round.png",
                          height: 50.0,
                          width: 50.0,
                          color: tshirt ?  Colors.white : null,
                        )
                          
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0.0, top: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom:15.0, top: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            boxer = true;                    
                            wash = false;
                            potwash = false;                                  
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:  boxer ? blue : Colors.white,
                            border: BorderDirectional(end: BorderSide(
                              width: 1.0,
                              color: shadowGrey,
                              style: BorderStyle.solid
                            ))
                          ),
                          child: Image.asset(
                            "assets/images/boxer.png",
                            height: 50.0,
                            width: 50.0,
                            color: boxer ? Colors.white : null,
                          )
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            boxer = false;                    
                            wash =  true;
                            potwash = false;                                  
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: wash ? blue : Colors.white,
                            border: BorderDirectional(end: BorderSide(
                              width: 1.0,
                              color: shadowGrey,
                              style: BorderStyle.solid
                            ))
                          ),
                          child: Image.asset(
                            "assets/images/diaper_icon_two.png",
                            height: 50.0,
                            width: 50.0,
                            color: wash ? Colors.white : null,
                          )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            boxer = false;                    
                            wash = false;
                            potwash = true;                                  
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: potwash ? blue : Colors.white,
                            border: BorderDirectional(end: BorderSide(
                              width: 1.0,
                              color: shadowGrey,
                              style: BorderStyle.solid
                            ))
                          ),
                          child: Image.asset(
                            "assets/images/diaper_icon_three.png",
                            height: 50.0,
                            width: 50.0, 
                            color: potwash ? Colors.white : null, 
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0, top: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
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
                    CheckboxContainer(
                      color: darkBlue,
                      submit: (values) {
                        setState(() {
                          notify = !notify;                          
                        });
                      },
                      text: fields.notify,
                      value: notify,
                    ),
                    CheckboxContainer(
                      color: darkBlue,
                      submit: (values) {
                        setState(() {
                          share = !share;                          
                        });
                      },
                      text: fields.share,
                      value: share,
                    ),
                    CheckboxContainer(
                      color: darkBlue,
                      submit: (values) {
                        setState(() {
                          beCareful = !beCareful;                          
                        });
                      },
                      text: fields.beCareful,
                      value: beCareful,
                    )
                  ],
                ),
              ),
              BuildPhotoGridView(
                uploadImages: uploadImages,
              ),
              SizedBox(height: 330.0,),
              
            ]
          ),
          Column(
            children: <Widget>[
             Expanded(
               child: Container(),
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
                      FirebaseStorage.instance.ref().child('diaper_${timestamp}${i}.png');
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
                FirebaseStorage.instance.ref().child('diaper_${timestamp}.jpg');
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
        "diaper_size": diaperSmall ? 'small' : diaperMedium ? 'medium' : diaperLarge ? 'large' : 'small',
        'tshrit': tshirt,
        'change': boxer ? 'boxer' : wash ? 'wash' : potwash ? 'potwash' : 'boxer',
        "time": int.parse(hourTransform.toString()),
        "hour": int.parse(hour.toStringAsFixed(0)),
        "minute": int.parse(minute.toString()),
        "comment": _comment,
        'picture': downloadUrl,
        
        'moreImages': imagesUrl,
        'notify': notify,
        'share': share,
        'beCareful': beCareful,
        'createdBy': staffId,
        'type': "diaper",
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


class CheckboxContainer extends StatelessWidget {
  final bool value;
  final Color color;
  final String text;
  final submit;

  CheckboxContainer({
    this.value,
    this.color,
    this.text,
    this.submit
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: value,
            onChanged: (values) {
              submit(values);
            },
            activeColor: color,
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          
          Text(
            text,
            style: TextStyle(
              color: black,
              fontSize: 14.0
            )
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
    );
  }
  
}
