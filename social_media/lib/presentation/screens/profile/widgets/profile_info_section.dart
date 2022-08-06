import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/presentation/widgets/gap.dart';
import 'package:social_media/presentation/widgets/theme_switch.dart';

class ProfileInfoSectionWidget extends StatelessWidget {
  const ProfileInfoSectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 220.sm,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.sm),
                child: Container(
                  color: primaryColor.withOpacity(0.2),
                  height: 150.sm,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 70.sm,
                ),
              )
            ],
          ),
        ),
        Gap(H: 10.sm),
        Text(
          "Shibil Hassan",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        Gap(H: 10.sm),
        Text(
          "Iam Shibl Hassan, Iam a self-learn Flurtter developer. Now attending a self-learn training program in Brototype Academy",
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        Gap(H: 10.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileBoxWidget(title: "Followers", value: "100"),
            Gap(W: 20.sm),
            ProfileBoxWidget(title: "Following", value: "1000"),
          ],
        )
      ],
    );
  }
}

class ProfileBoxWidget extends StatelessWidget {
  const ProfileBoxWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 15.sm),
        decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.sm)),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 15.sm),
            ),
            Gap(H: 5.sm),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 22.sm),
            )
          ],
        ),
      ),
    );
  }
}
