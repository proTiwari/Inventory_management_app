import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import 'data.dart';
import 'examples.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({Key? key}) : super(key: key);

  @override
  PdfScreenState createState() {
    return PdfScreenState();
  }
}

class PdfScreenState extends State<PdfScreen>
    with SingleTickerProviderStateMixin {
  int _tab = 0;
  TabController? _tabController;

  PrintingInfo? printingInfo;

  var _data = const CustomData();
  var _hasData = false;
  var _pending = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _init() async {
    final info = await Printing.info();

    _tabController = TabController(
      vsync: this,
      length: examples.length,
      initialIndex: _tab,
    );
    _tabController!.addListener(() {
      if (_tab != _tabController!.index) {
        setState(() {
          _tab = _tabController!.index;
        });
      }
      if (examples[_tab].needsData && !_hasData && !_pending) {
        _pending = true;
        askName(context).then((value) {
          if (value != null) {
            setState(() {
              _data = CustomData(name: value);
              _hasData = true;
              _pending = false;
            });
          }
        });
      }
    });

    setState(() {
      printingInfo = info;
    });
  }

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  Future<void> _saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File(
        '$appDocPath/inventory_${DateTime.now().toString().split("")[0]}.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;

    if (_tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )
    ];

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: examples.map<Tab>((e) => Tab(text: e.name)).toList(),
          isScrollable: true,
        ),
      ),
      body: PdfPreview(
        pdfFileName:
            'Inventory_${DateTime.now().toString().split(" ")[0].split("-")[2]}/${DateTime.now().toString().split(" ")[0].split("-")[1]}/${DateTime.now().toString().split(" ")[0].split("-")[0]}.pdf',
        maxPageWidth: 700,
        build: (format) => examples[_tab].builder(format, _data),
        actions: actions,
        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
      ),
    );
  }

  Future<String?> askName(BuildContext context) {
    return showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          final controller = TextEditingController();

          return AlertDialog(
            title: const Text('Please type your name:'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            content: TextField(
              decoration: const InputDecoration(hintText: '[your name]'),
              controller: controller,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (controller.text != '') {
                    Navigator.pop(context, controller.text);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }
}
