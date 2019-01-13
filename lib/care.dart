import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:carejoy/add_child_dialog.dart';
import 'package:carejoy/boxcontainers.dart';
import 'package:carejoy/buildgridview.dart';
import 'package:carejoy/child_list_widget.dart';
import 'package:carejoy/children.dart';
import 'package:carejoy/commentbox.dart';
import 'package:carejoy/day.dart';
import 'package:carejoy/eventactions.dart';
import 'package:carejoy/home.dart';
import 'package:carejoy/play.dart';
import 'package:carejoy/profile.dart';
import 'package:carejoy/theme.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:carejoy/week.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/localization/localization.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CarePage extends StatefulWidget {
  final time;
  final childList;
  CarePage({
    this.childList,
    this.time,
  });
  @override
  _CarePageState createState() => _CarePageState();
}

class _CarePageState extends State<CarePage> with SingleTickerProviderStateMixin {
  var time;
  bool notify = true;
  bool share = true;
  bool beCareful = true;
  TabController tabController;

  List<Asset> uploadImages = List<Asset>();
  String multiImageError;

   
                

  bool showBottomBar = true;
  FocusNode _focus = new FocusNode();

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
  // checkup
  bool fever = false;
  bool earPain = false;
  bool crying = false;
  bool runnyNose = false;
  bool vomiting = false;
  bool toothache = false;

  // care
  bool eyeCleaning = false;
  bool noseCleaning = false;
  bool moisturizer = false;
  bool other = false;

  // medicine
  bool paracetamol = false;
  bool earDrops = false;
  bool eyeDrops = false;
  bool vitamin = false;
  var staffId;
  var dayCare;
  @override
  initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
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
  void dispose() {
    tabController.dispose(); 
    super.dispose();
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
          fields.care.toUpperCase(),
          
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
                padding: EdgeInsets.only(
                  top: 10.0,
                  left: 15.0,
                  right: 15.0,
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          top: 5.0, bottom: 0.0,
                          left: 20.0, right: 20.0
                        ),
                        width: double.infinity,
                        
                        color: shadowGrey,
                        child: new TabBar(
                          controller: tabController,
                          tabs: [
                            new Tab(

                              child: Container(
                                width: double.infinity,
                                height: 70.0,
                                alignment: Alignment.center,
                                
                                child: Image.asset(
                                  "assets/images/diagnosis_color.png",
                                  height: 40.0,
                                  width: 40.0,
                                ),
                              )
                            ),
                            new Tab(
                              child: Container(
                                width: double.infinity,
                                height: 50.0,
                                alignment: Alignment.center,
                                
                                child: Image.asset(
                                  "assets/images/medication_color.png",
                                  height: 40.0,
                                  width: 40.0,
                                ),
                              )
                            ),
                            new Tab(
                              child: Container(
                                width: double.infinity,
                                height: 70.0,
                                alignment: Alignment.center,
                                
                                child: Image.asset(
                                  "assets/images/care.png",
                                  height: 40.0,
                                  width: 40.0,
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    
                      Container(
                        padding: EdgeInsets.all(0.0),
                        width: double.infinity,
                        height: 250.0, 
                        child: new TabBarView(
                          controller: tabController,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(0.0),
                              height: 250.0,
                              width: double.infinity,
                              child: Column(
                                  children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 15.0),
                                      child: Row(
                                      children: <Widget>[
                                          Expanded(
                                          child: BoxContainer(
                                            containerHeight: 90.0,
                                            imageData: "assets/images/fever.png",
                                            imageText: fields.fever.toUpperCase(),
                                            imageWidth: 45.0,
                                            action: (value) { 
                                              setState(() {
                                                fever = !fever;
                                              });
                                            },
                                            value: fever
                                          )
                                          ),
                                          SizedBox(
                                          width: 15.0,
                                          ),
                                          Expanded(
                                          child: BoxContainer(
                                            containerHeight: 90.0,
                                            imageData: "assets/images/ear_pain.png",
                                            imageText: fields.earPain.toUpperCase(),
                                            imageWidth: 45.0,
                                            action: (value) { 
                                              setState(() {
                                                earPain= !earPain;
                                              });
                                            },
                                            value: earPain
                                          )
                                          ),
                                          SizedBox(
                                          width: 15.0,
                                          ),
                                          Expanded(
                                          child: BoxContainer(
                                            containerHeight: 90.0,
                                            imageData: "assets/images/crying.png",
                                            imageText: fields.crying.toUpperCase(),
                                            imageWidth: 45.0,
                                            action: (value) { 
                                              setState(() {
                                                crying = !crying;
                                              });
                                            },
                                            value: crying
                                          )
                                        ),
                                      ],
                                      ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                                      child: Row(
                                      children: <Widget>[
                                          Expanded(
                                            child: BoxContainer(
                                              containerHeight: 90.0,
                                              imageData: "assets/images/runny_nose.png",
                                              imageText: fields.runnyNose.toUpperCase(),
                                              imageWidth: 45.0,
                                              action: (value) { 
                                              setState(() {
                                                runnyNose = !runnyNose;
                                              });
                                            },
                                            value: runnyNose
                                            )
                                          ),
                                          SizedBox(
                                          width: 15.0,
                                          ),
                                          Expanded(
                                            child: BoxContainer(
                                              containerHeight: 90.0,
                                              imageData: "assets/images/vomiting.png",
                                              imageText: fields.vomiting.toUpperCase(),
                                              imageWidth: 45.0,
                                              action: (value) { 
                                              setState(() {
                                                vomiting = !vomiting;
                                              });
                                            },
                                            value: vomiting
                                            )
                                          ),
                                          SizedBox(
                                          width: 15.0,
                                          ),
                                          Expanded(
                                            child: BoxContainer(
                                              containerHeight: 90.0,
                                              imageData: "assets/images/toothache.png",
                                              imageText: fields.toothache.toUpperCase(),
                                              imageWidth: 45.0,
                                              action: (value) { 
                                              setState(() {
                                                toothache = !toothache;
                                              });
                                            },
                                            value: toothache
                                            )
                                          ),
                                      ],
                                      ),
                                  ),
                                  ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(0.0),
                              height: 250.0,
                              width: double.infinity,
                              child: Column(
                                  children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 15.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                          child: BoxContainer(
                                            containerHeight: 90.0,
                                            imageData: "assets/images/eye_cleaning.png",
                                            imageText: fields.eyeCleaning.toUpperCase(),
                                            imageWidth: 45.0,
                                            action: (value) { 
                                              setState(() {
                                                eyeCleaning = !eyeCleaning;
                                              });
                                            },
                                            value: eyeCleaning
                                          )
                                          ),
                                          
                                          SizedBox(
                                          width: 15.0,
                                          ),
                                          Expanded(
                                          child: BoxContainer(
                                            containerHeight: 90.0,
                                            imageData: "assets/images/nose_cleaning.png",
                                            imageText: fields.noseCleaning.toUpperCase(),
                                            imageWidth: 45.0,
                                            action: (value) { 
                                              setState(() {
                                                noseCleaning = !noseCleaning;
                                              });
                                            },
                                            value: noseCleaning
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                                      child: Row(
                                      children: <Widget>[
                                          Expanded(
                                            child: BoxContainer(
                                              containerHeight: 90.0,
                                              imageData: "assets/images/moisturizer.png",
                                              imageText: fields.moisturizer.toUpperCase(),
                                              imageWidth: 45.0,
                                              action: (value) { 
                                              setState(() {
                                                moisturizer = !moisturizer;
                                              });
                                            },
                                            value: moisturizer
                                            )
                                          ),
                                          SizedBox(
                                          width: 15.0,
                                          ),
                                          Expanded(
                                            child: BoxContainer(
                                              containerHeight: 90.0,
                                              imageData: "assets/images/other.png",
                                              imageText: fields.other.toUpperCase(),
                                              imageWidth: 45.0,
                                              action: (value) { 
                                              setState(() {
                                                other = !other;
                                              });
                                            },
                                            value: other
                                            )
                                          ),
                                          
                                        ],
                                      ),
                                  ),
                                  ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(0.0),
                              height: 250.0,
                              width: double.infinity,
                              child: Column(
                                  children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 15.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                          child: BoxContainer(
                                            containerHeight: 90.0,
                                            imageData: "assets/images/paracetamol.png",
                                            imageText: fields.paracetamol..toUpperCase(),
                                            imageWidth: 45.0,
                                            action: (value) { 
                                              setState(() {
                                                paracetamol = !paracetamol;
                                              });
                                            },
                                            value: paracetamol
                                          )
                                          ),
                                          
                                          SizedBox(
                                          width: 15.0,
                                          ),
                                          Expanded(
                                          child: BoxContainer(
                                            containerHeight: 90.0,
                                            imageData: "assets/images/ear_drop.png",
                                            imageText: fields.earDrops.toUpperCase(),
                                            imageWidth: 45.0,
                                            action: (value) { 
                                              setState(() {
                                                earDrops = !earDrops;
                                              });
                                            },
                                            value: earDrops
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                                      child: Row(
                                      children: <Widget>[
                                          Expanded(
                                            child: BoxContainer(
                                              containerHeight: 90.0,
                                              imageData: "assets/images/eye_drop.png",
                                              imageText: fields.eyeDrops.toUpperCase(),
                                              imageWidth: 45.0,
                                              action: (value) { 
                                              setState(() {
                                                eyeDrops = !eyeDrops;
                                              });
                                            },
                                            value: eyeDrops
                                            )
                                          ),
                                          SizedBox(
                                          width: 15.0,
                                          ),
                                          Expanded(
                                            child: BoxContainer(
                                              containerHeight: 90.0,
                                              imageData: "assets/images/vitamin.png",
                                              imageText: fields.vitamin,
                                              imageWidth: 45.0,
                                              action: (value) { 
                                              setState(() {
                                                vitamin = !vitamin;
                                              });
                                            },
                                            value: vitamin
                                            )
                                          ),
                                          
                                        ],
                                      ),
                                  ),
                                ],
                              ),
                            ), 
                          ],
                        ),
                      )
                    ],
                  )
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
                      FirebaseStorage.instance.ref().child('care_${timestamp}${i}.png');
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
                FirebaseStorage.instance.ref().child('care_${timestamp}.jpg');
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
      
      await Firestore.instance.collection('events').document(dayCare.toString()).collection("${todayUtcTimestamp.toString()}/${widget.childList[i]['childId']}/eventData").document("${hourTransform}").setData({
        
        'checkup': {'fever': fever, 'earPain': earPain, 'crying': crying, 'runnyNose': runnyNose, 'vomiting': vomiting, "toothache": toothache },
        'care': {'eyeCleaning': eyeCleaning, 'noseCleaning' : noseCleaning, 'moisturizer': moisturizer, 'other' : other,},
        'medicine' : {'paracetamol': paracetamol, 'earDrops': earDrops, 'eyeDrops': eyeDrops, 'vitamin': vitamin},
        "time": int.parse(hourTransform.toString()),
        "hour": int.parse(hour.toStringAsFixed(0)),
        "minute": int.parse(minute.toString()),  
        "comment": _comment,
        'picture': downloadUrl,
        'moreImages': imagesUrl,
        'notify': notify,
        'share': share,
        'createdBy': staffId,
        'type': "care",
      }).then((value) {
        if(widget.childList.length == i+1) {
          setState(() {
            saveData = false;      
          });
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Home()));
        }
      }).catchError((e) {
        print(e);
      });  
    }   
  }
  
}


