import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:loan_calculator/components/calculator_app_bar.dart';
import 'package:loan_calculator/utils/constant.dart';
import 'package:loan_calculator/utils/extentsons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:loan_calculator/models/history.dart';
import 'package:loan_calculator/models/mortgage_data.dart';
import 'package:loan_calculator/models/result_data.dart';
import 'package:loan_calculator/models/row_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loan_calculator/utils/screen_config.dart';

class CalculationResultPreview extends StatefulWidget {
  static const String idScreen = "CalculationResultPreview";
  @override
  _CalculationResultPreviewState createState() => _CalculationResultPreviewState();
}

class _CalculationResultPreviewState extends State<CalculationResultPreview> {

  History history;
  MortgageData mortgageData;
  ResultData resultData;
  List<RowData> rowData;

  //Pdf Document object
  pw.Document pdf = pw.Document();
  //Generated file path
  String filePath, calculationDate;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  void initializeData() async {
    await Future.delayed(Duration(seconds: 2), () {
      Map data = ModalRoute.of(context).settings.arguments ?? {};
      history = data['data'];
      rowData = data['tableData'];
      mortgageData = history.mortgageData;
      resultData = history.resultData;
      calculationDate = history.calculationDate;
    });

    generateResultPdf();
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
                  await sendEmail('$appName Calculation Result', '');
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
                    'Generation PDF File\nPlease Wait',
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
      ),
    );
  }

  Future<void> generateResultPdf() async {
    const tableHeaders = [
      'Payment',
      'Interest',
      'Principal',
      'Balance',
    ];

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
              level: 0,
              title: 'PDF Generated by $appName',
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Text('PDF Generated by $appName',
                        textScaleFactor: 2),
                    pw.PdfLogo(),
                  ])),

          pw.Paragraph(text: 'Date: $calculationDate'),
          pw.SizedBox(height: 20),
          //Input data table
          pw.Paragraph(text: 'Input Data'),
          pw.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Input', 'Data', 'Input', 'Data'],
            <String>[
              'Home Value (\$)',
              '${mortgageData.homeValue}',
              'Money Down/Equity (${mortgageData.loanAmount == 0 ? '%' : '\$'})',
              '${mortgageData.downPayment}'
            ],
            <String>[
              'Loan Amount (\$)',
              '${mortgageData.loanAmount}',
              'Interest Rate (%)',
              '${mortgageData.interest}'
            ],
            <String>[
              'Loan Term (years)',
              '${mortgageData.loanTerm}',
              'Tax (per year)',
              '${mortgageData.propertyTax}'
            ],
            <String>[
              'Insurance (\$)',
              '${mortgageData.homeIns}',
              'PMI (%)',
              '${mortgageData.pmi}'
            ],
          ]),

          pw.SizedBox(height: 30),
          //Result data table
          pw.Paragraph(text: 'Result Data'),
          pw.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Result', 'Data', 'Result', 'Data'],
            <String>[
              'Monthly Payment (PITI)',
              '${resultData.monthlyPayment}',
              'Bi-weekly payment',
              '${resultData.biWeeklyPayment}'
            ],
            <String>[
              'Loan payoff date',
              '${resultData.lastPayment}',
              'Bi-weekly payoff date',
              '${resultData.biWeeklyLastPayment}'
            ],
            <String>[
              'Total interest',
              '${resultData.totalInterest}',
              'Bi-weekly total interest',
              '${resultData.biWeeklyTotalInterest}'
            ],
            <String>[
              'Monthly property tax',
              '${resultData.monthlyTax}',
              'Monthly insurance',
              '${resultData.monthlyIns}'
            ],
            <String>[
              'Monthly PMI',
              '${resultData.monthlyPmi}',
              'Total PMI',
              '${resultData.totalPmi}'
            ],
          ]),

          pw.SizedBox(height: 30),
          //Amortization Table
          pw.Paragraph(text: 'Amortization Table'),

          rowData.length <= 50
              ? pw.Table.fromTextArray(
                  context: context,
                  headers: List<String>.generate(
                    tableHeaders.length,
                        (col) => tableHeaders[col],
                  ),
                  data: List<List<String>>.generate(
                    rowData.length,
                    (row) => List<String>.generate(
                      tableHeaders.length,
                      (col) => rowData[row].getIndex(col),
                    ),
                  ),
                )
              : pw.Table.fromTextArray(
                  context: context,
                  headers: List<String>.generate(
                    tableHeaders.length,
                        (col) => tableHeaders[col],
                  ),
                  data: List<List<String>>.generate(
                    rowData.sublist(rowData.length ~/ 2, rowData.length).length,
                    (row) => List<String>.generate(
                      tableHeaders.length,
                      (col) => rowData
                          .sublist(rowData.length ~/ 2, rowData.length)[row]
                          .getIndex(col),
                    ),
                  ),
                ),
        ],
      ),
    );
    await savePdf();
  }

  Future<void> savePdf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int counter = (prefs.getInt('file_number') ?? 0) + 1;
    String prefix = counter.toString().length == 1
        ? '000'
        : counter.toString().length == 2
            ? '00'
            : counter.toString().length == 3
                ? '0'
                : '';


    String path = await createPath();


    File file = File('$path/LoanCalculator_$prefix$counter.pdf');
    await file.writeAsBytes(await pdf.save());
    await prefs.setInt('file_number', counter);

    setState(() {
      filePath = '$path/LoanCalculator_$prefix$counter.pdf';
    });
  }




  Future<void> sendEmail(String subject, String body) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: ['example@gmail.com'],
      attachmentPaths: [filePath],
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print(error);
    }
    //if (!mounted) return;
  }
}

