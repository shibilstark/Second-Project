import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/application/comments/comment_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/presentation/router/router.dart';
import 'package:social_media/presentation/screens/new_post/new_post.dart';
import 'package:social_media/presentation/screens/profile/widgets/post_sculpter.dart';
import 'package:social_media/presentation/screens/profile/widgets/profile_info_section.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileSuccess) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 20.sm),
            child: ListView(children: [
              ProfileInfoSectionWidget(
                user: state.user,
                posts: state.posts.length,
              ),
              Gap(H: 20.sm),
              PostSculpterWidget(),
              Gap(H: 5.sm),
              ProfilePostsWidget(
                posts: state.posts,
                user: state.user,
              )
            ]),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class ProfilePostsWidget extends StatelessWidget {
  const ProfilePostsWidget({Key? key, required this.posts, required this.user})
      : super(key: key);
  final List<PostModel> posts;
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Container(
        child: Center(child: Text("Empty")),
      );
    } else {
      return GridView(
        children: List.generate(
            posts.length,
            (index) => ProfilePost(
                  user: user,
                  post: posts[index],
                )),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2 / 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5),
      );
    }
  }
}

class ProfilePost extends StatelessWidget {
  const ProfilePost({Key? key, required this.user, required this.post})
      : super(key: key);
  final UserModel user;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<CommentCubit>().getAllComments(postId: post.postId);
        Navigator.pushNamed(context, DETAIL_FEED_SCREEN,
            arguments: ScreenArgs(args: {"post": post, "user": user}));
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            color: Theme.of(context).highlightColor,
            width: double.infinity,
            height: double.infinity,
            child: post.type == PostType.image
                ? Container(
                    child: FadeInImage(
                        fadeInDuration: Duration(milliseconds: 100),
                        fit: BoxFit.cover,
                        image: NetworkImage(post.post!),
                        placeholder: AssetImage(dummyProfilePicture)),
                  )
                : Container(
                    child: FadeInImage(
                        fadeInDuration: Duration(milliseconds: 100),
                        fit: BoxFit.cover,
                        image: NetworkImage(post.videoThumbnail!),
                        placeholder: AssetImage(dummyProfilePicture)),
                  ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 5.sm, horizontal: 10.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LimitedBox(
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 15.sm,
                            color: Colors.redAccent,
                          ),
                          Gap(W: 5.sm),
                          Text(
                            post.lights.length.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                    post.type == PostType.video
                        ? Row(
                            children: [
                              Icon(
                                Icons.video_call,
                                size: 15.sm,
                                color: pureWhite,
                              ),
                            ],
                          )
                        : Spacer(),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
