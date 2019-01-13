import 'dart:math';

import 'package:carejoy/chat/chat_children.dart';
import 'package:carejoy/create_room.dart';
import 'package:carejoy/settings/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carejoy/addevent.dart';
import 'package:carejoy/admin/main_screen.dart';
import 'package:carejoy/children.dart';
import 'package:carejoy/createStaff.dart';
import 'package:carejoy/createaccount.dart';
import 'package:carejoy/createchild.dart';
import 'package:carejoy/login.dart';
import 'package:carejoy/multi_image/main.dart';
import 'package:carejoy/newdate.dart';
import 'package:carejoy/staff_login.dart';
import 'package:carejoy/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:carejoy/tools/app_methods.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/localization/localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

import 'package:carejoy/tools/firebase.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ""),
        Locale('fr', ""),
      ],
      onGenerateTitle: (BuildContext context) => 
          AppLocalizations.of(context).home,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         brightness: Brightness.light,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController horizontalScrollController  = new ScrollController();
  ScrollController verticalScrollController = new ScrollController();
  ScrollController photoScrollController = new ScrollController();
  ScrollController timeScrollController = new ScrollController();
  double vertOffset = 0.0;
  double horizOffset = 0.0;
  int daysSubtotal = 0;
  List<DocumentSnapshot> snapshotData;
  String country = "";
  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();
  List<String> selectedChild = [];
  var dayCare;
  var staffId;
  String room = null;
  String staffEmail;
  String staffFullName;
  String staffPhoneNumber;
  bool firstLogin;
  AppMethods appMethods = new FirebaseMethods();
  
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


  @override
  initState()  {
    super.initState();
    checkLoggedIn();
    fetchLocalData();
    Future.delayed(Duration(seconds: 10)).then(
      (value) { 
        setState(() {
                  
        });
      }
    );
    
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    var android = new AndroidInitializationSettings('app_icon');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);
    
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {

      },
      onResume: (Map<String, dynamic> msg) {

      },
      onMessage: (Map<String, dynamic> msg) {

      }
    );
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        alert: true,
        badge: true,
      )
    );
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings) {

    });
    firebaseMessaging.getToken().then((token) {
      print("token" + token);
    });
    // showNotification();
  }
  
  Future onSelectNotification(String payload) {
    debugPrint('payload $payload' );
    showDialog(context: context, builder: (_) => new AlertDialog(
      title: new Text('notification'),
      content: Text("$payload"),
    ));
  }

  showNotification() async {
    var android = new AndroidNotificationDetails('channel id', 'channel name', 'channel description', importance: Importance.Max, priority: Priority.High );
    var iOS = new IOSNotificationDetails();
    print('id');
    int id =  Random().nextInt(100);

    var platform = new NotificationDetails(android, iOS);
    print('android ios');
    await flutterLocalNotificationsPlugin.show(id, 'new video is out', 'Flutter Local Notification', platform, payload: 'no payload').then((value) {
      print('sowed');
    }).catchError((e) {
      print(e);
    });
    print('show');
  }

  getChoices() async {
        
  }
  
  fetchLocalData() async {
    staffId = await getDataLocally(key: userId);
    dayCare =  await getDataLocally(key: 'dayCare');
    firstLogin = await getBoolDataLocally(key: 'firstLogin');
    staffFullName = await getDataLocally(key: fullName);
    staffEmail = await getDataLocally(key: email);
    staffPhoneNumber = await getDataLocally(key: phoneNumber);
     
    bool snapShotStatus = await getSnapshotData();
     
     
  }

  void _showOnLoadChildDialog(context, mainKey) {
    var screenSize = MediaQuery.of(context).size;
    // flutter defined function
    var fields = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          titlePadding: EdgeInsets.all(0.0),
          contentPadding: EdgeInsets.all(0.0),
          
          title: Row(
            children: <Widget>[
              Icon(Icons.close, color: Colors.transparent),
              Expanded(
                child: Text(
                  fields.addNewChild,
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
          content: ShowingAlertDialog( mainKey: mainKey,)
        );
      },
    );
  }

  checkLoggedIn() async {
    bool isLoggedIn = await getBoolDataLocally(key: loggedIn);
      print("$isLoggedIn" + "loggedin");
      if(isLoggedIn == false) {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Login() ));

      } else {
      int userType = await getIntDataLocally(key: 'type');
      
      print(userType);
      if(userType == 4) {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Login() )); 
      }
    }
  }

  Future<bool> getSnapshotData() async {
   
    QuerySnapshot querySnapshot =  await Firestore.instance.collection(childCollection).where('dayCare', isEqualTo: dayCare).where('room', isEqualTo: room).getDocuments();
     setState(() {
        snapshotData = querySnapshot.documents;      
      });
      
      if(snapshotData.length  == 0) {
        _showOnLoadChildDialog(context, mainKey);
      }
    
    return true;
  }


  @override
  void dispose() {
      super.dispose();
  }

  void onItemMenuPress(DocumentSnapshot choice) {
    if(choice['id'] == 'no room' ) {
      room = null;
    } else {
      room = choice['id'];
    }
    
    getSnapshotData();
  }

  onHorizontalDrag(DragUpdateDetails details) {
    setState(() {
        if(horizOffset > photoScrollController.position.maxScrollExtent) {
          horizOffset = photoScrollController.position.maxScrollExtent;
        } else if( horizOffset < photoScrollController.position.minScrollExtent) {
          horizOffset = photoScrollController.position.minScrollExtent;
        } else {
          horizOffset = horizOffset - details.delta.dx;
        }

        photoScrollController.jumpTo(horizOffset);
        horizontalScrollController.jumpTo(horizOffset);
      }
    );

  }    

  @override
  Widget build(BuildContext context) {
    var fields = AppLocalizations.of(context);
    return Scaffold(
      key: mainKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        iconTheme: new IconThemeData(color: black),  
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: GestureDetector(
          onLongPress: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AdminScreen()));
          },
          child: new Text(
            fields.home,
            
            style: TextStyle(
              fontSize: 20.0,
              color: black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
        
        actions: <Widget>[
          StreamBuilder(
            stream: Firestore.instance.collection("rooms").document(dayCare).collection(dayCare).orderBy('timestamp', descending: false).snapshots(),
            builder: (context, snapshot){
                if(!snapshot.hasData) {
                  return Container( 
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(),
                  );
                } else {
                return PopupMenuButton<DocumentSnapshot>(
                onSelected: (choice) { 
                  setState(() {
                  });
                  onItemMenuPress(choice);
                },
                itemBuilder: (BuildContext context) {
                  return snapshot.data.documents.map<PopupMenuItem<DocumentSnapshot>>(( document) {
                    return PopupMenuItem<DocumentSnapshot>(
                        value: document,
                        child: 
                            Text( 
                              document['id'].toString(),
                              style: TextStyle(color: grey),
                            ),
                        );
                    }).toList();
                  },
                );

              }
            }
          ),
          
          CreateStaff(),  
          
          CreateChild(mainkey: mainKey,),      
          
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 0.0),
            color: shadowGrey,
            child: Row(
              children: <Widget>[
                IconButton(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  icon: Icon(
                    Icons.arrow_left,
                    color: grey,
                    size: 22.0,
                  ),
                  onPressed: () {
                    setState(() {
                      daysSubtotal = daysSubtotal - 1;                 
                    
                    });
                  },
                ),
                Expanded(
                  child: Container(
                    
                    alignment: Alignment.center,
                    width: double.infinity,
                    color: shadowGrey,
                    child: Text(
                      DateFormat.yMMMd().format(DateTime.now().toUtc().add(Duration(days: daysSubtotal))),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: grey,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  icon: Icon(
                    Icons.arrow_right,
                    color: grey,
                    size: 22.0,
                  ),
                  onPressed: () {
                    setState(() {
                      daysSubtotal = daysSubtotal + 1;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(0.0),
            padding: EdgeInsets.all(0.0),
            height: 85.0,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Card(
                      margin: EdgeInsets.all(0.0),
                      elevation: 0.0,
                      child: Container(
                        height: 85.0,
                        width: 80.0,
                        
                        margin: EdgeInsets.all(0.0),
                        padding: EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFF6f6f6),
                          border: BorderDirectional(
                            end: BorderSide(width: 3.0, color: shadowGrey, style: BorderStyle.solid),
                            bottom: BorderSide(width: 3.0, color: shadowGrey, style: BorderStyle.solid)
                          ),
                        ),
                        child: Image.asset('assets/images/childrentime.jpg'),
                      ),
                    ), 
                    Expanded(
                      child: Container(
                         decoration: BoxDecoration(
                           border: Border(bottom: BorderSide(width: 2.0, color: shadowGrey, style: BorderStyle.solid))
                         ),
                         child: new StreamBuilder<QuerySnapshot>  (
                          stream: Firestore.instance.collection(childCollection).where('dayCare', isEqualTo: dayCare).where('room', isEqualTo: room).snapshots(),                
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            
                            if (!snapshot.hasData) {
                               
                              return Text("${fields.noData}");
                               
                            } else {
                              
                              return ChildList(photoScrollController: photoScrollController, list: snapshot, dayCare: dayCare, dragging: ( DragUpdateDetails details) {
                                onHorizontalDrag(details);
                              }, longpress: (String data ) {
                                
                                var match = false;
                                selectedChild.every((test) {
                                  if(test == data) {
                                    match  = true;
                                  }
                                  return true;     
                                     
                                  });
                                  if(match == false) {
                                    setState(() {
                                       selectedChild.add(data);
                                                    
                                    });
                                  } else {
                                    
                                  }
                                  return true;
                                },
                              );
                            }
                            
                          }
                        ), 
                      ),
                    ),
                  ],
                ),
                
              ],
            ),
            
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 2.0,
                        color: shadowGrey,
                        style: BorderStyle.solid 
                      )
                    )
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ListView.builder(
                        controller: timeScrollController,
                        itemCount: 24,
                        itemBuilder: (BuildContext context, int index) {
                          return new Card(
                            margin: EdgeInsets.all(0.0),
                            elevation: 0.0,
                            child: Container(
                              alignment: Alignment.center,
                              width: 70.0,
                              height: 70.0,
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                index < 6 ?
                                "${7 + index} ${fields.am}" : 
                                index < 18  ? "${index - 5 } ${fields.pm}" :
                                "${index - 17 } ${fields.am}",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: black,

                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Center(
                        child: GestureDetector(               
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                            setState(() {
                              if(vertOffset > timeScrollController.position.maxScrollExtent) {
                                vertOffset = timeScrollController.position.maxScrollExtent;
                              } else if( vertOffset < timeScrollController.position.minScrollExtent) {
                                vertOffset = timeScrollController.position.minScrollExtent;
                              } else {
                                vertOffset = vertOffset - details.delta.dy;
                              }

                              timeScrollController.jumpTo(vertOffset);
                              verticalScrollController.jumpTo(vertOffset);
                            }
                          );
                        },
                        
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Text(
                            "hello",
                            style: TextStyle(
                              color: Colors.transparent
                            ),
                          ),
                        ),
                        ),
                      )
                    ],
                  ),
                  
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ListView.builder(
                        controller: horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshotData == null ? 0 : snapshotData.length,
                        
                        itemBuilder: (BuildContext context, int index) {
                          return HorizList(
                            scrollController: verticalScrollController,
                            indexInt:  index,
                            snapShotData: snapshotData,
                            daysSubtotal: daysSubtotal,
                            snapLength: snapshotData.length,
                            room: room,
                            horizdrag: (details) {
                              setState(() {
                                  if(horizOffset > photoScrollController.position.maxScrollExtent) {
                                    horizOffset = photoScrollController.position.maxScrollExtent;
                                  } else if( horizOffset < photoScrollController.position.minScrollExtent) {
                                    horizOffset = photoScrollController.position.minScrollExtent;
                                  } else {
                                    horizOffset = horizOffset - details.delta.dx;
                                  }
                                  
                                  photoScrollController.jumpTo(horizOffset);
                                  horizontalScrollController.jumpTo(horizOffset);
                                }
                              );
                            },
                            vertdrag: (details) {
                              setState(() {
                                  if(vertOffset > timeScrollController.position.maxScrollExtent) {
                                    vertOffset = timeScrollController.position.maxScrollExtent;
                                  } else if( vertOffset < timeScrollController.position.minScrollExtent) {
                                    vertOffset = timeScrollController.position.minScrollExtent;
                                  } else {
                                    vertOffset = vertOffset - details.delta.dy;
                                  }

                                  timeScrollController.jumpTo(vertOffset);
                                  verticalScrollController.jumpTo(vertOffset);
                                }
                              );    
                            },
                          );
                        },
                      ),
                      
                      
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: blue,
              ),
              otherAccountsPictures: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    size: 32.0,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                  
                ),
                IconButton(
                  icon: Icon(
                    Icons.chat,
                    size: 32.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print('hello');
                  },
                  tooltip: "Chat",
                )
              ],
              currentAccountPicture: CircleAvatar(
                child: Image.asset('assets/images/default_profile.png'),
              ),
              accountName: Text(
                staffFullName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: roboto,
                  fontSize: 16.0
                ),
              ),
              accountEmail: Text(
                staffEmail,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: roboto,
                  fontSize: 16.0
                ),
              ),
            ),
            ListTile(
              onTap: () { 
              Navigator.of(context).pop();  
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) =>
                AddEvent() 
                )
              );
              
              },
              title: Text("${fields.add} ${fields.event}"),
            ),

            ListTile(
              title: CreateChild(type: "${fields.create} ${fields.children}", mainkey: mainKey,),
            ),
            ListTile(
              title: CreateStaff(type: "${fields.create} ${fields.staff}"),
            ),
            ListTile(
              onTap: () async { 
              Navigator.of(context).pop();
               await clearDataLocally();
              appMethods.logOutUser();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) =>
                 LoginPage() 
                )
              );
                
              },
              title: Text("${fields.logOut}"),
            ),
            ListTile(
              title: Text("Chat Screen"),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChatChildren())),
            ),
            ListTile(
              title: Text("profile"),
              onTap: ()  {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProfileHomePage()));
              },
            ),
            ListTile(
              title: Text("Create Rooms"),
              onTap: ()  {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (BuildContext context) => Rooms()));
              },
            ),
          ],
        )
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          
          selectedChild.isNotEmpty ? FloatingActionButton(
             heroTag: "btn1",
             child: RaisedButton(
               color: Colors.transparent,
               elevation: 0.0,
               child: Text(
                  selectedChild.length.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: roboto,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700
                  ),
               ),
               onPressed: () {
                
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddEvent(selectedChilds: selectedChild,)));
               },
             ),
             
           ) : Container(),
          SizedBox(height: 20.0),
          FloatingActionButton(
            heroTag: "btn2",
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () { 
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddEvent()));
              },
            ),
            onPressed: () { 
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddEvent()));
            },
          ),
        ],
      ),
      
    );
  }
}

class HorizList extends StatefulWidget {
  
  final ScrollController scrollController;
  final int indexInt;
  final int snapLength;
  final List<DocumentSnapshot> snapShotData;
  final int daysSubtotal;
  final GestureDragUpdateCallback vertdrag;
  final GestureDragUpdateCallback horizdrag;
  final String room;
  HorizList({this.scrollController, this.indexInt, this.snapShotData, this.vertdrag, this.horizdrag, this.daysSubtotal, this.snapLength, this.room}); 

  
  @override
  _HorizListState createState() => _HorizListState();
}

class _HorizListState extends State<HorizList> {
  int indexInt;
  List<DocumentSnapshot> snapShotData;
  var currentMonth;
  var currentYear;
  var currentday;
  var hour = DateFormat.H().format(DateTime.now().toUtc());
  var minute = DateFormat.m().format(DateTime.now().toUtc());
  var second = DateFormat.s().format(DateTime.now().toUtc());
  
  var todayUtcTimestamp;
  bool imageLoading = false;
  var sampleImage;
  var todayHourTimestamp;
  QuerySnapshot  rowData;
  DocumentSnapshot tenrowData;
  int documentsLength;
  List<String> selectedChild = [];
  int daysSubtotal = 0;  
  var dayCare;
  var staffId;
  
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      fetchLocalData();
      indexInt = widget.indexInt;
      snapShotData = widget.snapShotData;
      daysSubtotal = widget.daysSubtotal;
      var timestamp = new DateTime.now().toUtc().millisecondsSinceEpoch;   
      currentMonth = DateFormat.M().format(DateTime.now().toUtc().add(Duration(days: daysSubtotal)));
      currentYear = DateFormat.y().format(DateTime.now().toUtc().add(Duration(days: daysSubtotal)));
      currentday = DateFormat.d().format(DateTime.now().toUtc().add(Duration(days: daysSubtotal)));

      todayUtcTimestamp = new DateTime.utc(int.parse(currentYear), int.parse(currentMonth), int.parse(currentday)).millisecondsSinceEpoch;
      todayHourTimestamp = timestamp - todayUtcTimestamp;
      
      selectedChild.add(snapShotData[indexInt]['childId']);
      
  }

   fetchLocalData() async {
    staffId = await getDataLocally(key: userId);
    dayCare =  await getDataLocally(key: 'dayCare');
    getRowData(null);
  }

  @override
    void didUpdateWidget(HorizList oldWidget) {
        if(daysSubtotal != widget.daysSubtotal) {
            setState((){
                daysSubtotal = widget.daysSubtotal;
            });
            currentMonth = DateFormat.M().format(DateTime.now().toUtc().add(Duration(days: daysSubtotal)));
            currentYear = DateFormat.y().format(DateTime.now().toUtc().add(Duration(days: daysSubtotal)));
            currentday = DateFormat.d().format(DateTime.now().toUtc().add(Duration(days: daysSubtotal)));
            todayUtcTimestamp = new DateTime.utc(int.parse(currentYear), int.parse(currentMonth), int.parse(currentday)).millisecondsSinceEpoch;
             
              getRowData(indexInt);
            
        }

        if(snapShotData != widget.snapShotData) {
          setState(() {
            snapShotData = widget.snapShotData;                      
          });
          getRowData(indexInt);
        }
        if(indexInt != widget.indexInt) {
          setState(() {
            indexInt = widget.indexInt;                      
          });
          getRowData(indexInt);
        
        }
        super.didUpdateWidget(oldWidget);
    }
  
  void getRowData(index) async {
    
    QuerySnapshot data;
    if(index == null) {

      data = await Firestore.instance.collection("events").document(dayCare.toString()).collection(todayUtcTimestamp.toString()).document(snapShotData[indexInt]['childId']).collection('eventData').getDocuments();
    } else {
      data = await Firestore.instance.collection("events").document(dayCare.toString()).collection(todayUtcTimestamp.toString()).document(snapShotData[indexInt]['childId']).collection('eventData').getDocuments();
    }
     setState(() {
       rowData = data;
     }); 
     if(rowData != null) {
       documentsLength = rowData.documents.length;
     }
  }

  getRightImage(rowData, i) {
    if(rowData.documents[i]['type'] == 'arrive') {
      return Image.asset('assets/images/arrive.png');
    } else if(rowData.documents[i]['type'] == 'play') {
      return Image.asset('assets/images/play.png');
    } else if(rowData.documents[i]['type'] == 'leave') {
      return Image.asset('assets/images/leave.png');
    } else if(rowData.documents[i]['type'] == 'diaper') {
      return Image.asset('assets/images/diaper.png');
    } else if(rowData.documents[i]['type'] == 'care') {
      return Image.asset('assets/images/care.png');
    } else if(rowData.documents[i]['type'] == 'food') {
      return Image.asset('assets/images/food.png');
    } else if(rowData.documents[i]['type'] == 'sleep') {
      return Image.asset('assets/images/sleep.png');
    } else {
      return Image.asset('assets/images/cookie.png');
    }
  }

  getImageData(index, QuerySnapshot rowDatas) {
    
    if(rowDatas != null) {
    
      for(var i = 0; i < rowDatas.documents.length; i++) {
        if(index + 7 < 25) {
          if(int.parse(rowDatas.documents[i].documentID)  == index + 7 ) {
            
            return GestureDetector(
              onTap: () {
                
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddEvent(selectedChilds: selectedChild, time: index + 7)));      
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                widget.vertdrag(details);
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                widget.horizdrag(details);
              },
              onLongPress: () {
                setState(() {
                  Firestore.instance.collection("events").document(dayCare.toString()).collection(todayUtcTimestamp.toString()).document(snapShotData[indexInt]['childId']).collection('eventData').document((index + 7).toString()).delete();
                    
                    getRowData(indexInt); 
                                  
                });
              },
              child: Container(
                height: 70.0,
                width: 70.0,
                child: getRightImage(rowDatas, i),
              )
            );     
            
          }   
        }  else {
          if(int.parse(rowDatas.documents[i].documentID)  == index + 7 - 24  ) {
            
            return GestureDetector(
              onTap: () {
                print('photo');
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddEvent(selectedChilds: selectedChild, time: (index + 7 -24))));      
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                widget.vertdrag(details);
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                widget.horizdrag(details);
              },
              onLongPress: () {
                setState(() {
                  Firestore.instance.collection("events").document(dayCare.toString()).collection(todayUtcTimestamp.toString()).document(snapShotData[indexInt]['childId']).collection('eventData').document((index + 7 -24).toString()).delete();
                    
                    getRowData(indexInt); 
                                  
                });
              },
              child: Container(
                height: 70.0,
                width: 70.0,
                child: getRightImage(rowDatas, (i)),
              )
                 
            );
          }
        }
      }
    }
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        widget.vertdrag(details);
      },  
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        widget.horizdrag(details);
      },
      onTap: () {
        int passParameter = 1;
        if(index + 7 < 25) {
          passParameter = index + 7;
        } else {
          passParameter = index + 7 - 24;
        }

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddEvent(selectedChilds: selectedChild, time: passParameter)));
      },
      child: Opacity(
        opacity: 0.0,
        child: Image.asset(
          "assets/images/diaper.png",
           width: 70.0,
           height: 70.0,
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,

      child: new ListView.builder(
        controller: widget.scrollController,
        itemBuilder: (context, index){
        return GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
        widget.vertdrag(details);
        },  
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          widget.horizdrag(details);
        },
        onTap: () {
          int passParameter = 1;
          if(index + 7 < 25) {
            passParameter = index + 7;
          } else {
            passParameter = index + 7 - 24;
          }
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddEvent(selectedChilds: selectedChild, time: passParameter)));
        },
          child: new Card(
            margin: EdgeInsets.all(0.0),
            elevation: 0.0,
            child: new Container(
              height: 70.0,
              width: 70.0,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: shadowGrey, style: BorderStyle.solid)
              ),
              padding: EdgeInsets.all(12.0),
              child: getImageData(index, rowData),
              alignment: Alignment.center,
              )
            ),
        );
        }, 
        scrollDirection: Axis.vertical,),
      );
  }
}


class FormInputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool autoCorrect;
  final bool validator;
  final String validationText;
  final Function passParameter;
  final TextEditingController controller;
  FormInputField(
    {
      this.labelText,
      this.hintText,
      this.autoCorrect,
      this.validator,
      this.validationText,
      this.passParameter,
      this.controller
    }
  );


  @override
  Widget build(BuildContext context) {
    return 
    labelText.isNotEmpty ? 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          labelText,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: black,
            
            fontSize:  14.0,
          ),
        ),
        SizedBox(height: 4.0,),
        TextFormField(
          controller: controller,
          scrollPadding: EdgeInsets.all(0.0),
          autocorrect: autoCorrect,
          decoration: InputDecoration(
            fillColor: grey,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 12.0,
              color: grey,

            ),
            contentPadding: EdgeInsets.all(14.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2.0,
                color: shadowGrey,
                style: BorderStyle.solid
              )
            )
          ),
          
          validator: (str) =>
            validator ? validationText : null, 
          
        ),
      ],
    ) : TextFormField(
          controller: controller,
          scrollPadding: EdgeInsets.all(0.0),
          autocorrect: autoCorrect,
          decoration: InputDecoration(
            fillColor: grey,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 12.0,
              color: grey,

            ),
            contentPadding: EdgeInsets.only(top: 14.0, bottom: 70.0, left: 14.0, right:  14.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2.0,
                color: shadowGrey,
                style: BorderStyle.solid
              )
            )
          ),
          
          validator: (str) =>
            validator ? validationText : null, 
          
        );
  }

}


class ChildList extends StatelessWidget {
  final ScrollController photoScrollController;
  final AsyncSnapshot<QuerySnapshot> list;
  final GestureDragUpdateCallback dragging;
  final void Function(String) longpress;
  final String dayCare;
  ChildList({
    this.photoScrollController,
    this.list,
    this.dragging,
    this.longpress,
    this.dayCare
  });

  
  
  @override
  Widget build(BuildContext context) {
    var map = list.data.documents;
     
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: photoScrollController,
      itemCount: list.data.documents.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
          margin: EdgeInsets.all(0.0),
          elevation: 0.0,
          child: Container(
            alignment: Alignment.center,
            width: 70.0,
            height: 85.0,
            decoration: BoxDecoration(
              
            ),
            padding: EdgeInsets.all(0.0),
            margin: EdgeInsets.all(0.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onLongPress: () {
                    longpress(map[index]['childId']);
                  },
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChildrenPage(childId: map[index]['childId'], back: true,)));
                  },
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    dragging(details);
                  },
                  child: Container(
                    width: 65.0,
                    height: 65.0,

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(map[index]['childImage']),
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
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    dragging(details);
                  },
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChildrenPage(childId: map[index]['childId'], back: true,)));
                  },
                  child: Text(
                    map[index]['childFirstName'],
                    style: TextStyle(
                      color: black,
                      fontSize: 14.0
                    ),
                  ),
                )
              ],
            )
          ),
        );
      }
    );
  }
}


class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
