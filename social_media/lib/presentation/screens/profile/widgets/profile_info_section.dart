import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_media/application/others_profile/others_profile_cubit.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/domain/global/global_variables.dart';
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
        ),
        user.userId != Global.USER_DATA.id
            ? Column(
                children: [
                  Gap(H: 10.sm),
                  FollowMessageButton(
                    user: user,
                  )
                ],
              )
            : SizedBox(),
      ],
    );
  }
}

class FollowMessageButton extends StatelessWidget {
  const FollowMessageButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;
  @override
  Widget build(BuildContext context) {
    bool isFollowing = false;

    if (user.followers.contains(Global.USER_DATA.id)) {
      isFollowing = true;
    } else {
      isFollowing = false;
    }

    return Row(
      children: [
        Expanded(
            flex: isFollowing ? 1 : 2,
            child: ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(pureWhite),
                    backgroundColor: MaterialStateProperty.all(primaryColor)),
                child: Text(isFollowing ? "Following" : "Follow"),
                onPressed: () {
                  if (isFollowing) {
                    context.read<OthersProfileCubit>().followUnfollow(
                        userId: user.userId, shouldFollow: false);
                  } else {
                    context.read<OthersProfileCubit>().followUnfollow(
                        userId: user.userId, shouldFollow: true);
                  }
                })),
        Gap(W: 20.sm),
        Expanded(
            flex: isFollowing ? 2 : 1,
            child: ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(pureWhite),
                    backgroundColor: MaterialStateProperty.all(isFollowing
                        ? primaryColor
                        : primaryColor.withOpacity(0.6))),
                child: Text("Message"),
                onPressed: () {
                  if (!user.followers.contains(Global.USER_DATA.id)) {
                    Fluttertoast.showToast(
                        msg: "You are not following ${user.name}");
                  } else {}
                })),
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
