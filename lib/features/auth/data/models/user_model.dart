import 'package:appwrite/models.dart' as models;
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.createdAt,
  });

  factory UserModel.fromAppwriteUser(models.User user) {
    return UserModel(
      id: user.$id,
      email: user.email,
      displayName: user.name.isNotEmpty ? user.name : null,
      photoUrl: null, // Appwrite Account no maneja avatar nativo
      createdAt: DateTime.parse(user.registration),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      createdAt: createdAt,
    );
  }
}
