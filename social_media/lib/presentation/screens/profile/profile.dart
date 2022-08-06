import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/presentation/screens/profile/widgets/post_sculpter.dart';
import 'package:social_media/presentation/screens/profile/widgets/profile_info_section.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 20.sm),
      child: ListView(children: [
        ProfileInfoSectionWidget(),
        Gap(H: 20.sm),
        PostSculpterWidget(),
        GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5),
            itemCount: 10,
            itemBuilder: (context, index) => DummyGridVieItem())
      ]),
    );
  }
}

class DummyGridVieItem extends StatelessWidget {
  const DummyGridVieItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          color: primaryColor.withOpacity(0.2),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.sm, horizontal: 10.sm),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.favorite,
                    size: 15.sm,
                    color: pureWhite,
                  ),
                  Gap(W: 5.sm),
                  Text(
                    "100",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
