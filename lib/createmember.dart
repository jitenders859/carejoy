import 'package:flutter/material.dart';
import 'package:carejoy/theme.dart';

 void _showDialog(context, formKey, _firstName, _lastName, _compInformation, onPressed) {
    var screenSize = MediaQuery.of(context).size;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          titlePadding: EdgeInsets.all(0.0),
          contentPadding: EdgeInsets.all(0.0),
          
          title: ListTile(
            
            trailing: IconButton(
              icon: Icon(Icons.close),
              color: grey,
              alignment: Alignment.topRight,
              iconSize: 22.0,
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "Add New Child",
              textAlign: TextAlign.center,
              style: TextStyle( 
                fontSize: 16.0,
                color: black,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
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
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage("assets/images/default_profile.png"),
                              fit: BoxFit.cover,
                            )
                          ),
                        ),
                        Container(
                          height: 30.0,
                          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                          alignment: Alignment.topLeft,
                          width: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: darkBlue
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera),
                            color: Colors.white,
                            iconSize: 24.0,
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            child: Text(
                              "hello",
                              style: TextStyle(
                                color: Colors.transparent
                              ),    
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "First Name",
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14.0,
                                  ),
                                ),
                                TextFormField(
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    fillColor: grey,
                                    labelText: "Enter First Name",
                                    
                                  ),
                                  validator: (str) =>
                                      str.isEmpty ? "first name must not be empty" : null,
                                  onSaved: (str) => _firstName = str,
                                ),
                                
                                
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Last Name",
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14.0,
                                  ),
                                ),
                                TextFormField(
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    fillColor: grey,
                                    labelText: "Enter Last Name",
                                    
                                  ),
                                  validator: (str) =>
                                      str.isEmpty ? "Last name must not be empty" : null,
                                  onSaved: (str) => _lastName = str,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Date of Birth",
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14.0,
                                  ),
                                ),
                                TextFormField(
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    fillColor: grey,
                                    labelText: "DD/MM/YY",
                                    
                                  ),
                                  validator: (str) =>
                                      str.isEmpty ? "first name must not be empty" : null,
                                  onSaved: (str) => _firstName = str,
                                ),
                                
                                
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container()
                          )
                        ],
                      ),
                    ),
                    Text(
                      "Presence",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: grey
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 20.0),
                      child: Row(
                        children: <Widget>[
                          
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: true,
                                  onChanged: null,
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  "Monday",
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
                                  value: true,
                                  onChanged: null,
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  "Tuesday",
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
                                  value: false,
                                  onChanged: null,
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  "Wednesday",
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
                      padding: const EdgeInsets.only(top: 0.0, bottom: 20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: false,
                                  onChanged: null,
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                
                                Text(
                                  "Thursday",
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
                                  value: true,
                                  onChanged: null,
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  "Friday",
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
                                  value: true,
                                  onChanged: null,
                                  activeColor: darkBlue,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  "Saturday",
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
                    Text(
                      "Complementary Information",
                      style: TextStyle(
                        color: grey,
                        fontSize: 12.0
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: TextFormField(
                          autocorrect: false,
                          decoration: InputDecoration(
                            fillColor: grey,
                            labelText: "Enter Other Information",
                            
                          ),
                          onSaved: (str) => _compInformation = str,
                        ),
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      width: double.infinity,
                      child: RaisedButton(
                        color: blue,
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "SAVE",
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
              ),
            ),
          ),
        );
      },
    );
  }