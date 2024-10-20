import 'package:asia_cargo_ashir_11_boss_office/model/bilty.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  static const collectionBiltyInfo = 'biltyInfo';

  final biltyCollection =
      FirebaseFirestore.instance.collection(collectionBiltyInfo);

  Future<bool> addBilty(Bilty bilty) async {
    try {
      await biltyCollection
          .doc(bilty.biltyNumber.toString())
          .set(bilty.toMap());
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> removeBilty(Bilty bilty) async{
    try {
      await biltyCollection
          .doc(bilty.biltyNumber.toString())
          .delete();
    } catch (e) {
      return false;
    }
    return true;
  }
  
}
