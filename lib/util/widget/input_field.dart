import 'package:flutter/material.dart';

Widget buildTextInputField(
    TextEditingController controller, String label, Function setState) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.name,
    decoration: InputDecoration(
      labelText: label,
      hintText: 'Please provide a ${label.toLowerCase()}',
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1000))),
    ),
    autovalidateMode: AutovalidateMode.always,
    validator: (String? value) {
      return (value == null || value.isEmpty)
          ? '$label must be provided'
          : null;
    },
    onChanged: (text) => setState(() {}),
  );
}

Widget buildNumberInputField(
    TextEditingController controller, String label, Function setState) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      hintText: 'Please provide a ${label.toLowerCase()}',
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1000))),
    ),
    autovalidateMode: AutovalidateMode.always,
    validator: (String? value) {
      return (value == null || value.isEmpty)
          ? '$label must be provided'
          : double.tryParse(value) == null
              ? '$label must be a number'
              : null;
    },
    onChanged: (text) => setState(() {}),
  );
}
