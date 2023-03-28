// Flutter imports:
import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  required Function() function,
  required String text,
}) =>
    Container(
     width: width,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius), color: background
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextEditingController type,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  GestureTapCallback? onTap,
  required FormFieldValidator<String>? validate,
  required String lable,
  required IconData prefix,
  required String hintText,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isPassword= false,
  bool isClickable = true,
  int? lines, required bool obscureText,
}) =>
    TextFormField(
      controller: controller ,
      keyboardType: TextInputType.text,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      maxLines: lines,
      validator: validate,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        enabled: true,
        labelText: lable,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
            borderSide: BorderSide(color: Colors.white)),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10,),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );

Widget userInfo(IconData icon, String data, Color color, onPressed ,isExpanded) {
  return GestureDetector(
    onTap: onPressed,
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white,),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          data,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(),

         isExpanded?Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,):Container(),
      ],
    ),
  );
}

void NavigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
      ));

void NavigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context) => widget,
    ),
      (Route<dynamic> route) => false,
);

showLoadingDialog(context) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      children: const [
        Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

