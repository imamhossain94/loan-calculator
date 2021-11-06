import 'dart:io';
import 'package:flutter/material.dart';

class TaxTab extends StatefulWidget {
  const TaxTab({Key key}) : super(key: key);

  @override
  State<TaxTab> createState() => _TaxTabState();
}

class _TaxTabState extends State<TaxTab> {

  List<String> images = [];

  void loadImages() async{
    Directory dir = Directory('/storage/emulated/0/Download');
    final imagesDirectory = Directory(dir.path + "/LoanCalculator/TaxCalculator/");

    if(!await imagesDirectory.exists()){
      imagesDirectory.create(recursive: true);
    }

    final _imagesFile = imagesDirectory.listSync(followLinks: false, recursive: true);
    _imagesFile.forEach((img) {
      String imgString = img.toString().substring(
          img.toString().lastIndexOf('/') + 1,
          img.toString().length);
      setState(() {
        images.add(imagesDirectory.path+imgString);
      });
    });

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
