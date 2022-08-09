import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class ProfileInfoSectionWidget extends StatelessWidget {
  const ProfileInfoSectionWidget(
      {Key? key, required this.user, required this.posts})
      : super(key: key);

  final UserModel user;
  final int posts;

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
                child: user.coverImage == null
                    ? Container(
                        color: primaryColor.withOpacity(0.2),
                        height: 150.sm,
                      )
                    : Container(
                        height: 150.sm,
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(user.coverImage!))),
                      ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: user.profileImage != null
                    ? CircleAvatar(
                        backgroundColor: primaryColor,
                        backgroundImage: NetworkImage(user.profileImage!),
                        radius: 70.sm,
                      )
                    : CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 70.sm,
                      ),
              )
            ],
          ),
        ),
        Gap(H: 10.sm),
        Text(
          user.name,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        ProfileDiscriptionWidget(disc: user.discription),
        Gap(H: 20.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileBoxWidget(
                title: "Followers", value: user.followers.length.toString()),
            Gap(W: 20.sm),
            ProfileBoxWidget(
                title: "Following", value: user.following.length.toString()),
            Gap(W: 20.sm),
            ProfileBoxWidget(title: "Posts", value: posts.toString()),
          ],
        )
      ],
    );
  }
}

class ProfileDiscriptionWidget extends StatelessWidget {
  const ProfileDiscriptionWidget({
    Key? key,
    required this.disc,
  }) : super(key: key);

  final String? disc;

  @override
  Widget build(BuildContext context) {
    return disc == null
        ? SizedBox()
        : Column(
            children: [
              Gap(H: 10.sm),
              Text(
                disc!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
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
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 15.sm),
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
