import 'package:eatco_admin/screens/splash.dart';
import 'package:eatco_admin/utils/authservice.dart';
import 'package:eatco_admin/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:eatco_admin/screens/admin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider.value(value: AuthProvider.initialize())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: purple,
      // ),
      //home: AuthService().handleAuth(),
      //home: Home(),
      home: ScreenController(),
    );
  }
}

class ScreenController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.status == Status.Uninitialized) {
      return Splash();
    } else if (auth.loggedIn) {
      return Admin();
    } else {
      return Login();
    }
  }
}

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: LogInScreen(),
//   ));
// }

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       // Initialize FlutterFire
//       future: Firebase.initializeApp(),
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.hasError) {
//           // return SomethingWentWrong();
//           print('Error');
//           return Splash();
//         }
//
//         // Once complete, show your application
//         if (snapshot.connectionState == ConnectionState.done) {
//           return LogInScreen();
//         }
//
//         // Otherwise, show something whilst waiting for initialization to complete
//         print('Loading...');
//         return Splash();
//         //return Loading();
//       },
//     );
//   }
// }
