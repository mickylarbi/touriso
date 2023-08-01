import 'package:flutter/material.dart';

TextTheme textTheme(context) => Theme.of(context).textTheme;

TextStyle bodyLarge(context) =>
    bodyMedium(context).copyWith(fontSize: bodyMedium(context).fontSize! + 3);
TextStyle bodyMedium(context) => textTheme(context).bodyMedium!;
TextStyle bodySmall(context) => textTheme(context).bodySmall!;

TextStyle displayLarge(context) => textTheme(context).displayLarge!;
TextStyle displayMedium(context) => textTheme(context).displayMedium!;
TextStyle displaySmall(context) => textTheme(context).displaySmall!;

TextStyle headlineLarge(context) => textTheme(context).headlineLarge!;
TextStyle headlineMedium(context) => textTheme(context).headlineMedium!;
TextStyle headlineSmall(context) => textTheme(context).headlineSmall!;

TextStyle labelLarge(context) => textTheme(context).labelLarge!;
TextStyle labelMedium(context) => textTheme(context).labelMedium!;
TextStyle labelSmall(context) => textTheme(context).labelSmall!;

TextStyle titleLarge(context) => textTheme(context).titleLarge!;
TextStyle titleMedium(context) => textTheme(context).titleMedium!;
TextStyle titleSmall(context) => textTheme(context).titleSmall!;
