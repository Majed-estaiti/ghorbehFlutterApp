import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Ghorbeh/global/global.dart';
import 'package:Ghorbeh/splashScreen/splash_secreen.dart';
export 'package:web_ffi/web_ffi.dart' if (dart.library.ffi) 'dart:ffi';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var device=["E643198AD8B4BE6ED6238670AFEB9B8F"];
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration =RequestConfiguration(testDeviceIds: device);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);


 /* await Firebase.initializeApp(
   options: FirebaseOptions(
      apiKey: "AIzaSyDr7Q9p-4GBBFu0BZ7LeI_IGI14i1HNcPA",
      appId: "1:1019582155863:web:eb55a5e6ab00df30ec6712",
      messagingSenderId: "1019582155863",
      projectId: "ghorbehflutter-a4a45",
    ),
  );

  */



  runApp(ghorbeh());
}

class ghorbeh extends StatelessWidget {
  const ghorbeh({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ghorbeh",
      theme: ThemeData(primaryColor: Colors.white70),
      debugShowCheckedModeBanner: false,
      home: spalshsecreen(),
    );
  }
}
