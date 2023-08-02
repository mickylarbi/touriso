import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:touriso/utils/colors.dart';
import 'package:touriso/utils/text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.autoFocus = false,
    required this.controller,
    this.focusNode,
    required this.hintText,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.textAlign,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.initialValue,
  });

  final bool autoFocus;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final TextAlign? textAlign;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autoFocus,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      style: bodyMedium(context),
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          isDense: true,
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[100]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          prefixIcon: prefixIcon,
          prefixIconColor: Colors.grey,
          prefix: prefix,
          suffix: suffix,
          suffixIcon: suffixIcon),
      maxLines: maxLines,
      minLines: minLines,
      textAlign: textAlign ?? TextAlign.start,
      initialValue: initialValue,
    );
  }
}

class PasswordTextFormField extends StatefulWidget {
  final String? hintText;
  final TextEditingController controller;
  const PasswordTextFormField({
    Key? key,
    this.hintText = 'Password',
    required this.controller,
  }) : super(key: key);

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureText,
      builder: (context, value, child) {
        return TextFormField(
          controller: widget.controller,
          obscureText: value,
          style: bodyMedium(context),
          decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[100]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              prefixIconColor: Colors.grey,
              suffixIcon: IconButton(
                icon: Icon(value
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded),
                onPressed: () {
                  obscureText.value = !obscureText.value;
                },
              ),
              suffixIconColor: primaryColor),
        );
      },
    );
  }

  @override
  void dispose() {
    obscureText.dispose();
    super.dispose();
  }
}

class EditDetailsTextFormField extends StatelessWidget {
  const EditDetailsTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.maxLines,
    this.minLines,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String labelText;
  final int? maxLines;
  final int? minLines;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: bodySmall(context)),
        CustomTextFormField(
          controller: controller,
          hintText: '',
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: minLines,
          prefixIcon: prefixIcon,
          prefix: prefix,
          suffix: suffix,
        ),
      ],
    );
  }
}

class GeoLocationTextFields extends StatefulWidget {
  const GeoLocationTextFields({super.key, required this.geoLocationNotifier});
  final ValueNotifier<GeoPoint?> geoLocationNotifier;

  @override
  State<GeoLocationTextFields> createState() => _GeolocationTextFieldsState();
}

class _GeolocationTextFieldsState extends State<GeoLocationTextFields> {
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  setLocation() {
    if (double.tryParse(latitudeController.text.trim()) == null ||
        double.tryParse(longitudeController.text.trim()) == null) {
      widget.geoLocationNotifier.value = null;
    } else {
      widget.geoLocationNotifier.value = GeoPoint(
        double.parse(latitudeController.text.trim()),
        double.parse(longitudeController.text.trim()),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.geoLocationNotifier.value != null) {
      latitudeController.text =
          widget.geoLocationNotifier.value!.latitude.toString();
      longitudeController.text =
          widget.geoLocationNotifier.value!.longitude.toString();
    }

    latitudeController.addListener(() {
      setLocation();
    });
    longitudeController.addListener(() {
      setLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Geo location', style: bodySmall(context)),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: latitudeController,
                hintText: 'Latitude',
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                suffix: const Text('°'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomTextFormField(
                controller: longitudeController,
                hintText: 'Longitude',
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                suffix: const Text('°'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
