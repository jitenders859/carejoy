

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:carejoy/home.dart';
import 'package:carejoy/theme.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/localization/localization.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

class CreateChild extends StatefulWidget {
  final String type;
  final  GlobalKey<ScaffoldState> mainkey;
  final String childId;
  CreateChild({
    this.type,
    this.childId,
    this.mainkey
  });

  @override
  _CreateChildState createState() => _CreateChildState();
}

class _CreateChildState extends State<CreateChild> {
  
  @override
  Widget build(BuildContext context) {
    if(widget.type == null) {
      return new IconButton(
        alignment: Alignment.center,
        onPressed: () {
          _showChildDialog(context, widget.mainkey);
        },
        padding: EdgeInsets.all(0.0),
        icon: Icon(
          Icons.more_vert,
          color: black,
          size: 22.0,
        ),
      );
    } else {
      return GestureDetector(

        onTap: () {
          // Navigator.of(context).pop();
          _showChildDialog(context, widget.mainkey);
        },
        child: Text( 
          widget.type,
          style: TextStyle(
            color: widget.childId == null ? black : Colors.white,
          ),
        ),
      );
    }
    
  }

  void _showChildDialog(context, mainKey) {
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
          content: ShowingAlertDialog( mainKey: mainKey, childId: widget.childId,)
        );
      },
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

class ShowingAlertDialog extends StatefulWidget {
  final GlobalKey<ScaffoldState> mainKey;
  final String childId;
  ShowingAlertDialog({
    this.mainKey,
    this.childId,
  });

  @override
  _ShowingAlertDialogState createState() => _ShowingAlertDialogState();
}

class _ShowingAlertDialogState extends State<ShowingAlertDialog> {
  Firestore firestore;  
  bool mon = true;
  bool tues = true;
  bool weds = true;
  bool thurs = true;
  bool fri = true;
  bool sat = true;  
  var sampleImage;
  bool imageLoading = false;
  bool saveData = false;
  var dayCare;
  var staffId;
  String pinError  = '';
  bool _parentPinExist = false;
  String _addedPin;
  bool _addedImage = false;

  String _firstName, _lastName, _dateOfBirth, _childImage, _compInformation, _parentPin, room = 'no room';
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _dateOfBirthController = new TextEditingController();
  TextEditingController _compInformationController = new TextEditingController();
  TextEditingController _childImageController = new TextEditingController();
  TextEditingController _parentPinController = new TextEditingController();

  final formKey = GlobalKey<FormState>();
  
  @override
  initState() {
    super.initState();
    
    _firstNameController.addListener(onChange);  
    _lastNameController.addListener(onChange);  
    _dateOfBirthController.addListener(onChange);  
    _compInformationController.addListener(onChange);  
    _parentPinController.addListener(onChange);
    
    fetchLocalData();
    
    Future.delayed(Duration(seconds: 0)).then((onValue) {
      setState(() {
              
      });
    });  
  }
  fetchLocalData() async {
    staffId = await getDataLocally(key: userId);
    dayCare =  await getDataLocally(key: 'dayCare');
    if(widget.childId != null) {
      fetchChildData();
    }
  }

  fetchChildData() async {
    DocumentSnapshot data = await Firestore.instance.collection("children").document(widget.childId).get();
    
    mon = data.data['childPresence'][0];
    tues = data.data['childPresence'][1];
    weds = data.data['childPresence'][2];
    thurs = data.data['childPresence'][3];
    fri = data.data['childPresence'][4];
    sat = data.data['childPresence'][5];  
    
    _addedPin = data.data['parentPin'];
    
    _firstNameController.text = data.data['childFirstName'];
    _lastNameController.text = data.data['childLastName'];
    _compInformationController.text = data.data['childInformation'];
    _dateOfBirthController.text = data.data['childDateOfBirth'];
    _parentPinController.text = data.data['parentPin'];
    _childImageController.text = data.data['childImage'];
    _childImage = data.data['childImage'];
    sampleImage = data.data['childImage'];
    _addedImage = true;
    room = data.data['room'];

    setState(() {
          
    });
  }

  void onChange() {
    _firstName = _firstNameController.text;
    _lastName = _lastNameController.text;
    _dateOfBirth = _dateOfBirthController.text;
    _compInformation = _compInformationController.text;
    _parentPin = _parentPinController.text;
  }

  @override
  void dispose() {
      // TODO: implement dispose
      _firstNameController.dispose();
      _lastNameController.dispose();
      _dateOfBirthController.dispose();
      _compInformationController.dispose();
      _parentPinController.dispose();

      super.dispose();
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
      _addedImage = false;
      sampleImage = compressedImage;
      imageLoading = false;
      _childImageController.text = compressedImage.path;
      _childImage = compressedImage.path;
    });
     
  }

  void onPressed(fields) async {
    
    var form = formKey.currentState;
    
    setState(() {
        saveData = true;
    });
    bool result;
    if(_addedPin != null && _addedPin.length == 6 && _addedPin == _parentPin) {
      result = true;
    } else {
      result = await parentPinError(fields);
    }
    
    if(result) {

      if (form.validate()) {
         
          form.save();
          setState(() {
            saveData = true;
          });
          
          int timestamp = new DateTime.now().millisecondsSinceEpoch;
          String downloadUrl = '';
          if(_addedImage != true) {
          if( sampleImage != null) {
          
            final StorageReference firebaseStorageRef =
                        FirebaseStorage.instance.ref().child('childimage_${timestamp}.jpg');
            final StorageUploadTask task =
                        firebaseStorageRef.putFile(sampleImage);
            
            StorageTaskSnapshot taskSnapshot = await task.onComplete;

            downloadUrl = await taskSnapshot.ref.getDownloadURL();
            
          }
        } else {
          downloadUrl = sampleImage;
        }
          String childId = widget.childId != null ? widget.childId : timestamp.toString();
          
          await Firestore.instance.collection('children').document(childId).setData({
              childUserId: childId,
              childFirstName: _firstName,
              childLastName: _lastName,
              childImage: downloadUrl,
              childPresence: [mon, tues, weds, thurs, fri, sat],
              childInformation: _compInformation,
              'childDateOfBirth': _dateOfBirth,
              'parentPin': _parentPin,
              'room': room,
              childAddedBy: staffId,
              'dayCare': dayCare
            }).then((onValue) {
              writeBoolDataLocally(key: 'firstLogin', value: false);
              setState(() {
                saveData = false;
              });
              
              var fields = AppLocalizations.of(context);
              var snackbar = SnackBar(
                content:
                    Text(fields.childSuccessfullyAdded),
                duration: Duration(milliseconds: 5000),
              );
              
              
              if(widget.childId != null) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return Home();
                }));
              }
            });  
          
          
    } else {
  
      setState(() {
        saveData = false;
      });
    }
  }
  }

  Future _selectDate({day, month, year}) async {
    var firstDateYear = DateFormat.y().format(DateTime.now().subtract(Duration(days: 6300)));
    var currentYear = DateFormat.y().format(DateTime.now());
    DateTime initialDate = day == null ? DateTime.now() : DateTime( (2000 + year), month, day);
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: new DateTime(2000),
      lastDate: new DateTime(2032)
    );
    if(picked != null) setState(() => _dateOfBirthController.text = picked.toString());
    
    final f = new DateFormat('dd/MM/yy');

    _dateOfBirthController.text = f.format(new DateTime.fromMillisecondsSinceEpoch(picked.millisecondsSinceEpoch));
    _dateOfBirth = _dateOfBirthController.text; 
  } 


  Future<bool> parentPinError(fields) async {
    var fields = AppLocalizations.of(context); 
    if(_parentPin != null ) {
    
    if(_parentPin.length != 6 ) {
        
        setState(() {
          pinError = fields.pinError;            
          _parentPinExist = true;
        });
        
        return true;  
    }
    
    QuerySnapshot childParentData = await Firestore.instance.collection(childCollection).where('parentPin', isEqualTo: _parentPin ).getDocuments();
    
    if(childParentData != null) {
        
      if(childParentData.documents.length > 0) {
        setState(() {
          pinError = "${fields.parent} ${fields.pinAlreadyTaken}";
          _parentPinExist = true;            
        });
            
        
      }  else {
        setState(() {
          _parentPinExist = false;                      
        });
        
      }
    } else {
      setState(() {
        _parentPinExist = false;                      
      });
    } 
  } 

  if(_parentPin.length != 6) {
    
  }

  return true;
}

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var fields = AppLocalizations.of(context);
    return Container(
     
      child: Stack(
        
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: screenSize.width,
              height: screenSize.width > screenSize.height ? screenSize.width + 230.0 : screenSize.height + 230.0,
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
                              image: _addedImage == true ? NetworkImage(sampleImage) : sampleImage != null ? FileImage(sampleImage)  : AssetImage("assets/images/default_profile.png"),
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
                          onTap: () {
                           
                            getImage(); 
                          },
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
                       style: TextStyle(
                         color: Colors.transparent
                       ),
                       textAlign: TextAlign.center,
                      controller: _childImageController,
                      scrollPadding: EdgeInsets.all(0.0),
                      autocorrect: false,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,

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
                        _childImage == null  ? fields.imageFieldError : null, 
                      
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
                              labelText: fields.lastName,
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
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                 if(_dateOfBirth != null && _dateOfBirth.isNotEmpty) {
                                   var date = _dateOfBirth.split('/');
                                   int day = int.parse(date[0]);
                                   int month = int.parse(date[1]);
                                   int year = int.parse(date[2]);
                                   _selectDate(day: day, month: month, year: year);     
                                 } else {
                                   _selectDate();
                                 }
                                                              
                              },
                              child: AbsorbPointer(
                                child: FormInputField(
                                  labelText: fields.dateOfBirth,
                                  autoCorrect: false,
                                  hintText: "DD/MM/YY",
                                  controller: _dateOfBirthController,
                                  validator: _dateOfBirth != null ? _dateOfBirth.isEmpty : true,
                                  validationText: fields.dOBError,            
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container()
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 4.0,),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(0.0),
                      margin: EdgeInsets.all(0.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        fields.presence,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: grey
                        ),
                      ),
                    ),
                    Container(
                      height: 50.0,
                      width: double.infinity,
                      child: new StreamBuilder<QuerySnapshot>(
                        
                        stream: Firestore.instance.collection("rooms").document(dayCare).collection(dayCare).orderBy('timestamp', descending: false).snapshots(),
                            
                        builder: (context, snapshot){
                          if(!snapshot.hasData) {
                            return Container( 
                              padding: EdgeInsets.only(left: screenSize.width/2-25, right: screenSize.width/2-25),
                              
                              child: CircularProgressIndicator(),
                            );
                          }
                          return new DropdownButton<String>(
                            hint: Text("Assign Room"),
                            value: room,
                            items: snapshot.data.documents.map((DocumentSnapshot document) {
                              
                              return new DropdownMenuItem<String>(
                                value: document.documentID,
                                child: new Text(document.documentID),
                              );
                            }).toList(),
                            onChanged: (String val) {
                              setState(() {
                                room = val;
                              });
                            },
                          );
                      }
                    ),
                    ),
                    
                    SizedBox(height: 4.0,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Parent Pin",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: black,
                          
                          fontSize:  14.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0,),
                    TextFormField(
                      controller: _parentPinController,
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
                        _parentPinExist  ?  pinError : null, 
                      
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(0.0),
                      margin: EdgeInsets.all(0.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        fields.presence,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: grey
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: Row(
                        children: <Widget>[
                          
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  
                                  value: mon,
                                  onChanged: (value) {
                                    setState(() {
                                      mon = !mon;                                      
                                    });
                                  },
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                
                                Text(
                                  fields.mon,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14.0
                                  )
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: tues,
                                  onChanged: (value) {
                                    setState(() {
                                      tues = !tues;                                                                        
                                    });
                                  },
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                
                                Text(
                                  fields.tues,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14.0
                                  )
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: weds,
                                  onChanged: (value) {
                                    setState(() {
                                      weds = !weds;                                                                          
                                    });
                                  },
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                
                                Text(
                                  fields.weds,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14.0
                                  )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: thurs,
                                  onChanged: (value) {
                                    setState(() {
                                      thurs = !thurs;                                                                          
                                    });
                                  },
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                
                                Text(
                                  fields.thurs,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14.0
                                  )
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: fri,
                                  onChanged: (value) {
                                    setState(() {
                                      fri = !fri;                                      
                                    });
                                  },
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                
                                Text(
                                  fields.fri,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14.0
                                  )
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: sat,
                                  onChanged: (value) {
                                    
                                    setState(() {
                                      sat = !sat;
                                    print(sat);                                        
                                    });
                                    print(sat);
                                  },
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                
                                Text(
                                  fields.sat,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14.0
                                  )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 4.0),
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        fields.complimentaryInformation,
                        style: TextStyle(
                          color: grey,
                          fontSize: 12.0
                        ),
                      ),
                    ),
                    FormInputField(
                        labelText: "",
                        autoCorrect: false,
                        hintText: "${fields.enter} ${fields.otherInformation}",
                        controller: _compInformationController,
                        validator: false,
                        validationText: "",            
                      ),
                    SubmitButton(
                      submitPressed: () {
                        onPressed(fields);
                      },
                    )
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
      ),
    );
  }
}

getStringDataLocally({String key}) async {
  Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();
  final SharedPreferences localData = await saveLocal;
  return localData.getString(key);  
}


class SubmitButton extends StatelessWidget {
  
  final VoidCallback submitPressed;

  SubmitButton({
    this.submitPressed
  });
  
  @override
  Widget build(BuildContext context) {
    var fields = AppLocalizations.of(context);
    return  Container(
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
        onPressed:() => submitPressed(),
      ),
    );
  }
}