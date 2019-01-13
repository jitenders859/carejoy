import 'dart:io';

import 'package:carejoy/createaccount.dart';
import 'package:carejoy/home.dart';
import 'package:carejoy/staff_login.dart';
import 'package:carejoy/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/localization/localization.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


  String _email;
  String _password;


  GoogleSignIn googlAuth = new GoogleSignIn();
  
  FacebookLogin fbLogin = new FacebookLogin();
  
  class Login extends StatelessWidget {
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
      title: "login",
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  bool isLoggedIn = false;
  String _email, _password;
  TextEditingController _emailController = new TextEditingController();

  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();

  GoogleSignIn googlAuth = new GoogleSignIn();
  
  FacebookLogin fbLogin = new FacebookLogin();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  initState() {
    super.initState();
    checkLoggedInCase();
    _emailController.addListener(onChange);

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
      print("token " + token);
    });

  }

  void checkLoggedInCase() async {
    // writeBoolDataLocally(key: loggedIn, value: false);
    
    print('logged');
    bool login = await getBoolDataLocally(key: loggedIn);
    print(login);
    setState(() {
      isLoggedIn = login;      
    });
    
  }

  void onChange() {
    _email = _emailController.text;
  }

  Future<bool> _onBackPressed() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you really want to exit."),
        content: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    exit(0);
                  },
                ),
              ),
            ),
          ],
        ),
      )
    );
    print(isLoggedIn);
    if(isLoggedIn == false) {
      return false;
    } else {
      return true;
    }
    //return false;
    
  }

  @override
  Widget build(BuildContext context) {
    var fields = AppLocalizations.of(context);
    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () =>_onBackPressed(),
      child: Scaffold(
        backgroundColor: Colors.white,
        key: mainKey,
        body: SingleChildScrollView(
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: Text(
                    "LOGO",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),
                ),
                
                Padding( 
                  padding: const EdgeInsets.all(40.0),
                  child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            autocorrect: false,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              fillColor: grey,
                              labelText: "${fields.email} ${fields.address}",
                              icon: Icon(
                                Icons.email,
                                color: grey,
                                size: 20.0,
                                ),
                            ),
                            validator: (str) =>
                                !str.contains('@') ? fields.emailError : null,
                            onSaved: (str) => _email = str,
                          ),
                          // TextFormField(
                          //   autocorrect: false,
                          //   style: TextStyle(
                          //     color: grey
                          //   ),
                          //   decoration: InputDecoration(
                          //     fillColor: grey,
                          //     labelText: "Password:",
                          //     icon: Icon(
                          //       Icons.lock,
                          //       color: grey,
                          //       size: 20.0,
                          //       ),
                          //   ),
                          //   validator: (str) =>
                          //       str.length <= 3 ? "Not a Valid Password!" : null,
                          //   onSaved: (str) => _password = str,
                          //   obscureText: true,
                          // ),
                          Container(
                            padding: EdgeInsets.only(top: 10.0),
                            width: double.infinity,
                            child: RaisedButton(
                              color: blue,
                              
                              child: Text(
                                fields.submit.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0
                                ),
                              ),
                              onPressed: () => onPressed(true),
                            ),
                          ),
                        ],
                      ),
                    )
                  
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, left: 40.0, right: 40.0, bottom: 8.0),
                    child: Container(
                      height: 20.0,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Divider(
                            height: 3.0,
                            color: grey,
                          ),
                          new Container(
                            color: Colors.white,
                            width: 110.0,
                            height: 20.0,
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Text(
                              "or Login with ",
                              style: TextStyle(
                                color: black,
                                fontSize: 14.0
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 40.0, right: 40.0),
                    child: RaisedButton(
                      
                      color: darkBlue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(),
                          Text(
                            "LOGIN WITH FACEBOOK",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              
                            ),
                          ),
                          Icon(
                            MdiIcons.facebook,
                            size: 26.0,
                            color: Colors.white  
                          )
                        ],
                      ),
                      
                      onPressed: () {
                        fbLogin.logInWithReadPermissions(['email', 'public_profile'])
                            .then((result) {
                              print('case');
                              switch (result.status) {
                                case FacebookLoginStatus.loggedIn:
                                 
                                FirebaseAuth.instance.signInWithFacebook(
                                  accessToken: result.accessToken.token
                                ).then((signedInUser) {
                                  print('sign in');
                                  var emailCheck = signedInUser.email;
                                  print(emailCheck);
                                  // onPressed(emailCheck);
                                }).catchError((e) {
                                  var snackbar = SnackBar(
                                    content:
                                        Text("Some Error Occured Login with email and password."),
                                    duration: Duration(milliseconds: 5000),
                                  );

                                  mainKey.currentState.showSnackBar(snackbar);
                                });
                                break;
                                default: 
                                  var snackbar = SnackBar(
                                    content:
                                        Text("Some Error Occured Login with email and password."),
                                    duration: Duration(milliseconds: 5000),
                                  );

                                  mainKey.currentState.showSnackBar(snackbar);
                              }
                            }).catchError((e) {
                              var snackbar = SnackBar(
                                    content:
                                        Text("Some Error Occured Create a Account."),
                                    duration: Duration(milliseconds: 5000),
                                  );

                                  mainKey.currentState.showSnackBar(snackbar);
                            });
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context)
                          => CreateAccount()
                          )
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          
                          children: <TextSpan>[
                            TextSpan(
                              text: "Don\'t have an account? ", 
                              style: TextStyle(
                                color: black,
                                fontSize: 14.0
                              )),
                            TextSpan(
                              text: ' Create Account!',
                              style: TextStyle(
                                color: blue,
                                fontSize: 14.0
                              )
                            ),
                          ],
                        ),
                      ),
                    )
                  )
                
              ],
            ),
          ),
        )
      ),
    );
  }

  void onPressed(emailCheck) {
    var form = formKey.currentState;
    if(emailCheck == true) {
       if (form.validate()) {
          form.save();
          setState(() {
            // loggedIn = true;
          });

          FirebaseAuth.instance.fetchProvidersForEmail(email: _email).then((exist) {
            if(exist.isEmpty) {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CreateAccount(email: _email,))); 
            } else {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => StaffLogin(email: _email)));
            }
          }).catchError((e) {
            // code, message, details
          });

        //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => null ));

        } 
    } else {
      print('facebook login');
      FirebaseAuth.instance.fetchProvidersForEmail(email: emailCheck).then((exist) {
        if(exist.isEmpty) {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CreateAccount(email: emailCheck,))); 
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => StaffLogin(email: emailCheck)));
        }
      }).catchError((e) {
        // code, message, details
      });
    }
    
  }

}