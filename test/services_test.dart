import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freelance_invoice/dummy/dummy_data.dart';

import 'package:freelance_invoice/models/sale_item.dart';
import 'package:freelance_invoice/services.dart';

void main() {
  test("dummmy data columns", () {
    var correct = DummyData.raw.every((e) => e.length == 9);
    expect(correct, true, reason: "every row should be in 9 colums");

    for (var e in DummyData.raw) {
      if (e.length != 9) {
        print(e);
      }
    }
  });

  test("parsing sale_items", () {
    final saleItem = SaleItem.fromMap(DummyData.singleItem);

    expect(saleItem.date, "1/10/2022");
    expect(saleItem.name, "Softdrink");
    expect(saleItem.quantity, 10);
    expect(saleItem.discount, 0);
    expect(saleItem.price, 0.95);
    expect(saleItem.total, 9.5);
  });

  test("parsing sale_items", () {
    final row = DummyData.raw[0];
    final saleItem = SaleItem.fromRow(row);

    expect(saleItem.date, "1/10/2022");
    expect(saleItem.quantity, 10);
    expect(saleItem.discount, 0);
    expect(saleItem.price, 0.95);
    expect(saleItem.total, 9.5);
  });

  test("test raw sale_items to sale", () {
    final saleItems =
        DummyData.raw.map((row) => SaleItem.fromRow(row)).toList();
    var sales = RawSaleItemService.groupByInvoice(saleItems);
    final singleSale = sales.first;
    expect(singleSale.invoice, SaleItem.fromRow(DummyData.raw[0]).invoice,
        reason: "invoice number should be correct");
    expect(singleSale.quantity, 12, reason: "quantity of first invoice");
    expect(singleSale.items.length, 3, reason: "items length");

    expect(sales[1].invoice, SaleItem.fromRow(DummyData.raw[4]).invoice,
        reason: "invoice number should be correct");
    expect(sales[1].quantity, 17, reason: "quantity of first invoice");
    expect(sales[1].items.length, 3, reason: "items length");

    expect(sales[0].invoice, SaleItem.fromRow(DummyData.raw[4]).invoice,
        reason: "invoice number should be correct");
    expect(sales[0].quantity, 17, reason: "quantity of first invoice");
    expect(sales[0].items.length, 3, reason: "items length");
  });

  test("random time of day", () {
    var timeOfDay = AppService.randomTimeOfDay(
        TimeOfDay(hour: 1, minute: 0), TimeOfDay(hour: 12, minute: 60));

    // print(timeOfDay);
    // var d = DateTime.parse("16-10-2022".replaceAll("-", "/"));
    var raw = "2022-12-10T00:00:00.000";
    var result = raw.contains("/")
        ? raw.replaceAll("-", "/").split("/").reversed.join("-")
        : raw;
    // var d = "31/10/2022".replaceAll("-", "/").split("/").reversed.join("-");

    // print("d $d");
    print("result ${DateTime.tryParse(result)}");
  });
}
