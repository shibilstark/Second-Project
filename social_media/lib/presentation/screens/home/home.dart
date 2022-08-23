import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/core/constants/constants.dart';
import 'package:social_media/presentation/router/router.dart';
import 'package:social_media/presentation/screens/feeds/feed_view.dart';
import 'package:social_media/presentation/screens/message/message_screen.dart';
import 'package:social_media/presentation/screens/profile/profile.dart';
import 'package:social_media/presentation/screens/search/search.dart';

import 'package:social_media/presentation/widgets/theme_switch.dart';

ValueNotifier<int> _bottomNav = ValueNotifier(0);

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const PreferredSize(preferredSize: appBarHeight, child: HomeAppBar()),
      body: ValueListenableBuilder(
          valueListenable: _bottomNav,
          builder: (context, int val, _) {
            return Container(child: _pages[val]);
          }),
      bottomNavigationBar: const HomeBottomNavigationBar(),
    );
  }
}

gotoProfileView() {
  _bottomNav.value = 3;
  _bottomNav.notifyListeners();
}

gotoMessageView() {
  _bottomNav.value = 2;
  _bottomNav.notifyListeners();
}

final _pages = [
  FeedScreen(),
  SearchScreen(),
  MessageScreen(),
  ProfileScreen(),
];

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _bottomNav,
        builder: (context, int val, _) {
          return AppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            title: Text(
              "Sociello",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontFamily: 'sociello',
                    fontWeight: FontWeight.w900,
                    fontSize: 45.sm,
                    color: primaryColor,
                  ),
            ),
            actionsIconTheme: Theme.of(context).iconTheme,
            actions: [
              ThemeSwitchButtom(),
              // IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
              IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, NEW_POST_SCREEN),
                  icon: Icon(Icons.add_a_photo)),
              val == 3
                  ? IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, SETTINGS_SCREEN),
                      icon: Icon(Icons.settings))
                  : SizedBox(),
            ],
          );
        });
  }
}

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _bottomNav,
      builder: (BuildContext context, int index, _) {
        return BottomNavigationBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            currentIndex: _bottomNav.value,
            onTap: (value) {
              _bottomNav.value = value;
              _bottomNav.notifyListeners();
            },
            selectedIconTheme: Theme.of(context).primaryIconTheme.copyWith(
                  size: 27.sm,
                ),
            unselectedIconTheme: Theme.of(context).primaryIconTheme.copyWith(
                  color: Theme.of(context)
                      .primaryIconTheme
                      .color!
                      .withOpacity(0.7),
                  // color: primaryColor.withOpacity(0.5),
                ),
            elevation: 6,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.house,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forum),
                label: "Chats",
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.notifications),
              //   label: "Chats",
              // ),
              BottomNavigationBarItem(
                icon: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileSuccess) {
                      if (state.user.profileImage != null) {
                        return CircleAvatar(
                          radius: _bottomNav.value == 3 ? 15 : 12,
                          backgroundColor: primaryColor,
                          backgroundImage:
                              NetworkImage(state.user.profileImage!),
                        );
                      } else {
                        return CircleAvatar(
                          radius: _bottomNav.value == 3 ? 15 : 12,
                          backgroundColor: primaryColor,
                        );
                      }
                    } else {
                      return CircleAvatar(
                        radius: _bottomNav.value == 3 ? 15 : 12,
                        backgroundColor: primaryColor,
                      );
                    }
                  },
                ),
                label: "Profile",
              ),
            ]);
      },
    );
  }
}
