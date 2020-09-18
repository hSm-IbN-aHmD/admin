import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class BrandService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'Brands';

  void createBrand(String name) {
    var id = Uuid();
    String brandId = id.v1();
    _firestore.collection(ref).doc(brandId).set({'BrandName': name});
  }

  Future<List<DocumentSnapshot>> getBrands() {
    return _firestore.collection(ref).get().then((snaps) {
      print(snaps.docs.length);
      return snaps.docs;
    });
  }
}
