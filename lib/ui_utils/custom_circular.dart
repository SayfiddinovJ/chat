import 'package:flutter/material.dart';


class CustomCircularProgressIndicator extends StatelessWidget {
  final double? strokeWidth;
 final BuildContext? context;

  const CustomCircularProgressIndicator({
    super.key,
    this.strokeWidth,
    this.context
  });

  @override
  Widget build(BuildContext context) {
    if (strokeWidth == 4.0 || strokeWidth == null) {
      return const CircularProgressIndicator(
        strokeWidth: 5,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      );
    } else {
      return CircularProgressIndicator(
        strokeWidth: strokeWidth!,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
}
