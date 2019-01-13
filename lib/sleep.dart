import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:carejoy/add_child_dialog.dart';
import 'package:carejoy/boxcontainers.dart';
import 'package:carejoy/buildgridview.dart';
import 'package:carejoy/care.dart';
import 'package:carejoy/child_list_widget.dart';
import 'package:carejoy/children.dart';
import 'package:carejoy/commentbox.dart';
import 'package:carejoy/eventactions.dart';
import 'package:carejoy/home.dart';
import 'package:carejoy/multi_image/asset_view.dart';
import 'package:carejoy/multi_image/multi_image.dart';
import 'package:carejoy/play.dart';
import 'package:carejoy/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:multi_image_picker/asset.dart';
import 'localization/localization.dart';

class SleepPage extends StatefulWidget {
  final childList;
  final int time;
  SleepPage({
    this.childList,
    this.time
  });

  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  var time;
  bool notify = true;
  bool share = true;
  bool sleep = false;
  bool slept = true;
  bool normal = false;
  bool awake = false;
  bool sleeping= true;
  bool awaking = false;
  bool saveData = false;
  

  TextEditingController _commentController = TextEditingController();
  String _comment = "";

  FocusNode _focus = new FocusNode();
  bool showBottomBar = true;
  List<Asset> uploadImages = List<Asset>();
  String multiImageError;

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
    
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    
    setState(() {
      sampleImage = tempImage;
      imageLoading = false;
    });
     
  }

  Widget ShowAlertBox(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0.0),
          contentPadding: EdgeInsets.all(0.0),
          
          title: Row(
            children: <Widget>[
              Icon(Icons.close, color: Colors.transparent),
              Expanded(
                child: Text(
                  "Add Images",
                  textAlign: TextAlign.center,
                  style: TextStyle( 
                    fontSize: 16.0,
                    color: black,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                color: grey,
                alignment: Alignment.topRight,
                iconSize: 22.0,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: Container(
            height: 100.0,
            color: blue,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: OutlineButton(
                      color: grey,
                      borderSide: BorderSide(width: 1.0, color: shadowGrey, style: BorderStyle.solid),
                      onPressed: () =>  getImage() ,
                      child: Text(
                        "Capture Image",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: roboto,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: MultiImageUpload(
                      imageCallback: (images) {
                        setState(() {
                          uploadImages = images;
                        });
                      },
                      errorCallback: (error) {
                        setState(() {
                          multiImageError = error;                                                  
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
    
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
          fields.sleep.toUpperCase(),
          
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
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    
                    color: Colors.white,
                     
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: BoxContainer(
                          imageData: "assets/images/emoji_one.png",
                          containerHeight: 80.0,
                          value: sleep,
                          imageWidth: 40.0,
                          action: (value) {
                            setState(() {
                              sleep = true;
                              slept = false;
                              normal = false;
                              awake = false;                                                          
                            });
                          }
                        ),
                        
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: BoxContainer(
                          imageData: "assets/images/emoji_two.png",
                          containerHeight: 80.0,
                          value: slept,
                          imageWidth: 40.0,
                          action: (value) {
                            setState(() {
                              sleep = false;
                              slept = true;
                              normal = false;
                              awake = false;                                                          
                            });
                          }
                        ),
                        
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: BoxContainer(
                          imageData: "assets/images/emoji_three.png",
                          containerHeight: 80.0,
                          value: normal,
                          imageWidth: 40.0,
                          action: (value) {
                            setState(() {
                              sleep = false;
                              slept = false;
                              normal = true;
                              awake = false;                                                          
                            });
                          }
                        ),
                        
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: BoxContainer(
                          imageData: "assets/images/emoji_four.png",
                          containerHeight: 80.0,
                          value: awake,
                          imageWidth: 40.0,
                          action: (value) {
                            setState(() {
                              sleep = false;
                              slept = false;
                              normal = false;
                              awake = true;                                                          
                            });
                          }
                        ),
                        
                      ),
                    ],
                  ),
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
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 20.0, right: 20.0),
                child: Row(
                  children: <Widget>[
                    
                    Expanded(
                        child: BoxContainer(
                          imageData: "assets/images/sleeping.png",
                          containerHeight: 80.0,
                          value: sleeping,
                          imageWidth: 40.0,
                          action: (value) {
                            setState(() {
                              sleeping = true;
                              awaking = false;                                                          
                            });
                          },
                          imageText: "14:28",
                        ),
                        
                      ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                        child: BoxContainer(
                          imageData: "assets/images/wake_up.png",
                          containerHeight: 80.0,
                          value: awaking,
                          imageWidth: 40.0,
                          action: (value) {
                            setState(() {
                              sleeping = false;
                              awaking = true;                                                          
                            });
                          },
                          imageText: "15:05",
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
                      width: 10.0,
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
    String downloadUrl = "";
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
                      FirebaseStorage.instance.ref().child('sleep_${timestamp}${i}.png');
              final StorageUploadTask task =
                          firebaseStorageRef.putData(byteData);
              
              StorageTaskSnapshot taskSnapshot = await task.onComplete;
      
              var uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();
              imagesUrl.add(uploadedImageUrl);    
              uploadImages[i].requestOriginal();
            }
          }
      
          if(sampleImage != null) {
          final StorageReference firebaseStorageRef =
                      FirebaseStorage.instance.ref().child('sleep_${timestamp}.jpg');
          final StorageUploadTask task =
                      firebaseStorageRef.putFile(sampleImage);
          
          StorageTaskSnapshot taskSnapshot = await task.onComplete;
      
          downloadUrl = await taskSnapshot.ref.getDownloadURL();
          }
          double hour = todayHourTimestamp / 3600000;
          var hourTransform ;
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
              
              'mode': sleep ? 'sleep' : slept ? 'slept' : normal ? 'normal' : awake ? 'awake' : 'sleep',
              'sleeping': sleeping ? 'sleeping' : awaking ? 'awaking' : 'sleeping',
              "time": int.parse(hourTransform.toString()),
              "hour": int.parse(hour.toStringAsFixed(0)),
              "minute": int.parse(minute.toString()),
              "comment": _comment,
              'picture': downloadUrl,
              'notify': notify,
              'share': share,
              'moreImages': imagesUrl,
              'createdBy': staffId,
              'type': "sleep",
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
      
      class Random {
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

