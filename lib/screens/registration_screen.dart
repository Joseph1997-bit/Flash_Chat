import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'RegistrationScreen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth
      .instance; //kayit icin FirebaseAuth'tan bi degisken olusturyoz bi o degiskeni degistirmeycz.instance/misal/ornek/نموذج
  late String email;
  late String password;
  bool showSpinner = false;
  String error =
      ''; //bu degisken  Widget build fonksyund icinde yazsak ekranda gozukmez
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall:
              showSpinner, //zorunlu ve en onemli ozellik spinner/bekleme dairesi gostemek icin ve degeri true olmasi lazim
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: Hero(
                    //bu animation widget fotoyu sanki ekrandan ekrana atliyormus gibi gosterck.ve farkli bi foto da kullanabiliriz
                    tag:
                        'logo', //tag ozelligi ayni adi olmasi lazim ve flutter bileck bu sayfa son
                    child: Container(
                      height: 200,
                      child: Image.asset('images/logo2.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextField(
                    textAlign: TextAlign
                        .center, //hintText cumlesi ve yazacgimiz kelimeler ortada olsun
                    cursorColor:
                        Colors.black, //yazarken isaret koyan cizginin rengi
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0), //TextFiled icinde yazarken yazi rengi
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFiledInputDec.copyWith(
                        hintText: 'Enter your email')),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                    textAlign: TextAlign
                        .center, //hintText cumlesi ve yazacgimiz kelimeler ortada olsun
                    cursorColor:
                        Colors.black, //yazarken isaret koyan cizginin rengi
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0), //TextFiled icinde yazarken yazi rengi
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFiledInputDec.copyWith(
                        hintText: 'Enter your password')),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '$error',
                  style: TextStyle(color: Colors.red),
                ),
//Text('FireBase ayni gmail iki kere kabul etmez ve password 6 ve daha fazla karakterden olmasi lazim',style: TextStyle(color: Colors.black),),
                RoundedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: () async {
                      //because this is an asynchronous method, we don't want to continue on without knowing whether if our new user has been created or not
                      //creatUser methodu Bu asenkron/eşzamansiz bir yöntem olduğundan, yeni kullanıcımızın oluşturulup oluşturulmadığını bilmeden devam etmek istemiyoruz. baska islem yapmadan emin olmak lazim o yuzden async ve await ekledik
                      print(email);
                      print(password);
                      /* setState((){
                  if(password.length<6) {
                      error='password should be more than 6 character';
                  }});*/
                      setState(() {
                        //register button'i basinca ekranda Animation daire cikack bekleme olayi icin
                        showSpinner = true;
                      });

                      //auth deiskeni kullanark kullanici mail ve password ile kayit tapabilirz ve bu method Future cunku kullanici olusturmak veya dogrulamak bi suru zaman alabilirz
                      try {
                        //if our registration was successful,then this user actually gets saved into the authentication object as a current user,
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        Navigator.pushNamed(context, ChatScreen.id);

                        setState(() {
                          //register islemi tamamladiktan sonra artik animation daire donmesine gerek yok false yapip onu durduryoz
                          showSpinner = false;
                        });
                      }

                      //kayit yaparken eger ayni gmail iki kere yazarsak veya eksik yazsak veya password 6 karakterdan kucuk olursa Console'da hatayi gosterck bize
                      catch (e) {
                        print(e);

                        setState(() {
                          //Rigister islemi hatali olursa  artik animation daire donmesine gerek yok false yapip onu durduryoz
                          showSpinner = false;
                        });
                        return Alert(
                          type: AlertType.error,
                          context: context,
                          title: 'Wrong!',
                          desc: 'Somthing went wrong with email'
                              ' or password please try again',
                          closeIcon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 30,
                          ),
                        ).show();
                      }
                    },
                    pageName: 'Register'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
