import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carejoy/addevent.dart';
import 'package:carejoy/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/tools/app_tools.dart';
import 'localization/localization.dart';

class Week extends StatefulWidget {
  final String childId;
  Week({
    this.childId
  });

  @override
  _WeekState createState() => _WeekState();
}

class _WeekState extends State<Week> {

  ScrollController horizontalScrollController  = new ScrollController();
  ScrollController verticalScrollController = new ScrollController();
  ScrollController photoScrollController = new ScrollController();
  ScrollController timeScrollController = new ScrollController();
  double vertOffset = 0.0;
  double horizOffset = 0.0;
  int daysSubtotal = 0;
  int noOfDays = 31;
  var currentMonth = DateFormat.M().format(DateTime.now().toUtc());
  var currentYear = DateFormat.y().format(DateTime.now().toUtc());
  var currentday = DateFormat.d().format(DateTime.now().toUtc());
  var currentWeekday =  DateFormat.E().format(DateTime.now().toUtc()).substring(0,1);


  int getMonthdays() {
    var days = 31;
    if(currentMonth == 1) {
      days = 31;
    } else if(currentMonth == 2) {
      days = int.parse(currentYear) % 4 == 0 ? 29 : 28;
    } else if(currentMonth == 3) {
      days = 31;
    } else if(currentMonth == 4) {
      days = 30;
    } else if(currentMonth == 5) {
      days = 31;
    } else if(currentMonth == 6) {
      days = 30;
    } else if(currentMonth == 7) {
      days = 31;
    } else if(currentMonth == 8) {
      days = 31;
    } else if(currentMonth == 9) {
      days = 30;
    } else if(currentMonth == 10) {
      days = 31;
    } else if(currentMonth == 11) {
      days = 30;
    } else if(currentMonth == 12) {
      days = 31;
    }
    
    return days;
  }

  @override
  void initState() {
      // TODO: implement initState
    super.initState();
 
    setState(() {
      noOfDays = getMonthdays();
    }); 
    
  }


  @override
  Widget build(BuildContext context) {
    var fields = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          
          Container(
            margin: EdgeInsets.all(0.0),
            padding: EdgeInsets.all(0.0),
            height: 50.0,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Card(
                      margin: EdgeInsets.all(0.0),
                      elevation: 0.0,
                      child: Container(
                        height: 50.0,
                        width: 60.0,
                        
                        margin: EdgeInsets.all(0.0),
                        padding: EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                          border: BorderDirectional(end: BorderSide(width: 2.0, color: shadowGrey, style: BorderStyle.solid)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: photoScrollController,
                          itemCount: noOfDays,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              margin: EdgeInsets.all(0.0),
                              elevation: 0.0,
                              child: Container(
                                alignment: Alignment.center,
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  
                                ),
                                padding: EdgeInsets.all(0.0),
                                margin: EdgeInsets.all(0.0),
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        
                                      },
                                      child: Container(
                                        
                                        child: Text(
                                          DateFormat.E().format(DateTime(int.parse(currentYear), int.parse(currentMonth), index+1)).substring(0,1),
                                          style: TextStyle(
                                            color: int.parse(currentday) == index + 1 ? blue : black,
                                            fontSize: 14.0,
                                            fontFamily: roboto
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        
                                      },
                                      child: Container(
                                        width: 23.0,
                                        height: 23.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: int.parse(currentday) == index + 1 ? blue : Colors.white,
                                          shape: BoxShape.circle
                                        ),
                                        child: Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                            color: int.parse(currentday) == index +1 ? Colors.white : black,
                                            fontSize: 14.0
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: GestureDetector(               
              
                    onHorizontalDragUpdate: (DragUpdateDetails details) {
                          setState(() {
                            if(horizOffset > photoScrollController.position.maxScrollExtent) {
                              horizOffset = photoScrollController.position.maxScrollExtent;
                            } else if( horizOffset < photoScrollController.position.minScrollExtent) {
                              horizOffset = photoScrollController.position.minScrollExtent;
                            } else {
                              horizOffset = horizOffset - details.delta.dx;
                            }

                            photoScrollController.jumpTo(horizOffset);
                            horizontalScrollController.jumpTo(horizOffset);
                          }
                        );
                    
                    },
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
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
            
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  width: 60.0,
                  
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 2.0,
                        color: shadowGrey,
                        style: BorderStyle.solid 
                      )
                    )
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ListView.builder(
                        controller: timeScrollController,
                        itemCount: 24,
                        itemBuilder: (BuildContext context, int index) {
                          return new Card(
                            margin: EdgeInsets.all(0.0),
                            elevation: 0.0,
                            child: Container(
                              alignment: Alignment.center,
                              width: 60.0,
                              height: 50.0,
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                index < 6 ?
                                "${7 + index} ${fields.am}" : 
                                index < 18  ? "${index - 5 } ${fields.pm}" :
                                "${index - 17 } ${fields.am}",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: black,

                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Center(
                        child: GestureDetector(               
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                            setState(() {
                              if(vertOffset > timeScrollController.position.maxScrollExtent) {
                                vertOffset = timeScrollController.position.maxScrollExtent;
                              } else if( vertOffset < timeScrollController.position.minScrollExtent) {
                                vertOffset = timeScrollController.position.minScrollExtent;
                              } else {
                                vertOffset = vertOffset - details.delta.dy;
                              }

                              timeScrollController.jumpTo(vertOffset);
                              verticalScrollController.jumpTo(vertOffset);
                            }
                          );
                        },
                        
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
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
                  
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ListView.builder(
                        controller: horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: 31,
                        itemBuilder: (BuildContext context, int index) {
                          return HorizList(
                            scrollController: verticalScrollController,
                            indexInt:  index,
                            childId: widget.childId,
                            horizdrag: (details) {
                              setState(() {
                                  if(horizOffset > photoScrollController.position.maxScrollExtent) {
                                    horizOffset = photoScrollController.position.maxScrollExtent;
                                  } else if( horizOffset < photoScrollController.position.minScrollExtent) {
                                    horizOffset = photoScrollController.position.minScrollExtent;
                                  } else {
                                    horizOffset = horizOffset - details.delta.dx;
                                  }
                                  
                                  photoScrollController.jumpTo(horizOffset);
                                  horizontalScrollController.jumpTo(horizOffset);
                                }
                              );
                            },
                            vertdrag: (details) {
                              setState(() {
                                  if(vertOffset > timeScrollController.position.maxScrollExtent) {
                                    vertOffset = timeScrollController.position.maxScrollExtent;
                                  } else if( vertOffset < timeScrollController.position.minScrollExtent) {
                                    vertOffset = timeScrollController.position.minScrollExtent;
                                  } else {
                                    vertOffset = vertOffset - details.delta.dy;
                                  }

                                  timeScrollController.jumpTo(vertOffset);
                                  verticalScrollController.jumpTo(vertOffset);
                                }
                              );    
                            },
                          );
                        },
                      ),
                      Center(
                        child: GestureDetector(               
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                          print(details);
                          setState(() {
                            if(vertOffset > timeScrollController.position.maxScrollExtent) {
                              vertOffset = timeScrollController.position.maxScrollExtent;
                            } else if( vertOffset < timeScrollController.position.minScrollExtent) {
                              vertOffset = timeScrollController.position.minScrollExtent;
                            } else {
                              vertOffset = vertOffset - details.delta.dy;
                            }

                            timeScrollController.jumpTo(vertOffset);
                            verticalScrollController.jumpTo(vertOffset);
                          }
                        );
                    
                      },
                        onHorizontalDragUpdate: (DragUpdateDetails details) {
                          print(details);
                          setState(() {
                            if(horizOffset > photoScrollController.position.maxScrollExtent) {
                              horizOffset = photoScrollController.position.maxScrollExtent;
                            } else if( horizOffset < photoScrollController.position.minScrollExtent) {
                              horizOffset = photoScrollController.position.minScrollExtent;
                            } else {
                              horizOffset = horizOffset - details.delta.dx;
                            }
                            
                            photoScrollController.jumpTo(horizOffset);
                            horizontalScrollController.jumpTo(horizOffset);
                          }
                        );
                    
                    },
                    child: Container(
                        height: double.infinity,
                        width: double.infinity,
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
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Image.asset(
          "assets/images/leave_blue.png",
          alignment: Alignment.center,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                AddEvent();
              }
            )
          );
        },
      ),
    );
  }
}


class HorizList extends StatefulWidget {
  
  final ScrollController scrollController;
  final int indexInt;
  final childId;
  final GestureDragUpdateCallback vertdrag;
  final GestureDragUpdateCallback horizdrag;
  HorizList({this.scrollController, this.indexInt, this.childId, this.vertdrag, this.horizdrag}); 

  
  @override
  _HorizListState createState() => _HorizListState();
}

class _HorizListState extends State<HorizList> {
  
  var currentMonth = DateFormat.M().format(DateTime.now().toUtc());
  var currentYear = DateFormat.y().format(DateTime.now().toUtc());
  var currentday = DateFormat.d().format(DateTime.now().toUtc());
  var hour = DateFormat.H().format(DateTime.now().toUtc());
  var minute = DateFormat.m().format(DateTime.now().toUtc());
  var second = DateFormat.s().format(DateTime.now().toUtc());
  
  var todayUtcTimestamp;
  bool imageLoading = false;
  var sampleImage;
  var todayHourTimestamp;
  QuerySnapshot  rowData;
  DocumentSnapshot tenrowData;
  int documentsLength;
  List<String> selectedChild = [];
  var dayCare; 

  @override
  void initState() {
      // TODO: implement initState
      super.initState();

      var timestamp = new DateTime.utc(int.parse(currentYear), int.parse(currentMonth), int.parse((widget.indexInt + 1).toString()), int.parse(hour), int.parse(minute), int.parse(second) ).millisecondsSinceEpoch;   
      todayUtcTimestamp = new DateTime.utc(int.parse(currentYear), int.parse(currentMonth), int.parse((widget.indexInt + 1).toString())).millisecondsSinceEpoch;
      todayHourTimestamp = timestamp - todayUtcTimestamp;
      fetchLocalData();
      
      selectedChild.add(widget.childId);
    
  }
  
  fetchLocalData() async {
    dayCare = await getDataLocally(key: 'dayCare');
    getRowData();
  }
  
  void getRowData() async {

        QuerySnapshot data = await Firestore.instance.collection("events").document(dayCare.toString()).collection(todayUtcTimestamp.toString()).document(widget.childId).collection('eventData').getDocuments();

        setState(() {
           rowData = data;
        }); 
     if(rowData != null) {
       
       documentsLength = rowData.documents.length;
       print(rowData.documents.length);
       print(rowData.documents[0].documentID);
     }
     
  
  }

  getRightImage(rowData, i) {
    if(rowData.documents[i]['type'] == 'arrive') {
      return Image.asset('assets/images/arrive.png');
    } else if(rowData.documents[i]['type'] == 'play') {
      return Image.asset('assets/images/play.png');
    } else if(rowData.documents[i]['type'] == 'leave') {
      return Image.asset('assets/images/leave.png');
    } else if(rowData.documents[i]['type'] == 'diaper') {
      return Image.asset('assets/images/diaper.png');
    } else if(rowData.documents[i]['type'] == 'care') {
      return Image.asset('assets/images/care.png');
    } else if(rowData.documents[i]['type'] == 'food') {
      return Image.asset('assets/images/food.png');
    } else if(rowData.documents[i]['type'] == 'sleep') {
      return Image.asset('assets/images/sleep.png');
    } else {
      return Image.asset('assets/images/cookie.png');
    }
  }

  getImageData(index, QuerySnapshot rowDatas) {
    
    if(rowDatas != null) {
    
      for(var i = 0; i < rowDatas.documents.length; i++) {
        if(index + 7 < 25) {
          if(int.parse(rowDatas.documents[i].documentID)  == index + 7 ) {
            
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddEvent(selectedChilds: selectedChild, time: index + 7)));      
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                widget.vertdrag(details);
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                widget.horizdrag(details);
              },
              child: Container(
                height: 50.0,
                width: 50.0,
                child: getRightImage(rowDatas, i),
              )
            );  
          }   
        }  else {
          if(int.parse(rowDatas.documents[i].documentID)  == index + 7 - 24  ) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddEvent(selectedChilds: selectedChild, time: (index + 7 -24))));      
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                widget.vertdrag(details);
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                widget.horizdrag(details);
              },
              
              child: Container(
                height: 50.0,
                width: 50.0,
                child: getRightImage(rowDatas, (i)),
              )
            );
          }
        }
      }
    }
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        widget.vertdrag(details);
      },  
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        widget.horizdrag(details);
      },
      onTap: () {
        int passParameter = 1;
        if(index + 7 < 25) {
          passParameter = index + 7;
        } else {
          passParameter = index + 7 - 24;
        }

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddEvent(selectedChilds: selectedChild, time: passParameter)));
      },
      child: Opacity(
        opacity: 0.0,
        child: Image.asset(
          "assets/images/diaper.png",
           width: 50.0,
           height: 50.0,
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,

      child: new ListView.builder(
        controller: widget.scrollController,
        itemBuilder: (context, index){
        return GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
        widget.vertdrag(details);
        },  
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          widget.horizdrag(details);
        },
        onTap: () {
          int passParameter = 1;
          if(index + 7 < 25) {
            passParameter = index + 7;
          } else {
            passParameter = index + 7 - 24;
          }
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddEvent(selectedChilds: selectedChild, time: passParameter)));
        },
          child: new Card(
            margin: EdgeInsets.all(0.0),
            elevation: 0.0,
            child: new Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: shadowGrey, style: BorderStyle.solid)
              ),
              padding: EdgeInsets.all(12.0),
              child: getImageData(index, rowData),
              alignment: Alignment.center,
              )
            ),
        );
      }, 
      scrollDirection: Axis.vertical,),
    );
  }
}
