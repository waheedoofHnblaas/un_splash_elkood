import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTextField extends StatelessWidget {
  AppTextField({
    Key? key,
    required this.type,
    required this.iconData,
    required this.inputType,
    required this.onChanged,
    required this.validator,
    this.obscureText = false,
    this.auto = true,
    this.lines = 1,
    this.onTap,
    required this.textFieldController,
    required this.submit,
  }) : super(key: key);

  late String type;
  late int lines;
  late bool obscureText;
  late bool auto;
  late IconData iconData;
  late TextInputType inputType;
  late String? Function(String?)? onChanged;
  late Future Function(dynamic v) submit;
  late String? Function(String?)? validator;
  final void Function()? onTap;
  late TextEditingController textFieldController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 2),
      decoration: BoxDecoration(
        color: context.theme.primaryColor.withOpacity(0.06),
        border: Border.all(
            color: Get.theme.primaryColor.withOpacity(0.4), width: 0),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: TextFormField(
        onFieldSubmitted: submit,
        maxLines: lines,
        autofocus: auto,
        style: TextStyle(color: context.theme.primaryColor),
        textAlign: TextAlign.center,
        controller: textFieldController,
        validator: validator,
        keyboardType: inputType,
        obscureText: obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintTextDirection: TextDirection.ltr,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Get.theme.primaryColor,
              width: 0.8,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: IconButton(
            onPressed: onTap,
            icon: Icon(
              iconData,
              color: context.theme.primaryColor,
            ),
          ),
          // label: Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Text(
          //     '',
          //     style: TextStyle(color: context.theme.primaryColor),
          //   ),
          // ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: type,
          hintStyle: TextStyle(color: context.theme.primaryColor),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              strokeAlign: 0,
              color: Colors.transparent,
              style: BorderStyle.solid,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
