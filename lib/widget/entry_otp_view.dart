
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_web/object/data.dart';
import 'package:tdv2_showcase_web/object/meta.dart';

import 'otp_comparing_view.dart';

class EntryOtpView extends StatelessWidget {
  const EntryOtpView({super.key, required this.data});

  final EntryData data;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      data.type,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(data.timestamp).toString(),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.info,
                size: 76.0,
                color: Colors.blue,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: OtpComparingView(data.meta as OtpMeta),
          ),
        ],
      ),
    ),
  );
}