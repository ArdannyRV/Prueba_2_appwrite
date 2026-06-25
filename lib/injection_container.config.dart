// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import 'core/network/network_info.dart' as _i1054;
import 'features/auth/data/datasources/auth_remote_data_source.dart'
    as _i796;
import 'features/auth/data/repositories/auth_repository_impl.dart' as _i529;
import 'features/auth/domain/repositories/auth_repository.dart' as _i742;
import 'features/auth/domain/usecases/get_current_user.dart' as _i833;
import 'features/auth/domain/usecases/reset_password.dart' as _i420;
import 'features/auth/domain/usecases/sign_in.dart' as _i390;
import 'features/auth/domain/usecases/sign_out.dart' as _i71;
import 'features/auth/domain/usecases/sign_up.dart' as _i341;
import 'features/auth/presentation/bloc/auth_bloc.dart' as _i1026;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i1054.NetworkInfo>(
        () => _i1054.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i796.AuthRemoteDataSource>(
        () => _i796.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i742.AuthRepository>(() => _i529.AuthRepositoryImpl(
          remoteDataSource: gh<_i796.AuthRemoteDataSource>(),
          networkInfo: gh<_i1054.NetworkInfo>(),
        ));
    gh.factory<_i390.SignIn>(() => _i390.SignIn(gh<_i742.AuthRepository>()));
    gh.factory<_i341.SignUp>(() => _i341.SignUp(gh<_i742.AuthRepository>()));
    gh.factory<_i420.ResetPassword>(
        () => _i420.ResetPassword(gh<_i742.AuthRepository>()));
    gh.factory<_i71.SignOut>(() => _i71.SignOut(gh<_i742.AuthRepository>()));
    gh.factory<_i833.GetCurrentUser>(
        () => _i833.GetCurrentUser(gh<_i742.AuthRepository>()));
    gh.factory<_i1026.AuthBloc>(() => _i1026.AuthBloc(
          signIn: gh<_i390.SignIn>(),
          signUp: gh<_i341.SignUp>(),
          resetPassword: gh<_i420.ResetPassword>(),
          signOut: gh<_i71.SignOut>(),
          getCurrentUser: gh<_i833.GetCurrentUser>(),
        ));
    return this;
  }
}
