import 'dart:math';
import 'dart:ui' as ui ;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ozelgunler/OzelGunDao.dart';
import 'package:ozelgunler/VeritabaniYardimcisi.dart';
import 'package:ozelgunler/dinamikListe.dart';
import 'package:ozelgunler/ekle.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<dinamikListe>> tumListeyiGoster() async{
    var ozelGunListesi = await OzelGunDao().tumListe();
    return ozelGunListesi;

  }


  @override
  void initState() {
    super.initState();
    VeritabaniYardimcisi.veritabaniErisim();
    tumListeyiGoster();

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Random().nextInt(0xffffffff)).withAlpha(0xff),
      ),
      body:FutureBuilder<List<dinamikListe>>(
        future: tumListeyiGoster(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var ozelGunListesi=snapshot.data;
            return ListView.builder(
                itemCount:ozelGunListesi!.length,
                itemBuilder:(context,index){
                  var ozelGun=ozelGunListesi[index];
                  return Slidable(
                    actionPane:SlidableStrechActionPane(),
                    actionExtentRatio: 0.20,

                    actions: [
                      IconSlideAction(
                        caption: "Sil",
                        color: Colors.green,
                        icon: Icons.delete,
                        onTap: (){
                          OzelGunDao().ozelGunSil(ozelGun.id);
                          Navigator.pop(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                        },
                      ),

                    ],
                    secondaryActions: <Widget>[
                  IconSlideAction(
                  caption: 'Güncelle',
                    color: Colors.deepOrange,
                    icon: Icons.sync,
                    onTap: (){
                      OzelGunDao().ozelGunSil(ozelGun.id);
                      Navigator.pop(context, MaterialPageRoute(builder: (context)=>ekle()));
                    },
                  ),
                  ],
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  colors: [Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),Colors.primaries[Random().nextInt(Colors.primaries.length)]],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow:[
                                  BoxShadow(
                                    blurRadius: 12,
                                    offset: Offset(0,6),
                                  )
                                ]
                            ),
                          ),

                          Positioned(
                            right: 0,
                            top:0,
                            bottom: 0,
                            child: CustomPaint(
                              size: Size(70,50),
                              painter:CustomShapePainter(24,Colors.black,Colors.black54),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Image.asset("images/star.png",width: 40,),
                                  PopupMenuButton(
                                    child:Icon(Icons.more_vert),
                                    itemBuilder: (context) =>[
                                      PopupMenuItem(
                                        value: 1,
                                        child: Text("Sil"),

                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Text("Güncelle"),
                                      ),
                                    ],
                                    onSelected: (menuItem){
                                      if(menuItem==1){
                                        OzelGunDao().ozelGunSil(ozelGun.id);
                                        Navigator.pop(context, MaterialPageRoute(builder: (context)=>MyHomePage()));

                                      }
                                      if(menuItem==2){

                                        OzelGunDao().ozelGunSil(ozelGun.id);
                                        Navigator.pop(context, MaterialPageRoute(builder: (context)=>ekle()));
                                      }
                                    },

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Text("Şanslı Kişi : ${ozelGun.isim}",style: TextStyle(fontSize: 15)),
                                        Divider(),
                                        Text("Özel Gün : ${ozelGun.gunturu.toString()}".toString(),style: TextStyle(fontSize: 15)),
                                        Divider(),
                                        Text("Özel Tarih : ${ozelGun.tarih} ".toString(),style: TextStyle(fontSize: 15)),
                                        Divider(),
                                        Text("${ozelGun.bildirim} Gün Önce Hatırlatma Var.".toString(),style: TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            );
          };

          return Center(

          );
        },

      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ekle()));
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        label: Text("Ekle"),
        icon: Icon(Icons.add),
      ),

    );
  }
}

class CustomShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius=24.0;
    var paint=Paint();
    paint.shader=ui.Gradient.linear(
        Offset(0,0) ,Offset(size.width,size.height),[
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),endColor
    ]);
    var path = Path()
      ..moveTo(0,size.height)
      ..lineTo(size.width-radius,size.height)
      ..quadraticBezierTo(size.width,size.height,size.width, size.height-radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width-radius, 0)
      ..lineTo(size.width-1.5*radius, 0)
      ..quadraticBezierTo(-radius, 2*radius, 0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
