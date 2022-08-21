import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:social_media/application/auth/auth_bloc.dart';
import 'package:social_media/application/comment/comment_cubit.dart';
import 'package:social_media/application/home/home_cubit.dart';
import 'package:social_media/application/intermediat/inter_mediat_cubit.dart';
import 'package:social_media/application/main/main_cubit.dart';
import 'package:social_media/application/others_profile/others_profile_cubit.dart';
import 'package:social_media/application/post/post_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/application/search/search_cubit.dart';
import 'package:social_media/application/theme/theme_bloc.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/core/themes/themes.dart';
import 'package:social_media/domain/db/user_data/user_data.dart';
import 'package:social_media/infrastructure/auth/auth_repo.dart';
import 'package:social_media/infrastructure/auth/auth_service.dart';
import 'package:social_media/infrastructure/home/home_repo.dart';
import 'package:social_media/infrastructure/home/home_services.dart';
import 'package:social_media/infrastructure/post/post_repo.dart';
import 'package:social_media/infrastructure/post/post_services.dart';
import 'package:social_media/infrastructure/profile/profile_repo.dart';
import 'package:social_media/infrastructure/profile/profile_service.dart';
import 'package:social_media/infrastructure/search/search_repo.dart';
import 'package:social_media/infrastructure/search/search_services.dart';
import 'package:social_media/presentation/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final HydratedBloc.storage =   await HydratedStorage.build(
  //     storageDirectory: await getApplicationDocumentsDirectory());

  final storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  await Firebase.initializeApp();
  await Hive.initFlutter();
  // await configureInjection();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: commonBlack,
  // ));

  if (!Hive.isAdapterRegistered(UserDataAdapter().typeId)) {
    Hive.registerAdapter(UserDataAdapter());
  }

  HydratedBlocOverrides.runZoned(() => runApp(MyApp()), storage: storage);
}

class MyApp extends StatelessWidget {
  late final AppRouter appRouter;

  ProfileRepo profileRepo = ProfileServices();
  AuthRepo authRepo = AuthService();
  PostRepo postRepo = PostServices();
  HomeRepo homeRepo = HomeServices();
  SearchRepo searchRepo = SearchServices();

  late final HomeCubit homeCubit;
  late final ProfileCubit profileCubit;
  late final AuthBloc authBloc;
  late final PostCubit postCubit;
  late final MainCubit mainCubit;
  late final CommentCubit commentCubit;
  late final OthersProfileCubit othersProfileCubit;
  late final SearchCubit searchCubit;

  MyApp({Key? key}) : super(key: key) {
    appRouter = AppRouter();
    homeCubit = HomeCubit(homeRepo: homeRepo, postRepo: postRepo);
    profileCubit = ProfileCubit(
        profileRepo: profileRepo, postRepo: postRepo, homeRepo: homeRepo);

    authBloc = AuthBloc(authRepo: authRepo);
    othersProfileCubit = OthersProfileCubit(
        profileRepo: profileRepo,
        homeRepo: homeRepo,
        profileCubit: profileCubit);
    mainCubit = MainCubit(
        homeCubit: homeCubit,
        profileCubit: profileCubit,
        homeRepo: homeRepo,
        othersProfileCubit: othersProfileCubit,
        postRepo: postRepo,
        profileRepo: profileRepo);
    postCubit = PostCubit(postRepo: postRepo, mainCubit: mainCubit);
    commentCubit = CommentCubit(
        homeRepo: homeRepo,
        homeCubit: homeCubit,
        profileCubit: profileCubit,
        othersProfileCubit: othersProfileCubit);

    searchCubit = SearchCubit(searchRepo: searchRepo);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ThemeBloc(),
              ),
              BlocProvider(create: (context) => mainCubit),
              BlocProvider(create: (context) => profileCubit),
              BlocProvider(create: (context) => homeCubit),
              BlocProvider(create: (context) => authBloc),
              BlocProvider(create: (context) => postCubit),
              BlocProvider(create: (context) => commentCubit),
              BlocProvider(create: (context) => othersProfileCubit),
              BlocProvider(create: (context) => searchCubit),
            ],
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return MaterialApp(
                  theme: state.isDark ? MyTheme.darkTheme : MyTheme.lightTheme,
                  // theme: MyTheme.darkTheme,
                  debugShowCheckedModeBanner: false,
                  // showPerformanceOverlay: true,
                  onGenerateRoute: appRouter.onGenerateRoute,
                );
              },
            ),
          );
        });
  }
}
