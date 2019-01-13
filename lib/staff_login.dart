import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carejoy/children.dart';
import 'package:carejoy/home.dart';
import 'package:carejoy/theme.dart';
import 'package:flutter/material.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/localization/localization.dart';

class StaffLogin extends StatefulWidget {
  final String email;
  
  
  StaffLogin({
    this.email,
  });
  @override
  _StaffLoginState createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  Firestore firestore = Firestore.instance;
  final mainKey = GlobalKey<ScaffoldState>();
  bool passwordObscure = true;
  
  @override
  Widget build(BuildContext context) {
    var fields = AppLocalizations.of(context);
    return MaterialApp(
      title: "${fields.staff} ${fields.login}",
      theme: ThemeData(
        primaryColor: blue,
        hintColor: blue,
      ),
      home: Scaffold(
        key: mainKey,
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 80.0,),
            Text(
              "LOGO",
              style: TextStyle(
                fontFamily: bebas,
                color: black,
                fontSize: 50.0
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              "${fields.welcome} ${fields.back} !",
              style: TextStyle(
                fontSize: 20.0,
                color: black,
                fontFamily: roboto,
                fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "${fields.checkIn} ${fields.please}",
              style: TextStyle(
                fontFamily: roboto,
                color: black,
                fontSize: 16.0
              ),
            ),
            SizedBox(
              height: 30.0, 
            ),
            PinPut( 
              fieldsCount: 6, 
              clearButtonColor: 0xFF3462AF,
              isTextObscure: passwordObscure, 
              fontSize: 30.0,  
              borderRadius: 1.0,
              autoFocus: true,
              
              onSubmit: (String pin) {
                FirebaseAuth.instance
                .signInWithEmailAndPassword(
                  email: widget.email, password: pin
                ).then(
                  (FirebaseUser user) async {
                    
                    int userInfo = await getUserInfo(user.uid);   
                    if(userInfo == 1 || userInfo == 2 || userInfo == 3) {
                     
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) 
                          => HomePage()
                          )
                        );
                     
                    } else if(userInfo == 4) {
                      var childrenId = await getDataLocally(key: "childId");
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) 
                      => ChildrenPage(childId: childrenId,)));
                    } else if(userInfo == 0) {
                      var snackbar = SnackBar(
                        content:
                            Text("Your Password is Incorrect."),
                        duration: Duration(milliseconds: 5000),
                      );

                      mainKey.currentState.showSnackBar(snackbar);
                    }
                    // print(userInfo[userEmail]);
                    
                  } 
                ).catchError((e) {
                  var snackbar = SnackBar(
                    content: Text("Your Password is Incorrect."),
                    duration: Duration(milliseconds: 5000),
                  );

                  mainKey.currentState.showSnackBar(snackbar);

                });
              }
            ),
              
              GestureDetector(
                onTap: () {
                  setState(() {
                    passwordObscure = !passwordObscure;                    
                });   
                                                          
                  
                },
                child: new Icon(
                  Icons.remove_red_eye,
                  color: grey,
                  size: 32.0,
                ),
              )
            
          ], 
        ),
        
      ),
    );
  }

  

  Future<int> getUserInfo(String userid) async {
    // TODO: implement getUserInfo
    DocumentSnapshot result = await firestore.collection('usersData').document(userid).get();
    if(result.data != null) {
      writeDataLocally(key: userId, value: result.data[userId]);            
      writeDataLocally(key: email, value: result.data[email]);
      writeDataLocally(key: phoneNumber, value: result.data[phoneNumber]);
      writeDataLocally(key: fullName, value: result.data[fullName]);
      writeIntDataLocally(key: type, value: result.data[type]);
      writeBoolDataLocally(key: loggedIn, value: true);
      writeDataLocally(key: 'dayCare', value: result.data[userId]);
      writeBoolDataLocally(key: 'firstLogin', value: true);
      
      return result.data['type'];
    
    } else {
      DocumentSnapshot parentData = await firestore.collection('parent').document(userid).get();
      
      
      if(parentData.data  != null) {
        writeDataLocally(key: userId, value: parentData.data[userId]);            
        writeDataLocally(key: email, value: parentData.data[email]);
        writeDataLocally(key: phoneNumber, value: parentData.data[phoneNumber]);
        writeDataLocally(key: fullName, value: parentData.data[fullName]);
        writeIntDataLocally(key: type, value: parentData.data[type]);
        writeBoolDataLocally(key: loggedIn, value: true);
        writeDataLocally(key: 'dayCare', value: parentData.data['dayCare']);
        writeDataLocally(key: 'childId', value: parentData.data['childId']);
        writeBoolDataLocally(key: 'firstLogin', value: true);
        return parentData.data['type'];
      } else {
          
        DocumentSnapshot staffData = await firestore.collection('staffMember').document(userid).get();
        if(staffData.data != null) {
          writeDataLocally(key: userId, value: staffData.data[userId]);            
          writeDataLocally(key: email, value: staffData.data[email]);
          writeDataLocally(key: phoneNumber, value: staffData.data[phoneNumber]);
          writeDataLocally(key: fullName, value: staffData.data[fullName]);
          writeIntDataLocally(key: type, value: staffData.data[type]);
          writeBoolDataLocally(key: loggedIn, value: true);
          writeDataLocally(key: 'dayCare', value: staffData.data['dayCare']);
          writeBoolDataLocally(key: 'firstLogin', value: true);
          print(staffData.data['type']);
          return staffData.data['type'];
        }  else {
          return 0;
        }    

      } 
    }    
    return 0;

  }

}

