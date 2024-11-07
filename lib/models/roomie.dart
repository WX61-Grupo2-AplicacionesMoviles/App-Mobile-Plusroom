class Preferences {
  final List<String> preferences;
  final List<String> hobbies;
  final String locationPreference;
  final double budget;
  final String genderPreference;
  final int minAge;
  final int maxAge;
  final bool petFriendly;
  final bool smokingPreference;
  final String cleaningHabits;
  final String sleepingHabits;

  Preferences({
    required this.preferences,
    required this.hobbies,
    required this.locationPreference,
    required this.budget,
    required this.genderPreference,
    required this.minAge,
    required this.maxAge,
    required this.petFriendly,
    required this.smokingPreference,
    required this.cleaningHabits,
    required this.sleepingHabits,
  });

  factory Preferences.fromJson(Map<String, dynamic> map) {
    return Preferences(
      preferences: List<String>.from(map['preferences']) ?? [],
      hobbies: List<String>.from(map['hobbies']) ?? [],
      locationPreference: map['locationPreference'] ?? '',
      budget: map['budget'] ?? 0.0,
      genderPreference: map['genderPreference'] ?? '',
      minAge: map['minAge'] ?? 0,
      maxAge: map['maxAge'] ?? 0,
      petFriendly: map['petFriendly'] ?? false,
      smokingPreference: map['smokingPreference'] ?? false,
      cleaningHabits: map['cleaningHabits'] ?? '',
      sleepingHabits: map['sleepingHabits'] ?? '',
    );
  }

  @override
  String toString() {
    return "Preferences{preferences: $preferences, hobbies: $hobbies, "
        "locationPreference: $locationPreference, budget: $budget, "
        "genderPreference: $genderPreference, minAge: $minAge, maxAge: $maxAge, "
        "petFriendly: $petFriendly, smokingPreference: $smokingPreference, "
        "cleaningHabits: $cleaningHabits, sleepingHabits: $sleepingHabits}";
  }

  Map<String, dynamic> toJson() {
    return {
      'preferences': preferences,
      'hobbies': hobbies,
      'locationPreference': locationPreference,
      'budget': budget,
      'genderPreference': genderPreference,
      'minAge': minAge,
      'maxAge': maxAge,
      'petFriendly': petFriendly,
      'smokingPreference': smokingPreference,
      'cleaningHabits': cleaningHabits,
      'sleepingHabits': sleepingHabits,
    };
  }
}

class Tenant {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String description;
  final String dni;
  final int age;
  final String gender;
  final String occupation;
  final String photo;
  Preferences? preferences;

  Tenant({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.description,
    required this.dni,
    required this.age,
    required this.gender,
    required this.occupation,
    required this.photo,
    this.preferences,
  });

  factory Tenant.fromJson(Map<String, dynamic> data) {
    return Tenant(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      description: data['description'] ?? '',
      dni: data['dni'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      occupation: data['occupation'] ?? '',
      photo: data['photo'] ?? '',
      preferences: data['preferences'] != null ? Preferences.fromJson(data['preferences']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'description': description,
      'dni': dni,
      'age': age,
      'gender': gender,
      'occupation': occupation,
      'photo': photo,
      'preferences': preferences?.toJson(),
    };
  }

  @override
  String toString() {
    return "Tenant{id: $id, name: $name, lastName: $lastName, email: $email, "
        "description: $description, dni: $dni, age: $age, gender: $gender, "
        "occupation: $occupation, photo: $photo, preferences: $preferences}";
  }
}
