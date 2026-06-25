import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:appwrite/appwrite.dart';
import '../models/user_model.dart';
import '../../../../core/constants/app_constants.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Stream<UserModel?> get authStateChanges;
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Account account;
  final StreamController<UserModel?> _authStateController = StreamController<UserModel?>.broadcast();

  AuthRemoteDataSourceImpl(this.account);

  void _emitAuthState(UserModel? user) {
    if (!_authStateController.isClosed) {
      _authStateController.add(user);
    }
  }



  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final user = await account.get();
      final userModel = UserModel.fromAppwriteUser(user);
      _emitAuthState(userModel);
      return userModel;
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: displayName,
      );

      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final userModel = UserModel.fromAppwriteUser(user);
      _emitAuthState(userModel);
      return userModel;
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Error al registrarse: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      final redirectUrl = AppConstants.vercelBaseUrl;
      final recoveryUrl = '$redirectUrl${AppConstants.resetPasswordPath}';
      await account.createRecovery(
        email: email,
        url: recoveryUrl,
      );


    } on AppwriteException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Error al enviar email de recuperación: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await account.deleteSession(sessionId: 'current');
      _emitAuthState(null);
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await account.get();
      return UserModel.fromAppwriteUser(user);
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        return null;
      }
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Error al obtener usuario actual: $e');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;
}
