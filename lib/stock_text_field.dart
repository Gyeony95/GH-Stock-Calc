import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: use_key_in_widget_constructors
class StockTextField extends StatefulWidget {
  final TextEditingController textController;
  final String? hintText;
  final String? labelText;
  const StockTextField({
    required this.textController,
    this.hintText,
    this.labelText,
  });

  @override
  _StockTextFieldState createState() => _StockTextFieldState();
}

class _StockTextFieldState extends State<StockTextField> {
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder _border = OutlineInputBorder(
      // 외곽선 스타일
      borderRadius: BorderRadius.circular(10.0), // 둥근 모서리 반지름
    );

    return TextFormField(
      controller: widget.textController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: _border,
        focusedBorder: _border.copyWith(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0)),
        errorBorder: _border.copyWith(
            borderSide: const BorderSide(color: Colors.red, width: 2.0)),
        focusedErrorBorder: _border.copyWith(
            borderSide: const BorderSide(color: Colors.red, width: 2.0)),
      ),
    );
  }
}
