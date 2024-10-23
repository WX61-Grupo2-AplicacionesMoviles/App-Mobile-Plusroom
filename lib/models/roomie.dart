class Roomie {
  final String name;
  final String lastName;
  final String email;
  final String? description;
  final String dni;
  final int age;
  final String gender;
  final String occupation; // student, professional
  final bool? pets;
  final bool? smoker;
  final String photo;
  // final bool searchRoomie;
  // final String? receivedMessages, sentMesages; // Message model
  // final String? listNotification; // Notification model

  Roomie({
    required this.name,
    required this.lastName,
    required this.email,
    // if description empty, show "No description"
    this.description = "No description",
    required this.dni,
    required this.age,
    required this.gender,
    required this.occupation,
    this.pets,
    this.smoker,
    required this.photo,
    // required this.searchRoomie,
    // this.receivedMessages,
    // this.sentMesages,
    // this.listNotification
  });

  // method to map data from json to Roomie object
  factory Roomie.fromMap(Map<String, dynamic> data) {
    return Roomie(
      name: data['name'],
      lastName: data['lastName'],
      email: data['email'],
      description: data['description'],
      dni: data['dni'],
      age: data['age'],
      gender: data['gender'],
      occupation: data['occupation'],
      pets: data['pets'],
      smoker: data['smoker'],
      photo: data['photo'],
      // searchRoomie: data['searchRoomie'],
    );
  }

}
