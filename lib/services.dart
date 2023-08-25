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
}
