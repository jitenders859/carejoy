import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/localization/localization.dart';
import 'package:carejoy/theme.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:carejoy/tools/progressdialog.dart';
class Profile extends StatefulWidget {
  
  final String childId;
  
  Profile({
    this.childId
  });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loading;
  DocumentSnapshot child;
  bool credit = false;
  bool mon, tues, weds, thurs, fri, sat;

  @override
  initState()  {
    super.initState();
    setState(() {
          loading = true;
    });
    getUserType(); 
    getChildData();
  }

  getUserType() async {
    print('userType');
     int userType = await getIntDataLocally(key: 'type');
     print(userType);
    if(userType == 4) {
      credit =  false;
    } else {
      credit =  true;
    }
  }

  getChildData() async  {
    var children = await Firestore.instance.collection("children").document(widget.childId).get();
    setState(() {
      child = children;      
      loading = false;
      mon = child.data['childPresence'][0];
      tues = child.data['childPresence'][1];
      weds = child.data['childPresence'][2];
      thurs = child.data['childPresence'][3];
      fri = child.data['childPresence'][4];
      sat = child.data['childPresence'][5];

    });


    
  }
  
  @override
  Widget build(BuildContext context) {
    var fields = AppLocalizations.of(context);
    return loading ? Container( child: CircularProgressIndicator(backgroundColor: blue,), width: 70.0, height: 70.0, alignment: Alignment.center,) : ListView(
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white
            ),
            child: GestureDetector(
              onTap: () {
              ProgressDialog(networkImage:  child.data['childImage'],);
                
              },
              child: AbsorbPointer(
                child: CircleAvatar(
                  maxRadius: 32.5,
                  backgroundImage: child == null ? AssetImage("assets/images/default_profile.png") : NetworkImage(
                              child.data['childImage'],
                  ),
                ),
              ),
            )
            
          ),
        ),
        Center(
          child: Text(
            "${child.data['childFirstName']} ${child.data['childLastName']}",
            style: TextStyle(
              fontFamily: roboto,
              color: grey,
              fontSize: 16.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          decoration: BoxDecoration(
            border: BorderDirectional(top: BorderSide(width: 2.0, color: blue), bottom: BorderSide(width:  2.0, color: blue) )
          ),
          child: Column(
            children: <Widget>[
              Text(
                "Info",
                style: TextStyle(
                  color: black,
                  fontFamily: roboto,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold
                )
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(
                child.data['childInformation'],
                style: TextStyle(
                  fontFamily: roboto,
                  color: grey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal
                ),
              )
            ],
          ),
        ),
        Text(
          "Presence",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: black,
            fontFamily: roboto,
            fontSize: 15.0,
            fontWeight: FontWeight.bold
          )
        ),
        Container(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                
                value: mon,
                onChanged: (value) {},
                activeColor: darkBlue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              
              Text(
                fields.mon,
                style: TextStyle(
                  color: black,
                  fontSize: 14.0
                )
              ),
              SizedBox(width: 10.0,),
              Checkbox(
                
                value: tues,
                onChanged: (value) {},
                activeColor: darkBlue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              
              Text(
                fields.tues,
                style: TextStyle(
                  color: black,
                  fontSize: 14.0
                )
              ),
              SizedBox(width: 10.0,),
              Checkbox(
                
                value: weds,
                onChanged: (value) {},
                activeColor: darkBlue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              
              Text(
                fields.weds,
                style: TextStyle(
                  color: black,
                  fontSize: 14.0
                )
              ),
            ],
          ),
        
        ),
        Container(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                
                value: thurs,
                onChanged: (value) {},
                activeColor: darkBlue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              
              Text(
                fields.thurs,
                style: TextStyle(
                  color: black,
                  fontSize: 14.0
                )
              ),
              SizedBox(width: 10.0,),
              Checkbox(
                
                value: fri,
                onChanged: (value) {},
                activeColor: darkBlue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              
              Text(
                fields.fri,
                style: TextStyle(
                  color: black,
                  fontSize: 14.0
                )
              ),
              SizedBox(width: 10.0,),
              Checkbox(
                
                value: sat,
                onChanged: (value) {},
                activeColor: darkBlue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              
              Text(
                fields.sat,
                style: TextStyle(
                  color: black,
                  fontSize: 14.0
                )
              ),
            ],
          ),
        ),
        Center(
          child: credit == true ?  Container(
            width: double.infinity,
            height: 60.0,
            margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              border: BorderDirectional(top: BorderSide(width: 2.0, color: blue), bottom: BorderSide(width:  2.0, color: blue) )
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "Parent Pin",
                  style: TextStyle(
                    color: black,
                    fontFamily: roboto,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  "${child.data['parentPin']}",
                  style: TextStyle(
                    fontFamily: roboto,
                    color: grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal
                  ),
                )
              ],
            ) 
          ): Text(
            "parentPin",
            style: TextStyle(
              color: Colors.transparent
            ),
          ),  
        ) ,
        SizedBox(height: 30.0,)
      ],
    );
  }
}
