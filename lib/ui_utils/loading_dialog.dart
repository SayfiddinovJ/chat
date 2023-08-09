import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_circular.dart';


void showLoading({required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(),
          child: Center(
            child: SizedBox(
              height: 70.0.h,
              width: 70.0.w,
              child: const CustomCircularProgressIndicator(strokeWidth: 6,),
            ),
          ),
        ),
      );
    },
  );
}

void hideLoading({required BuildContext? dialogContext}) async {
  if (dialogContext != null) Navigator.pop(dialogContext);
}
