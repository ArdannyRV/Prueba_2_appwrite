// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:appwrite/appwrite.dart' as _i317;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:elecciones/core/network/network_info.dart' as _i505;
import 'package:elecciones/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i383;
import 'package:elecciones/features/auth/data/repositories/auth_repository_impl.dart'
    as _i12;
import 'package:elecciones/features/auth/domain/repositories/auth_repository.dart'
    as _i638;
import 'package:elecciones/features/auth/domain/usecases/get_current_user.dart'
    as _i496;
import 'package:elecciones/features/auth/domain/usecases/sign_in.dart' as _i1051;
import 'package:elecciones/features/auth/domain/usecases/sign_out.dart' as _i427;
import 'package:elecciones/features/auth/domain/usecases/sign_up.dart' as _i369;
import 'package:elecciones/features/auth/presentation/bloc/auth_bloc.dart'
    as _i746;

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
    gh.lazySingleton<_i505.NetworkInfo>(
        () => _i505.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i383.AuthRemoteDataSource>(
        () => _i383.AuthRemoteDataSourceImpl(gh<_i317.Account>()));
    gh.lazySingleton<_i638.AuthRepository>(() => _i12.AuthRepositoryImpl(
          remoteDataSource: gh<_i383.AuthRemoteDataSource>(),
          networkInfo: gh<_i505.NetworkInfo>(),
        ));
    gh.factory<_i496.GetCurrentUser>(
        () => _i496.GetCurrentUser(gh<_i638.AuthRepository>()));
    gh.factory<_i1051.SignIn>(() => _i1051.SignIn(gh<_i638.AuthRepository>()));
    gh.factory<_i427.SignOut>(() => _i427.SignOut(gh<_i638.AuthRepository>()));
    gh.factory<_i369.SignUp>(() => _i369.SignUp(gh<_i638.AuthRepository>()));
    gh.factory<_i746.AuthBloc>(() => _i746.AuthBloc(
          signIn: gh<_i1051.SignIn>(),
          signUp: gh<_i369.SignUp>(),
          signOut: gh<_i427.SignOut>(),
          getCurrentUser: gh<_i496.GetCurrentUser>(),
        ));
    return this;
  }
}
