import 'dart:io';
import 'package:flutter/material.dart';

class SavingsTab extends StatelessWidget {
  const SavingsTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Directory dir = Directory('/storage/emulated/0/Download');
    final imagesDirectory = Directory(dir.path + "/LoanCalculator/SavingsCalculator/");

    List<String> images = [];
    final _imagesFile = imagesDirectory.listSync(followLinks: false, recursive: true);
    _imagesFile.forEach((img) {
      String imgString = img.toString().substring(
          img.toString().lastIndexOf('/') + 1,
          img.toString().length);
      images.add(imagesDirectory.path+imgString);
    });
    print(images);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: images != null?ListView(
        physics: BouncingScrollPhysics(),
        children: [
          for(String image in images)
            Image.file(File(image.replaceAll("'", "").trim()),)
        ],
      ):Center(
        child: Text('Empty'),
      ),
    );
  }
}
