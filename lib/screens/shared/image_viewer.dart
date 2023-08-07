import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InteractiveViewer(
        child: Center(
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
