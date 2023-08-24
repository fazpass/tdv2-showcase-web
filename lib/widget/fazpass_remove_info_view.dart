
import 'package:flutter/cupertino.dart';
import 'package:tdv2_showcase_web/object/meta.dart';

import 'info_field.dart';

class FazpassRemoveInfoView extends StatelessWidget {
  const FazpassRemoveInfoView(this.meta, {super.key});

  final FazpassRemoveMeta meta;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      InfoField(title: 'Platform', content: meta.platform),
      InfoField(title: 'Application', content: meta.application),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InfoField(title: 'Fazpass ID', content: meta.fazpass_id),
      ),
      InfoField(title: 'Is Active', content: meta.is_active),
      InfoField(title: 'Device Information', content: meta.device_id),
      InfoField(title: 'Geolocation', content: meta.geolocation),
    ],
  );
}