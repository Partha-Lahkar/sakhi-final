import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sakhi/models/places.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title,File image, placelocation location) {
    final newPlace = Place(title: title,image: image, location: location);
    state = [newPlace, ...state];
  }
}

final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier,List<Place>>(
  (ref) => UserPlacesNotifier(),
);
