/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:math';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:xplode_management/global_variables.dart';

import '../data.dart';

Future<Uint8List> generateReport(
    PdfPageFormat pageFormat, CustomData data) async {
  const tableHeaders = ['PRODUCT', 'BRAND', 'QTY'];

  // var dataTable = [
  //   [
  //     ['Phone', '80', 95],
  //     ['Internet', 250, 230],
  //     ['Electricity', 300, 375],
  //     ['Movies', 85, 80],
  //     ['Food', 300, 350],
  //     ['Fuel', 650, 550],
  //     ['Insurance', 250, 310],
  //     ['Phone', 80, 95],
  //     ['Internet', 250, 230],
  //     ['Electricity', 300, 375],
  //     ['Movies', 85, 80],
  //     ['Electricity', 300, 375],
  //     ['Movies', 85, 80],
  //     ['Movies', 85, 80],
  //   ],
  //   [
  //     ['Phone', 80, 95],
  //     ['Internet', 250, 230],
  //     ['Electricity', 300, 375],
  //   ],
  //   [
  //     ['Phone', 80, 95],
  //     ['Internet', 250, 230],
  //     ['Electricity', 300, 375],
  //   ],
  // ];
  var dataTable = productlist;

  const baseColor = PdfColors.cyan;

  // Create a PDF document.
  final document = pw.Document(
    title: 'inventory_${DateTime.now()}.pdf',
  );

  final theme = pw.ThemeData.withFont(
    base: await PdfGoogleFonts.openSansRegular(),
    bold: await PdfGoogleFonts.openSansBold(),
  );
  List datatablentity = [];
  var table = pw.TableHelper.fromTextArray(
    cellHeight: 38,
    border: null,
    headers: tableHeaders,
    data: List<List<dynamic>>.generate(
      datatablentity.length,
      (index) => <dynamic>[
        datatablentity[index][0],
        datatablentity[index][1],
        datatablentity[index][2]
      ],
    ),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontSize: 17,
      fontWeight: pw.FontWeight.bold,
    ),
    headerDecoration: const pw.BoxDecoration(
      color: baseColor,
    ),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: baseColor,
          width: .5,
        ),
      ),
    ),
    cellAlignment: pw.Alignment.centerRight,
    cellAlignments: {
      0: pw.Alignment.center,
      1: pw.Alignment.center,
      2: pw.Alignment.center,
      3: pw.Alignment.center
    },
  );
  var finalloop = dataTable.length;
  for (var i = 0; i < finalloop; i++) {
    document.addPage(
      pw.Page(
        pageFormat: pageFormat,
        theme: theme,
        build: (context) {
          const chartColors = [
            PdfColors.blue300,
            PdfColors.green300,
            PdfColors.amber300,
            PdfColors.pink300,
            PdfColors.cyan300,
            PdfColors.purple300,
            PdfColors.lime300,
          ];

          return pw.Column(children: [
            pw.Expanded(
              flex: 55,
              child: pw.Column(
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        locationlist.length == 1
                            ? pw.Text("${locationlist[0]}",
                                style: pw.TextStyle(
                                    fontSize: 16,
                                    fontWeight: pw.FontWeight.normal))
                            : pw.Text("${locationlist[i]}",
                                style: pw.TextStyle(
                                    fontSize: 16,
                                    fontWeight: pw.FontWeight.normal)),
                        pw.Text(
                            "Date :- ${selectedDate.toString().split(" ")[0].split("-")[2]}/${selectedDate.toString().split(" ")[0].split("-")[1]}/${selectedDate.toString().split(" ")[0].split("-")[0]}",
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.normal)),
                      ]),
                  pw.SizedBox(height: 10),
                  pw.TableHelper.fromTextArray(
                    cellHeight: 38,
                    border: null,
                    headers: tableHeaders,
                    data: List<List<dynamic>>.generate(
                      dataTable[i].length,
                      (index) => <dynamic>[
                        dataTable[i][index][0] ?? 0,
                        dataTable[i][index][1] ?? 0,
                        dataTable[i][index][2] ?? 0
                      ],
                    ),
                    headerStyle: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 17,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    headerDecoration: const pw.BoxDecoration(
                      color: baseColor,
                    ),
                    rowDecoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: baseColor,
                          width: .5,
                        ),
                      ),
                    ),
                    cellAlignment: pw.Alignment.centerRight,
                    cellAlignments: {
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center
                    },
                  ),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Text("Page ${i + 1} of ${finalloop}",
                  style: pw.TextStyle(
                      fontSize: 8, fontWeight: pw.FontWeight.normal)),
            )
          ]);
        },
      ),
    );
  }

  // Return the PDF file content
  return document.save();
}
