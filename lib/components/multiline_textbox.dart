import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

// ignore: must_be_immutable
class InputTextFieldMaxlines extends StatefulWidget {
  final String hintText;
  int maxlength;
  int maxLines;
  var textLength = 0;
  var onTap;

  var validation;
  bool readOnly;
  final TextEditingController? textEditingController;
  final String counterText;
  InputTextFieldMaxlines({
    super.key,
    this.validation,
    this.textLength = 0,
    this.readOnly = false,
    required this.hintText,
    this.onTap,
    required this.maxlength,
    required this.maxLines,
    required this.counterText,
    this.textEditingController,
  });

  @override
  State<InputTextFieldMaxlines> createState() => _InputTextFieldMaxlinesState();
}

class _InputTextFieldMaxlinesState extends State<InputTextFieldMaxlines> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLines: null,
        minLines: widget.maxLines,
        validator: widget.validation,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        maxLength: widget.maxlength,
        controller: widget.textEditingController,
        cursorColor: AppTheme.primaryColor,
        keyboardType: TextInputType.multiline,
        onChanged: (value) {
          setState(() {
            widget.textLength = value.length;
          });
        },
        decoration: InputDecoration(
          counterText:
              '',
          counterStyle: GoogleFonts.openSans(
              color: AppTheme.whiteColor, fontSize: 12),
         hintStyle: GoogleFonts.openSans(color:Colors.white70, fontSize: 13),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(225, 30, 61, 1),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: const BorderSide(
          //     color: Color.fromRGBO(240, 247, 253, 1),
          //     width: 1,
          //   ),
          //   borderRadius: BorderRadius.circular(8),
          // ),
          isDense: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
             color: Color.fromRGBO(240, 247, 253, 1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
              color: Color.fromRGBO(240, 247, 253, 1),
                width: 1,
              )),
         
          contentPadding: const EdgeInsetsDirectional.fromSTEB(15, 15, 10, 15),
          hintText: widget.hintText,
          floatingLabelStyle:
              const TextStyle(color: Color.fromRGBO(245, 73, 53, 1)),
        ));
  }
}
