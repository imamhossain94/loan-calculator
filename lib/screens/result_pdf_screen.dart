import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:loan_calculator/models/history.dart';
import 'package:loan_calculator/models/mortgage_data.dart';
import 'package:loan_calculator/models/result_data.dart';
import 'package:loan_calculator/models/row_data.dart';
import 'package:loan_calculator/ui/widgets.dart';
import 'package:loan_calculator/utils/constant.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Renders the calculation as a PDF and previews it.
///
/// The PDF is never written to shared storage: [PdfPreview] renders it from
/// bytes held in memory and its share/print actions hand those bytes straight
/// to the system. No storage permission is involved, which is what Google
/// Play's Personal Loans policy requires.
class ResultPdfScreen extends StatefulWidget {
  static const String route = '/result-pdf';
  const ResultPdfScreen({super.key});

  @override
  State<ResultPdfScreen> createState() => _ResultPdfScreenState();
}

class _ResultPdfScreenState extends State<ResultPdfScreen> {
  History? _history;
  List<RowData> _schedule = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_history != null) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _history = args['history'] as History?;
      _schedule = (args['schedule'] as List<RowData>?) ?? const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = _history;
    return Scaffold(
      appBar: AppBar(title: const Text('PDF')),
      body: history == null
          ? const EmptyState(
              icon: Icons.picture_as_pdf_outlined,
              title: 'Nothing to export',
            )
          : PdfPreview(
              build: (format) => _build(format, history),
              pdfFileName: 'loan-calculation.pdf',
              allowPrinting: true,
              allowSharing: true,
              canChangePageFormat: false,
              canChangeOrientation: false,
              canDebug: false,
              shareActionExtraSubject: '$appName calculation',
              loadingWidget: const Center(child: CircularProgressIndicator()),
            ),
    );
  }

  Future<Uint8List> _build(PdfPageFormat format, History history) async {
    final MortgageData? m = history.mortgageData;
    final ResultData? r = history.resultData;
    final pdf = pw.Document();

    const headers = ['Period', 'Interest', 'Principal', 'Balance'];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(appName,
                    style: pw.TextStyle(
                        fontSize: 22, fontWeight: pw.FontWeight.bold)),
                pw.Text(history.calculationDate ?? '',
                    style: const pw.TextStyle(fontSize: 11)),
              ],
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Text('Loan details',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            context: context,
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerStyle: pw.TextStyle(
                fontSize: 10, fontWeight: pw.FontWeight.bold),
            data: <List<String>>[
              ['Field', 'Value', 'Field', 'Value'],
              [
                'Home value',
                '${m?.homeValue ?? 0}',
                'Money down',
                '${m?.downPayment ?? 0}',
              ],
              [
                'Loan amount',
                '${m?.loanAmount ?? 0}',
                'Interest rate',
                '${m?.interest ?? 0}%',
              ],
              [
                'Term (months)',
                '${m?.loanTerm ?? 0}',
                'Property tax / yr',
                '${m?.propertyTax ?? 0}',
              ],
              [
                'Insurance / yr',
                '${m?.homeIns ?? 0}',
                'PMI rate',
                '${m?.pmi ?? 0}%',
              ],
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text('Results',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            context: context,
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerStyle: pw.TextStyle(
                fontSize: 10, fontWeight: pw.FontWeight.bold),
            data: <List<String>>[
              ['Result', 'Value', 'Result', 'Value'],
              [
                'Monthly payment',
                r?.monthlyPayment ?? '-',
                'Bi-weekly payment',
                r?.biWeeklyPayment ?? '-',
              ],
              [
                'Payoff date',
                r?.lastPayment ?? '-',
                'Bi-weekly payoff',
                r?.biWeeklyLastPayment ?? '-',
              ],
              [
                'Total interest',
                r?.totalInterest ?? '-',
                'Bi-weekly interest',
                r?.biWeeklyTotalInterest ?? '-',
              ],
              [
                'Monthly tax',
                r?.monthlyTax ?? '-',
                'Monthly insurance',
                r?.monthlyIns ?? '-',
              ],
              [
                'Monthly PMI',
                r?.monthlyPmi ?? '-',
                'Total PMI',
                r?.totalPmi ?? '-',
              ],
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text('Amortization schedule',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            context: context,
            headers: headers,
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerStyle:
                pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            data: List<List<String>>.generate(
              _schedule.length,
              (row) => List<String>.generate(
                headers.length,
                (col) => _schedule[row].getIndex(col),
              ),
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Estimates only. Generated by $appName.',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );

    return pdf.save();
  }
}
