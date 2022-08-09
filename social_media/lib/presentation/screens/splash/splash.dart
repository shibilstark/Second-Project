import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/application/intermediat/inter_mediat_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/domain/db/user_data/user_data.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/presentation/router/router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final data = await UserDataStore.getUserData();

      await Future.delayed(Duration(seconds: 1));
      if (data == null) {
        Navigator.pushReplacementNamed(context, AUTH_SCREEN);
      } else {
        Global.USER_DATA = data;

        context.read<InterMediatCubit>().getUserProfile();
        context.read<InterMediatCubit>().getHomeFeed();

        Navigator.pushReplacementNamed(context, HOME_SCREEN);
      }
    });
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
