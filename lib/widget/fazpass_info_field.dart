
import 'package:flutter/cupertino.dart';
import 'package:tdv2_showcase_web/object/meta.dart';

import 'info_field.dart';

class FazpassInfoField extends StatelessWidget {
  const FazpassInfoField(this.meta, {super.key});

  final FazpassMeta meta;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      InfoField(title: 'Platform', content: meta.platform),
      InfoField(title: 'Application', content: meta.application),
      InfoField(title: 'Client IP', content: meta.client_ip),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InfoField(title: 'Fazpass ID', content: meta.fazpass_id),
      ),
      InfoField(title: 'Is Active', content: meta.is_active),
      InfoField(title: 'Is App Tempering', content: meta.is_app_tempering),
      InfoField(title: 'Is Clone App', content: meta.is_clone_app),
      InfoField(title: 'Is Debug', content: meta.is_debug),
      InfoField(title: 'Is Emulator', content: meta.is_emulator),
      InfoField(title: 'Is Gps Spoof', content: meta.is_gps_spoof),
      InfoField(title: 'Is Rooted', content: meta.is_rooted),
      InfoField(title: 'Is Screen Sharing', content: meta.is_screen_sharing),
      InfoField(title: 'Is Vpn', content: meta.is_vpn),
      InfoField(title: 'Device Information', content: meta.device_id),
      InfoField(title: 'Geolocation', content: meta.geolocation),
    ],
  );
}