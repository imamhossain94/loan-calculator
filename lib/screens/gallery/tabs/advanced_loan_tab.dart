import 'dart:io';
import 'package:flutter/material.dart';

class AdvancedLoanTab extends StatefulWidget {
  const AdvancedLoanTab({Key key}) : super(key: key);

  @override
  State<AdvancedLoanTab> createState() => _AdvancedLoanTabState();
}

class _AdvancedLoanTabState extends State<AdvancedLoanTab> {
  List<String> images = [];


  @override
  void initState() {
    loadImages();
    super.initState();
  }


  void loadImages() async{
    Directory dir = Directory('/storage/emulated/0/Download');
    final imagesDirectory = Directory(dir.path + "/LoanCalculator/AdvancedLoan/");

    if(!await imagesDirectory.exists()){
      imagesDirectory.create(recursive: true);
    }

    print(imagesDirectory);


    final _imagesFile = imagesDirectory.listSync();
    print(_imagesFile);
    _imagesFile.forEach((img) {
      String imgString = img.toString().substring(
          img.toString().lastIndexOf('/') + 1,
          img.toString().length);
        // File file = File((imagesDirectory.path+imgString).replaceAll("'", "").trim());
        // file.length();
        // print(file.length());
        images.add(imagesDirectory.path+imgString);

    });
    print(images);
    //setState(() {});
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
            Text(image)
            // Image.file(File(image.replaceAll("'", "").trim()),)
        ],
      ):Center(
        child: Text('Empty'),
      ),
    );
  }
}
