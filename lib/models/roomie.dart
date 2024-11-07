class Preferences {
  final List<String> preferences;
  final List<String> hobbies;
  final String locationPreference;
  final int budget;
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
      preferences: List<String>.from(map['preferences'] ?? []),
      hobbies: List<String>.from(map['hobbies'] ?? []),
      locationPreference: map['locationPreference'] ?? '',
      budget: map['budget'] ?? 0,
      genderPreference: map['genderPreference'] ?? 'Any',
      minAge: map['minAge'] ?? 18,
      maxAge: map['maxAge'] ?? 99,
      petFriendly: map['petFriendly'] ?? false,
      smokingPreference: map['smokingPreference'] ?? false,
      cleaningHabits: map['cleaningHabits'] ?? 'Unknown',
      sleepingHabits: map['sleepingHabits'] ?? 'Unknown',
    );
  }

  // Constructor vacío para cuando preferences no está presente en los datos
  factory Preferences.empty() {
    return Preferences(
      preferences: [],
      hobbies: [],
      locationPreference: '',
      budget: 0,
      genderPreference: 'Any',
      minAge: 18,
      maxAge: 99,
      petFriendly: false,
      smokingPreference: false,
      cleaningHabits: 'Unknown',
      sleepingHabits: 'Unknown',
    );
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
  final Preferences preferences;

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
    required this.preferences,
  });

  factory Tenant.fromJson(Map<String, dynamic> data) {
    return Tenant(
      id: data['id'] ?? 0,
      name: data['name'] ?? 'Unknown',
      lastName: data['lastName'] ?? 'Unknown',
      email: data['email'] ?? 'No email',
      description: data['description'] ?? 'No description',
      dni: data['dni'] ?? 'No DNI',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? 'Unknown',
      occupation: data['occupation'] ?? 'Unknown',
      photo: data['photo'] ?? '',
      preferences: data.containsKey('preferences') && data['preferences'] != null
          ? Preferences.fromJson(data['preferences'])
          : Preferences.empty(), // Usa `Preferences.empty()` si falta `preferences`
    );
  }
}
