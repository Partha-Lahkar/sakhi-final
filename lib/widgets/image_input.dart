import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Imageinput extends StatefulWidget {
  const Imageinput({super.key, required this.onPickImage});
  final void Function(File image) onPickImage;
  @override
  State<Imageinput> createState() {
    return _ImageinputState();
  }
}

class _ImageinputState extends State<Imageinput> {
  File? _selectedimage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final Pickedimage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ); //you can also choose gallery

    if (Pickedimage == null) {
      return;
    }
    setState(() {
      _selectedimage = File(Pickedimage.path);
    });

    widget.onPickImage(_selectedimage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: const Icon(Icons.camera),
      label: const Text('Take picture'),
      onPressed: _takePicture,
    );
    if (_selectedimage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedimage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      )),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
