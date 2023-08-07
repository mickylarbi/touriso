import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touriso/utils/colors.dart';
import 'package:touriso/utils/routes.dart';

class Src extends StatelessWidget {
  const Src({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor.withOpacity(.1),
            foregroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: primaryColor)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        bottomAppBarTheme: BottomAppBarTheme(color: primaryColor),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.black),
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
