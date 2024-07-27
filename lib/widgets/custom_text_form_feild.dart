import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextFormFeild extends StatefulWidget {
  const CustomTextFormFeild({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.width,
    this.height,
    this.textInputType,
    this.focusNode,
    this.obscureText = false,
  });
  final String label;
  final TextEditingController? controller;
  final ValueChanged? onChanged;
  final double? width;
  final double? height;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final bool obscureText;

  @override
  State<CustomTextFormFeild> createState() => _CustomTextFormFeildState();
}

class _CustomTextFormFeildState extends State<CustomTextFormFeild> {
  bool showText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: context.theme.colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              focusNode: widget.focusNode,
              keyboardType: widget.textInputType,
              controller: widget.controller,
              onChanged: widget.onChanged,
              obscureText: widget.obscureText ? showText : false,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                label: Text(
                  widget.label,
                  style: TextStyle(
                    color: context.theme.colorScheme.secondary,
                  ),
                ),
                filled: true,
                fillColor: context.theme.colorScheme.surface,
              ),
            ),
          ),
          widget.obscureText
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showText = !showText;
                    });
                  },
                  icon: showText
                      ? const Icon(Icons.lock_open_rounded)
                      : const Icon(Icons.lock_outline_rounded),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
