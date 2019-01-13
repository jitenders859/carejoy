import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carejoy/multi_image/asset_view.dart';
import 'package:carejoy/theme.dart';
import 'package:carejoy/tools/progressdialog.dart';
import 'package:multi_image_picker/asset.dart';

class BuildPhotoGridView extends StatelessWidget {
  final List<Asset> uploadImages;
  final List<String> showImages;
  BuildPhotoGridView(
    {this.uploadImages, this.showImages}
  );
  
  Widget buildGridView() {
    
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      primary: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 6,
      itemCount: uploadImages.length,
      itemBuilder: (BuildContext context, int index) { 
      
      return Card(
        child: AssetView(index, uploadImages[index]),  
      );
      },
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, 3),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  
  }  

  displayProgressDialog(BuildContext context, String networkImage) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ProgressDialog(networkImage:  networkImage,);
        }));
  }

  Widget showGridView() {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      primary: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 6,
      itemCount: showImages.length,
      itemBuilder: (BuildContext context, int index) { 
      var queryDataImage = showImages[index];
      return Card(
        child: GestureDetector(
          onTap: () {
            displayProgressDialog(context, queryDataImage);
          },
          child: Container(
            alignment: Alignment.center,
            child: Image.network(queryDataImage, fit: BoxFit.contain,),
          ),
        ),
      );
      },
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, 3),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  getLength(length) {
    if(length == 0) {
      return 0;
    } else if(length <= 3) {
      return 1;
    } else if(length <= 6) {
      return 2;
    } else if(length <= 9) {
      return 3;
    } else {
      return 4;
    }
  }


  @override
  Widget build(BuildContext context) {
    return uploadImages != null ? Container(
      
      decoration: BoxDecoration(
        color: shadowGrey,
      ),
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(left: 40.0, right: 40.0),
      height: 165.0 * getLength(uploadImages.length),
      width: double.infinity,
      alignment:Alignment.center,
      child:  buildGridView(),
    ) : Container(
      decoration: BoxDecoration(
        color: shadowGrey,
      ),
      height: 160.0 * getLength(showImages.length),
      width: double.infinity,
      alignment:Alignment.center,
      child: showGridView(),
    );

  }
}