import 'dart:io';
import 'package:flutter/material.dart';

class ChooseImageDialog extends StatelessWidget {
  final File? image;
  final Future<void> Function() onPickImageFromGallery;
  final Future<void> Function() onPickImageFromCamera;

  const ChooseImageDialog({
    super.key,
    this.image,
    required this.onPickImageFromGallery,
    required this.onPickImageFromCamera,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                    onPressed: () async {
                      await onPickImageFromGallery();
                      Navigator.pop(context);
                    },
                    child: const Text("Gallery")),
                MaterialButton(
                    onPressed: () async {
                      await onPickImageFromCamera();
                      Navigator.pop(context);
                    },
                    child: const Text("Camera")),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: image != null
            ? FileImage(image!)
            : const AssetImage('assets/images/newcompass_logo.png'),
      ),
    );
  }
}
