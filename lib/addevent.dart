import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:carejoy/add_child_dialog.dart';
import 'package:carejoy/arrive.dart';
import 'package:carejoy/care.dart';
import 'package:carejoy/child_list_widget.dart';
import 'package:carejoy/diapers_change.dart';
import 'package:carejoy/eat.dart';
import 'package:carejoy/home.dart';
import 'package:carejoy/leave.dart';
import 'package:carejoy/localization/localization.dart';
import 'package:carejoy/login.dart';
import 'package:carejoy/play.dart';
import 'package:carejoy/sleep.dart';
import 'package:carejoy/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:carejoy/tools/app_methods.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:carejoy/tools/firebase.dart';

class AddEvent extends StatelessWidget {

  final List<String> selectedChilds;
  final int time;
  AddEvent({
    this.selectedChilds, 
    this.time
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return HomePage();
        }));
      },
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ""),
          Locale('fr', ""),
        ],
        title: "Add Event",
        home: Events(selectedChilds: selectedChilds, time: time,)
      ),
    );
  }
}

class Events extends StatefulWidget 
{
  final List<String> selectedChilds;
  final int time;
  
  
  Events({
    this.selectedChilds,
    this.time
  });  
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  var time;
  AppMethods appMethods = new FirebaseMethods();
  ScrollController scrollController = new ScrollController();
  List<Event> eventList = [
    Event(image: Image.asset("assets/images/arrive.png"), text: "ARRIVE"),
    Event(image: Image.asset("assets/images/food.png"), text: "FOOD"),
    Event(image: Image.asset("assets/images/diaper.png"), text: "DIAPER"),
    Event(image: Image.asset("assets/images/play.png"), text: "PLAY"),
    Event(image: Image.asset("assets/images/sleep.png"), text: "SLEEP"),
    Event(image: Image.asset("assets/images/care.png"), text: "CARE"),
    Event(image: Image.asset("assets/images/leave.png"), text: "LEAVE"),
  ];
  double vertOffset  = 0.0;
  var childList = [];
  var dayCare;
  var staffId;
  List<String> selectedChildList = [];
  

  @override
  void initState() {
      
    super.initState();
    fetchLocalData();  
    
    time = widget.time; 
    selectedChildList = widget.selectedChilds;  
  }

  fetchLocalData() async {
    staffId = await getDataLocally(key: userId);
    dayCare =  await getDataLocally(key: 'dayCare');
    if(selectedChildList != null) {
      getChildList();
    }
    
  }
  

  void getChildList() async {
    // QuerySnapshot querySnapshot = await Firestore.instance.collection(childCollection).where('childId', isEqualTo: "1544681680653" ).getDocuments();
    // print('snap');
    // childList = querySnapshot.documents;
    // print(childList.length);
    await Firestore.instance.collection('children').where('dayCare', isEqualTo:  dayCare).getDocuments().then((data) {
        
        for(var j = 0; j < data.documents.length; j++) {
          var childdata = data.documents[j];
          for(var i = 0; i < selectedChildList.length; i++) {
            if(childdata.documentID == selectedChildList[i]) {
              setState(() {
                childList.add(childdata);
              });              
            }
          }
        }
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
         "${fields.add.toUpperCase()} ${fields.event.toUpperCase()}",
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
            child: Container(),
          ),
          ListView(
            controller: scrollController,
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
                          list: childList,
                          action: (childData) {
                            
                            setState(() {
                              childList.remove(childData);                              
                            });
                            
                          },
                        ),
                           
                      ),
                    ),
                    AddChildDialogButton(
                      childList: childList,
                      action: (document) {
                        setState(() {
                          childList.add(document);                                                    
                        });
                      },
                    ),
                  ],
                ),
                
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                  ),
                ), 
              ),
              Container(
                height: (eventList.length /2 ).round() * screenSize.width/7,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                  child: new StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    primary: true,
                    shrinkWrap: true,
                    itemCount: eventList.length,
                    itemBuilder: (BuildContext context, int index) => 
                      GestureDetector(

                        onTap: () {
                          
                          if(eventList[index].text.toLowerCase() == "arrive") {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return ArrivePage(childList: childList, time: widget.time,);
                            }));
                          } else if(eventList[index].text.toLowerCase() == "food") {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return EatPage(childList: childList, time: widget.time,);
                            }));  
                          } else if(eventList[index].text.toLowerCase() == "diaper") {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return ChangeDiapersPage(childList: childList, time: widget.time,);
                            }));
                          } else if(eventList[index].text.toLowerCase() == "play") {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return PlayPage(childList: childList, time: widget.time,);
                            }));
                          } else if(eventList[index].text.toLowerCase() == "sleep") {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return SleepPage(childList: childList, time: widget.time,);
                            }));
                          } else if(eventList[index].text.toLowerCase() == "care") {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return CarePage(childList: childList, time: widget.time,);
                            }));
                          } else if(eventList[index].text.toLowerCase() == "leave") {
                            print('leave');
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return LeavePage(childList: childList, time: widget.time,);
                            }));
                          } else {
                            print('hello');
                          }
                          
                        },
                        child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2.0, color: shadowGrey, style: BorderStyle.solid),
                          color: Colors.white,
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
                              child: eventList[index].image
                            ),
                            Text(
                              eventList[index].text.toLowerCase() == 'arrive' ? fields.arrive.toUpperCase() : 
                              eventList[index].text.toLowerCase() == 'food' ? fields.food.toUpperCase() :
                              eventList[index].text.toLowerCase() == 'diaper' ? fields.diaper.toUpperCase() :
                              eventList[index].text.toLowerCase() == 'play' ? fields.play.toUpperCase() :
                              eventList[index].text.toLowerCase() == 'sleep' ? fields.sleep.toUpperCase() :
                              eventList[index].text.toLowerCase() == 'care' ? fields.care.toUpperCase() :
                              eventList[index].text.toLowerCase() == 'leave' ? fields.leave.toUpperCase() : fields.arrive.toUpperCase(),
                              style: TextStyle(
                                color: black,
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
                    physics: new NeverScrollableScrollPhysics()
                  ),
                ),
              ), 
              SizedBox(
                height: 350.0,
              )
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return HomePage();
                              })
                            );
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
                              widget.time != null ? "${widget.time}:00" :
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
                            Icons.keyboard_arrow_right,
                            size: 35.0,
                            color: Colors.white  
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return ArrivePage(childList: childList, time: widget.time);
                              })
                            );
                          },
                        ),
                      ),      
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
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

            ],
          )
        )
      ),
    );
  }
}

class Event {
  final Image image;
  final String text;

  Event({
    this.image,
    this.text
  });

}


