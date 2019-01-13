import 'package:flutter/material.dart';
import 'package:carejoy/multi_image/multi_image.dart';
import 'package:carejoy/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:carejoy/localization/localization.dart';
import 'package:multi_image_picker/asset.dart';


class CommentBox extends StatelessWidget {
  final TextEditingController commentController;
  final bool imageLoading;
  final VoidCallback getImage;
  final FocusNode focus;
  final Function(String) errorCallback;
  final Function(List<Asset>) imageCallback;
  CommentBox(
    {
      this.commentController,
      this.imageLoading,
      this.getImage,
      this.focus,
      this.imageCallback,
      this.errorCallback
    }
  );
  
  @override
  Widget build(BuildContext context) {
    var fields = AppLocalizations.of(context);
    return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  
                ),
                child: TextFormField(
                  controller: commentController,
                  scrollPadding: EdgeInsets.all(0.0),
                  autocorrect: false,
                  focusNode: focus,
                  decoration: InputDecoration(
                    fillColor: grey,
                    hintText: "${fields.add} ${fields.comment}",
                    hintStyle: TextStyle(
                      fontSize: 12.0,
                      color: grey,
                    ),
                    contentPadding: EdgeInsets.all(16.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: shadowGrey,
                        style: BorderStyle.solid,
                        
                      ),
                      borderRadius: BorderRadius.circular(0.0)
                    )
                  ),
                  
                  
                ),
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
            MultiImageUpload( errorCallback: (error) {
              errorCallback(error);
            }, imageCallback: (images) {
              imageCallback(images);
            },
              
            ),
          ],
        ),
      );
      
  }
}