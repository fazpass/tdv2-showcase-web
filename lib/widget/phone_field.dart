
import 'package:flutter/material.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({super.key, required this.onChangePhone});
  
  final Function(String?) onChangePhone;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {

  final controller = TextEditingController();
  bool locked = false;

  lock() {
    setState(() {
      locked = !locked;
    });

    widget.onChangePhone(locked ? controller.text : null);
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: locked,
              style: const TextStyle(
                fontSize: 16.0,
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    width: 0.0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                prefixIcon: const Icon(Icons.phone_android),
                hintText: 'Enter Phone Number',
              ),
            ),
          ),
          IconButton(
            onPressed: lock,
            icon: Icon(locked ? Icons.lock : Icons.lock_open),
          ),
        ],
      ),
    );
  }
}

