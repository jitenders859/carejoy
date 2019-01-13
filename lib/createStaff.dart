import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carejoy/theme.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/localization/localization.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

class CreateStaff extends StatefulWidget {
  final String type;
  CreateStaff({
    this.type
  });
  @override
  _CreateStaffState createState() => _CreateStaffState();
}

class _CreateStaffState extends State<CreateStaff> {
  
  @override
  Widget build(BuildContext context) {
     if(widget.type == null) {
      return new IconButton(
        alignment: Alignment.center,
        onPressed: () {
          _showStaffDialog(context);
        },
        padding: EdgeInsets.all(0.0),
        icon: Icon(
          Icons.date_range,
          color: black,
          size: 22.0,
        ),
      );
    } else {
      return GestureDetector(

        onTap: () {
          // Navigator.of(context).pop();
          _showStaffDialog(context);
        },
        child: Text(
          widget.type,
        ),
      );
    }
  }

  void _showStaffDialog(context) {
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
                  "${fields.add} ${fields.staff}",
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
          content: ShowingStaffDialogContent(),
        );
      },
    );
  }

}


class ShowingStaffDialogContent extends StatefulWidget {
  @override
  _ShowingStaffDialogContentState createState() => _ShowingStaffDialogContentState();
}

class _ShowingStaffDialogContentState extends State<ShowingStaffDialogContent> {
  var dayCare;
  var staffId;
  var sampleImage;   
  
  String _firstName = "", _lastName = "", _qualification = "", _email = "", _pin = "", _memberImage;
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _qualificationController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _pinController = new TextEditingController();
  TextEditingController _memberImageController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();
  bool imageLoading = false;
  bool saveData = false;
  bool emailAlreadyExist = false;
  String emailError = "";

  void onPressed() async {
    var fields = AppLocalizations.of(context);
    var form = formKey.currentState;
    
    setState(() {
      saveData = true;
    });
    
    bool result = await staffEmailError(fields);
    
    if(result) {
      if (form.validate()) {
        form.save();
        setState(() {
          saveData = true;
        });

        FirebaseAuth.instance.fetchProvidersForEmail(email: _email).then((exist) {
          if(exist.isEmpty) {
            FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _pin).then(
            (FirebaseUser user) async {

      
            if (user != null) {
              String downloadUrl = "";
              int timestamp = new DateTime.now().millisecondsSinceEpoch;
              if(sampleImage != null) {
                final StorageReference firebaseStorageRef =
                            FirebaseStorage.instance.ref().child('staff_${timestamp}.jpg');
                final StorageUploadTask task =
                            firebaseStorageRef.putFile(sampleImage);
                
                StorageTaskSnapshot taskSnapshot = await task.onComplete;

                downloadUrl = await taskSnapshot.ref.getDownloadURL();
                
              }

              
              
              await Firestore.instance.collection('staffMember').document(user.uid).setData({
                userId: user.uid,
                email: _email,
                userPassword : _pin,
                type : 3,
                phoneNumber : "",
                fullName : "$_firstName $_lastName",
                'staffFirstName': _firstName,
                'staffLastName': _lastName,
                staffQualification: _qualification,
                staffImage: downloadUrl,
                'createdBy': staffId,
                'dayCare': dayCare

              });
              setState(() {
                saveData = false;                          
              });   
              Navigator.of(context).pop();
              
            }
      
            }
          );

          } else {
                    
            Navigator.of(context).pop();

          }
          
        }).catchError((e) {
                
          Navigator.of(context).pop();

          var snackbar = SnackBar(
            content:
                Text(fields.someErrorOccured),
            duration: Duration(milliseconds: 5000),
          );

          mainKey.currentState.showSnackBar(snackbar);

        });

      } else {
        setState(() {
          saveData = false;
        });
      }
    }
  }
  
  @override
  initState()  {
    super.initState();
    _firstNameController.addListener(onChange);  
    _lastNameController.addListener(onChange);  
    _qualificationController.addListener(onChange);  
    _pinController.addListener(onChange);  
    _emailController.addListener(onChange);
    fetchLocalData();
  }

  fetchLocalData() async {
     staffId = await getDataLocally(key: 'userId');
     dayCare = await getDataLocally(key: 'dayCare');
  }

  void onChange() {
    _firstName = _firstNameController.text;
    _lastName = _lastNameController.text;
    _qualification = _qualificationController.text;
    _pin = _pinController.text;
    _email = _emailController.text;    
  }

  @override
  void dispose() {
      // TODO: implement dispose
      super.dispose();
  }


  bool pinCheck(String pin) {
    if(pin == null) {
      return true;
    } else if (pin.length != 6) {
      return true;
    } else {
      return false;
    }
  }

  Future getImage() async {

    setState(() {
      imageLoading = true;      
    });
    
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand = new Math.Random().nextInt(10000000);

  Im.Image image = Im.decodeImage(tempImage.readAsBytesSync());
  Im.Image smallerImage = Im.copyResize(image, 200); // choose the size here, it will maintain aspect ratio

  File compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 85));
  
    setState(() {
      sampleImage = compressedImage;
      imageLoading = false;
      _memberImageController.text = compressedImage.path;
      _memberImage = compressedImage.path;
    });
     
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
    var screenSize = MediaQuery.of(context).size;
    var fields = AppLocalizations.of(context);
    return Stack(
      key: mainKey,
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            width: screenSize.width,
            height: screenSize.width > screenSize.height ? screenSize.width + 100.0 : screenSize.height + 100.0,
            padding: EdgeInsets.only(
              left: 12.0,
              right: 12.0
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: sampleImage != null ? FileImage(sampleImage)  : AssetImage("assets/images/default_profile.png"),
                            fit: BoxFit.cover,
                          )
                        ),
                        child: imageLoading ? CircularProgressIndicator(backgroundColor: blue) : null,
                      ),
                      
                      Container(
                        height: 37.0,
                        
                        alignment: Alignment.center,
                        width: 37.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: blue
                        ),
                        child: IconButton(
                          alignment: Alignment.topCenter,
                          icon: Icon(Icons.photo_camera, color: Colors.white,),
                          color: Colors.white,
                          iconSize: 22.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => getImage(),
                        child: AbsorbPointer(
                          absorbing: true,
                          child: Container(
                            height: 100.0,
                            width: 100.0,
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
                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: _memberImageController,
                    scrollPadding: EdgeInsets.all(0.0),
                    autocorrect: false,
                    decoration: InputDecoration(
                      fillColor: grey,
                      hintText: "",
                      hintStyle: TextStyle(
                        fontSize: 12.0,
                        color: grey,

                      ),
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(0.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.0,
                          color: Colors.transparent,
                          style: BorderStyle.none
                        )
                      )
                    ),
                    validator: (str) =>
                      _memberImage == null ? fields.imageFieldError : null, 
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: FormInputField(
                              labelText: fields.firstName,
                              autoCorrect: false,
                              hintText: "${fields.enter} ${fields.firstName}",
                              controller: _firstNameController,
                              validator: _firstName != null ?_firstName.isEmpty : true,
                              validationText: fields.firstNameError,            
                            ),          
                              
                          ),
                        ),
                        Expanded(
                          child: FormInputField(
                            labelText: "${fields.lastName}",
                            autoCorrect: false,
                            hintText: "${fields.enter} ${fields.lastName}",
                            controller: _lastNameController,
                            validator: _lastName != null ? _lastName.isEmpty : true,
                            validationText: fields.lastNameError,            
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: new DropdownButton<String>(
                            hint: Text(fields.qualification),
                            value: _qualification,
                            items: <String>["", fields.education, fields.engineering, fields.biology, fields.food, fields.dayCare]
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: value == "" ? new Text(fields.selectAField) : new Text(value),
                              );
                            }).toList(),
                            onChanged: (String val) {
                              _qualification = val;
                              setState(() {
                                _qualification = val;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 4.0,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Member Email",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: black,
                          
                          fontSize:  14.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0,),
                    TextFormField(
                      controller: _emailController,
                      scrollPadding: EdgeInsets.all(0.0),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: 12.0,
                          color: grey,
                        ),
                        contentPadding: EdgeInsets.all(14.0),
                        hintText: "${fields.member} ${fields.email}",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.0,
                            color: black,
                            style: BorderStyle.none
                          )
                        )
                      ),
                      
                      validator: (str) =>
                        emailAlreadyExist  ?  emailError : null, 
                      
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                  
                  SizedBox(height: 4.0,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Create Pin",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: black,
                          
                          fontSize:  14.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0,),
                    TextFormField(
                      controller: _pinController,
                      scrollPadding: EdgeInsets.all(0.0),
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: 12.0,
                          color: grey,
                        ),
                        contentPadding: EdgeInsets.all(14.0),
                        hintText: "${fields.create} ${fields.pin}",   
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.0,
                            color: black,
                            style: BorderStyle.none
                          )
                        )
                      ),
                      
                      validator: (str) =>
                        pinCheck(_pin)  ?  fields.pinError : null,
                    ),
                    SizedBox(
                      height: 4.0,
                    ),               
                  Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    width: double.infinity,
                    child: RaisedButton(
                      color: blue,
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        fields.save,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0
                        ),
                        ),
                      onPressed: onPressed
                    ),
                  ),
                
                ],
              ),
            ),
          ),
        ),
        Center(
          child: saveData ? CircularProgressIndicator(backgroundColor: blue,) : Container(
            height: 0,
            width: 0,
          ),
        )
      ],
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
  final TextInputType keyboardType;
  FormInputField(
    {
      this.labelText,
      this.hintText,
      this.autoCorrect,
      this.validator,
      this.validationText,
      this.passParameter,
      this.controller,
      this.keyboardType = TextInputType.emailAddress,
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
          keyboardType: keyboardType,        
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
