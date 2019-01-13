import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carejoy/buildgridview.dart';
import 'package:carejoy/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/localization/localization.dart';

class CheckboxContainer extends StatelessWidget {
  final bool value;
  final Color color;
  final String text;
  final double sizeboxWidth;
  final submit;

  CheckboxContainer({
    this.value,
    this.color,
    this.text,
    this.submit,
    this.sizeboxWidth = 10.0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: value,
            onChanged: (values) {
              submit(values);
            },
            activeColor: color,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          
          Text(
            text,
            style: TextStyle(
              color: black,
              fontSize: 14.0
            )
          ),
          SizedBox(
            width: sizeboxWidth,
          ),
        ],
      ),
    );
  }
}


class BoxContainer extends StatelessWidget {
  
  final String imageData;
  final String imageText;
  final double containerHeight;
  final double imageWidth;
  final void Function(bool) action;
  final bool value;
  BoxContainer({
    this.imageData,
    this.imageText,
    this.containerHeight,
    this.imageWidth,
    this.action,
    this.value,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        action(value);
      },
      child: Container(
        alignment: Alignment.center,
        height: containerHeight,
        width: double.infinity,
        decoration: BoxDecoration(
        color: value == true ? blue : Colors.white,
        boxShadow: [
            BoxShadow(
            blurRadius: 2.0,
            color: shadowGrey
            )
        ],
        border: BorderDirectional(end: BorderSide(
            width: 1.0,
            color: shadowGrey,
            style: BorderStyle.solid
        ))
        ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imageData,
            height: imageWidth,
            width: imageWidth,
            color: value == true ? Colors.white : null,
          ),
          SizedBox(
            height: 5.0,
          ),
          imageText != null ? Text(
            imageText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.0,
                color: value == true ? Colors.white : black,
                fontFamily: roboto,
            ), 
          ) : Container(),
          ],
        )
      ),
    );
  }
}
class DayContainer extends StatefulWidget {
  final queryData;
  DayContainer({
    this.queryData,
  });

  @override
  _DayContainerState createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> with SingleTickerProviderStateMixin {

  TabController tabController;  
  var queryData;
  @override
  initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);    
    queryData = widget.queryData;
  }
  
  getRightImage(imageData) {
    if(imageData['type'] == 'arrive') {
      return 'assets/images/arrive.png';
    } else if(imageData['type'] == 'play') {
      return 'assets/images/play.png';
    } else if(imageData['type'] == 'leave') {
      return 'assets/images/leave.png';
    } else if(imageData['type'] == 'diaper') {
      return 'assets/images/diaper.png';
    } else if(imageData['type'] == 'care') {
      return 'assets/images/care.png';
    } else if(imageData['type'] == 'food') {
      return 'assets/images/food.png';
    } else if(imageData['type'] == 'sleep') {
      return 'assets/images/sleep.png';
    } else {
      return 'assets/images/cookie.png';
    }
  }

  getRightDialog(context, queryData) {
    if(queryData['type'] == 'arrive') {
      _showArriveDialog(context, queryData);
    } else if(queryData['type'] == 'play') {
      _showPlayDialog(context, queryData);
    } else if(queryData['type'] == 'leave') {
      _showLeaveDialog(context, queryData);
    } else if(queryData['type'] == 'diaper') {
      _showDiaperDialog(context, queryData);
    } else if(queryData['type'] == 'care') {
      _showCareDialog(context, queryData);
    } else if(queryData['type'] == 'food') {
      _showFoodDialog(context, queryData);
    } else if(queryData['type'] == 'sleep') {
      _showSleepDialog(context, queryData);
    } else {
      _showArriveDialog(context, queryData);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  () {
        getRightDialog(context, queryData);
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
            BoxShadow(
            blurRadius: 2.0,
            
            offset: Offset(0.0, 0.0),
            spreadRadius: 1.0,
            color: shadowGrey
            )
        ],
        ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  getRightImage(queryData),
                  height: 35.0,
                  width: 35.0,
                ),
                SizedBox(width: 8.0,),
                Text(
                  "${queryData['time']}:00",
                  style: TextStyle(
                    fontFamily: roboto,
                    color: black,
                    fontSize: 15.0
                  ),    
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            queryData['comment'],
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13.0,
                color: black,
                fontFamily: roboto,
            ),
          ),
          
          ],
        )
      ),
    );
  }

  void _showArriveDialog(context, queryData) {
    var fields = AppLocalizations.of(context);
    var screenSize = MediaQuery.of(context).size;
    // flutter defined function
    bool notify = queryData['notify'];
    bool share = queryData['share'];

    List<String> moreImages = [];

    for(var i = 0; i < queryData['moreImages'].length; i++) {

      moreImages.add(queryData['moreImages'][i]);
    }

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
                  fields.arrive,
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
          content: Container(
            height: screenSize.height,
            width: screenSize.width,
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        getRightImage(queryData),
                        height: 35.0,
                        width: 35.0,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        "${queryData['time']}:00",
                        style: TextStyle(
                          fontFamily: roboto,
                          color: black,
                          fontSize: 15.0
                        ),    
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 8.0,),
                // Container(
                //   height: 45.0,
                //   width: double.infinity,
                //   child: Row(
                //     children: <Widget>[
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.notify,
                //         value: notify
                //       ),
                //       SizedBox(width: 2.0,),
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.share,
                //         value: share
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 10.0),
                Text(
                  fields.comment,
                  style: TextStyle(
                    color: black,
                    
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  queryData['comment'],
                  style: TextStyle(
                    color: grey,
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                BuildPhotoGridView(showImages: moreImages,)
              ],
            ),
          )
        );
      },
    );
  }

  void _showLeaveDialog(context, queryData) {
    var screenSize = MediaQuery.of(context).size;
    // flutter defined function
    var fields = AppLocalizations.of(context);
    bool notify = queryData['notify'];
    bool share = queryData['share'];
    
    
    List<String> moreImages = [];

    for(var i = 0; i < queryData['moreImages'].length; i++) {

      moreImages.add(queryData['moreImages'][i]);
    }

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
                  fields.leave,
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
          content: Container(
            width: screenSize.width,
            height: screenSize.height,
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        getRightImage(queryData),
                        height: 35.0,
                        width: 35.0,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        "${queryData['time']}:00",
                        style: TextStyle(
                          fontFamily: roboto,
                          color: black,
                          fontSize: 15.0
                        ),    
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 10.0),
                // Container(
                //   height: 45.0,
                //   width: double.infinity,
                //   child: Row(
                //     children: <Widget>[
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.notify,
                //         value: notify
                //       ),
                //       SizedBox(width: 2.0,),
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.share,
                //         value: share
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 10.0),
                
                Text(
                  fields.comment,
                  style: TextStyle(
                    color: black,
                    
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  queryData['comment'],
                  style: TextStyle(
                    color: grey,
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                BuildPhotoGridView(showImages: moreImages,)              
              ],
            ),
          )
        );
      },
    );
  }

  void _showSleepDialog(context, queryData) {
    var screenSize = MediaQuery.of(context).size;
    var fields = AppLocalizations.of(context);
    // flutter defined function
    bool notify = queryData['notify'];
    bool share = queryData['share'];
    bool sleep = queryData['mode'] == 'sleep' ? true : false;
    bool slept = queryData['mode'] == 'slept' ? true : false;
    bool normal = queryData['mode'] == 'normal' ? true : false;
    bool awake = queryData['mode'] == 'awake' ? true : false;
    bool sleeping= queryData['sleeping'] == 'sleeping' ? true : false;
    bool awaking = queryData['sleeping'] == 'awaking' ? true : false;
    

    
    List<String> moreImages = [];

    for(var i = 0; i < queryData['moreImages'].length; i++) {

      moreImages.add(queryData['moreImages'][i]);
    }

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
                  fields.sleep,
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
          content: Container(
            height: screenSize.height,
            width: screenSize.width,
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        getRightImage(queryData),
                        height: 35.0,
                        width: 35.0,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        "${queryData['time']}:00",
                        style: TextStyle(
                          fontFamily: roboto,
                          color: black,
                          fontSize: 15.0
                        ),    
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0.0, top: 0.0),
                  child: Container(
                    height: 4.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      
                      color: Colors.white,
                      
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: BoxContainer(
                            imageData: "assets/images/emoji_one.png",
                            containerHeight: 80.0,
                            value: sleep,
                            imageWidth: 40.0,
                            
                            
                          ),
                          
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: BoxContainer(
                            imageData: "assets/images/emoji_two.png",
                            containerHeight: 80.0,
                            value: slept,
                            imageWidth: 40.0,
                            
                          ),
                          
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: BoxContainer(
                            imageData: "assets/images/emoji_three.png",
                            containerHeight: 80.0,
                            value: normal,
                            imageWidth: 40.0,
                            
                          ),
                          
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: BoxContainer(
                            imageData: "assets/images/emoji_four.png",
                            containerHeight: 80.0,
                            value: awake,
                            imageWidth: 40.0,
                            
                          ),
                          
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0.0, top: 0.0),
                  child: Container(
                    height: 4.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 20.0, right: 20.0),
                  child: Row(
                    children: <Widget>[
                      
                      Expanded(
                          child: BoxContainer(
                            imageData: "assets/images/sleeping.png",
                            containerHeight: 80.0,
                            value: sleeping,
                            imageWidth: 40.0,
                            
                            imageText: "14:28",
                          ),
                          
                        ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                          child: BoxContainer(
                            imageData: "assets/images/wake_up.png",
                            containerHeight: 80.0,
                            value: awaking,
                            imageWidth: 40.0,
                            
                            imageText: "15:05",
                          ),
                          
                        ),
                    ],
                  ),
                ),


              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0, top: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                  ),
                ),
              ),
                // SizedBox(height: 10.0),
                // Container(
                //   height: 45.0,
                //   width: double.infinity,
                //   child: Row(
                //     children: <Widget>[
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.notify,
                //         value: notify
                //       ),
                //       SizedBox(width: 2.0,),
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.share,
                //         value: share
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 10.0),
                Text(
                  fields.comment,
                  style: TextStyle(
                    color: black,
                    
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(height: 8.0,),
                
                Text(
                  queryData['comment'],
                  style: TextStyle(
                    color: grey,
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                BuildPhotoGridView(showImages: moreImages,)
              ],
            ),
          )
        );
      },
    );
  }

  void _showDiaperDialog(context, queryData) {
    var screenSize = MediaQuery.of(context).size;
    var fields = AppLocalizations.of(context);
    // flutter defined function
    bool notify = queryData['notify'];
    bool share = queryData['share'];
      
    bool beCareful = queryData['beCareful'];
    bool diaperSmall = queryData['diaper_size'] == "small" ? true : false;
    bool diaperMedium = queryData['diaper_size'] == "medium" ? true : false;
    bool diaperLarge = queryData['diaper_size'] == "large" ? true : false;
    bool tshirt = queryData['tshrit'];
    bool boxer = queryData['change'] == "boxer" ? true : false;
    bool wash = queryData['change'] == "wash" ? true : false;
    bool potwash = queryData['change'] == "potwash" ? true : false;

    
    List<String> moreImages = [];

    for(var i = 0; i < queryData['moreImages'].length; i++) {

      moreImages.add(queryData['moreImages'][i]);
    }

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
                  "${fields.diaper} ${fields.change}",
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
          content: Container(
            height: screenSize.height,
            width: screenSize.width,
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        getRightImage(queryData),
                        height: 35.0,
                        width: 35.0,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        "${queryData['time']}:00",
                        style: TextStyle(
                          fontFamily: roboto,
                          color: black,
                          fontSize: 15.0
                        ),    
                      ),
                    ],
                  ),
                ),
                Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0.0, top: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 80.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                          color: shadowGrey,
                          width: 2.0,
                          style: BorderStyle.solid
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3.0,
                              color: shadowGrey
                            )
                          ]  
                        ),
                        child: Row(
                          children: <Widget>[
                            
                            TickBoxContainer(
                              containerSize: 80.0,
                              imageDimension: 30.0,
                              tickDimension: 14.0,
                              image: "assets/images/diaper_rating.png",
                              tickImage: "assets/images/green_tick.png",
                              
                              value: diaperSmall,
                            ),
                            TickBoxContainer(
                              containerSize: 80.0,
                              imageDimension: 35.0,
                              tickDimension: 15.0,
                              image: "assets/images/diaper_rating.png",
                              tickImage: "assets/images/green_tick.png",
                              
                              value: diaperMedium,
                            ),
                            TickBoxContainer(
                              containerSize: 80.0,
                              imageDimension: 40.0,
                              tickDimension: 16.0,
                              image: "assets/images/diaper_rating.png",
                              tickImage: "assets/images/green_tick.png",
                              
                              value: diaperLarge,
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                  
                      child: Container(
                        margin: EdgeInsets.only(left: 5.0),
                        height: 80.0,
                        width: 65.0,

                        decoration: BoxDecoration(
                          border: Border.all(
                            color: shadowGrey,
                            width: 2.0,
                            style: BorderStyle.solid
                          ),
                          color: tshirt ? blue : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3.0,
                              color: shadowGrey
                            )
                          ]
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/tshirt_round.png",
                          height: 50.0,
                          width: 50.0,
                          color: tshirt ?  Colors.white : null,
                        )
                          
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0.0, top: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom:15.0, top: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                       
                        child: Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:  boxer ? blue : Colors.white,
                            border: BorderDirectional(end: BorderSide(
                              width: 1.0,
                              color: shadowGrey,
                              style: BorderStyle.solid
                            ))
                          ),
                          child: Image.asset(
                            "assets/images/boxer.png",
                            height: 50.0,
                            width: 50.0,
                            color: boxer ? Colors.white : null,
                          )
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: wash ? blue : Colors.white,
                            border: BorderDirectional(end: BorderSide(
                              width: 1.0,
                              color: shadowGrey,
                              style: BorderStyle.solid
                            ))
                          ),
                          child: Image.asset(
                            "assets/images/diaper_icon_two.png",
                            height: 50.0,
                            width: 50.0,
                            color: wash ? Colors.white : null,
                          )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          height: 80.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: potwash ? blue : Colors.white,
                            border: BorderDirectional(end: BorderSide(
                              width: 1.0,
                              color: shadowGrey,
                              style: BorderStyle.solid
                            ))
                          ),
                          child: Image.asset(
                            "assets/images/diaper_icon_three.png",
                            height: 50.0,
                            width: 50.0, 
                            color: potwash ? Colors.white : null, 
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0, top: 0.0),
                child: Container(
                  height: 4.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                  ),
                ),
              ),
                // Container(
                //   height: 45.0,
                //   width: double.infinity,
                //   child: Row(
                //     children: <Widget>[
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.notify,
                //         value: notify,
                //         sizeboxWidth: 0.0,
                //       ),
                      
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.share,
                //         value: share,
                //         sizeboxWidth: 0.0,
                //       ),
                      
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.beCareful,
                //         value: beCareful,
                //         sizeboxWidth: 0.0,
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 8.0,),
                Text(
                  fields.comment,
                  style: TextStyle(
                    color: black,
                    
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(height: 8.0,),
                
                SizedBox(height: 10.0),
                Text(
                  queryData['comment'],
                  style: TextStyle(
                    color: grey,
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                BuildPhotoGridView(showImages: moreImages,)
              ],
            ),
          )
        );
      },
    );
  }

  void _showFoodDialog(context, queryData) {
    var screenSize = MediaQuery.of(context).size;
    var fields = AppLocalizations.of(context);
    // flutter defined function
    bool notify = queryData['notify'];
    bool share = queryData['share'];

    double _slidervalue = 0.0;
    bool cheeseSmall = queryData['cheese'] == "small" ?  true : false;
    bool cheeseMedium = queryData['cheese'] == "medium" ?  true : false;
    bool cheeseLarge = queryData['cheese'] == "large" ?  true : false;
    bool cookieSmall = queryData['cookie'] == "small" ?  true : false;
    bool cookieMedium = queryData['cookie'] == "medium" ?  true : false;
    bool cookieLarge = queryData['cookie'] == "large" ?  true : false;
    bool fruitSmall = queryData['fruit'] == "small" ?  true : false;
    bool fruitMedium = queryData['fruit'] == "medium" ?  true : false;
    bool fruitLarge = queryData['fruit'] == "large" ?  true : false;
    String _milk = queryData['milk'];
    
    
    List<String> moreImages = [];

    for(var i = 0; i < queryData['moreImages'].length; i++) {

      moreImages.add(queryData['moreImages'][i]);
    }
    
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
                  fields.food,
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
          content: Container(
            height: screenSize.height,
            width: screenSize.width,
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        getRightImage(queryData),
                        height: 35.0,
                        width: 35.0,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        "${queryData['time']}:00",
                        style: TextStyle(
                          fontFamily: roboto,
                          color: black,
                          fontSize: 15.0
                        ),    
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0.0, top: 0.0),
                  child: Container(
                    height: 4.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                      color: shadowGrey,
                      width: 2.0,
                      style: BorderStyle.solid
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: shadowGrey
                        )
                      ]  
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 80.0,
                                decoration: BoxDecoration(
                                  border: BorderDirectional(
                                  end: BorderSide(color: shadowGrey,
                                  width: 2.0,
                                  style: BorderStyle.solid),
                                  top: BorderSide(color: shadowGrey,
                                  width: 2.0,
                                  style: BorderStyle.solid),
                                  bottom: BorderSide(color: shadowGrey,
                                  width: 0.0,
                                  style: BorderStyle.solid),
                                  start: BorderSide(color: shadowGrey,
                                  width: 2.0,
                                  style: BorderStyle.solid)
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: shadowGrey,
                                    )
                                  ]  
                                ),
                                child: Row(
                                  children: <Widget>[
                                    TickBoxContainer(
                                      containerSize: 80.0,
                                      imageDimension: 30.0,
                                      tickDimension: 14.0,
                                      image: "assets/images/cheese.png",
                                      tickImage: "assets/images/green_tick.png",
                                      value: cheeseSmall,
                                    ),
                                    TickBoxContainer(
                                      containerSize: 80.0,
                                      imageDimension: 35.0,
                                      tickDimension: 14.0,
                                      image: "assets/images/cheese.png",
                                      tickImage: "assets/images/green_tick.png",
                                      value: cheeseMedium,
                                    ),
                                    TickBoxContainer(
                                      containerSize: 80.0,
                                      imageDimension: 40.0,
                                      tickDimension: 14.0,
                                      image: "assets/images/cheese.png",
                                      tickImage: "assets/images/green_tick.png",
                                      value: cheeseLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 80.0,
                                decoration: BoxDecoration(
                                  border: BorderDirectional(
                                  end: BorderSide(color: shadowGrey,
                                  width: 2.0,
                                  style: BorderStyle.solid),
                                  top: BorderSide(color: shadowGrey,
                                  width: 2.0,
                                  style: BorderStyle.solid),
                                  bottom: BorderSide(color: shadowGrey,
                                  width: 0.0,
                                  style: BorderStyle.solid),
                                  start: BorderSide(color: shadowGrey,
                                  width: 2.0,
                                  style: BorderStyle.solid)
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: shadowGrey
                                    )
                                  ]  
                                ),
                                child: Row(
                                  children: <Widget>[
                                    TickBoxContainer(
                                      containerSize: 80.0,
                                      imageDimension: 30.0,
                                      tickDimension: 14.0,
                                      image: "assets/images/cookie.png",
                                      tickImage: "assets/images/green_tick.png",
                                      value: cookieSmall,
                                    ),
                                    TickBoxContainer(
                                      containerSize: 80.0,
                                      imageDimension: 35.0,
                                      tickDimension: 14.0,
                                      image: "assets/images/cookie.png",
                                      tickImage: "assets/images/green_tick.png",
                                      value: cookieMedium,
                                    ),
                                    TickBoxContainer(
                                      containerSize: 80.0,
                                      imageDimension: 40.0,
                                      tickDimension: 14.0,
                                      image: "assets/images/cookie.png",
                                      tickImage: "assets/images/green_tick.png",
                                      value: cookieLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 80.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                  color: shadowGrey,
                                  width: 2.0,
                                  style: BorderStyle.solid
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: shadowGrey
                                    )
                                  ]  
                                ),
                                child: Row(
                                  children: <Widget>[
                                    
                                    TickBoxContainer(
                                      containerSize: 80.0,
                                      imageDimension: 30.0,
                                      tickDimension: 14.0,
                                      image: "assets/images/fruit.png",
                                      tickImage: "assets/images/green_tick.png",
                                      
                                      value: fruitSmall,
                                    ),
                                    TickBoxContainer(
                                      containerSize: 80.0,
                                      imageDimension: 35.0,
                                      tickDimension: 14.0,
                                      image: "assets/images/fruit.png",
                                      tickImage: "assets/images/green_tick.png",
                                      
                                      value: fruitMedium,
                                    ),
                                    TickBoxContainer(
                                      containerSize: 80.0,
                                      imageDimension: 40.0,
                                      tickDimension: 14.0,
                                      image: "assets/images/fruit.png",
                                      tickImage: "assets/images/green_tick.png",
                                      
                                      value: fruitLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0.0, top: 0.0),
                  child: Container(
                    height: 4.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0, top: 10.0),
                  child: Text(
                    fields.milk,
                    style: TextStyle(
                      color: black,
                      fontSize: 18.0,
                      fontFamily: roboto
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 12.0, top: 12.0),
                  child: FluidSlider(
                    value: double.parse(_milk) ,
                    
                    start: Container(
                      height: 26.0,
                      width: 50.0,
                      alignment: Alignment.centerRight,
                      
                      child: Text(
                        "0 ml",
                        style: TextStyle(
                          color: blue,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.0
                        ),  
                      ),
                    ),
                    end: Container(
                      height: 26.0,
                      width: 50.0,
                      alignment: Alignment.centerRight,
                      
                      child: Text(
                        "350 ml",
                        style: TextStyle(
                          color: blue,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500
                        ),  
                      ),
                    ),
                    min: 0.0,
                    max: 350.0,
                    sliderColor: shadowGrey,
                    thumbColor: blue,
                    labelsTextStyle: TextStyle(
                      fontFamily: roboto,
                      color: Colors.green,
                    
                    ),
                    valueTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: roboto,
                      fontSize: 14.0,
                      
                    ),
                    
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0, top: 0.0),
                  child: Container(
                    height: 4.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
                    ),
                  ),
                ),
                SizedBox(height: 8.0,),
                // Container(
                //   height: 45.0,
                //   width: double.infinity,
                //   child: Row(
                //     children: <Widget>[
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.notify,
                //         value: notify
                //       ),
                //       SizedBox(width: 2.0,),
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.share,
                //         value: share
                //       ),
                //     ],
                //   ),
                // ),
                Text(
                  fields.comment,
                  style: TextStyle(
                    color: black,
                    
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                
                SizedBox(height: 10.0),
                Text(
                  queryData['comment'],
                  style: TextStyle(
                    color: grey,
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                BuildPhotoGridView(showImages: moreImages,)
              ],
            ),
          )
        );
      },
    );
  }

  void _showPlayDialog(context, queryData) {
    var screenSize = MediaQuery.of(context).size;
    // flutter defined function
  var fields = AppLocalizations.of(context);
  bool notify = queryData['notify'];
  bool share = queryData['share'];

  List<String> moreImages = [];

  for(var i = 0; i < queryData['moreImages'].length; i++) {

    moreImages.add(queryData['moreImages'][i]);
  }

  bool reading = queryData['play'] == 'reading' ? true : false;
  bool singing = queryData['play'] == 'singing' ? true : false;
  bool painting = queryData['play'] == 'painting' ? true : false;
  bool jumping = queryData['play'] == 'jumping' ? true : false;
  bool free = queryData['play'] == 'free' ? true : false;
  String tab;
  setState(() {
    tab = queryData['play'];    
  });
  
  ScrollController scrollController = new ScrollController();
  List<Event> eventList = [
    Event(image: "assets/images/reading.png", text: "READING"),
    Event(image: "assets/images/painting.png", text: "PAINTING"),
    Event(image: "assets/images/singing.png", text: "SINGING"),
    Event(image: "assets/images/jumping.png", text: "JUMPING"),
    Event(image: "assets/images/free.png", text: "FREE"),
  ];


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
                  fields.play,
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
          content: Container(
            height: screenSize.height,
            width: screenSize.width,
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        getRightImage(queryData),
                        height: 35.0,
                        width: 35.0,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        "${queryData['time']}:00",
                        style: TextStyle(
                          fontFamily: roboto,
                          color: black,
                          fontSize: 15.0
                        ),    
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  height: (screenSize.width /4 * 2.2),
                  
                  child: new StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemCount: eventList.length,
                    itemBuilder: (BuildContext context, int index) { 
                      return Container(
                      
               
                      decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: shadowGrey, style: BorderStyle.solid),
                        color: tab == eventList[index].text.toLowerCase() ? blue : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2.0,
                            color: shadowGrey,
                            spreadRadius: 0.0
                          )
                        ] 
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            height: 30.0,
                            width: 30.0,  
                            child: Image.asset(
                              eventList[index].image,
                              color: tab == eventList[index].text.toLowerCase() ?  Colors.white : null
                            )
                          ),
                          Text(
                            eventList[index].text,
                            style: TextStyle(
                              color: tab == eventList[index].text  ? Colors.white : black,
                              fontSize: 18.0
                            ),
                          )
                        ],
                      )
                    );
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(2, 1),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  fields.comment,
                  style: TextStyle(
                    color: black,
                    
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                // SizedBox(height: 8.0,),
                // Container(
                //   height: 45.0,
                //   width: double.infinity,
                //   child: Row(
                //     children: <Widget>[
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.notify,
                //         value: notify
                //       ),
                //       SizedBox(width: 2.0,),
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.share,
                //         value: share
                //       ),
                //     ],
                //   ),
                // ),
                
                SizedBox(height: 8.0),
                Text(
                  queryData['comment'],
                  style: TextStyle(
                    color: grey,
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                
                BuildPhotoGridView(showImages: moreImages,),
                SizedBox(height: 500.0,)
              ],
            ),
          )
        );
      },
    );
  }
  


  void _showCareDialog(context, queryData) {
    var screenSize = MediaQuery.of(context).size;
    var fields = AppLocalizations.of(context);
    bool notify = queryData['notify'];
    bool share = queryData['share'];
    
    bool fever = queryData['checkup']['fever'];
    bool earPain = queryData['checkup']['earPain'];
    bool crying = queryData['checkup']['crying'];
    bool runnyNose = queryData['checkup']['runnyNose'];
    bool vomiting = queryData['checkup']['vomiting'];
    bool toothache = queryData['checkup']['toothache'];

    // care
    bool eyeCleaning = queryData['care']['eyeCleaning'];
    bool noseCleaning = queryData['care']['noseCleaning'];
    bool moisturizer = queryData['care']['moisturizer'];
    bool other = queryData['care']['other'];

    // medicine
    bool paracetamol = queryData['medicine']['paracetamol'];
    bool earDrops = queryData['medicine']['earDrops'];
    bool eyeDrops = queryData['medicine']['eyeDrops'];
    bool vitamin = queryData['medicine']['vitamin'];
    // flutter defined function

    
    List<String> moreImages = [];

    for(var i = 0; i < queryData['moreImages'].length; i++) {

      moreImages.add(queryData['moreImages'][i]);
    }

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
                  fields.care,
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
          content: Container(
            height: screenSize.height,
            width: screenSize.width,
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        getRightImage(queryData),
                        height: 35.0,
                        width: 35.0,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        "${queryData['time']}:00",
                        style: TextStyle(
                          fontFamily: roboto,
                          color: black,
                          fontSize: 15.0
                        ),    
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0,),
                Container(
                  padding: EdgeInsets.only(
                    top: 5.0, bottom: 0.0,
                    left: 20.0, right: 20.0
                  ),
                  width: double.infinity,
                  
                  color: shadowGrey,
                  child: new TabBar(
                    controller: tabController,
                    tabs: [
                      new Tab(

                        child: Container(
                          width: double.infinity,
                          height: 70.0,
                          alignment: Alignment.center,
                          
                          child: Image.asset(
                            "assets/images/diagnosis_color.png",
                            height: 40.0,
                            width: 40.0,
                          ),
                        )
                      ),
                      new Tab(
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          alignment: Alignment.center,
                          
                          child: Image.asset(
                            "assets/images/medication_color.png",
                            height: 40.0,
                            width: 40.0,
                          ),
                        )
                      ),
                      new Tab(
                        child: Container(
                          width: double.infinity,
                          height: 70.0,
                          alignment: Alignment.center,
                          
                          child: Image.asset(
                            "assets/images/care.png",
                            height: 40.0,
                            width: 40.0,
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              
                Container(
                  padding: EdgeInsets.all(0.0),
                  width: double.infinity,
                  height: 250.0, 
                  child: new TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(0.0),
                        height: 250.0,
                        width: double.infinity,
                        child: Column(
                            children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 15.0),
                                child: Row(
                                children: <Widget>[
                                    Expanded(
                                    child: BoxContainer(
                                      containerHeight: 90.0,
                                      imageData: "assets/images/fever.png",
                                      imageText: fields.fever.toUpperCase(),
                                      imageWidth: 45.0,
                                      
                                      value: fever
                                    )
                                    ),
                                    SizedBox(
                                    width: 15.0,
                                    ),
                                    Expanded(
                                    child: BoxContainer(
                                      containerHeight: 90.0,
                                      imageData: "assets/images/ear_pain.png",
                                      imageText: fields.earPain.toUpperCase(),
                                      imageWidth: 45.0,
                                      
                                      value: earPain
                                    )
                                    ),
                                    SizedBox(
                                    width: 15.0,
                                    ),
                                    Expanded(
                                    child: BoxContainer(
                                      containerHeight: 90.0,
                                      imageData: "assets/images/crying.png",
                                      imageText: fields.crying.toUpperCase(),
                                      imageWidth: 45.0,
                                      
                                      value: crying
                                    )
                                  ),
                                ],
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                                child: Row(
                                children: <Widget>[
                                    Expanded(
                                      child: BoxContainer(
                                        containerHeight: 90.0,
                                        imageData: "assets/images/runny_nose.png",
                                        imageText: fields.crying.toUpperCase(),
                                        imageWidth: 45.0,
                                        
                                        value: runnyNose
                                      )
                                    ),
                                    SizedBox(
                                    width: 15.0,
                                    ),
                                    Expanded(
                                      child: BoxContainer(
                                        containerHeight: 90.0,
                                        imageData: "assets/images/vomiting.png",
                                        imageText: fields.vomiting.toUpperCase(),
                                        imageWidth: 45.0,
                                        
                                        value: vomiting
                                      )
                                    ),
                                    SizedBox(
                                    width: 15.0,
                                    ),
                                    Expanded(
                                      child: BoxContainer(
                                        containerHeight: 90.0,
                                        imageData: "assets/images/toothache.png",
                                        imageText: fields.toothache.toUpperCase(),
                                        imageWidth: 45.0,
                                        
                                        value: toothache
                                      )
                                    ),
                                ],
                                ),
                            ),
                            ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0.0),
                        height: 250.0,
                        width: double.infinity,
                        child: Column(
                            children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                    child: BoxContainer(
                                      containerHeight: 90.0,
                                      imageData: "assets/images/eye_cleaning.png",
                                      imageText: fields.eyeCleaning.toUpperCase(),
                                      imageWidth: 45.0,
                                      
                                      value: eyeCleaning
                                    )
                                    ),
                                    
                                    SizedBox(
                                    width: 15.0,
                                    ),
                                    Expanded(
                                    child: BoxContainer(
                                      containerHeight: 90.0,
                                      imageData: "assets/images/nose_cleaning.png",
                                      imageText: fields.noseCleaning.toUpperCase(),
                                      imageWidth: 45.0,
                                      
                                      value: noseCleaning
                                    )
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                                child: Row(
                                children: <Widget>[
                                    Expanded(
                                      child: BoxContainer(
                                        containerHeight: 90.0,
                                        imageData: "assets/images/moisturizer.png",
                                        imageText: fields.moisturizer.toUpperCase(),
                                        imageWidth: 45.0,
                                        
                                        value: moisturizer
                                      )
                                    ),
                                    SizedBox(
                                    width: 15.0,
                                    ),
                                    Expanded(
                                      child: BoxContainer(
                                        containerHeight: 90.0,
                                        imageData: "assets/images/other.png",
                                        imageText: fields.other.toUpperCase(),
                                        imageWidth: 45.0,
                                        
                                        value: other
                                      )
                                    ),
                                    
                                  ],
                                ),
                            ),
                            ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0.0),
                        height: 250.0,
                        width: double.infinity,
                        child: Column(
                            children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                    child: BoxContainer(
                                      containerHeight: 90.0,
                                      imageData: "assets/images/paracetamol.png",
                                      imageText: fields.paracetamol.toUpperCase(),
                                      imageWidth: 45.0,
                                      
                                      value: paracetamol
                                    )
                                    ),
                                    
                                    SizedBox(
                                    width: 15.0,
                                    ),
                                    Expanded(
                                    child: BoxContainer(
                                      containerHeight: 90.0,
                                      imageData: "assets/images/ear_drop.png",
                                      imageText: fields.earDrops.toUpperCase(),
                                      imageWidth: 45.0,
                                      
                                      value: earDrops
                                    )
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                                child: Row(
                                children: <Widget>[
                                    Expanded(
                                      child: BoxContainer(
                                        containerHeight: 90.0,
                                        imageData: "assets/images/eye_drop.png",
                                        imageText: fields.eyeDrops.toUpperCase(),
                                        imageWidth: 45.0,
                                        
                                        value: eyeDrops
                                      )
                                    ),
                                    SizedBox(
                                    width: 15.0,
                                    ),
                                    Expanded(
                                      child: BoxContainer(
                                        containerHeight: 90.0,
                                        imageData: "assets/images/vitamin.png",
                                        imageText: fields.vitamin.toUpperCase(),
                                        imageWidth: 45.0,
                                        
                                        value: vitamin
                                      )
                                    ),
                                    
                                  ],
                                ),
                            ),
                          ],
                        ),
                      ), 
                    ],
                  ),
                ),
                // SizedBox(height: 8.0,),
                // Container(
                //   height: 45.0,
                //   width: double.infinity,
                //   child: Row(
                //     children: <Widget>[
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.notify,
                //         value: notify
                //       ),
                //       SizedBox(width: 2.0,),
                //       CheckboxContainer(
                //         color: blue,
                //         text: fields.share,
                //         value: share
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 10.0),
                Text(
                  fields.comment,
                  style: TextStyle(
                    color: black,
                    
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  queryData['comment'],
                  style: TextStyle(
                    color: grey,
                    fontFamily: roboto,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                BuildPhotoGridView(showImages: moreImages,)
              ],
            ),
          )
        );
      },
    );
  }

}

 

class LineBreak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0, top: 15.0),
      child: Container(
        height: 4.0,
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, style: BorderStyle.solid, color: shadowGrey )
        ),
      ),
    );
  }
}

class TickBoxContainer extends StatelessWidget {
  
  final double containerSize;
  final double imageDimension;
  final double tickDimension;
  final String image;
  final String tickImage;
  final VoidCallback action;
  final bool value;
  TickBoxContainer({
    this.containerSize,
    this.imageDimension,
    this.tickDimension,
    this.image,
    this.tickImage,
    this.action,
    this.value,
  });
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: containerSize,
            width: double.infinity,
            decoration: BoxDecoration(
              border: BorderDirectional(end: BorderSide(
                width: 1.0,
                color: shadowGrey,
                style: BorderStyle.solid
              ))
            ),
            child: Image.asset(
              image,
              height: imageDimension,
              width: imageDimension,
            )
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: value == true ? Image.asset(
              tickImage,
              height: tickDimension,
              width: tickDimension,
            ) : Container(),
          ),
          GestureDetector(
            onTap: () {
              action();
              
            },
            child: Container(
              alignment: Alignment.center,
              height: containerSize,
              
              child: Text(
                "click",
                style: TextStyle(
                  color: Colors.transparent
                ),
              ),
            ),  
          )
        ],
      ),
    );
  }
}

class Event {
  final String image;
  final String text;

  Event({
    this.image,
    this.text
  });

}

