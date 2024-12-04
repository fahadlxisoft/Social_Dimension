import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerPage extends StatefulWidget {
  @override
  _FilePickerPageState createState() => _FilePickerPageState();
}

class _FilePickerPageState extends State<FilePickerPage> {
  Uint8List? imageBytes;  // Store image bytes for web platform

  Future<void> pickImage() async {
    // Pick a file using the file picker
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      // Check if the platform is web
      if (kIsWeb) {
        // For web, access the file as bytes
        final fileBytes = result.files.single.bytes;
        if (fileBytes != null) {
          // Use the bytes to display the image
          setState(() {
            imageBytes = fileBytes;
          });
        } else {
          // Handle the case when bytes are null
          setState(() {
            imageBytes = null;
          });
        }
      } else {
        // For mobile, access the file path (which works on mobile platforms)
        final filePath = result.files.single.path;
        if (filePath != null) {
          setState(() {
            imageBytes = null; // Reset imageBytes since we are using path now
          });
          // You can use filePath for mobile-specific code (e.g., Image.file)
        } else {
          // Handle the case when path is null (shouldn't happen on non-web platforms)
          setState(() {
            imageBytes = null;
          });
        }
      }
    } else {
      // Handle the case when no file is selected
      setState(() {
        imageBytes = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick an Image'),
            ),
            if (imageBytes != null)
              kIsWeb
                  ? Image.memory(imageBytes!) // Display using Image.memory for web
                  : Text('Image selected on mobile') // Placeholder for mobile-specific handling
          ],
        ),
      ),
    );
  }
}
