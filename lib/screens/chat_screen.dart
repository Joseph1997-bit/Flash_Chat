import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

final _firestore = FirebaseFirestore.instance; //bu degiskeni kullanark fireStore methodlarina olasabilirz
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _auth = FirebaseAuth.instance;
//simdilik kabul et null olmaz sonra ona deger atacz

  late String messageText;
   FieldValue messagesTimes=FieldValue.serverTimestamp();

final messageTextController=TextEditingController();//TextFielde icndeki mesaji gonderdikten sonra mesaj silinsin diye kullanacz

  @override
  void initState() {
    super.initState();
    //login islemi yaptiktan sonra chat sayfasina gideck yada acar ve icindeki initStae sayesinde bu method direk calisack herhangi bi sey basmadan
    getCurrentUser();
  }

//this method will check to see if there is a current user who is signed in. So previously if our registration was successful,
// then this user actually gets saved into the authentication object as a current user,
  //ve mesaj atarken mailleri kullanacigmiz icin chat sayfasi acinca bu method direk calisir
  void getCurrentUser() {
    //if somebody has registered or if somebody is logged in,then this will correspond to the current user and we'll be able to tap into that user's email or password.
    //FireBaseAuth tipinden olsturdugmuz degisken kullanark currentUser diye hazir bi method cagirabiliriz
    //bu method(currentUser) kayit yaptiktan sonra kullanicinin bilgileri ona atiliyor otomatik.ve bu methodu kullanark bilgilere olasabilirz
    //this user actually gets saved into the authentication object as a current user,
    try {
//eski versiyon bu sekilde yazilior FirebaseUser user = await auth.currentUser();
      //FirebaseUser changed to User. And AuthResult changed to UserCredential.GoogleAuthProvider.getCredential() changed to GoogleAuthProvider.credential() .onAuthStateChanged which notifies about changes to the user's sign-in state was replaced with authStateChanges().
      // currentUser() which is a method to retrieve the currently logged in user, was replaced with the property currentUser and it no longer returns a Future<FirebaseUser>.
      final user = _auth.currentUser;
      loggedInUser = user!;
      print(loggedInUser.email);
      //be able to print out the current user's email address because we're going to need that when we start sending messages in their name.
      //messaj atarken kullanicinin maileine ihtiyacim olack.We're going to have to tag our messages with the sender/سيتعين علينا وضع علامة على رسائلنا مع المرسل

    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('⚡ Chat'),
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
               //   messagesStream();
                _auth.signOut();
                 Navigator.pop(context);
              }),
        ],
      ),
      body: Column(
       //crossAxisAlignment: CrossAxisAlignment.stretch,
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
MessageStream(),
          Row(
          //  crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.black,fontSize: 20.0),
                  cursorColor: Colors.black,
                  controller: messageTextController,
                  onChanged: (value) {
                    messageText = value;
                  },
                  decoration: kMessageTextFieldDecoration,
                ),
              ),
              TextButton(
                  onPressed: () {
                    //messagelar ve messaglari gonderen kisilerin bilgileri tutulack yeri yaziyoz ccllection denir yani dataBase adi sayilir ve onu messages olark adlandirdik
                    //messajlari gonderdikten sonra baska kullanici onlari gormek icin veritabanna/FireStor'a atiyoz
                    //Firstor'a atmak icin FireStor tipnden olusturdugmuz degiskeni kullanark collection adini yaziyoz messages'olark verdik sonra add fonks ile ekleybilirz/ atabilirz
                    //add fonksyunu map olark bi parametre aliyo bu mapi kullanark mesajlari ve mesagi gondern kisinin maili FireStor'a atip kaydedebilirz bu map'in 1.parametresi Anahtar/key String value/deger 2.si ise dynamic olmasi lazim
                    //maplar genelde <anahtar ve value> olark olusuyor map'in 1.anahtari/key FireStorda yazdigmiz field/alan adi kullanacz sender/gonderen kisi degeri/value ise loggedInUser degiskeni kullanark gonderen kisinin mailini alip oraya atiyoz
                    //map'ta 2.anahtar/key mesajlar icin olusturdugmuz field adi text ve TextField icinde yazdigmiz messajlar bu anhatari kullanark FireStor'a atabilir
                    _firestore.collection('messages').add(({
                          'sender_gonderen': loggedInUser.email,
                          'text': messageText,
                      //mesajlari sirayla yapmak icin yani son gonderilen mesajlar ilk basta gozuksun diye zamani gosteren yada ekleyen fonksyunu eklemek zorunda kaldik
                      'timestamp': messagesTimes,//We use the server time instead of generating a timestamp with the user device because:Our users may be in different timezones so the time differences will affect our app.and Some devices could be set to incorrect times.
                        }));
                    print(messageText);
                    messageTextController.clear();//TextFielde icndeki mesaji gonderdikten sonra TextField'i temizlemek/clean icin kullanaczgiz
                  },
                  child: Text(
                      'Send')) //eger internet baglantisi yoksa ve mesaj gonersek internet geldikten sonra ve uygulamayi calistiktan sonra mesajlar FireStore'a gider ve kaydedileck
            ],
          ),
        ],
      ),
    );
  }



}


class MessageStream extends StatelessWidget {

  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  //StreamBuilder Widgeti kullanark firebase'in collection'dan bilgi alip ekranda onlari gostercez
      //StreamBuilder can handle a stream  that comes from snapshots and will create a list of text widgets for us.And it will update or rebuild our widgets every time a new message/data/bilgi comes into the stream/akim/nehir gibi/مجرى
      //and StreamBuilder does that using the set state.So in other words, set state will be called every time there's a new value in the stream.internette Flutter sayfasinda anlatilyormus bunlari
      StreamBuilder<QuerySnapshot>(
        //StreamBuilder icinde iki tane onemli ozellikler/parametresi var stream ve builder ve return widget
        //stream ozelligi bilgileri nerden geldigini yada nerden alacagimizi bi deger aliyo bilgileri snapshots olarak firebaseten aliyoz ve herhangi bi yeni data/bilgi firebase'e giderse  stream ozelligie direk gelir
        stream: _firestore.collection('messages')
            .orderBy('timestamp', descending: true).snapshots(), //orderBy mehhodu ve icindeki zaman ile ilgil ozellikler gonderilen mesahlari son gelen mesaji ekranda gostermek icin kullandik
        //we're going to fetch these snapshots which is a stream. In particular, it's a stream of query snapshots.The query snapshot is a class from Firebase which will ultimately contain the chat messages that we're after
        //This builder must only return a widget and should not have any side effects as it may be called multiple times.
        //chat message being sent,our stream builder receives a snapshot. At this point the builder function needs to update the list of messages displayed/show on the screen.In other words the builder needs to rebuild all the children of the stream builder
        //And a builder is something that takes an anonymous callback and it has two inputs. So it's going to trigger the callback passing in the context and also the snapshot that we get back from firebase,and this builder returns an actual widget.
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Flutter's async snapshot because we're working with our Stream builder.This asyncSnapshot represents the most recent interaction.yani data/bilgiler'de en son etkileşimi/degisme temsil eder.ve mesajlar asyncSnapshot icinde bi yerde saklaniyo ve bunlari almak icin builder fonksyunu ile.we can get access to messages through the builder function.
          //and our a async snapshot actually contains our query snapshot from Firebase.

          List<Widget> messageWidgets = []; //her messaji ve mail yazdirmak icin bi text widget icnde koymamiz lazim vew bi suru messag olabilr o yuzden List of text kurduk her yeni gelen mesaj/text ona atip baska yerde yazdiracz

          if (!snapshot.hasData) {
            //eger data yoksa kucuk animated bi daire cikack bilgi yada mesaj gelene kadar donecek sonra gider
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          //The async snapshot contains a query snapshot from Firebase.We access the query snapshot through the data property.Now we're dealing with a query snapshot object so we can use the query snapshot's properties like this(snapshot.data.docs)And this will give us a list of document snapshots.
          final dataInfo = snapshot.data.docs; //eger snapshot'ta data varsa messages degiskene atiyoz.(snpashot.data)this is how we can access the data inside our async,snapshot yani asyncsnapshot'in verilerine ulasiyoz.ve bu data icinde documents var onlara da docs ile ulasabilirz
          for (var message in dataInfo) {
            //dataInfo degisken icinde artik a list of documents snapshots var o yuzden hepsini getirmek icin for dongusu icnde koyduk
            //I'm going to use a FOR loop to build a whole bunch of text widgets.
            final messageText = message.data()['text']; //message degiskeni dataInfo listesinden bilgi yani documents bilgileri aldigi icin data()fonksyunu kullanark text field'in degerini alip mesajText degiskne atiyoz
            final messageSender = message.data()['sender_gonderen']; //text fieldaki gibi mesaji gonderen kisi malini bu sekilde aliyoz ve her document icinde iki tane field yazdik
            final messageTime=(message.data()['timestamp']);
            final currentUser=loggedInUser.email;


//mesajlari ve gonderen kisi bilgilerini aldiktan sonra ekranda gostermek icin text widget icinde yazmamz lazim ve for dogusu icinde oldugu icin eski mesajlari ve her gelen yeni mesaj bu sekilde yazdirabiliyoz
            final messageWidget = MessageBubble(message: messageText, sender: messageSender,
              user: currentUser==messageSender?true:false, time: messageTime,);
            messageWidgets.add(messageWidget); //butun text widgetkeri ve yeni gelen mesajlari yazdirmak icin bi  List of widget'a atiyoz sonra bu List widget'ten olusan degisken baska yerde yazabiliyoz
          }
          return Expanded(
            //Sadece LIstView kullansak butun ekranin alani  kapsayabilir oYuzden Expanded icinde koyduk TextField alani almasin diye
            child: ListView(
              reverse: true,//And if we set this to true, then you can see now my list view is sticky towards the bottom of the view.
                //reverse true olunca demeki ListVIew alt kismini hep onu gostereck yani gonderilen mesajlar asgaya gitmeyeck
                padding: EdgeInsets.all(10.0),
                //StreamBuilder return a widget ve bu widget icinde List of Text koyacaz icnde sakladigmiz butun mesajlari ve StreamBuilder builder ozllik sayesinde rebuild olur ve icinde setState oldugu icin  ekranda direk gozukecek
                children: messageWidgets
            ),
          );
        },
      );
  }
}


//  butun kodlar ayni yerde olmasin ve bi suru ozellikler ekleyelim diye ayri bi stateLess classi olusturduk
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key, required this.message, required this.sender, required this.user,
    required this.time,}) : super(key: key);
  final time;  final message;  final sender; final bool user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        //eger kullanici mesaj gonderiyorsa yani user degeri true olmasi lazim mesahlar sagda olsun degilse solda olsun
        crossAxisAlignment: user?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [

          Text(
            '$sender ' ,
            style: TextStyle(color: Colors.black45, fontSize: 15.0),
          ),
          Material(
            //eger kullanici mesaj gonderirse renk yesil olack kullanici degilse mesaj rengi mavi olack
            color: user ? Colors.green : Colors.lightBlueAccent,
            elevation: 5.0,
            //eger kullanici mesaj gonderiyorsa mesahlar sagda ve ona isaret ediyo olsun degilse solda olsun ve gonderen tarafa isaret etsin
            borderRadius:user?userMessageDirction:notUserMessageDirct ,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text(
                '$message',
                style: TextStyle(color: Colors.white, fontSize: 20.0,),
              ),
            ),
          ),
          SizedBox(height: 10.0,),
     /*     Text(
            '${time} ' ,
            style: TextStyle(color: Colors.black45, fontSize: 15.0),
            textAlign: TextAlign.end,
          ),*/
        ],
      ),
    );
  }
}
