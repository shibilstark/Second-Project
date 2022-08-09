import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/presentation/widgets/gap.dart';
import 'package:social_media/presentation/widgets/theme_switch.dart';

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

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
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      actions: [ThemeSwitchButtom()],
    );
  }
}
