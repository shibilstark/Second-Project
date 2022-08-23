// ignore_for_file: constant_identifier_names

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/application/auth/auth_bloc.dart';
import 'package:social_media/application/home/home_cubit.dart';
import 'package:social_media/application/post/post_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/infrastructure/auth/auth_repo.dart';
import 'package:social_media/infrastructure/auth/auth_service.dart';
import 'package:social_media/infrastructure/home/home_repo.dart';
import 'package:social_media/infrastructure/home/home_services.dart';
import 'package:social_media/infrastructure/post/post_repo.dart';
import 'package:social_media/infrastructure/post/post_services.dart';
import 'package:social_media/infrastructure/profile/profile_repo.dart';
import 'package:social_media/infrastructure/profile/profile_service.dart';
import 'package:social_media/presentation/screens/auth/auth_screen.dart';
import 'package:social_media/presentation/screens/chat/chat_screen.dart';
import 'package:social_media/presentation/screens/comment/comment.dart';
import 'package:social_media/presentation/screens/edit/edit_profile.dart';
import 'package:social_media/presentation/screens/feeds/report/report_post.dart';
import 'package:social_media/presentation/screens/home/home.dart';
import 'package:social_media/presentation/screens/new_post/new_post.dart';
import 'package:social_media/presentation/screens/others_profile/others_profile.dart';
import 'package:social_media/presentation/screens/settings/settings.dart';
// import 'package:social_media/presentation/screens/comment_screen/comment_screen.dart';
// import 'package:social_media/presentation/screens/edit/edit_profile.dart';
// import 'package:social_media/presentation/screens/home/home.dart';
// import 'package:social_media/presentation/screens/media_view/views.dart';
// import 'package:social_media/presentation/screens/new_post/new_post.dart';
// import 'package:social_media/presentation/screens/other_profile/others_profile.dart';
// import 'package:social_media/presentation/screens/profile/widgets/profile_feed.dart';
// import 'package:social_media/presentation/screens/settings/settings.dart';
import 'package:social_media/presentation/screens/splash/splash.dart';
import 'package:social_media/presentation/video_player/video_player.dart';

const HOME_SCREEN = "/home";
const REPORT_TYPE_SCREEN = "/reporttype";
const REPORT_SCREEN = "/report";
const AUTH_SCREEN = "/auth";
const SETTINGS_SCREEN = "/settings";
const EDIT_PROFILE_SCREEN = "/edit_profile";
const NEW_POST_SCREEN = "/new_post";
const CHAT_SCREEN = "/chat";
const ONLINE_VIDEO_PLAYER = "/onlinevideoplayer";
const OFFLINE_VIDEO_PLAYER = "/offlinevideoplayer";
const ONLINE_IMAGE = "/seeimageonline";
const OFFLINE_IMAGE = "/seeimageoffline";
const COMMENTS_SCREEN = "/comments";
const PROFILE_FEED_SCREEN = "/profileFeed";
const OTHERS_PROFILE_SCREEN = "/others_profile";

class AppRouter {
  // final ProfileCubit profileCubit;
  // HomeRepo homeRepo = HomeServices();
  // PostRepo postRepo = PostServices();
  // late final HomeCubit homeCubit;

  AppRouter() {
    // homeCubit = HomeCubit(
    //     homeRepo: homeRepo, postRepo: postRepo, profileCubit: profileCubit);
  }
  Route? onGenerateRoute(RouteSettings routSettings) {
    switch (routSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case REPORT_TYPE_SCREEN:
        final args = routSettings.arguments as ScreenArgs;
        return MaterialPageRoute(
            builder: (_) => ReportTypeScreen(
                  postId: args.args['postId'],
                ));
      case REPORT_SCREEN:
        final args = routSettings.arguments as ScreenArgs;
        return MaterialPageRoute(
            builder: (_) => ReportScreen(
                  reportType: args.args['reportType'],
                  postId: args.args['postId'],
                ));
      case HOME_SCREEN:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case ONLINE_VIDEO_PLAYER:
        final args = routSettings.arguments as ScreenArgs;
        return MaterialPageRoute(
            builder: (_) => OnlineVideoPlayer(
                  path: args.args['path'],
                ));
      case AUTH_SCREEN:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case SETTINGS_SCREEN:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case EDIT_PROFILE_SCREEN:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
      case NEW_POST_SCREEN:
        return MaterialPageRoute(builder: (_) => NewPostScreen());
      case CHAT_SCREEN:
        final args = routSettings.arguments as ScreenArgs;
        return MaterialPageRoute(
            builder: (_) => ChatScreen(
                  conversationId: args.args['id'],
                  recieverId: args.args['recieverId'],
                ));
      case COMMENTS_SCREEN:
        final args = routSettings.arguments as ScreenArgs;
        return MaterialPageRoute(
            builder: (_) => CommentScreen(
                  postId: args.args['postId'],
                ));
      case OTHERS_PROFILE_SCREEN:
        return MaterialPageRoute(builder: (_) => OthersProfileScreen());
      // case COMMENTS_SCREEN:
      //   final args = routSettings.arguments as ScreenArgs;
      //   return MaterialPageRoute(
      //       builder: (_) => CommentScreen(postId: args.args['postId']));
      // case PROFILE_FEED_SCREEN:
      //   final args = routSettings.arguments as ScreenArgs;
      //   return MaterialPageRoute(
      //       builder: (_) => ProfileFeedScreen(
      //           post: args.args['post'], user: args.args['user']));

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
