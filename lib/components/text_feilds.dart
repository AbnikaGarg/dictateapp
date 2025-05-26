import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';


class MyTextField extends StatelessWidget {
  String hintText;
  var color;
  var icon;
  var preicon;
  bool readOnly;
  var validation;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  var ontap;
  var ontapSuffix;
  final bool obsecureText;
  final bool isSuffixIcon;
  final TextEditingController? textEditingController;
  MyTextField(
      {super.key,
      required this.hintText,
      required this.color,
      this.icon,
      this.ontapSuffix,
      this.obsecureText = false,
      this.isSuffixIcon = false,
      this.readOnly = false,
      this.preicon,
      this.ontap,
      this.textInputType,
      this.inputFormatters,
      this.textEditingController,
      this.validation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8),
      child: TextFormField(
          keyboardType: textInputType,
          onTap: ontap,
          readOnly: readOnly,
          inputFormatters: inputFormatters,
          controller: textEditingController,
          obscureText: obsecureText,
          validator: validation,
          cursorColor: AppTheme.primaryColor,
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.displaySmall,
              counterText: '',
              errorStyle: GoogleFonts.roboto(fontSize: 12),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(225, 30, 61, 1),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              prefixIcon: preicon,
            
              hintStyle:GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromRGBO(153, 153, 153, 1)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromRGBO(201, 201, 201, 1),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(201, 201, 201, 1),
                  width: 1,
                  
                ),

                borderRadius: BorderRadius.circular(12),
              ),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(
                  color: Color.fromRGBO(201, 201, 201, 1),
                width: 1,
              )),
              filled: true,
              fillColor: AppTheme.whiteDullColor,
              contentPadding: EdgeInsetsDirectional.fromSTEB(
                  15, 15, 10, 20),
              hintText: hintText,
              floatingLabelStyle:
                  const TextStyle(color: Color.fromRGBO(245, 73, 53, 1)),
              suffixIcon: isSuffixIcon
                  ? GestureDetector(
                      child: !obsecureText
                          ? Icon(
                              Icons.visibility_off,
                              size: 18,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.visibility,
                              size: 18,
                              color: Colors.grey,
                            ),
                      onTap: ontapSuffix,
                    )
                  : icon)),
    );
  }
}
