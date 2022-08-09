import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/application/auth/auth_bloc.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/core/constants/constants.dart';
import 'package:social_media/presentation/router/router.dart';
import 'package:social_media/presentation/widgets/gap.dart';
import 'package:social_media/presentation/widgets/theme_switch.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: SettingsAppBar(),
        preferredSize: appBarHeight,
      ),
      body: SettingsBody(),
    );
  }
}

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: -5,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: IconTheme(
            data: Theme.of(context).iconTheme, child: Icon(Icons.arrow_back)),
      ),
      title: Text(
        "Settings",
        style: Theme.of(context).textTheme.titleSmall,
      ),
      actions: [ThemeSwitchButtom()],
    );
  }
}

class SettingsBody extends StatelessWidget {
  const SettingsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 20.sm),
      child: Column(
        children: [
          // Row(
          //   children: [
          // Text(
          //   "Edit Profile",
          //   style: Theme.of(context)
          //       .textTheme
          //       .bodyLarge!
          //       .copyWith(fontSize: 18.sm),
          // ),
          //     Spacer(),

          //   ],
          // )

          ListTile(
            onTap: (() => Navigator.pushNamed(context, EDIT_PROFILE_SCREEN)),
            dense: true,
            horizontalTitleGap: 0,
            title: Text(
              "Edit Profile",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 18.sm),
            ),
            leading: IconTheme(
                data: Theme.of(context).iconTheme, child: Icon(Icons.edit)),
          ),
          ListTile(
            onTap: () {
              context.read<AuthBloc>().add(LogOut());
              showLogOutLoading(context);
            },
            dense: true,
            horizontalTitleGap: 0,
            title: Text(
              "Log Out",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 18.sm),
            ),
            leading: IconTheme(
                data: Theme.of(context).iconTheme, child: Icon(Icons.logout)),
          ),
        ],
      ),
    );
  }
}

showLogOutLoading(BuildContext context) => showDialog(
      context: context,
      builder: (context) => BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess && state.type == AuthMode.logout) {
            Navigator.pushReplacementNamed(context, AUTH_SCREEN);
          }
        },
        child: AlertDialog(
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.sm,
                  width: 20.sm,
                  child: CircularProgressIndicator(color: primaryColor),
                ),
                Gap(W: 10.sm),
                Text(
                  "Loading...",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 15.sm, fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
        ),
      ),
    );
