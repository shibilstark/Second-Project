// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../application/auth/auth_bloc.dart' as _i7;
import '../../application/profile/profile_bloc.dart' as _i8;
import '../../infrastructure/auth/auth_repo.dart' as _i3;
import '../../infrastructure/auth/auth_service.dart' as _i4;
import '../../infrastructure/profile/profile_repo.dart' as _i5;
import '../../infrastructure/profile/profile_service.dart'
    as _i6; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.AuthRepo>(() => _i4.AuthService());
  gh.lazySingleton<_i5.ProfileRepo>(() => _i6.ProfileServices());
  gh.factory<_i7.AuthBloc>(() => _i7.AuthBloc(get<_i3.AuthRepo>()));
  gh.factory<_i8.ProfileBloc>(() => _i8.ProfileBloc(get<_i5.ProfileRepo>()));
  return get;
}
