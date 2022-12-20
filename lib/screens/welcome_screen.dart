import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/rounded_button.dart';


class WelcomeScreen extends StatefulWidget {
  //routes kullaninca herhangi bi hata oluşmaması icin static ve string bi degğşken tanımladık istedigmiz yer kullanabiliriz sadece class adı yazark cunku static
//sabit bir deger baska sayfada kolayca kullanmak icin onu static yapariz
  static const id = 'WelcomeScreen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

//bu syfaya yeni ozellik eklemek icin animation gibi with kelimesi kullaniyoz burda ekranda tek bir animation ekleyecz diye (SingleTicker...) ozelligi klullandik
//birden fazla animation kullanacksak TickerProvider....  ozelligi ekleycz
class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  //bu ozellik ekleyince artik bu sayfa bir işaretçi olarak hareket etmek/act as a ticker bi tane animation icin

//late demeki bu degiskene sonra deger atacz simdilik kabul et ve null olmz/olmyck
  late AnimationController controller1;
  late Animation animation;
  late AnimationController
  controller2; //ayni ekranda 1'den fazla animation kullanmak icin ayri bi degisken olusturduk ve SingleTicker kullanmaycz

  @override
  void initState() {
    //bu sayfayi cagirnca/calistircinca bu fonks direk calisir ve icndeki yazdigiz degisken/foknslar direk calisir
    super.initState();

    controller1 = AnimationController(
      duration: Duration(
          seconds: 2), //olusturacagimiz animation ekranda ne kadar surecegine bu ozellikle belirliyoz ve forword fonksyunu 0.0'dan 1'a kadar belirledigmiz saniye/zaman icinde onu hesaplayck oYizden animation ona gore ekranda surecek
      //then we want to reference the object made from the class in the class' own code, we use the keyword this
      //'this'. So this line of code says that who's going to provide the ticker for my animation controller.
      //eger bi nesne/object isaret etmek/cagirmak istiyorsak ve bu nesne ayni classtan olusuyor ve ayni class'ta kullanacaksak this' kelimesi kullaniyoz
      vsync: this, //bu class'ta Ticker veya animation ozellgi kullanmak/calistirmak icin vsync'ozelligi kullanmk zorundayiz.yani this kelimsei animation ozelligi bu class/sayfada calisack/gosterileck
//upperBound: 100.0,//upperBound ozelligi 0'dan 100'e kadar saysin/gitsin diye kullaniyoz
    );

    animation = CurvedAnimation(
        parent: controller1,
        curve: Curves
            .easeIn); //Curved widgeti internten ozellikleri daha aciklayici bi sekilde gorebilirz veya controller1 yerine de kullanabilirz

    controller1
        .forward(); //animationi baslatmak icin bu forward/ilerle fonksyunu cagiriyoz initState icinde.yani 0.0'da. 1.0'a kadar Duration icinde belirledgimz zaman yukseleck yavas yavas
    //controller.reverse(from: 1.0);//curvedAnimation ve bazi ozellikler ekledikten sonra 100'dan 0'a kadar gider yani ters foto buyk baslar sonra kucuk olur

    animation.addStatusListener((status) {
      //addStatusListener((status) bu fonks controller.forward degeri saymaya bittikten sonra AnimationStatus.completed yazar onu kullanark farkli animation yapabiliriz

      if (status == AnimationStatus.completed) {//status icinde oldugu icin 1'e kadar saydiktan sonra AnimationSatus.completed yazar yani saymaya/durum bitti
        //bu kod fotunun buyutup sonra tekrar kuculteck sonsuza kadar bi animation devam edebilirz
        controller1.reverse(
            from:
                1.0); //addStatusListener((status) bu fonks controller.reverse degeri saymaya bittikten sonra AnimationStatus.dismised yazar
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
      // print(status);//dismissed yada completed durmuna gormek.bakmak icin yazdik
    });

    controller1.addListener(() {
      //controller nasil calisir yada ne yapar gormek icin addListener fonksyonu ekleriz
      setState(()
          //we don't have to do anything inside set state because our values are already changing with the animation controller.
          //ekran rengini degistirmek icin setState kullanmak zorundayiz ama bu sefer set icinde herhangi bi sey koymamiza gerek yok cunku degerler Animation controller ile degisiyo sadece ekranda gostermek icin setState kullaniriz
          {});
      // print(controller.value);//controller degeri veya olusturdugu rakamlar gormek icin print icinde yazariz
    });

    controller2 = AnimationController(duration: Duration(seconds: 5), vsync: this);
    controller2.forward();

  }
  //even if this screen is dismissed that controller still lives on and it's costing resources.
  //So whenever you're using animation controllers, it's really important that you tap into the dispose method
  //we have to make sure that we also dispose our controller.So this way it doesn't end up staying in memory and hogging all the resources/tüm kaynakları çalıyor.

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //animation kullanark ekran rengini degistirebilirz.renginin sefaflik derecesini gostermek icin withOpacity fonksyunu kullanirz ve bu opacity double deger(0-1 arasinda) alir ve controller(0-1arasinda) degeride double oYuzden direk yazdik
        //SingleTicker sectigmiz icin ekranda iki tane animation yapamayiz hem ekran rengi hemde yukselen rakam animationi olmaz bi tanesini silmemiz lazim
        backgroundColor: Colors.teal.withOpacity(controller2.value),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    //iki ekran arasinda geçiş animation olark yapmak icin Hero widgeti kullanyoz
                    tag:
                        'logo', //tag parametresi zorunlu ve iki ekranda ayni adi olmasi lazim ve flutter bileck bu sayfadan baslayck
                    child: Container(
                      height: animation.value * 100,//animation valuesu 0-1 arasinda oldugu icin fotuyu buyuk gostermez oYuzden 100 ile carptik fotunun boyutu daha buyuk olsun diye
                      child: Image.asset(
                        'images/logo2.png',
                      ), //upperBound ozellgi ekledikten sonra height'ta controller.value kullanip fotunun boyutu ve sekili degistirebilirz animation olur yani
                      //yada animation.value*100 kullanip fotuyu kucultup buyutebilirz
                    ),
                  ),
                  TextLiquidFill(
                    text: 'Chat',
                    //  boxBackgroundColor: Colors.black,
                    waveDuration: Duration(seconds: 4),
                    waveColor: Colors.green,
                    textStyle: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                    boxHeight: 50.0,
                    boxWidth: 100.0,
                    loadUntil: 0.90,
                  ),
                ],
              ),
              SizedBox(
                height: 45.0,
              ),
              RoundedButton(
                color: Colors.indigo,
                pageName: 'Log In',
                onPressed: () {
                  Navigator.pushNamed(context,
                      LoginScreen.id);
                },
              ),
              RoundedButton(
                  color: Colors.cyan,
                  pageName: 'Register',
                  onPressed: () { //onPreesed parametresi yaninda anonymous/isimsiz fonks yani (){} kullanmazsak bi suru hatalar verir
                    Navigator.pushNamed(context,
                        RegistrationScreen.id);
                  }),],
          ),
        ),
      ),
    );
  }
}
