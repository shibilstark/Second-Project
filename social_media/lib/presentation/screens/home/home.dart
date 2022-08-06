import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/core/constants/constants.dart';
import 'package:social_media/presentation/screens/profile/profile.dart';
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

const _pages = [
  Scaffold(),
  Scaffold(),
  Scaffold(),
  ProfileScreen(),
];

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      title: Text(
        "Social Media",
        style: Theme.of(context).textTheme.titleSmall!.copyWith(),
      ),
      actionsIconTheme: Theme.of(context).iconTheme,
      actions: [
        ThemeSwitchButtom(),
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        IconButton(onPressed: () {}, icon: Icon(Icons.add_a_photo)),
      ],
    );
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
            selectedIconTheme:
                Theme.of(context).primaryIconTheme.copyWith(size: 27.sm),
            unselectedIconTheme: Theme.of(context).primaryIconTheme.copyWith(
                color:
                    Theme.of(context).primaryIconTheme.color!.withOpacity(0.7)),
            elevation: 6,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: const [
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
                icon: CircleAvatar(
                  radius: 12,
                  backgroundColor: primaryColor,
                ),
                label: "Profile",
              ),
            ]);
      },
    );
  }
}
