import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:sakhi/models/places.dart';
import 'package:sakhi/providers/user_places.dart';
import 'package:sakhi/widgets/image_input.dart';
import 'package:sakhi/widgets/location_input.dart';

class AddPlacescreen extends ConsumerStatefulWidget {
  const AddPlacescreen({super.key});
  @override
  ConsumerState<AddPlacescreen> createState() {
    return _AddPlacescreenState();
  }
}

class _AddPlacescreenState extends ConsumerState<AddPlacescreen> {
  final _titlecontroller = TextEditingController();
  File? _selectedImage;
  placelocation? _selectedlocation;

  void _saveplace() {
    final enteredtitle = _titlecontroller.text;
    if (enteredtitle.isEmpty || _selectedImage == null||_selectedlocation==null) {
      return;
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredtitle, _selectedImage!,_selectedlocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                label: Text('Title'),
              ),
              controller: _titlecontroller,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),

            //image input
            const SizedBox(height: 10),
            LocationInput(
              onSelectlocation: (location) {
                _selectedlocation = location;
              },
            ),
            Imageinput(
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),

            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              onPressed: _saveplace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
