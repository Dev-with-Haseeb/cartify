import 'package:cartify/providers/cart_provider.dart';
import 'package:cartify/providers/product_provider.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:cartify/screens/splash_screen/splash_screen.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        primaryColor: AppColors.mainColor,
        textTheme: GoogleFonts.latoTextTheme(),
        textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: Colors.transparent,
            cursorColor: AppColors.mainColor),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainColor, width: 2),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.mainColor),
          ),
          floatingLabelStyle: TextStyle(color: AppColors.mainColor),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
