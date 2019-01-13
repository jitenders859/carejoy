
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carejoy/theme.dart';
import 'package:carejoy/tools/app_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/localization/localization.dart';
import 'package:carejoy/tools/app_tools.dart';
class AddChildDialogButton extends StatefulWidget {
  
  final childList;
  final Function(DocumentSnapshot) action;
  
  AddChildDialogButton({
    this.childList,
    this.action,
  });
  @override
  _AddChildDialogButtonState createState() => _AddChildDialogButtonState();
}

class _AddChildDialogButtonState extends State<AddChildDialogButton> {
  String dayCare = '';
  String staffId = '';
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      fetchLocalData();
    }  

    fetchLocalData() async {
    staffId = await getDataLocally(key: userId);
    dayCare =  await getDataLocally(key: 'dayCare');
    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showChildAddDialog(context);
      },
      child: new Card(
        margin: EdgeInsets.all(0.0),
        elevation: 0.0,
        child: Container(
          height: 65.0,
          width: 75.0,
          alignment: Alignment.topCenter,
          margin: EdgeInsets.all(0.0),
          padding: EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            border: BorderDirectional(end: BorderSide(width: 0.0, color: shadowGrey, style: BorderStyle.solid)),
          ),
          child: CircleAvatar(
            
            backgroundColor: blue,
            maxRadius: 32.5,
            minRadius: 30.0,
            child: IconButton(
              icon: Icon(
                Icons.add,
                size: 32.0,
                color: Colors.white
              )
            ),
          ),
        ),
      ),
    );
  }

  void _showChildAddDialog(context) {
    var fields = AppLocalizations.of(context);
    var screenSize = MediaQuery.of(context).size;
    // flutter defined function
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
                  "${fields.add}  ${fields.child}",
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
          content: new StreamBuilder<QuerySnapshot>  (
            stream: Firestore.instance.collection(childCollection).where('dayCare', isEqualTo: dayCare).snapshots(),                
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              
              if (!snapshot.hasData) {
                return new Text("${fields.noData}");
              } else {
                              
                var listData = snapshot.data.documents;
                return Container(
                  height: screenSize.height,
                  width: screenSize.width,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    
                    itemCount: listData.length,
                    itemBuilder: (BuildContext context, int index) {
                      
                      return ListTile(
                        contentPadding: EdgeInsets.all(10.0),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(listData[index][childImage]),
                          radius: 35.0,
                          backgroundColor: Colors.white,
                            
                        ),
                        title: Text(
                          listData[index][childFirstName],
                          style: TextStyle(
                            color: black,
                            fontFamily: roboto,
                            fontSize: 18.0
                          ),
                        ),
                        onTap: () {
                          bool exist = false;
                  
                          for(var i = 0; i < widget.childList.length; i++) {
                           
                            if(widget.childList[i]['childId'] == listData[index]['childId']) {
                              
                                exist = true;                              
                              
                            }
                          }
                          if(exist == false) {
                            widget.action(listData[index]);
                          }
                        },
                        onLongPress: () {
                          bool exist = false;
                  
                          for(var i = 0; i < widget.childList.length; i++) {
                           
                            if(widget.childList[i]['childId'] == listData[index]['childId']) {
                              
                                exist = true;                              
                              
                            }
                          }
                          if(exist == false) {
                            widget.action(listData[index]);
                          }
                          
                          
                        },
                      );
                      
                      
                      
                    }
                  ),
                );
              }
              
            }
          )
        );
      },
    );
  }
}
