import 'dart:async';

import 'package:freelance_invoice/models/sale.dart';
import 'package:freelance_invoice/models/sale_item.dart';
import 'package:intl/intl.dart';

class TemplateService {
  static FutureOr<String> generateInvoiceHtml(Sale sale) async {
    var tdItem = """""";
    for (var saleItem in sale.items) {
      tdItem += """<tr>
                        <td align="left" valign="top">${saleItem.name}</td>
                        <td align="center" valign="top">${saleItem.quantity!.toStringAsFixed(2)}</td>
                        <td align="center" valign="top">\$ ${saleItem.price!.toStringAsFixed(2)}</td>
                        <td align="right" valign="top">% ${saleItem.discount!.toStringAsFixed(2)}</td>
                        <td align="right" valign="top">\$ ${saleItem.total!.toStringAsFixed(2)}</td>
                    </tr>""";
    }

    return """
<!DOCTYPE html>
<html lang="{{ lang | default:" en" }}">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<style type="text/css">
    @import url('https://fonts.googleapis.com/css2?family=Noto+Sans&family=Noto+Serif+Khmer:wght@100;200;300;500&display=swap');
    body,
    p {
        margin: 0px;
        padding: 0px;
        font-family: 'Noto Serif Khmer', 'Noto Sans', sans-serif !important;
    }

    .list,
    ol,
    ul,
    p,
    tr,
    td {
        break-inside: avoid;
    }

    body {
        margin: 0px;
        padding: 0px;
        font-family: 'Noto Serif Khmer', 'Noto Sans', sans-serif;
        font-weight: 600;
        font-size: 25px;
        line-height: 25px;
        width: 576px;
    }

    .receipt {
        max-width: 572px;
        /* margin: 24px auto;*/
        max-width: 576px;
        margin: auto;
        background: white;
    }

    .container {
        padding: 5px 15px;
    }

    .hr {
        border-bottom: dashed 2px black;
        margin: 8px 0 12px;
    }

    .text-center {
        text-align: center;
    }

    .text-left {
        text-align: left;
    }

    .text-right {
        text-align: left;
    }

    .text-justify {
        text-align: justify;
    }

    .right {
        float: right;
    }

    .left {
        float: left;
    }

    .store_name {
        font-size: 1.3em;
        margin: 5px;
    }

    .ticket_name {
        font-size: 1.8em;
        margin: 5px;
    }

    .dine_name {
        font-size: 1.5em;
        margin: 5px;
    }

    .logo {
        width: 125px;
        height: 125px;
    }

    .total {
        font-size: 1.5em;
        margin: 5px;
    }

    .sub_total {
        font-size: 1.3em;
        margin: 5px;
    }

    a {
        color: #1976d2;
    }

    span,
    {
    color: black;
    font-size: 23px;
    line-height: 27px;
    font-weight: 500;
    }

    .composite {
        padding-left: 5px;
    }

    .full-width {
        width: 100%;
    }

    .inline-block {
        display: inline-block;
    }

    .item-block {
        padding-top: 12px;
    }

    .item-block .left {
        max-width: 75%;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }

    .item-block .right {
        max-width: 25%;
    }

    .qrcode {
        width: 200px;
        height: 200px;
    }

    .flex {
        display: flex;
    }

    .col-1 {
        flex: 1;
    }

    .col-2 {
        flex: 2;
    }

    .col-3 {
        flex: 3;
    }

    .col-4 {
        flex: 4;
    }

    .col-5 {
        flex: 5;
    }

    .col-6 {
        flex: 6;
    }

    .col-7 {
        flex: 7;
    }

    .col-8 {
        flex: 8;
    }

    .col-9 {
        flex: 9;
    }

    .col-10 {
        flex: 10;
    }

    .col-11 {
        flex: 11;
    }

    .col-12 {
        flex: 12;
    }

    /* @media print {
        html,
        body {
            width: 80mm;
            position: absolute;
        }
    } */
    *,
    html,
    p {
        padding: 0;
        margin: 0;
        font-family: 'Noto Serif Khmer', 'Noto Sans', sans-serif !important;
    }

    span {
        color: black;
        font-size: 23px;
        line-height: 27px;
        font-weight: 500;
    }

    p {
        color: black;
        font-size: 23px;
        line-height: 35px;
        font-weight: 500;
    }

    .right {
        text-align: right;
    }

    .flex {
        display: flex;
    }

    .col-1 {
        flex: 1;
    }

    .col-2 {
        flex: 2;
    }

    .col-3 {
        flex: 3;
    }

    .col-4 {
        flex: 4;
    }

    .col-5 {
        flex: 5;
    }

    .col-6 {
        flex: 6;
    }

    .col-7 {
        flex: 7;
    }

    .col-8 {
        flex: 8;
    }

    .col-9 {
        flex: 9;
    }

    .col-10 {
        flex: 10;
    }

    .col-11 {
        flex: 11;
    }

    .col-12 {
        flex: 12;
    }

    thead {
        background: black;
        color: white;
    }
</style>

<body>
    <div class="receipt">
        <div class="container">
            <!-- header part -->
            <div class="text-center">
                <p class="store_name">កេសរកូល ខារ៉ាអូខា</p>
                <p class="store_name"><u>Invoice</u></p>
            </div>
            <!-- end header part -->

            <div class="full-width flex">
                <div class="left col-6">
                    <p>Bill-${sale.invoice}</p>
                    <p>Room: ${sale.table}</p>
                    <p>Cashier: 1111 1111</p>
                </div>
                <div class="right col-6">
                    <p>Date: ${sale.date}</p>
                    <p>Payment: </p>
                    <p>Customer: General</p>
                </div>
            </div>


            <p class="hr">

            <table align="center" width="100%" cellpadding="0" cellspacing="0" role="presentation">
                <thead>
                    <tr>
                        <td align="left" style="width:40%;"> Name </td>
                        <td align="center" style="width:15%;"> Qty </td>
                        <td align="center" style="width:15%;"> Pri </td>
                        <td align="right" style="width:15%;"> Dis </td>
                        <td align="right" style="width:15%;"> Total </td>
                    </tr>
                </thead>
                <!-- product part -->
                <tbody>
                    
                    $tdItem

                </tbody>
                <!-- end product part -->
            </table>

            <p class="hr"></p>

            <!-- footer part -->

            <div class="flex">
                <p class="col-9" colspan="10" align="right"> Total: </p>
                <p class="col-4" colspan="1" align="right">\$ ${sale.total!.toStringAsFixed(2)} </p>
            </div>
            
            <!-- end footer part -->
        </div>

        <div class="container text-center">
            Thank You
        </div>

        <div style="height:20px;"></div>
    </div>
</body>

</html>
""";
  }
}
