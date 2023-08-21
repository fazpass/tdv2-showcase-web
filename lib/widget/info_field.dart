
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_web/object/meta.dart';

class InfoField extends StatelessWidget {
  const InfoField({super.key, required this.title, required this.content});

  final String title;
  final dynamic content;

  @override
  Widget build(BuildContext context) {
    switch (content.runtimeType) {
      case bool:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(title),
              ),
              Switch(
                value: content,
                onChanged: (_) {},
              ),
            ],
          ),
        );
      case String:
        return TextField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: title,
          ),
          controller: TextEditingController(text: content),
        );
      case FazpassMetaDevice:
        FazpassMetaDevice data = content;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 6),
                child: Text(title),
              ),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _Chip(title: 'Name', value: data.name),
                    _Chip(title: 'CPU', value: data.cpu),
                    _Chip(title: 'OS Version', value: data.os_version),
                    _Chip(title: 'Series', value: data.series),
                  ],
                ),
              ),
            ],
          ),
        );
      case FazpassMetaGeolocation:
        FazpassMetaGeolocation data = content;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 6),
                child: Text(title),
              ),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _Chip(title: 'Latitude', value: data.lat),
                    _Chip(title: 'Longitude', value: data.lng),
                    _Chip(title: 'Distance', value: data.distance),
                    _Chip(title: 'Time', value: data.time),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Chip(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    label: Text.rich(
      TextSpan(
        text: '$title ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}