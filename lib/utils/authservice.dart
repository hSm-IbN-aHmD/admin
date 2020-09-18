import 'dart:async';
import 'package:eatco_admin/screens/admin.dart';
import 'package:eatco_admin/screens/login.dart';
import 'package:eatco_admin/utils/screen_navigation.dart';
import 'package:eatco_admin/utils/user.dart';
import 'package:eatco_admin/utils/user_ser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  static const LOGGED_IN = "loggedIn";
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  Status _status = Status.Uninitialized;

  // Firestore _firestore = Firestore.instance;
  UserServices _userServices = UserServices();
  UserModel _userModel;
  TextEditingController phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  bool loggedIn;
  bool loading = false;

//  getter
  UserModel get userModel => _userModel;

  Status get status => _status;

  User get user => _user;

  AuthProvider.initialize() {
    readPrefs();
  }

  Future<void> readPrefs() async {
    await Future.delayed(Duration(seconds: 3)).then((v) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loggedIn = prefs.getBool(LOGGED_IN) ?? false;

      if (loggedIn) {
        _user = await _auth.currentUser;
        _userModel = await _userServices.getUserById(_user.uid);
        _status = Status.Authenticated;
        notifyListeners();
        return;
      }

      _status = Status.Unauthenticated;
      notifyListeners();
    });
  }

  Future<void> verifyPhoneNumber(BuildContext context, String number) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: number.trim(), // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential.toString() + "lets make this work");
          },
          verificationFailed: (FirebaseAuthException exception) {
            print('${exception.message} + something is wrong');
          });
    } catch (e) {
      handleError(e, context);
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  handleError(error, BuildContext context) {
    print(error);
    errorMessage = error.toString();
    notifyListeners();
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        print("The verification code is invalid");
        Fluttertoast.showToast(msg: "The verification code is invalid");
        break;
      default:
        errorMessage = error.message;
        break;
    }
    notifyListeners();
  }

  void _createUser({String id, String number}) {
    _userServices.createUser({
      "id": id,
      "number": number,
    });
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () async {
                  loading = true;
                  notifyListeners();
                  User user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    _userModel = await _userServices.getUserById(user.uid);
                    if (_userModel == null) {
                      _createUser(id: user.uid, number: user.phoneNumber);
                    }
                    Navigator.of(context).pop();
                    loading = false;
                    notifyListeners();
                    changeScreenReplacement(context, Admin());
                  } else {
                    loading = true;
                    notifyListeners();
                    Navigator.of(context).pop();
                    loading = false;
                    signIn(context);
                  }
                },
              )
            ],
          );
        });
  }

  signIn(BuildContext context) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final UserCredential user = await _auth.signInWithCredential(credential);
      final User currentUser = await _auth.currentUser;
      assert(user.user.uid == currentUser.uid);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(LOGGED_IN, true);
      loggedIn = true;
      if (user != null) {
        _userModel = await _userServices.getUserById(user.user.uid);
        if (_userModel == null) {
          _createUser(id: user.user.uid, number: user.user.phoneNumber);
        }

        loading = false;
        Navigator.of(context).pop();
        changeScreenReplacement(context, Admin());
      }
      loading = false;

      Navigator.of(context).pop();
      changeScreenReplacement(context, Admin());
      notifyListeners();
    } catch (e) {
      print("${e.toString()}");
    }
  }

  Future signOut(BuildContext context) async {
    _status = Status.Unauthenticated;
    loggedIn = false;
    await _auth.signOut();
    Navigator.of(context).pop();
    notifyListeners();
    changeScreenReplacement(context, Login());
    //Navigator.popUntil(context, ModalRoute.withName("/"));
    return Future.delayed(Duration.zero);
  }
}

//import 'package:eatco/scr/screens/dashboard.dart';
/*import 'package:eatco/scr/screens/home.dart';
import 'package:eatco/scr/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  handleAuth() {
    return StreamBuilder(
      stream: _auth.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          //Fluttertoast.showToast(msg: "Login Successful.");
          return Home();
        } else {
          return Login();
        }
      },
    );
  }

  //signout
  signOut() {
    _auth.signOut();
  }

  //signin
  signIn(AuthCredential authCreds) {
    //final currentUser = await
    _auth.signInWithCredential(authCreds);
    //if (currentUser != null) {}
    //final uid = await _auth.getCurrentUID();
    //Fluttertoast.showToast(msg: "Number Verified");
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }

  /*Future<String> getCurrentUID() async {
    return uid = (await _auth.currentUser()).uid;
  }*/
}
*/
