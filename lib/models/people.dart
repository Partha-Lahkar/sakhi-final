// models/people.dart

class Person {
  int? id;
  String name;
  String relationship;
  String photoPath;
  String phoneNumber;
  String address;

  Person({
    this.id,
    required this.name,
    required this.relationship,
    required this.photoPath,
    required this.phoneNumber,
    required this.address,
  });

  // Convert a Person object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'relationship': relationship,
      'photoPath': photoPath,
      'phoneNumber': phoneNumber,
      'address': address,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Extract a Person object from a Map object
  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(id : map['id'],
    name : map['name'],
    relationship : map['relationship'],
    photoPath : map['photoPath'],
    phoneNumber : map['phoneNumber'],
    address : map['address']);
  }
}
