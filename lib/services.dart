import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:excel/excel.dart';
import 'package:freelance_invoice/models/sale.dart';
import 'package:freelance_invoice/models/sale_item.dart';

class DataParsingService {
  static bool isDebug = false;

  /// ### `getDecimal`: parsing  per_page value from route
  static Object? getDecimal(Map map, String key) {
    if (map.containsKey(key)) {
      var value = map[key];

      if (value is num) {
        return value.toDouble();
      } else if (value is String) {
        if (isDebug) print("$key is String");
        return num.tryParse(value)?.toDouble();
      }
      if (isDebug) print("$key is null");
    }
    if (isDebug) print("$key is missing");
    return null;
  }

  static Object? parseDecimal(Object? value) {
    if (value == null) return null;
    if (value is num) {
      return value.toDouble();
    } else if (value is String) {
      return num.tryParse(value)?.toDouble();
    }
    return null;
  }

  /// ### `getInterger`: parsing  per_page value from route
  static Object? getInterger(Map map, String key) {
    if (map.containsKey(key)) {
      var value = map[key];
      if (value is num) {
        return value.toInt();
      } else if (value is String) {
        if (isDebug) print("$key is String");
        return num.tryParse(value)?.toInt();
      }
      if (isDebug) print("$key is null");
    }
    if (isDebug) print("$key is missing");
    return null;
  }

  static Object? parseInterger(Object? value) {
    if (value == null) return null;
    if (value is num) {
      return value.toInt();
    } else if (value is String) {
      return num.tryParse(value)?.toInt();
    }
    return null;
  }

  /// ### `getInterger`: parsing  per_page value from route
  static Object? getBoolean(Map map, String key) {
    if (map.containsKey(key)) {
      var value = map[key];
      if (value is bool) {
        return value;
      } else if (value is num) {
        return value.toInt().toBool;
      } else if (value is String) {
        if (isDebug) print("$key is String");
        return num.tryParse(value)?.toInt().toBool;
      }
      if (isDebug) print("$key is null");
    }
    if (isDebug) print("$key is missing");
    return null;
  }
}

class RawSaleItemService {
  static List<Sale> groupByInvoice(List<SaleItem> values) {
    var copies = <Sale>[];

    for (var saleItem in values) {
      final saleInvoices = copies.map((e) => e.invoice).toList();
      final existInvoice = saleInvoices.contains(saleItem.invoice);
      if (!existInvoice) {
        copies.add(saleItem.singleSale);
      } else {
        final index = saleInvoices.indexOf(saleItem.invoice);
        copies[index] = copies[index].addSaleItem(saleItem);
      }
    }

    return copies;
  }

  static FutureOr<List<List>> rowsFromFile() async {
    var result = <List<List>>[];

    return result;
  }
}

extension on SaleItem {
  Sale get singleSale => Sale(
        id: id,
        invoice: invoice,
        table: table,
        date: date,
        name: name,
        price: price,
        quantity: quantity,
        discount: discount,
        total: total,
        items: [this],
      );
}

extension on Sale {
  Sale addSaleItem(SaleItem v) {
    final _total = total! + v.total!;
    final _discount = discount! + v.discount!;
    final _quantity = quantity! + v.quantity!;
    final _price = price! + v.price!;

    final copy = copyWith(
      total: _total,
      discount: _discount,
      quantity: _quantity,
      price: _price,
      items: items..add(v),
    );

    return copy;
  }
}

extension CoreIntExtension on int {
  bool get toBool => this == 0 ? false : true;

  int random({int min = 0, int max = 99999}) {
    Random rnd = Random();
    return min + rnd.nextInt(max - min);
  }
}

extension ListExt on List<Data?> {
  bool get isPharsable =>
      isNotEmpty &&
      length >= 5 &&
      (this[0] != null &&
          this[0]?.value != null &&
          this[1] != null &&
          this[1]?.value != null &&
          this[2] != null &&
          this[2]?.value != null &&
          this[3] != null &&
          this[3]?.value != null);
}

class AppService {
  static Logger logger = Logger();

  static TimeOfDay randomTimeOfDay(TimeOfDay from, TimeOfDay to) {
    final hour = 1.random(min: from.hour, max: to.hour);
    final minute = 1.random(min: from.minute, max: to.minute);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
