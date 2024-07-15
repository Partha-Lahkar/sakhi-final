class Medicine {
  int? id;
  String name;
  String photoPath;
  List<int> daysToTake;
  List<String> timesToTake;

  Medicine({
    this.id,
    required this.name,
    required this.photoPath,
    required this.daysToTake,
    required this.timesToTake,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoPath': photoPath,
      'daysToTake': daysToTake.join(','), // Store days as comma-separated string
      'timesToTake': timesToTake.join(','), // Store times as comma-separated string
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      photoPath: map['photoPath'],
      daysToTake: (map['daysToTake'] as String).split(',').map((e) => int.parse(e)).toList(),
      timesToTake: (map['timesToTake'] as String).split(','),
    );
  }
}
