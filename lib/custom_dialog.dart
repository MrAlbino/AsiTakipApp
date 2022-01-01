import 'dart:ui';
import 'package:flutter/material.dart';


class BlurryDialog extends StatefulWidget {

  final String title;
  //final String content;
  final VoidCallback continueCallBack;
  //this.content, ↓
  const BlurryDialog(this.title, this.continueCallBack, {Key? key}) : super(key: key);

  @override
  State<BlurryDialog> createState() => _BlurryDialogState();
}

class _BlurryDialogState extends State<BlurryDialog> {
  TextStyle textStyle = const TextStyle (color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  AlertDialog(
          backgroundColor: Colors.blue.withOpacity(.85),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(widget.title, style: const TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child:const Text("Cancel",style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:const Text("Exit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              onPressed: () {
                widget.continueCallBack();
              },
            ),
          ],
        ));
  }
}