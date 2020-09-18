import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:eatco_admin/utils/color_util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  File imageFile;
  var formKey = GlobalKey<FormState>();
  String name;
  Float price, qty1, qty2, qty3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: purple,
        title: Text(
          "Add Products",
          style: TextStyle(color: white),
        ),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 15)),
              Container(
                child: imageFile == null
                    ? FlatButton(
                        onPressed: () {
                          _showDialog();
                        },
                        child: Icon(
                          Icons.add_a_photo,
                          size: 80,
                          color: purple,
                        ),
                      )
                    : Image.file(
                        imageFile,
                        width: 400,
                        height: 400,
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Theme(
                      data: ThemeData(
                        hintColor: grey,
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please write name";
                          } else {
                            name = value;
                          }
                          return null;
                        },
                        style: TextStyle(color: grey),
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: Theme(
                      data: ThemeData(
                        hintColor: grey,
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please write Price";
                          } else {
                            price = value as Float;
                          }
                        },
                        style: TextStyle(color: grey),
                        decoration: InputDecoration(
                          labelText: "Price",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: Theme(
                      data: ThemeData(
                        hintColor: grey,
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please write qty1";
                          } else {
                            qty1 = value as Float;
                          }
                        },
                        style: TextStyle(color: grey),
                        decoration: InputDecoration(
                          labelText: "Qty1",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: Theme(
                      data: ThemeData(
                        hintColor: grey,
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please write qty2";
                          } else {
                            qty2 = value as Float;
                          }
                        },
                        style: TextStyle(color: grey),
                        decoration: InputDecoration(
                          labelText: "Qty2",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 1,
                    child: Theme(
                      data: ThemeData(
                        hintColor: grey,
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please write qty3";
                          } else {
                            qty3 = value as Float;
                          }
                        },
                        style: TextStyle(color: grey),
                        decoration: InputDecoration(
                          labelText: "Qty3",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: grey, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  if (imageFile == null) {
                    Fluttertoast.showToast(
                        msg: "Please select an image",
                        gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_LONG,
                        timeInSecForIosWeb: 2);
                  } else {
                    Fluttertoast.showToast(msg: "Image Uploaded Successfully");
                    upload();
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: purple,
                child: Text(
                  "Upload",
                  style: TextStyle(fontSize: 18, color: white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text("Choose Photo from"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      openGallery();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  GestureDetector(
                    child: Text('Camera'),
                    onTap: () {
                      openCamera();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> openGallery() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
  }

  Future<void> openCamera() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
  }

  Future<void> upload() async {
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(new DateTime.now().millisecondsSinceEpoch.toString() +
            "." +
            imageFile.path);
    StorageUploadTask uploadTask = reference.putFile(imageFile);

    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = imageUrl.toString();
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child("vegetables");
    String uploadId = databaseReference.push().key;
    HashMap map = new HashMap();
    map["name"] = name;
    map["price"] = price;
    map["qty1"] = qty1;
    map["qty2"] = qty2;
    map["qty3"] = qty3;
    map["imgUrl"] = url;

    databaseReference.child(uploadId).set(map);
  }
}
