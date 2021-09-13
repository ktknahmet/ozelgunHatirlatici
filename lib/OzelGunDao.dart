import 'package:ozelgunler/VeritabaniYardimcisi.dart';
import 'package:ozelgunler/dinamikListe.dart';

class OzelGunDao {
  Future<List<dinamikListe>> tumListe() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT * FROM tablo");
    return List.generate(maps.length, (index) {
      var satir = maps[index];
      return dinamikListe(satir["id"], satir["isim"], satir["tarih"], satir["bildirim"], satir["gunturu"]);
    });
  }
  Future<void> ozelGunEkle(String isim,String tarih,String bildirim,String gunturu) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var bilgiler = Map<String,dynamic>();
    bilgiler["isim"]=isim;
    bilgiler["tarih"]=tarih;
    bilgiler["bildirim"]=bildirim;
    bilgiler["gunturu"]=gunturu;

    await db.insert("tablo", bilgiler);
  }
  Future<void> ozelGunGuncelle(int id,String isim,String tarih,String bildirim,String gunturu) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var bilgiler = Map<String,dynamic>();
    bilgiler["isim"]=isim;
    bilgiler["tarih"]=tarih;
    bilgiler["bildirim"]=bildirim;
    bilgiler["gunturu"]=gunturu;

    await db.update ("tablo", bilgiler,where:"id=?",whereArgs:[id]);
  }
  Future<void> ozelGunSil(int id,) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();


    await db.delete("tablo", where:"id=?",whereArgs:[id]);
  }
}