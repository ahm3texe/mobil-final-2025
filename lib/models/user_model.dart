// lib/models/user_model.dart

class UserModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String birthPlace;
  final String city;

  UserModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.birthPlace,
    required this.city,
  });

  /// SharedPreferences’a yazmak için Map’e dönüştür
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'birthPlace': birthPlace,
      'city': city,
    };
  }

  /// SharedPreferences’tan gelen Map’i UserModel’e dönüştür
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      password: map['password'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      birthDate: DateTime.parse(map['birthDate'] as String),
      birthPlace: map['birthPlace'] as String,
      city: map['city'] as String,
    );
  }
}
