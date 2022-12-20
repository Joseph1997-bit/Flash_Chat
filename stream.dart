




//**************sadece consolde mesajlari gormek icin bu fonksyunu kullandik ***************
//Well imagine that you're chatting with your friend.In that case you want to see your friends messages show up right away
  //yeni gonderilen mesajlari her hangi biseye basmadan  otomatik olark gormek icin snapshots fonksyunu kullanacz
//ilk basta fireStordan olusan degiskeni kuullaniyoz sonra collection cagiriyoz String bi parametre aliyo sonra snapshots fonksyunu cagirabilirz
//this method instead of a future query snapshot, it returns a stream of query snapshots.Stream ise Stream/مجرى/aktarim adisindan belli yuruyen/hareket eden sey yani onun calisma prensibi sayesınde gonderilen yeni mesajlari.yada baska bi sey olabir direk otomatik ekranda/console'de gorebilirz
  Future<void> messagesStream() async {
//this snapshot is a data type that comes from Firebase and it's a snapshot of the data as we have it in our current collection.
    //yani  Firebase'den gelen bir veri türüdür ve mevcut koleksiyonumuzda/collection bulunan verilerin anlık görüntüsüdür.
    //snapshots map   olark parametre aldigi icin en uygun for dongusu kullanip istedigmiz bilgiyi getirebilirz
    //bu snapshot degiskeni document icinde gezip ve snapshots olark dondureck ve snapshots ise Stream<QuerySnapshot<Map<String, dynamic>>> bi deger dondureck ve Stream/مجرى/aktarim sayesinde gonderilen yeni mesajlari direk otomatik gorebilirz
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      //And this is almost kind of like a list of futures, it's a whole bunch of futures.await yazmazsak hata verir cunku future bi list donduryo ve baska islemlere gecmeden once bitmesini beklememiz lazim
      //messages degiskeni snapshots  docmentsler icinde gezeck FireStorda her document icinde text ve sender/gonderen degerleri var onlari almak/gostermek icin
      for (var messages in snapshot.docs) {
        print(messages.get('text'));}
//en son FireStorda bulunan her document'i alip gostercz data fonksyun ile ve data() fonksyunu hem keys/anahtarlar hemde value/degerleri getiriyo
      print(snapshot.docs); //docs fonksyunu List of queryDocmentSnapshot of map bi deger donduryo
      //baska fonksyunlar var farkli bilgiler getirebilirz ama biz docs sectik cunku docs fonksyunu map olarik bi deger getiriyo 1.si field adilari key/anahtar String olark 2.si field'in degerileri ise value/deger dynamc olark gosterck
    }}




var _firestore;
  //bu fonksyunu calistirmak icin ve data getirmek icin onu bi button icine koyup button' basmamiz lazim
//eger baska kullanici mesaj atarsa ben gormek icin bu fonksyunu her seferde cagirmam lazim yada buttoni basmam lazim Stream gibi degil
  void getmessages() async {
    //get() methodu Future query snapshot(yani sorgu anlık görüntüsü) ve ayni zamanda onun tipi/donduryor
    //this query snapshot is a data type that comes from Firebase and it's a snapshot of the data as we have it in our current collection.
    //yani  Firebase'den gelen bir veri türüdür ve mevcut koleksiyonumuzda/collection bulunan verilerin anlık görüntüsüdür.

    final messages=await _firestore.collection('messages').get();
    //bu message degiskeni document icinde gezip alack ve FireStorda her document icinde text ve sender/gonderen degerleri var onlari almak/gostermek icin get() ve sonra docs fonksyunlari kullandik
    for(var message in messages.docs){
      print(message.data());
      //baska fonksyunlar var farkli bilgiler getirebilirz ama biz data sectik cunku data fonksyunu map olarik bi deger getiriyo 1.si field adilari key/anahtar String olark 2.si field'in degerileri ise value/deger dynamc olark gosterck
    }

  }
