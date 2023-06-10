import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import 'data.dart';
import 'examples/calendar.dart';
import 'examples/certificate.dart';
import 'examples/document.dart';
import 'examples/invoice.dart';
import 'examples/report.dart';
import 'examples/resume.dart';

var examples = <Example>[
  // Example('RÉSUMÉ', 'resume.dart', generateResume),
  // Example('DOCUMENT', 'document.dart', generateDocument),
  // Example('INVOICE', 'invoice.dart', generateInvoice),
  Example('REPORT', 'Inventory_${DateTime.now()}.dart', generateReport),
  // Example('CALENDAR', 'calendar.dart', generateCalendar),
  // Example('CERTIFICATE', 'certificate.dart', generateCertificate, true),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, CustomData data);

class Example {
  Example(this.name, this.file, this.builder, [this.needsData = true]);

  String name;

  String? file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
