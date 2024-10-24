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
      preferences: List<String>.from(map['preferences']),
      hobbies: List<String>.from(map['hobbies']),
      locationPreference: map['locationPreference'],
      budget: map['budget'],
      genderPreference: map['genderPreference'],
      minAge: map['minAge'],
      maxAge: map['maxAge'],
      petFriendly: map['petFriendly'],
      smokingPreference: map['smokingPreference'],
      cleaningHabits: map['cleaningHabits'],
      sleepingHabits: map['sleepingHabits'],
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
      id: data['id'],
      name: data['name'],
      lastName: data['lastName'],
      email: data['email'],
      description: data['description'],
      dni: data['dni'],
      age: data['age'],
      gender: data['gender'],
      occupation: data['occupation'],
      photo: data['photo'],
      preferences: Preferences.fromJson(data['preferences']),
    );
  }
}
