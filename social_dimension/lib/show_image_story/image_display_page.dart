import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

class ImageDisplayPage extends StatelessWidget {
  const ImageDisplayPage({Key? key, required imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final imagePath = args?['imagePath'] as String?;
    final imageBytes = args?['imageBytes'] as Uint8List?;

    Widget _buildImage() {
      if (imagePath != null && File(imagePath).existsSync()) {
        return Image.file(File(imagePath), fit: BoxFit.contain);
      } else if (imageBytes != null) {
        return Image.memory(imageBytes, fit: BoxFit.contain);
      } else {
        return const Text('No image selected', style: TextStyle(fontSize: 16));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Selected Image')),
      body: Center(child: _buildImage()),
    );
  }
}
