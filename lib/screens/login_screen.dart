// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'loginScreen';

  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //herhangi bi degisken tipi blerilemezsek ona atigmiz deger tipi otomatik aliyor.mesela burda deger atiktan sonra degisken tipi FirebaseAuth olmus
  final _auth = FirebaseAuth
      .instance; //artik bu sekil _auth degiskeni kullanark tum FirebaseAuth.instance methodlarina olasabilirz
  late String email;
  late String passWord;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  //Flexable/esnek widget icindeki widget eger yeterli alan yoksa daha kucuk olup uygun alani kapsayabilir//it can be flexible about it and be smaller so that other parts of the screen is visible
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height:
                          200.0, //textFielde basinca keyboard yer almak icin foto alani biraz kucuk olmasi lazim ve ekranda bos alan olmasi lazim yukari cikmasi icin
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
                      fontSize: 27.0), //TextFiled icinde yazarken yazi rengi
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kTextFiledInputDec.copyWith(hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                TextField(
                    textAlign: TextAlign.center,
                    cursorColor:
                        Colors.black, //yazarken isaret koyan cizginin rengi
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 27.0), //TextFiled icinde yazarken yazi rengi
                    obscureText: true,
                    onChanged: (value) {
                      passWord = value;
                    },
                    decoration: kTextFiledInputDec.copyWith(
                        hintText:
                            'Enter your password') //copyWith fonksyun ile ayni ozellikler kaliyor sadece  widget'a yeni ozelik ekleyebilirz yada degistirebilirz
                    ),
                SizedBox(
                  height: 20.0,
                ),
                RoundedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: () async {
                      print('user email = $email');
                      print('user password = $passWord');
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        //SignIn islemi icin Register sayfasinda yaptigimiz ayni islemler yazdik burda sadece signIn methodu kullandik creatUser yerine
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: passWord);
                        Navigator.pushNamed(
                            context,
                            ChatScreen
                                .id); //yukardaki method await ile yazdigmiz icin islemini bitirip sonra diger isleme gecek yani animation/daire bu fonks islem bitene kadar donece
                        setState(() {
                          //LogIN islemi tamamladiktan sonra artik animation daire donmesine gerek yok false yapip onu durduryoz
                          showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                        setState(() {
                          //LogIN islemi hatali olursa  artik animation daire donmesine gerek yok false yapip onu durduryoz
                          showSpinner = false;
                        });
                        return Alert(
                          type: AlertType.error,
                          context: context,
                          title: 'Error!',
                          desc:
                              'Please write your email and password correctly',
                          closeIcon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 30,
                          ),
                        ).show();
                      }
                    },
                    pageName: 'Log In'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
