
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_web/util/color_picker.dart';

class ExpectedEntryView extends StatelessWidget {
  const ExpectedEntryView({super.key, required this.action});

  final String action;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text.rich(
                      TextSpan(
                        text: action,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        children: const [
                          TextSpan(
                            text: ' Expected',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    DateTime.now().toString(),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox.square(
                dimension: 58.0,
                child: CircularProgressIndicator(color: ColorPicker.pickColorByDataType(action)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}