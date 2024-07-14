import 'package:firebase_database/firebase_database.dart';
import 'package:sakhi/models/nurses.dart'; // Import your Nurse model

class NurseService {
  final databaseReference = FirebaseDatabase.instance.reference();

  Stream<List<Nurse>> getNurses() {
    return databaseReference.onValue.map((event) {
      List<Nurse> nurses = [];
      var snapshot = event.snapshot;

      if (snapshot.value != null) {
        List<dynamic>? nursesData = snapshot.value as List<dynamic>?;

        if (nursesData != null) {
          nursesData.forEach((nurseData) {
            if (nurseData is Map<dynamic, dynamic>) {
              // Assuming each nurseData has a 'key' field in Firebase
              String key = nurseData['key'];
              nurses.add(Nurse.fromJson({...nurseData, 'key': key}));
            }
          });
        }
      }

      return nurses;
    });
  }
}
