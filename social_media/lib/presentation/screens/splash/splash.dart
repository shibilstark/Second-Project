import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/application/intermediat/inter_mediat_cubit.dart';
import 'package:social_media/application/main/main_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/domain/db/user_data/user_data.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/presentation/router/router.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = await UserDataStore.getUserData();

      if (data == null) {
        Navigator.pushReplacementNamed(context, AUTH_SCREEN);
      } else {
        Global.USER_DATA = data;
        context.read<MainCubit>().getUserProfile();
        context.read<MainCubit>().getHomeFeeds();
        Navigator.pushReplacementNamed(context, HOME_SCREEN);
      }
    });
    return Scaffold(
      body: Container(
        color: primaryColor.withOpacity(0.2),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/bg/SocielloSplashBg.png'),
            SizedBox(
              height: 20.sm,
              width: 20.sm,
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 2.sm,
              ),
            )
          ],
        )),
      ),
    );
  }
}
