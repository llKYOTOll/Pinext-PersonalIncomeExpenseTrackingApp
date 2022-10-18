import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/theme_data/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintTitle;
  final TextEditingController controller;
  final bool isPassword;
  int numberOfLines;
  TextInputType textInputType;

  CustomTextFormField(
      {Key? key,
      required this.controller,
      required this.hintTitle,
      this.numberOfLines = 1,
      this.isPassword = false,
      this.textInputType = TextInputType.text,
      required this.onChanged,
      required this.validator,
      this.showClearSuffix = false,
      this.textInputAction = TextInputAction.next})
      : super(key: key);

  Function onChanged;
  Function validator;
  bool showClearSuffix;

  TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: regularTextStyle,
      maxLines: numberOfLines,
      keyboardType: textInputType,
      validator: (value) {
        return validator(value);
      },
      textInputAction: textInputAction,
      onChanged: ((value) {
        onChanged(value);
      }),
      decoration: InputDecoration(
        suffixIcon: showClearSuffix
            ? GestureDetector(
                onTap: () {
                  controller.clear();
                },
                child: Icon(
                  Icons.clear,
                  color: customBlackColor.withOpacity(.6),
                  size: 16,
                ),
              )
            : const SizedBox.shrink(),
        hintText: hintTitle,
        hintStyle: regularTextStyle.copyWith(
          color: customBlackColor.withOpacity(
            .5,
          ),
        ),
        errorStyle: regularTextStyle.copyWith(
          color: Colors.red,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderSide: Divider.createBorderSide(
            context,
            color: cyanColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: Divider.createBorderSide(
            context,
            color: customBlueColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: Divider.createBorderSide(
            context,
            color: customBlackColor.withOpacity(.1),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
        ),
        fillColor: greyColor,
        filled: true,
      ),
      obscureText: isPassword,
      obscuringCharacter: "*",
    );
  }
}
