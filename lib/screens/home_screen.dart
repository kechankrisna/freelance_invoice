import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:freelance_invoice/models/sale.dart';
import 'package:freelance_invoice/models/sale_item.dart';
import 'package:freelance_invoice/services.dart';
import 'package:freelance_invoice/template_service.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:webcontent_converter/webcontent_converter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int startRow = 6;
  io.File? _file;
  String? _excelInfo;
  List<Sale> _sales = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("home screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextFormField(
                initialValue: startRow.toString(),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  label: Text("start row to parse"),
                ),
                onChanged: (v) {
                  if (v == null || int.tryParse(v) == null) return;
                  setState(() {
                    startRow = int.tryParse(v)!;
                  });
                },
              ),
            ),
            TextButton(onPressed: pickFile, child: Text("pick a file")),
            if (_file != null) ...[
              TextButton(onPressed: parseExcel, child: Text("parse excel")),
              TextButton(onPressed: printPreview, child: Text("print preview")),
            ],
            if (_excelInfo != null) Text(_excelInfo!),
            TextButton(
                onPressed: testLoadDummyExcel, child: Text("load dummy excel"))
          ],
        ),
      ),
    );
  }

  pickFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false);
    if (pickedFile == null || pickedFile.files.isEmpty) {
      AppService.logger.d("no file was selected", time: DateTime.now());
      return;
    }
    var file = pickedFile.files.single;
    setState(() {
      _file = io.File(file.path!);
    });
  }

  parseExcel() async {
    if (_file == null) {
      AppService.logger.d("no file was selected", time: DateTime.now());
      return;
    }
    final _bytes = await _file!.readAsBytes();
    var excel = Excel.decodeBytes(_bytes);
    var excelRows = excel.sheets[excel.getDefaultSheet()]!.rows;

    final datas = excelRows.sublist(startRow);
    print(datas.length);

    ///
    var rows = <List>[];
    for (var row in datas) {
      var _singleData = [];
      if (row.isPharsable) {
        for (var e in row) {
          _singleData.add(e?.value);
        }
        rows.add(_singleData);
      }
    }

    final saleItems = rows.map((e) => SaleItem.fromRow(e)).toList();
    print(saleItems[0]);
    print(saleItems[1]);
    final sales = RawSaleItemService.groupByInvoice(saleItems);
    print("saleItems count ${saleItems.length}");
    print("invoice count ${sales.length}");
    print("last invoice count ${sales.last.invoice}");

    setState(() {
      _sales = sales;
    });

    setState(() {
      _excelInfo = """
\n invoice count ${sales.length}
\n item count ${saleItems.length}
""";
    });
  }

  printPreview() async {
    for (var sale in _sales) {
      var content = await TemplateService.generateInvoiceHtml(sale);

      // WebcontentConverter.printPreview(content: content);
      var img = await WebcontentConverter.contentToImage(content: content);
      var fileImg = io.File(
          p.join(io.Directory.current.path, "screenshots/${sale.invoice}.png"));
      await fileImg.writeAsBytes(img);
      print(fileImg.path);
    }
    // print("content $content");
  }

  testLoadDummyExcel() async {
    var dir = await getApplicationCacheDirectory();
    print("dir ${dir.path}");
    final filePath = p.join(dir.path, "/assets/dummy.xlsx");
    var content = await rootBundle.load("assets/dummy.xlsx");
    // print(content.lengthInBytes);

    // var file = io.File(filePath);
    // print(file.absolute.path);
    // var content = await file.readAsString();

    // print("content ${content != null}");
    // testReadExcel(content.buffer.asInt8List());
  }

  // testReadExcel(List<int> bytes) async {
  //   var excel = Excel.decodeBytes(bytes);
  //   var raws = excel.sheets[excel.getDefaultSheet()]!.rows;

  //   final startRow = 6;
  //   final datas = raws.sublist(6);
  //   print(datas.length);

  //   ///
  //   var rows = <List>[];
  //   for (var row in datas) {
  //     var _singleData = [];
  //     if (row.isPharsable) {
  //       for (var e in row) {
  //         _singleData.add(e?.value);
  //       }
  //       rows.add(_singleData);
  //     }
  //   }

  //   final saleItems = rows.map((e) => SaleItem.fromRow(e)).toList();
  //   print(saleItems[0]);
  //   print(saleItems[1]);
  //   final sales = RawSaleItemService.groupByInvoice(saleItems);
  //   print("saleItems count ${saleItems.length}");
  //   print("invoice count ${sales.length}");
  //   print("last invoice count ${sales.last.invoice}");
  // }
}
