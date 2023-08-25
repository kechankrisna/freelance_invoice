// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:freelance_invoice/services.dart';

class SaleItem {
  final String? id;
  final String? invoice;
  final String? table;
  final String? date;
  final String? name;
  final double? price;
  final double? quantity;
  final double? discount;
  final double? total;
  SaleItem({
    this.id,
    this.invoice,
    this.table,
    this.date,
    this.name,
    this.price,
    this.quantity,
    this.discount,
    this.total,
  });

  SaleItem copyWith({
    String? id,
    String? invoice,
    String? table,
    String? date,
    String? name,
    double? price,
    double? quantity,
    double? discount,
    double? total,
  }) {
    return SaleItem(
      id: id ?? this.id,
      invoice: invoice ?? this.invoice,
      table: table ?? this.table,
      date: date ?? this.date,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'invoice': invoice,
      'table': table,
      'date': date,
      'name': name,
      'price': price,
      'quantity': quantity,
      'discount': discount,
      'total': total,
    };
  }

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      id: map['id'] != null ? map['id'] as String : null,
      invoice: map['invoice'] != null ? map['invoice'] as String : null,
      table: map['table'] != null ? map['table'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: DataParsingService.getDecimal(map, "price") as double? ?? 0,
      quantity: DataParsingService.getDecimal(map, "quantity") as double? ?? 0,
      discount: DataParsingService.getDecimal(map, "discount") as double? ?? 0,
      total: DataParsingService.getDecimal(map, "total") as double? ?? 0,
    );
  }

  /// from excel row
  /// columns: id, invoice, table, date, name, quantity, discount, price, total
  factory SaleItem.fromRow(List row) {
    return SaleItem(
      id: "${row[0]}",
      invoice: "${row[1]}",
      table: "${row[2]}",
      date: "${row[3]}",
      name: "${row[4]}",
      quantity: DataParsingService.parseDecimal(row[5]) as double? ?? 0,
      discount: DataParsingService.parseDecimal(row[6]) as double? ?? 0,
      price: DataParsingService.parseDecimal(row[7]) as double? ?? 0,
      total: DataParsingService.parseDecimal(row[8]) as double? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SaleItem.fromJson(String source) =>
      SaleItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SaleItem(id: $id, invoice: $invoice, table: $table, date: $date, name: $name, price: $price, quantity: $quantity, discount: $discount, total: $total)';
  }

  @override
  bool operator ==(covariant SaleItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.invoice == invoice &&
        other.table == table &&
        other.date == date &&
        other.name == name &&
        other.price == price &&
        other.quantity == quantity &&
        other.discount == discount &&
        other.total == total;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        invoice.hashCode ^
        table.hashCode ^
        date.hashCode ^
        name.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        discount.hashCode ^
        total.hashCode;
  }
}
