import 'dart:io';
import 'package:flutter/material.dart';

class DiscountTab extends StatefulWidget {
  const DiscountTab({Key key}) : super(key: key);

  @override
  State<DiscountTab> createState() => _DiscountTabState();
}

class _DiscountTabState extends State<DiscountTab> {

  List<String> images = [];

  void loadImages() async{
    Directory dir = Directory('/storage/emulated/0/Download');
    final imagesDirectory = Directory(dir.path + "/LoanCalculator/DiscountCalculator/");

    if(!await imagesDirectory.exists()){
      imagesDirectory.create(recursive: true);
    }

    final _imagesFile = imagesDirectory.listSync(followLinks: false, recursive: true);
    _imagesFile.forEach((img) {
      String imgString = img.toString().substring(
          img.toString().lastIndexOf('/') + 1,
          img.toString().length);
        images.add(imagesDirectory.path+imgString);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    loadImages();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: images.isNotEmpty?ListView(
        physics: BouncingScrollPhysics(),
        children: [
          for(String image in images)
            Image.file(File(image.replaceAll("'", "").trim()),)
        ],
      ):Center(
        child: Text('Empty',),
      ),
    );
  }
}
