
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_web/object/meta.dart';

class OtpItem {
  OtpItem(this.title, this.value);

  final String title;
  final int value;
  bool isBest = false;
}

class OtpComparingField extends StatelessWidget {
  const OtpComparingField._(this.items);

  factory OtpComparingField(OtpMeta meta) {
    final items = <OtpItem>[
      OtpItem('WA', meta.WA),
      OtpItem('Citcall SMS', meta.citcallSMS),
      OtpItem('IMS', meta.IMS),
    ];
    var bestItem = items[0];
    for (var item in items) {
      if (bestItem.value < item.value) {
        bestItem = item;
      }
    }
    bestItem.isBest = true;

    return OtpComparingField._(items);
  }

  final List<OtpItem> items;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(30),
      },
      border: const TableBorder(horizontalInside: BorderSide(color: Colors.transparent, width: 5)),
      children: [
        for (var item in items) TableRow(
          children: [
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: item.value/100,
                  minHeight: 8,
                  color: item.isBest ? Colors.green : Colors.red,
                ),
              ),
            ),
            Text(
              item.value.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}