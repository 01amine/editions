import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.studyYear,
    required super.specialite,
    required super.area,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      studyYear: json['study_year'],
      specialite: json['specialite'],
      area: json['area'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'study_year': studyYear,
      'specialite': specialite,
      'area': area,
    };
  }
}
