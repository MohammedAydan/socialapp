import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenderDropDownMenu extends StatelessWidget {
  const GenderDropDownMenu({
    super.key,
    this.value,
    required this.onChange,
  });

  final String? value;
  final ValueChanged<String?> onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: context.theme.colorScheme.surface,
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text("Select gender"),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: context.theme.colorScheme.surface,
        ),
        dropdownColor: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        items: [
          DropdownMenuItem(
            value: "male",
            child: Row(
              children: [
                Icon(Icons.male),
                const SizedBox(width: 10),
                Text("male".tr),
              ],
            ),
          ),
          DropdownMenuItem(
            value: "female",
            child: Row(
              children: [
                Icon(Icons.female),
                const SizedBox(width: 10),
                Text("female".tr),
              ],
            ),
          ),
        ],
        onChanged: onChange,
      ),
    );
  }
}
