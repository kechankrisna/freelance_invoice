// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'sale_item.dart';

class Sale {
  final String? id;
  final String? invoice;
  final String? table;
  final String? date;
  final String? name;
  final double? price;
  final double? quantity;
  final double? discount;
  final double? total;
  final List<SaleItem> items;
  Sale({
    this.id,
    this.invoice,
    this.table,
    this.date,
    this.name,
    this.price,
    this.quantity,
    this.discount,
    this.total,
    required this.items,
  });
  

  Sale copyWith({
    String? id,
    String? invoice,
    String? table,
    String? date,
    String? name,
    double? price,
    double? quantity,
    double? discount,
    double? total,
    List<SaleItem>? items,
  }) {
    return Sale(
      id: id ?? this.id,
      invoice: invoice ?? this.invoice,
      table: table ?? this.table,
      date: date ?? this.date,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      items: items ?? this.items,
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
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'] != null ? map['id'] as String : null,
      invoice: map['invoice'] != null ? map['invoice'] as String : null,
      table: map['table'] != null ? map['table'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as double : null,
      quantity: map['quantity'] != null ? map['quantity'] as double : null,
      discount: map['discount'] != null ? map['discount'] as double : null,
      total: map['total'] != null ? map['total'] as double : null,
      items: List<SaleItem>.from((map['items'] as List<int>).map<SaleItem>((x) => SaleItem.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Sale.fromJson(String source) => Sale.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Sale(id: $id, invoice: $invoice, table: $table, date: $date, name: $name, price: $price, quantity: $quantity, discount: $discount, total: $total, items: $items)';
  }

  @override
  bool operator ==(covariant Sale other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.invoice == invoice &&
      other.table == table &&
      other.date == date &&
      other.name == name &&
      other.price == price &&
      other.quantity == quantity &&
      other.discount == discount &&
      other.total == total &&
      listEquals(other.items, items);
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
      total.hashCode ^
      items.hashCode;
  }
}
