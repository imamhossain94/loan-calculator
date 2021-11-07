import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loan_calculator/utils/extensions.dart';

class TaxTab extends StatefulWidget {
  const TaxTab({Key key}) : super(key: key);

  @override
  State<TaxTab> createState() => _TaxTabState();
}

class _TaxTabState extends State<TaxTab> {

  List<String> images = [];

  @override
  void initState() {
    loadImages();
    super.initState();
  }

  void loadImages() async{

    String path = await createPath('/TaxCalculator/');
    final imagesDirectory = Directory(path);

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
