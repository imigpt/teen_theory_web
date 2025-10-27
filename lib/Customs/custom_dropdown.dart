import 'package:flutter/material.dart';
import 'package:teen_theory/Utils/helper.dart';

class CustomDropdown extends StatelessWidget {
  final String? headerText;
  final String? initialValue;
  final List<DropdownMenuItem<String>>? items;
  final void Function(String? value)? onChanged;
  const CustomDropdown({
    super.key,
    this.headerText,
    this.initialValue,
    this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headerText != null) Text(headerText!, style: textStyle()),
        hSpace(height: 5),
        DropdownButtonFormField(
          value: initialValue,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
