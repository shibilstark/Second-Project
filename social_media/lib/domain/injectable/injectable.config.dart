// // GENERATED CODE - DO NOT MODIFY BY HAND

// // **************************************************************************
// // InjectableConfigGenerator
// // **************************************************************************

// // ignore_for_file: no_leading_underscores_for_library_prefixes
// import 'package:get_it/get_it.dart' as _i1;
// import 'package:injectable/injectable.dart' as _i2;

// import '../../application/auth/auth_bloc.dart' as _i9;
// import '../../application/post/post_bloc.dart' as _i11;
// import '../../application/profile/profile_bloc.dart' as _i10;
// import '../../infrastructure/auth/auth_repo.dart' as _i3;
// import '../../infrastructure/auth/auth_service.dart' as _i4;
// import '../../infrastructure/post/post_repo.dart' as _i5;
// import '../../infrastructure/post/post_services.dart' as _i6;
// import '../../infrastructure/profile/profile_repo.dart' as _i7;
// import '../../infrastructure/profile/profile_service.dart'
//     as _i8; // ignore_for_file: unnecessary_lambdas

// // ignore_for_file: lines_longer_than_80_chars
// /// initializes the registration of provided dependencies inside of [GetIt]
// _i1.GetIt $initGetIt(_i1.GetIt get,
//     {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
//   final gh = _i2.GetItHelper(get, environment, environmentFilter);
//   gh.lazySingleton<_i3.AuthRepo>(() => _i4.AuthService());
//   gh.lazySingleton<_i5.PostRepo>(() => _i6.PostServices());
//   gh.lazySingleton<_i7.ProfileRepo>(() => _i8.ProfileServices());
//   gh.factory<_i9.AuthBloc>(() => _i9.AuthBloc(get<_i3.AuthRepo>()));
//   gh.factory<_i10.ProfileBloc>(() => _i10.ProfileBloc(get<_i7.ProfileRepo>()));
//   gh.factory<_i11.PostBloc>(
//       () => _i11.PostBloc(get<_i5.PostRepo>(), get<_i10.ProfileBloc>()));
//   return get;
// }
