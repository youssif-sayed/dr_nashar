import 'package:dr_nashar/utils/colors_palette.dart';
import 'package:flutter/material.dart';


class TextInput extends StatefulWidget {
  final String hint;
  final TextInputType inputType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const TextInput({
    Key? key,
    required this.hint,
    this.inputType = TextInputType.text,
    this.prefixIcon,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _obscured = true;
  void _toggleObscure() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 47,
          width: double.infinity,
          decoration: BoxDecoration(color: ColorsPalette.white,borderRadius: BorderRadius.circular(50),),
        ),
        TextFormField(
        style: TextStyle(color: Colors.black),
        obscureText: widget.inputType == TextInputType.visiblePassword && _obscured,
        keyboardType: widget.inputType,
        validator: widget.validator,
        onSaved: widget.onSaved,
        cursorRadius: Radius.circular(200),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12),
          isDense: true,

          focusColor: ColorsPalette.darkGrey,


          border:  OutlineInputBorder(borderSide: const BorderSide(color: ColorsPalette.white),borderRadius: BorderRadius.circular(50)),
          prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: Colors.blueAccent) : null,
          hintText: widget.hint,
          hintStyle: const TextStyle(color: ColorsPalette.darkGrey),
          suffixIcon: widget.inputType == TextInputType.visiblePassword
              ? IconButton(
                  icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
                  onPressed: _toggleObscure,
                )
              : null,
        ),
      ),]
    );
  }
}
