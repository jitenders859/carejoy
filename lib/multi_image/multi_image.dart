import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:carejoy/theme.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'asset_view.dart';

class MultiImageUpload extends StatefulWidget {
  final Function(String) errorCallback;
  final Function(List<Asset>) imageCallback;

  MultiImageUpload({
    this.imageCallback,
    this.errorCallback,
  });
  @override
  _MultiImageUploadState createState() => _MultiImageUploadState();
}

class _MultiImageUploadState extends State<MultiImageUpload> {
  List<Asset> images = new List<Asset>();
  String _error;

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        enableCamera: true,
        maxImages: 10,
      );
    } on PlatformException catch (e) {
      error = e.message;
    }
    
  if (!mounted) return;

    setState(() {
      images = resultList;
      widget.imageCallback(resultList);
      if (error == null) _error = 'No Error Dectected';
      widget.errorCallback(error);
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        loadAssets();
      },
      child: Container(
        height: 50.0,
        width: 60.0,
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: grey, style: BorderStyle.solid),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/add_photo.png",
              height: 25.0,
              width: 25.0,
            ),
            Text(
              "add photo",
              style: TextStyle(
                color: grey,
                fontSize: 10.0
              ),
            )
          ],
            
        ),
      ),
    );
  }
}