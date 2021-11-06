import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SimpleLoanTab extends StatelessWidget {
  const SimpleLoanTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Directory dir = Directory('/storage/emulated/0/Download');
    final imagesDirectory = Directory(dir.path + "/LoanCalculator/SimpleLoan/");

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
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          for(String x in images)
            Image.file(File(x.replaceAll("'", "").trim()),)
        ],
      ),
    );
  }
}
