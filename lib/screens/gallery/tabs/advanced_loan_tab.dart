import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loan_calculator/utils/extensions.dart';

import '../pdf_preview_screen.dart';

class AdvancedLoanTab extends StatefulWidget {
  const AdvancedLoanTab({Key key}) : super(key: key);

  @override
  State<AdvancedLoanTab> createState() => _AdvancedLoanTabState();
}

class _AdvancedLoanTabState extends State<AdvancedLoanTab> {
  List<Map<String,dynamic>> files = [];


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadPdfs();
    });
    super.initState();
  }

  void loadPdfs() async{
    String path = await createPath('/AdvancedLoan/');
    final fileDirectory = Directory(path);

    final _pdfFile = fileDirectory.listSync();

    _pdfFile.forEach((img) async{
      String imgString = img.toString().substring(
          img.toString().lastIndexOf('/') + 1,
          img.toString().length);
        File file = File((fileDirectory.path+imgString).replaceAll("'", "").trim());
        file.length();
        files.add({
          '0':(fileDirectory.path+imgString).replaceAll("'", "").trim(),
          '1': await getFileSize((fileDirectory.path+imgString).replaceAll("'", "").trim(), 1)
        });
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: files.isNotEmpty?ListView(
        physics: BouncingScrollPhysics(),
        children: [
          for(Map file in files)
            pdfCard(file)
        ],
      ):Center(
        child: Text('Empty'),
      ),
    );
  }


  Widget pdfCard(Map file){
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, PdfPreviewScreen.idScreen, arguments: {
              'filePath': file['0'].toString()
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 60,
                margin: EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  FontAwesomeIcons.solidFilePdf,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        file['0'].toString().substring(
                            file['0'].toString().lastIndexOf('/') + 1,
                            file['0'].toString().length),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      file['1'].toString(),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }



}
