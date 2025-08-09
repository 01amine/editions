import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String studyYear;
  final String specialite;

  const User(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.phoneNumber,
      required this.studyYear,
      required this.specialite});

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phoneNumber,
        studyYear,
        specialite,
      ];
}
