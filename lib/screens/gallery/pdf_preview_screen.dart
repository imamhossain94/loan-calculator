import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/utils/constant.dart';
import 'package:loan_calculator/utils/screen_config.dart';

class PdfPreviewScreen extends StatefulWidget {
  static const String idScreen = "PdfPreviewScreen";
  @override
  _PdfPreviewScreenState createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {

  String filePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset : true,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: CalculatorAppBar(
              title: "Result PDF\nPreview",
              historyButtonClick: null,
              saveButtonClick: null,
              deleteButtonClick: null,
              shareButtonClick: () async {
                if(filePath != null) {
                  //await sendEmail('$appName Calculation Result', '');
                }
              },
            )
        ),

        body: filePath != null
            ? Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                margin: EdgeInsets.all(5),
                //padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: PDFView(
                  key: GlobalKey<ScaffoldState>(),
                  filePath: filePath, //"/sdcard/download/LoanCalculator/Loan Calculator 0013.pdf",//filePath,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: false,
                  pageFling: false,
                  onRender: (_pages) {
                  },
                  onError: (error) {
                    print(error.toString());
                  },
                  onPageError: (page, error) {
                    print('$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController pdfViewController) {

                  },
                  onPageChanged: (int page, int total) {
                    print('page change: $page/$total');
                  },
                ),
              ),
            ))
            : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.grey.withOpacity(0.8)),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Loading\nPlease Wait',
                  textAlign: TextAlign.center,
                ),
              ],
            )),
      ),
    );
  }

}

