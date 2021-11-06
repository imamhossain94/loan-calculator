import 'package:flutter/material.dart';

class SimpleLoanTab extends StatelessWidget {
  const SimpleLoanTab({Key key}) : super(key: key);



  void loadImages() async{
    final dir = await getApplicationDocumentsDirectory();
    final imagesDirectory = Directory(dir.path + "/images/pets/");

    List<String> images = [];
    final _imagesFile = imagesDirectory.listSync(followLinks: false, recursive: true);
    _imagesFile.forEach((img) {
      String imgString = img.toString().substring(
          img.toString().lastIndexOf('/') + 1,
          img.toString().length);
      images.add(imgString);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
