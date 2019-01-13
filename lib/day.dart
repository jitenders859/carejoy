import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:carejoy/addevent.dart';
import 'package:carejoy/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carejoy/boxcontainers.dart';
import 'package:carejoy/tools/app_tools.dart';

class Day extends StatefulWidget {
  final String childId;
  final int daysSubtotal;
  Day({
    this.childId,
    this.daysSubtotal
  });

  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> {
  int daysSubtotal;
  var currentMonth = DateFormat.M().format(DateTime.now().toUtc());
  var currentYear = DateFormat.y().format(DateTime.now().toUtc());
  var currentday = DateFormat.d().format(DateTime.now().toUtc());
  var hour = DateFormat.H().format(DateTime.now().toUtc().toUtc());
  var minute = DateFormat.m().format(DateTime.now().toUtc().toUtc());
  var second = DateFormat.s().format(DateTime.now().toUtc().toUtc());
  bool isLoading = false;
  var todayUtcTimestamp;
  var todayHourTimestamp;
  QuerySnapshot  morningData;
  QuerySnapshot eveningData;
  DocumentSnapshot tenrowData;
  int morningLength;
  int eveningLength;
  List<String> selectedChild = [];
  var dayCare;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      isLoading = true;
      daysSubtotal = widget.daysSubtotal;  
      
      
      selectedChild.add(widget.childId);
      fetchLocalData();
  }


  @override
    void didUpdateWidget(Day oldWidget) {
    if(daysSubtotal != widget.daysSubtotal) {
      setState(() {
        daysSubtotal = widget.daysSubtotal;
      });
      currentMonth = DateFormat.M().format(DateTime.now().toUtc().add(Duration(days: daysSubtotal)));
      currentYear = DateFormat.y().format(DateTime.now().toUtc().add(Duration(days: daysSubtotal)));
      currentday = DateFormat.d().format(DateTime.now().toUtc().add(Duration(days: daysSubtotal)));
      fetchLocalData();    
    }
    
    super.didUpdateWidget(oldWidget);
  }


  fetchLocalData() async {
    dayCare = await getDataLocally(key: 'dayCare');
    getRowData();
  }
  
  void getRowData() async {
    var timestamp = new DateTime.utc(int.parse(currentYear), int.parse(currentMonth), int.parse((currentday).toString()), int.parse(hour), int.parse(minute), int.parse(second) ).millisecondsSinceEpoch;   
    todayUtcTimestamp = new DateTime.utc(int.parse(currentYear), int.parse(currentMonth), int.parse(currentday)).millisecondsSinceEpoch;
    todayHourTimestamp = timestamp - todayUtcTimestamp;   
    print(dayCare + 'day ${widget.childId} $todayUtcTimestamp ');
    

    QuerySnapshot morning = await Firestore.instance.collection("events").document(dayCare.toString()).collection(todayUtcTimestamp.toString()).document(widget.childId).collection('eventData').where("time", isLessThan: 13).getDocuments();
    QuerySnapshot evening = await Firestore.instance.collection("events").document(dayCare.toString()).collection(todayUtcTimestamp.toString()).document(widget.childId).collection('eventData').where("time",isGreaterThan: 12 ).getDocuments();
    
    setState(() {
        morningData = morning;
        eveningData = evening; 
        
        if(morningData != null) {
      
          morningLength = morningData.documents.length;
          print(morningLength);
        }
        if(eveningData != null) {
      
          eveningLength = eveningData.documents.length;
          print(eveningLength);
        }
        isLoading = false;
    });  
  }

  ScrollController scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading ? Center(
        child:  CircularProgressIndicator(
          backgroundColor: blue,
        ) ): ListView(
          shrinkWrap: true,
          controller: scrollController,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Text(
                "Morning Transmissions",
                style: TextStyle(
                  color: black,
                  fontSize: 16.0,
                  fontFamily: roboto,
                  fontWeight: FontWeight.w500
                )
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              width: screenSize.width,
              child: new StaggeredGridView.countBuilder(
                shrinkWrap: true,
                primary: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                itemCount: morningData.documents.length,
                itemBuilder: (BuildContext context, int index) { 
                var queryData = morningData.documents[index].data;
                return DayContainer(
                  queryData: queryData,
                  
                 );
                
                },
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, 1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
            ),
            LineBreak(),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Text(
                "Evening Transmissions",
                style: TextStyle(
                  color: black,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              width: screenSize.width,
              child: new StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: eveningData.documents.length,
                shrinkWrap: true,
                primary: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                var queryData = eveningData.documents[index].data;
                return DayContainer(
                  queryData: queryData,
                  
                 );
                },
                staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, 1),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
            ),
            SizedBox(height: 100.0,)
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
      )
    );
  }
}
