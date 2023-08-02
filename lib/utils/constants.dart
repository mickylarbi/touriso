import 'package:flutter/material.dart';

String kLogoTag = 'logoTag';
String searchHeroTag = 'search';
String ghanaCedi = 'GH₵';

Color kBackgroundColor = const Color(0xFFF9F9F9);

Duration ktimeout = const Duration(seconds: 30);

TextStyle get labelTextStyle => const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

class EditObject {
  EditAction action;
  dynamic object;

  EditObject({required this.action, this.object});
}

enum EditAction { add, edit, delete }

String? kpatientName;
