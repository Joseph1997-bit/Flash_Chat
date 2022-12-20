//Mixins are a way of reusing a class’s code in multiple class hierarchies.//bir yada daha fazla class'in ozellikleri baska bi class'ta kullanmak icin kullanilir
//To use a mixin, use the with keyword followed by one or more mixinnames.

void main() {
//herhnagi bi classin metodu cagirmak icin parantez(Animal().) koymamiz lazim cunku static degil olsaydi classi adi direk kullanabiliriz
//Animal().move();
//Fish().move();
//Bird().move();

Duck().fly(); //mixin ve with kelimeleriekledikten sonra artik fly yada swim yada move istedigimiz methodu cagirabilirz
}

class Animal {
  void move() {
    print('change postion');
  }
}

mixin CanSwim{
  void swim() {
    print('changing position by swiming' );
  }
}
mixin CanFly{
  void fly() {
    print('changing position by flying');
  }
}

//sadece bi classtan miras/inherit alabiliyoruz oYuzden bazen with kelimesi kullanmak zorunda kalirz.Baska class'in ozellikleri kullanmak icin kullaniriz
//ama bu classlar mixin tipinden olusmasi lazim yoksa hata verir
class Duck extends Animal with CanFly,CanSwim{//simdi Duck classimiz yerini ya ucarak degistirebilir yada yuzerek
}

//Herhangi bi methodu yazmadan with kelimesi ile fly methodu kullanabiliriz
class AirPlane with CanFly{

}


//*********asagdaki classlar extends ve with,mixin  arasinda farklari gostermek icin kullandik*******************
//extends inherit/miras almak icin kullanilir
class Fish extends Animal{

  @override//override ve super kelimesi miras aldigimiz classtan istedgimiz ozellik/mthod cagirip ona yeni bi ozelik ekleyebilirz yada degistirebiriz
  void move(){
    super.move();
    print('by swiming');
  }

}
class Bird extends Animal{
  @override
  void move() {
    super.move();
    print('by flying');
  }
}