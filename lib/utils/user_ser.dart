import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatco_admin/utils/user.dart';

class UserServices {
  String collection = "users";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createUser(Map<String, dynamic> values) {
    String id = values["id"];
    // String number = values["number"];
    _firestore.collection(collection).doc(id).set(values);
    // _firestore.collection(collection).document(number).setData(values);
  }

  void updateUserData(Map<String, dynamic> values) {
    _firestore.collection(collection).doc(values['id']).update(values);
    /* _firestore
        .collection(collection)
        .document(values['number'])
        .updateData(values);*/
  }

  Future<UserModel> getUserById(String id) =>
      _firestore.collection(collection).doc(id).get().then((doc) {
        if (doc.data == null) {
          return null;
        }
        return UserModel.fromSnapshot(doc);
      });
}
