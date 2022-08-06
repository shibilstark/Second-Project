import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media/application/auth/auth_bloc.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/domain/db/user_data/user_data.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/main.dart';
import 'package:social_media/presentation/widgets/gap.dart';
import 'package:social_media/presentation/widgets/theme_switch.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 10.sm),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: size.height / 2,
                        width: size.width * 0.8,
                        child: SvgPicture.asset("assets/svg/authImage.svg"),
                      ),
                      Gap(H: 10.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi,",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Gap(H: 5.sm),
                          Text(
                            "Welcome to this Social Media,",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: 25.sm,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                      Gap(H: 60.sm),
                      Column(
                        children: [
                          Container(
                            width: size.width * 0.8,
                            child: AuthButton(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(H: 10.sm),
                  Text(
                    "Terms & conditions | Privacy Policy",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 12.sm, fontWeight: FontWeight.bold),
                  ),
                  ThemeSwitchButtom()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthError) {
          Fluttertoast.showToast(msg: state.fail.error);
        }
        if (state is AuthSuccess) {
          if (state.type == AuthMode.login) {
            final data = await UserDataStore.getUserData();

            if (data == null) {
              Fluttertoast.showToast(msg: "Something went wrong");
            } else {
              Global.USER_DATA = data;
              Navigator.pushNamed(context, '/home');
            }
          }
        }
      },
      builder: (context, state) {
        return ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryColor),
              foregroundColor: MaterialStateProperty.all(pureWhite),
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 15.sm, horizontal: 20.sm))),
          onPressed: () {
            context.read<AuthBloc>().add(LoginOrSignUp());
          },
          icon: (state is AuthLoading)
              ? SizedBox()
              : Icon(
                  FontAwesomeIcons.google,
                  size: 20,
                ),
          label: (state is AuthLoading)
              ? SizedBox(
                  height: 20.sm,
                  width: 20.sm,
                  child: CircularProgressIndicator(
                    color: pureWhite,
                  ))
              : Text("Login/Sign up With Google"),
        );
      },
    );
  }
}
