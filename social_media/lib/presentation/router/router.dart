import 'package:flutter/material.dart';
import 'package:social_media/infrastructure/auth/auth_repo.dart';
import 'package:social_media/presentation/screens/auth/auth_screen.dart';
import 'package:social_media/presentation/screens/home/home.dart';
import 'package:social_media/presentation/screens/splash/splash.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routSettings) {
    switch (routSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/auth':
        return MaterialPageRoute(builder: (_) => AuthScreen());
      // case '/auth':
      //   return MaterialPageRoute(builder: (_) => AuthScreen());
      // case '/home':
      //   return MaterialPageRoute(builder: (_) => HomeScreen());
      // case '/profile':
      //   return MaterialPageRoute(builder: (_) => ProfileScreen());
      // case "/onlinevideoplayer":
      //   final args = routSettings.arguments as ScreenArgs;
      //   return MaterialPageRoute(
      //       builder: (_) => SeePostVideoOnline(
      //             video: args.args['path'],
      //           ));
      // case "/offlinevideoplayer":
      //   final args = routSettings.arguments as ScreenArgs;
      //   return MaterialPageRoute(
      //       builder: (_) => SeePostVideoOffline(
      //             video: args.args['path'],
      //           ));
      // case "/seeimageonline":
      //   final args = routSettings.arguments as ScreenArgs;
      //   return MaterialPageRoute(
      //       builder: (_) => SeePostImageNetwork(
      //             image: args.args['path'],
      //           ));
      // case "/seeimageoffline":
      //   final args = routSettings.arguments as ScreenArgs;
      //   return MaterialPageRoute(
      //       builder: (_) => SeePostImageOffline(
      //             image: args.args['path'],
      //           ));

      default:
        // return MaterialPageRoute(builder: (_) => SplashScreen());
        return null;
    }
  }
}

class ScreenArgs {
  final Map<String, dynamic> args;
  ScreenArgs({required this.args});
}
