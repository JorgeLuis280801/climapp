import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class DialogWidget {
  BuildContext context;
  ProgressDialog? pd;
  DialogWidget({required this.context}) {
    pd = ProgressDialog(context: context);
  }

  void showProgress() {
    pd!.show(
        msg: "Espere por favor",
        msgColor: const Color.fromARGB(255, 0, 0, 0),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        progressBgColor: Color.fromARGB(255, 39, 87, 176),
        progressValueColor: const Color.fromARGB(255, 64, 204, 255),
        barrierColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2));
  }

  void closeProgress() {
    pd!.close();
  }
}
