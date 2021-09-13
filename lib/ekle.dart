import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ozelgunler/OzelGunDao.dart';
import 'package:ozelgunler/VeritabaniYardimcisi.dart';
import 'package:ozelgunler/main.dart';



class ekle extends StatefulWidget  {

  @override
  _ekleState createState() => _ekleState();
}

class _ekleState extends State<ekle> {
  var textfieldcontrol=TextEditingController();
  var tftarih=TextEditingController();
  var scafflodKey = GlobalKey<ScaffoldState>();
  int radioDeger=0;
  bool swichKontrol=false;
  var bildirimDeger;
  var defaultDeger="45";

  var ozelGunler=["Doğum Günü","Sevgililer Günü","Tanışma Yıl Dönümü","Evlilik Dönümü","Erkekler Günü","Diğer Günler"];
  Future<void> kayit(String isim,String tarih,String bildirim,String gunturu) async {
    await OzelGunDao().ozelGunEkle(isim, tarih, bildirim, gunturu);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
  }
  var flp = FlutterLocalNotificationsPlugin();
  Future<void> kurulum() async{
    var androidAyari = AndroidInitializationSettings("@mipmap/ic_launcher");
    var kurulumAyari = InitializationSettings(android: androidAyari);
    await flp.initialize(kurulumAyari);
  }
  Future<void> bildirimSecilme(String payload) async{
    if(payload !=null){
      print("bildirim seçildi : $payload");
    } await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => MyHomePage()),
    );

  }
  Future<void> bildirimGosterme() async{
    var androidBildirim = AndroidNotificationDetails(
        "id",
        "title",
        "açıklama",
        importance: Importance.high,
        playSound: true,
        priority: Priority.max,
        icon: "@mipmap/gift",

    );
    var bildirimDetay = NotificationDetails(android: androidBildirim);
    var gecikme=DateTime.now().add(Duration(seconds: 8));
    await flp.schedule(0, "Acele Et",tftarih.text + " Tarihinde " + textfieldcontrol.text + " : " + ozelGunler[radioDeger] + " var " + " Hediyeni Unutma ",gecikme, bildirimDetay,payload:"payload içerik");
    bildirimSecilme("payload içerik");
  }
  Future dialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Are you sure?'),
            actions: [
              new FlatButton(
                child: const Text('Anladım'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

            ],
          );
        });
  }


  @override
  void initState() {
    super.initState();
    VeritabaniYardimcisi.veritabaniErisim();
    kurulum();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Random().nextInt(0xffffffff)).withAlpha(0xff),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: textfieldcontrol,
                  decoration: InputDecoration(
                      errorText:"Zorunlu Alan",
                      hintText: "İsim Giriniz",
                      focusColor: Colors.teal,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                      ),
                      prefixIcon: Icon(Icons.drive_file_rename_outline)
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: tftarih,
                  decoration: InputDecoration(
                      errorText:"Zorunlu Alan",
                      hintText: "Tarihi Giriniz",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                      ),
                      prefixIcon: Icon(Icons.today_outlined)
                  ),
                  onTap: (){
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    ).then((alinanTarih) {
                      setState(() {
                        tftarih.text = "${alinanTarih!.day}/${alinanTarih.month}/${alinanTarih.year}";
                      });
                    });
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Bildirim:",style: TextStyle(fontSize: 25.0),)
                    ),
                  ),
                ),

                DropdownButton<String>(
                  hint: Text("Bildirim Gününü Seçiniz"),
                  value: defaultDeger,
                  icon: Icon(Icons.notifications_active,color: Colors.red,),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black,fontSize: 15),
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? newValue){
                    setState(() {
                      defaultDeger=newValue!;
                      bildirimDeger=newValue;
                    });
                  },
                  items:<String>["45","1","2","3","4","5","7","15","30"].map<DropdownMenuItem<String>>((String deger){
                    return DropdownMenuItem<String>(
                      value: deger,
                      child: Text("$deger Gün Önce"),
                    );
                  }).toList(),
                ),Container(
                  color: Colors.deepOrange,
                )
              ],

            ),

            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Özel Gün Türü Seçiniz:",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
              ),
              alignment: Alignment.topLeft,
            ),

            RadioListTile(
              value: 0,
              groupValue: radioDeger,
              title: Text("${ozelGunler[0]}"),
              activeColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
              onChanged: (val){
                setState(() {
                  radioDeger=val  as int;
                });

              },
            ),
            RadioListTile(
              value: 1,
              groupValue: radioDeger,
              title: Text("${ozelGunler[1]}"),
              activeColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
              onChanged: (val){
                setState(() {
                  radioDeger=val  as int;
                });
              },
            ),
            RadioListTile(
              value: 2,
              groupValue: radioDeger,
              title: Text("${ozelGunler[2]}"),
              activeColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
              onChanged: (val){
                setState(() {
                  radioDeger=val  as int;
                });
              },
            ),
            RadioListTile(
              value: 3,
              groupValue: radioDeger,
              title: Text("${ozelGunler[3]}"),
              activeColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
              onChanged: (val){
                setState(() {
                  radioDeger=val  as int;


                });
              },
            ),
            RadioListTile(
              value: 4,
              groupValue: radioDeger,
              title: Text("${ozelGunler[4]}"),
              activeColor:Colors.primaries[Random().nextInt(Colors.primaries.length)],
              onChanged: (val){
                setState(() {
                  radioDeger=val  as int;

                });
              },
            ),
            RadioListTile(
              value: 5,
              groupValue: radioDeger,
              title: Text("${ozelGunler[5]}"),
              activeColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
              onChanged: (val){
                setState(() {
                  radioDeger=val  as int;

                });
              },
            ),
          ],

        ),

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          setState(() {
            kayit(textfieldcontrol.text,tftarih.text,bildirimDeger,ozelGunler[radioDeger]);
            bildirimGosterme();
          });

        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        label: Text("Kaydet"),
        icon: Icon(Icons.bookmark),
      ),
    );
  }
}
