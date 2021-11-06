import 'dart:io';
import 'package:flutter/material.dart';

class TipTab extends StatefulWidget {
  const TipTab({Key key}) : super(key: key);

  @override
  State<TipTab> createState() => _TipTabState();
}

class _TipTabState extends State<TipTab> {

  List<String> images = [];

  @override
  void initState() {
    loadImages();
    super.initState();
  }

  void loadImages() async{
    Directory dir = Directory('/storage/emulated/0/Download');
    final imagesDirectory = Directory(dir.path + "/LoanCalculator/TipCalculator/");

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
