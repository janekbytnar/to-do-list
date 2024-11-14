import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String userId;
  final String email;
  final String firstName;

  const MyUserEntity({
    required this.userId,
    required this.email,
    required this.firstName,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'] ?? '',
      email: doc['email'] ?? '',
      firstName: doc['firstName'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        firstName,
      ];
}
