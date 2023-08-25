import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:freelance_invoice/models/sale_item.dart';
import 'package:freelance_invoice/services.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            TextButton(
                onPressed: testLoadDummyExcel, child: Text("load dummy excel"))
          ],
        ),
      ),
    );
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
    testReadExcel(content.buffer.asInt8List());
  }

  testReadExcel(List<int> bytes) async {
    var excel = Excel.decodeBytes(bytes);
    var raws = excel.sheets[excel.getDefaultSheet()]!.rows;

    final startRow = 6;
    final datas = raws.sublist(6);
    print(datas.length);

    ///
    var rows = <List>[];
    for (var row in datas) {
      var _singleData = [];
      for (var e in row) {
        _singleData.add(e?.value);
      }
      if (_singleData.isPharsable) {
        rows.add(_singleData);
      }
    }

    final saleItems = rows.map((e) => SaleItem.fromRow(e)).toList();
    print(saleItems[0]);
    print(saleItems[1]);
    final sales = RawSaleItemService.groupByInvoice(saleItems);
    print("saleItems count ${saleItems.length}");
    print("invoice count ${sales.length}");
  }
}
