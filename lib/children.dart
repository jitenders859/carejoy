import 'package:carejoy/chat/chat.dart';
import 'package:carejoy/createchild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carejoy/addevent.dart';
import 'package:carejoy/day.dart';
import 'package:carejoy/login.dart';
import 'package:carejoy/profile.dart';
import 'package:carejoy/staff_login.dart';
import 'package:carejoy/theme.dart';
import 'package:carejoy/tools/app_methods.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:carejoy/tools/firebase.dart';
import 'package:carejoy/week.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/localization.dart';


class ChildrenPage extends StatefulWidget {
  final String childId;
  final bool back;
  ChildrenPage({
    this.childId,
    this.back,
  });
  
  @override
  _ChildrenPageState createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> with SingleTickerProviderStateMixin {
  TabController tabController;  
  int daysSubtotal = 0;
  DocumentSnapshot child;
  var dayCare;
  AppMethods appMethods = new FirebaseMethods();

  @override
  initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    fetchLocalData();
    getChildData();  
  }
  fetchLocalData() async {
    dayCare = await getDataLocally(key: 'dayCare');
  }

  getChildData() async  {
    var children = await Firestore.instance.collection("children").document(widget.childId).get();
    setState(() {
      child = children;      
    });
    
  }

  @override
  void dispose() {
    tabController.dispose(); 
    super.dispose();
  }

  TabBar makeTabBar() {
    return TabBar(tabs: <Tab>[
      Tab(
        text: "Day",
      ),
      Tab(
        text: "Week",
      ),
      Tab(
        text: "Profile",
      ),
    ], controller: tabController);
  }

  TabBarView makeTabBarView(tabs) {
    return TabBarView(
      children: tabs,
      controller: tabController,
    );
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var fields = AppLocalizations.of(context);
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
      title: fields.children,
      home: Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: black),  
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: widget.back != null ? IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ) : null,
          title: new Text(
            fields.child.toUpperCase(),
            style: TextStyle(
              fontSize: 20.0,
              color: black,
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
              onPressed: null,
              icon: Icon(
                Icons.calendar_today,
                color: black,
                size: 22.0,
              ),
            ),
            new IconButton(
              onPressed: null,
              icon: Icon(
                Icons.more_vert,
                color: black,
                size: 22.0,
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  onTap: () { 
                  
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) =>
                        Chat(
                          peerId: dayCare,
                          peerAvatar: child.data['childImage'],
                        )                      
                      )
                    );
                    
                  },
                  title: Text("Chat"),
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
              

              ],
            )
          )
        ),
        body: SingleChildScrollView(
          child: Container(
            width: screenSize.width,
            height: screenSize.width > screenSize.height ? screenSize.width : screenSize.height,
            child: Column(
            
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  
                  alignment: Alignment.center,
                  width: double.infinity,
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

                Stack(
                  alignment: Alignment.topLeft,
                  
                  children: <Widget>[
                     Container(
                       height: 130.0,
                       alignment: Alignment.bottomRight,
                       width: double.infinity,
                       decoration: BoxDecoration(
                         
                         image: DecorationImage(
                           image: AssetImage(
                             "assets/images/childback.jpg",
                           ),
                           fit: BoxFit.cover
                         )
                       ),
                       child: OutlineButton(
                         child: CreateChild(type: "${fields.profile}", childId: widget.childId,),
                       ),
                     ),
                     Container(
                        padding: EdgeInsets.only(top: 90.0, left: 25.0),
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: child == null ? AssetImage("assets/images/default_profile.png") : NetworkImage(
                            child.data['childImage'],
                          ),
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(top: 136.0,  left: 110.0),
                        child: child == null ? Text("") : Text("${child.data['childFirstName']} ${child.data['childLastName']}"),
                      )   
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                      
                    ),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 20.0, left: 30.0, right: 30.0),
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
                                  child: Text(
                                    fields.day,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: grey,
                                    ),
                                  ), 
                                ),
                                new Tab(
                                  child: Text(
                                    fields.week,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: grey,
                                    ),
                                  ),
                                ),
                                new Tab(
                                  child: Text(
                                    fields.profile,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                          Container(
                            width: screenSize.width,
                            height: screenSize.width > screenSize.height ? screenSize.width - 370.0 : screenSize.height - 370.0, 
                            child: new TabBarView(
                              controller: tabController,
                              children: <Widget>[
                                Day(childId: widget.childId, daysSubtotal: daysSubtotal),
                                Week(childId: widget.childId,),
                                Profile(childId: widget.childId), 
                              ],
                            ),
                          )
                        ],
                      )
                    ), 
                  ),
                )
                    
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
