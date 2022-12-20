import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoundedButton extends StatelessWidget {//stalessWidget'tan miras aldik cunku widget dondurmemiz/gondermemiz lazim yoksa column icnde hata verir
 late final dynamic onPressed;
 final Color color;
  final String pageName;
   RoundedButton({ required this.color,
     required this.onPressed,
     required this.pageName});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          height: 60.0,
          child: Text(
            pageName,
            style: kSendButtonTextStyle,),
        ),
      ),
    );}}

//*********** sadece MaterialButton ile de guzel ve duzgun bi button yapabilirz *************
/*  Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: MaterialButton(
                  padding: EdgeInsets.all(18.0),
                  elevation: 5.0,minWidth: 30.0,height: 60.0,
                  child: Text('Log In',style: TextStyle(fontSize: 20.0),),
                  color: Colors.cyan,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
              ),
               )*/