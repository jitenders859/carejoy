import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carejoy/home.dart';
import 'package:carejoy/staff_login.dart';
import 'package:carejoy/theme.dart';
import 'dart:async';
import 'dart:convert';
import 'package:carejoy/tools/app_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/localization/localization.dart';


class CreateAccount extends StatefulWidget {
  final String email;
  CreateAccount({
    this.email
  });

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  
  bool loggedIn = false;
  String _email = "", _password, _rePassword, _parentPin = "";
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _rePasswordController = new TextEditingController();
  TextEditingController _childController = new TextEditingController();
  
  bool passwordObscure = true;
  bool rePasswordObscure = true;

  bool emailAlreadyExist = false;
  String emailError = '';
  
  bool _parent = true, _nurse = false, _dayCare = false;

  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
      
    super.initState();
    if(widget.email != null) {
      _emailController.text = widget.email;
      
      // final snackBar = SnackBar(content: Text("Email doesn\'t exist. Create Account."), duration: Duration(seconds: 5),);
      // mainKey.currentState.showSnackBar(snackBar);
    
    }
    _emailController.addListener(onChange);
    _passwordController.addListener(onChange);
    _rePasswordController.addListener(onChange);
  }

  void onChange() {
    _email = _emailController.text;
    _password = _passwordController.text;
    _rePassword = _rePasswordController.text;
    _parentPin = _childController.text;
   
  }

  Future<bool> staffEmailError(fields) async {
    
    if(_email == null ) { 
      setState(() {
        emailError = fields.emailError;
        emailAlreadyExist = true;      
      });
      return true;
    } 
    
      if(!_email.contains("@")) {
        setState(() {
          emailError = fields.emailError;
          emailAlreadyExist = true;                 
        });
        return true;
      }
      
      List<String> exist = await FirebaseAuth.instance.fetchProvidersForEmail(email: _email);
      if(exist.isNotEmpty) {
        setState(() {
          emailError = "Email Already Exist.";
          emailAlreadyExist = true;                 
        });
        return true;
      } else {
        setState(() {
          emailError = fields.emailError;
          emailAlreadyExist = false;                 
        });
        return true;
      } 
  }

  @override
  Widget build(BuildContext context) {
    var fields = AppLocalizations.of(context);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: mainKey,
      body: SingleChildScrollView(
        child: Container(
          height: screenSize.height + 100.0,
          width: screenSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 60.0),
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
                padding: EdgeInsets.only(top: 20.0, bottom: 0.0),
                child: Text(
                  "${fields.create} ${fields.account}",
                  style: TextStyle(
                    color: black,
                    fontSize: 22.0,
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: _parent,
                          activeColor: darkBlue,
                          onChanged: (bool newValue) {
                            setState(() {
                              _parent = true;
                              _nurse = false;
                              _dayCare = false;
                            });
                          }),
                          Text(
                            fields.parent.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: grey
                            ),
                          )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _nurse,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: darkBlue,
                          onChanged: (bool newValue) {
                            setState(() {
                              _parent = false;
                              _nurse = true;
                              _dayCare = false;
                            });
                          }),
                          Text(
                            fields.nurse.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: grey
                            ),
                          )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _dayCare,
                          activeColor: darkBlue,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onChanged: (bool newValue) {
                            setState(() {
                              _parent = false;
                              _nurse = false;
                              _dayCare = true;
                            });
                          }),
                          Text(
                            fields.dayCare.toUpperCase(),
                            
                            style: TextStyle(
                              fontSize: 14.0,
                              color: grey
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Padding( 
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            
                            controller: _emailController,
                            
                            decoration: InputDecoration(
                              fillColor: grey,
                              labelText: "${fields.email} ${fields.address}",
                              icon: Icon(
                                Icons.mail_outline,
                                color: grey,
                                size: 20.0,
                                ),
                            ),
                            validator: (str) =>
                                emailAlreadyExist ? emailError : null,
                            onSaved: (str) => _email = str,
                            
                          ),

                          Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[
                              TextFormField(
                                controller: _passwordController,
                                autocorrect: false,
                                style: TextStyle(
                                  color: grey
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  fillColor: grey,
                                  labelText: fields.password,
                                  icon: Icon(
                                    Icons.lock_outline,
                                    color: grey,
                                    size: 20.0,
                                    ),
                                    
                                ),
                                validator: (str) =>
                                    str.length == 6  && str != null ? null : fields.pinError,
                                onSaved: (str) => _password = str,
                                obscureText: passwordObscure,
                              ),
                              new FlatButton(
                                onPressed: () {
                                  setState(() {
                                    passwordObscure = !passwordObscure;                                                                            
                                  });
                                },
                                child: new Icon(Icons.remove_red_eye, color: grey,)
                              )
                            ],
                          ),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[
                              TextFormField(
                                controller: _rePasswordController,
                                autocorrect: false,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: grey
                                ),
                                decoration: InputDecoration(
                                  fillColor: grey,
                                  labelText: "${fields.confirm} ${fields.password}",
                                  icon: Icon(
                                    Icons.lock_outline,
                                    color: grey,
                                    size: 20.0,
                                    ),
                                ),
                                validator: (str) =>
                                    _password == _rePassword && _rePassword != null ? null  : fields.passwordNotMatch,
                                onSaved: (str) => _rePassword = str,
                                obscureText: rePasswordObscure,
                              ),
                              new FlatButton(
                                onPressed: () {
                                  setState(() {
                                    rePasswordObscure = !rePasswordObscure;                                                                            
                                  });
                                },
                                child: new Icon(Icons.remove_red_eye, color: grey,)
                              )
                            ],
                          ),
                          _parent == true ? TextFormField(
                            controller: _childController,
                            
                            style: TextStyle(
                              color: grey
                            ),
                            decoration: InputDecoration(
                              fillColor: grey,
                              labelText: "Parent Pin",
                              icon: Icon(
                                Icons.vpn_key,
                                color: grey,
                                size: 20.0,
                                ),
                            ),
                            validator: (str) =>
                               str.isEmpty ? "Parent Pin Required"   :  null,
                            onSaved: (str) => _parentPin = str,
                            obscureText: false,
                          ) : Container(),
                          
                          Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            padding: EdgeInsets.only(top: 10.0),
                            width: double.infinity,
                            child: RaisedButton(
                              color: blue,
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                fields.submit.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0
                                ),
                              ),
                              onPressed: onPressed,
                            ),
                          ),
                        ],
                      ),
                    )
                  
                ),
              ),
              
              
            ],
          ),
        ),
      )
    );
  }

  void onPressed() async { 
    var fields = AppLocalizations.of(context);
    var form = formKey.currentState;
    Firestore firestore = Firestore.instance;
    setState(() {
      loggedIn = true;
    });
    bool result = await staffEmailError(fields);
    if(result) {
    if (form.validate()) {
      form.save();
      setState(() {
        loggedIn = true;
      });
      
      

      FirebaseAuth.instance.fetchProvidersForEmail(email: _email).then((exist) async {
        if(exist.isEmpty) {

          if(_parent == true) {

            QuerySnapshot child = await Firestore.instance.collection(childCollection).where('parentPin', isEqualTo: _parentPin ).getDocuments();
            if(child.documents.length > 0) {
              FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password).then(
              (FirebaseUser user) async {
                if (user != null) {
                  await firestore.collection('parent').document(user.uid).setData(
                    {
                      userId: user.uid,
                      email: _email,
                      userPassword : _password,
                      type: 4,
                      "dayCare": child.documents[0].data['dayCare'],
                      "childId": child.documents[0].data['childId'],
                      'approved': false,
                      phoneNumber : "",
                      fullName : "",
                    }
                  );
                }
              }
            );
            
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) 
            => StaffLogin(email: _email,)));

            } else {
              var snackbar = SnackBar(
                content: Text("Pin doesn\'t match"),
                duration: Duration(milliseconds: 5000),
              );
              
              mainKey.currentState.showSnackBar(snackbar);

            }
            
          } else {
            
            FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password).then(
              (FirebaseUser user) async {
                if (user != null) {
                  await firestore.collection('usersData').document(user.uid).setData(
                    {
                      userId: user.uid,
                      email: _email,
                      userPassword : _password,
                      type : _nurse == true ? 1: _dayCare == true ? 2 : 0,
                      phoneNumber : "",
                      fullName : ""
                    }
                  );
                }
              }
            );

            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) 
            => StaffLogin(email: _email,)));

          }

          
        } else {
          final snackBar = SnackBar(content: Text('Email Already Exist'), duration: Duration(seconds: 5),);
          mainKey.currentState.showSnackBar(snackBar);
        }
      });
            
    } else {
      setState(() {
      
        loggedIn = false;
              
      });
    }
    }
  }
}