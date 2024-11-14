import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUser extends Equatable {
  final String userId;
  final String email;
  final String firstName;

  const MyUser({
    required this.userId,
    required this.email,
    required this.firstName,
  });

  static const empty = MyUser(
    userId: '',
    email: '',
    firstName: '',
  );

  MyUser copyWith({
    String? userId,
    String? email,
    String? firstName,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      firstName: firstName,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      firstName: entity.firstName,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        firstName,
      ];
}
