import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  const FormWidget({
    super.key,
    required this.mediaQuery,
    required this.labelText,
    required this.hintText,
    required this.focusNode,
    required this.nextNode,
    required this.validationFun,
    required this.textInputAction,
    required this.isNormal,
    this.togglePasswordVisibility,
    required this.obscureText,
    required this.textInputType,
  });
  final Size mediaQuery;
  final String labelText;
  final String hintText;
  final FocusNode focusNode;
  final FocusNode nextNode;
  final String? Function(String?)? validationFun;
  final TextInputAction? textInputAction;
  final bool isNormal;
  final Function()? togglePasswordVisibility;
  final bool obscureText;
  final TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    return isNormal
        ? Stack(
            children: [
              Container(
                height: mediaQuery.height / 17,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  textInputAction: textInputAction,
                  keyboardType: textInputType,
                  focusNode: focusNode,
                  obscureText: obscureText,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(nextNode);
                  },
                  decoration: InputDecoration(
                    labelText: labelText,
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.black38),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    // Add padding
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                  validator: validationFun,
                ),
              ),
            ],
          )
        : Stack(
            children: [
              Container(
                width: double.infinity,
                height: mediaQuery.height / 17,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  focusNode: focusNode,
                  obscureText: obscureText,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(nextNode);
                  },
                  decoration: InputDecoration(
                    labelText: labelText,
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.black38),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    // Add padding
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: togglePasswordVisibility,
                    ),
                  ),
                  validator: validationFun,
                ),
              ),
            ],
          );
  }
}
