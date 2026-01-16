import 'package:flutter/material.dart';
import 'package:teen_theory/Utils/helper.dart';

class CustomTextfield extends StatelessWidget {
  final bool readOnly;
  final String? headerText;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  const CustomTextfield({super.key, this.readOnly = false, this.headerText, this.controller, this.validator});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headerText != null) Text(headerText!, style: textStyle()),
        hSpace(height: 5),
        TextFormField(
          readOnly: readOnly,
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }
}
