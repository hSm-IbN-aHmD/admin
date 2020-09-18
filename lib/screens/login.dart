import 'package:eatco_admin/screens/splash.dart';
import 'package:eatco_admin/utils/authservice.dart';
import 'package:eatco_admin/utils/color_util.dart';
import 'package:eatco_admin/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          child: auth.loading
              ? Splash()
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "images/eatco_logo.jpg",
                        width: 400,
                      ),
                    ],
                  ),
                  //SizedBox(height: 10),
                  /*CustomText(
                    text: "eatco.in",
                    size: 30,
                    weight: FontWeight.bold,
                    color: red.shade700,
                  ),*/
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(color: black, width: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: grey.withOpacity(0.3),
                                offset: Offset(2, 1),
                                blurRadius: 2)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          controller: number,
                          decoration: InputDecoration(
                              icon: Icon(Icons.phone_android, color: grey),
                              border: InputBorder.none,
                              hintText: "+91 Your Mobile Number",
                              hintStyle: TextStyle(
                                  color: grey,
                                  fontFamily: "Sen",
                                  fontSize: 18)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "After entering your Phone Number, Click on Verify to Authenticate yourself! Then wait up to 20 seconds to get the OTP and proceed.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: grey),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomButton(
                      msg: "Verify",
                      onTap: () {
                        auth.verifyPhoneNumber(context, number.text);
                      })
                ]),
        ),
      ),
    );
  }
}

/*import 'package:eatco/scr/helpers/style.dart';
import 'package:eatco/scr/providers/authservice.dart';
//import 'package:eatco/scr/screens/home.dart';
import 'package:eatco/scr/widgets/custom_text.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;
  bool codeSent = false;

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = _auth.currentUser();
    if (user != null) {
      loggedInUser = user as FirebaseUser;
      print(loggedInUser.phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        elevation: 0.0,
        backgroundColor: red.shade700,
        title: Align(
          alignment: Alignment.center,
          child: CustomText(
            text: "Number Authentication",
            color: white,
            size: 20,
            weight: FontWeight.bold,
          ),
        ),
      ),*/
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/eatco_logo1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 30.0, 10.0),
                  child: CustomText(
                    text: 'Enter your number(with country code)',
                    size: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration:
                        InputDecoration(hintText: 'eg:+91 Your Mobile Number '),
                    onChanged: (val) {
                      setState(() {
                        this.phoneNo = val;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: 'Enter OTP'),
                    onChanged: (val) {
                      setState(() {
                        this.smsCode = val;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
                  child: Container(
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                        color: red.shade700,
                        borderRadius: BorderRadius.circular(10)),
                    child: RaisedButton(
                      color: red.shade700,
                      child: Center(
                        child: codeSent
                            ? CustomText(
                                text: 'Verify',
                                color: white,
                              )
                            : CustomText(
                                text: 'Sent OTP',
                                color: white,
                              ),
                      ),
                      onPressed: () async {
                        if (codeSent) {
                          _firestore
                              .collection('users')
                              .add({'phonenumber': phoneNo});
                          Fluttertoast.showToast(msg: "Number Verified");
                          AuthService().signInWithOTP(smsCode, verificationId);
                          if (this.smsCode == null) {
                            Fluttertoast.showToast(msg: "Number not Verified.");
                          }
                        } else {
                          verifyPhone(phoneNo);
                          if (this.phoneNo == null) {
                            Fluttertoast.showToast(msg: "Enter your Number.");
                          } else {
                            int len = this.phoneNo.length;
                            if (len != 13) {
                              Fluttertoast.showToast(
                                  msg: "Number not Verified.");
                            } else {
                              Fluttertoast.showToast(msg: "OTP Sent.");
                            }
                            //Fluttertoast.showToast(msg: "OTP Sent");
                          }
                          //Fluttertoast.showToast(msg: "Number not Verified");
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
*/
/*import 'package:eatco/scr/helpers/style.dart';
import 'package:eatco/scr/providers/authservice.dart';
import 'package:eatco/scr/screens/splash.dart';
import 'package:eatco/scr/widgets/custom_button.dart';
import 'package:eatco/scr/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          child: auth.loading
              ? Splash()
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "images/eatco_logo1.jpg",
                        width: 160,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomText(
                      text: "Corona Out", size: 28, weight: FontWeight.bold),
                  SizedBox(height: 5),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "Welcome to the"),
                    TextSpan(
                        text: " Corona out",
                        style: TextStyle(color: red.shade700)),
                    TextSpan(text: " app"),
                  ], style: TextStyle(color: black))),
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(color: black, width: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: grey.withOpacity(0.3),
                                offset: Offset(2, 1),
                                blurRadius: 2)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          controller: number,
                          decoration: InputDecoration(
                              icon: Icon(Icons.phone_android, color: grey),
                              border: InputBorder.none,
                              hintText: "+91 0000000000",
                              hintStyle: TextStyle(
                                  color: grey,
                                  fontFamily: "Sen",
                                  fontSize: 18)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "After entering your phone number, click on verify to authenticate yourself! Then wait up to 20 seconds to get th OTP and procede",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: grey),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomButton(
                      msg: "Verify",
                      onTap: () {
                        auth.verifyPhoneNumber(context, number.text);
                      })
                ]),
        ),
      ),
    );
  }
}*/

/*/*import 'package:eatco/scr/helpers/style.dart';
import 'package:eatco/scr/providers/authservice.dart';
//import 'package:eatco/scr/screens/home.dart';
import 'package:eatco/scr/widgets/custom_text.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';*/

/*class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;
  bool codeSent = false;

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = _auth.currentUser();
    if (user != null) {
      loggedInUser = user as FirebaseUser;
      print(loggedInUser.phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        elevation: 0.0,
        backgroundColor: red.shade700,
        title: Align(
          alignment: Alignment.center,
          child: CustomText(
            text: "Number Authentication",
            color: white,
            size: 20,
            weight: FontWeight.bold,
          ),
        ),
      ),*/
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/eatco_logo1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 30.0, 10.0),
                  child: CustomText(
                    text: 'Enter your number(with country code)',
                    size: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration:
                        InputDecoration(hintText: 'eg:+91 Your Mobile Number '),
                    onChanged: (val) {
                      setState(() {
                        this.phoneNo = val;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: 'Enter OTP'),
                    onChanged: (val) {
                      setState(() {
                        this.smsCode = val;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0.0),
                  child: Container(
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                        color: red.shade700,
                        borderRadius: BorderRadius.circular(10)),
                    child: RaisedButton(
                      color: red.shade700,
                      child: Center(
                        child: codeSent
                            ? CustomText(
                                text: 'Verify',
                                color: white,
                              )
                            : CustomText(
                                text: 'Sent OTP',
                                color: white,
                              ),
                      ),
                      onPressed: () async {
                        if (codeSent) {
                          _firestore
                              .collection('users')
                              .add({'phonenumber': phoneNo});
                          Fluttertoast.showToast(msg: "Number Verified");
                          AuthService().signInWithOTP(smsCode, verificationId);
                          if (this.smsCode == null) {
                            Fluttertoast.showToast(msg: "Number not Verified.");
                          }
                        } else {
                          verifyPhone(phoneNo);
                          if (this.phoneNo == null) {
                            Fluttertoast.showToast(msg: "Enter your Number.");
                          } else {
                            int len = this.phoneNo.length;
                            if (len != 13) {
                              Fluttertoast.showToast(
                                  msg: "Number not Verified.");
                            } else {
                              Fluttertoast.showToast(msg: "OTP Sent.");
                            }
                            //Fluttertoast.showToast(msg: "OTP Sent");
                          }
                          //Fluttertoast.showToast(msg: "Number not Verified");
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}*/

/*class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /*final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;
  bool loading = false;
  bool isLogedin = false;*/

  String phoneNo;
  String smsCode;
  String verificationId;

  /* @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    setState(() {
      loading = true;
    });

    preferences = await SharedPreferences.getInstance();
    isLogedin = await googleSignIn.isSignedIn();
    if (isLogedin) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }

    setState(() {
      loading = false;
    });
  }*/

  Future<void> verifyPhone() async {
    /*preferences = await SharedPreferences.getInstance();

    setState(() {
      loading = true;
    });
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;
    if (firebaseUser != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        //user insertion
        Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .setData({
          "id": firebaseUser.uid,
          "username": firebaseUser.displayName,
          "profilePicture": firebaseUser.photoUrl
        });

        await preferences.setString("id", firebaseUser.uid);
        await preferences.setString("username", firebaseUser.displayName);
        await preferences.setString("photoUrl", firebaseUser.displayName);
      } else {
        await preferences.setString("id", documents[0]['id']);
        await preferences.setString("username", documents[0]['username']);
        await preferences.setString("photoUrl", documents[0]['photoUrl']);
      }

      Fluttertoast.showToast(msg: "Login Successful");
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      Fluttertoast.showToast(msg: "Login Failed");
    }*/
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (string verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      print('Verified');
    };
    final PhoneVerificationFailed verFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verFailed);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return ShowDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter sms code'),
          content: TextField(
            onChanged: (value) {
              this.smsCode = value;
            },
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            FlatButton(
              child: CustomText(
                text: 'Done',
              ),
              onPressed: () {
                FirebaseAuth.instance.currentUser().then((user) {
                  if (user != null) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  } else {
                    Navigator.of(context).pop();
                  }
                });
              },
            )
          ],
        );
      },
    );
  }

  signIn(){
    FirebaseAuth.instance.signInWithPhoneNumber(
        verificationId:verificationId,
    smsCode:smsCode).then((user){})
  }

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red.shade700,
        centerTitle: true,
        title: CustomText(
          text: "Login",
          color: white,
          size: 20,
          weight: FontWeight.bold,
        ),
        elevation: 0.5,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration:
                    InputDecoration(hintText: 'Enter your phone Number'),
                onChanged: (value) {
                  this.phoneNo = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: verifyPhone,
                child: CustomText(
                  text: 'Verify',
                  color: white,
                ),
                elevation: 7.0,
                color: red.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
*/
