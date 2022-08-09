import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:social_media/application/comments/comment_cubit.dart';
import 'package:social_media/application/home/home_cubit.dart';
import 'package:social_media/application/intermediat/inter_mediat_cubit.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/presentation/router/router.dart';
import 'package:social_media/presentation/screens/new_post/new_post.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 10.sm),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeSuccess) {
            return ListView(
              children: List.generate(state.homeFeed.length, (index) {
                final currentFeed = state.homeFeed[index];

                return Column(
                  children: [
                    HomeFeedWidget(
                      post: currentFeed.post,
                      user: currentFeed.user,
                    ),
                    Column(
                      children: [
                        Gap(H: 5.sm),
                        Divider(
                          thickness: 3,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.2),
                        ),
                      ],
                    )
                  ],
                );
              }),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class HomeFeedWidget extends StatelessWidget {
  const HomeFeedWidget({
    Key? key,
    required this.user,
    required this.post,
  }) : super(key: key);

  final UserModel user;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              user.profileImage == null
                  ? CircleAvatar(
                      radius: 20.sm,
                      backgroundColor: primaryColor,
                    )
                  : CircleAvatar(
                      radius: 20.sm,
                      backgroundColor: primaryColor,
                      backgroundImage: NetworkImage(user.profileImage!),
                    ),
              Gap(W: 10.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    timeago.format(post.createdAt),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 10.sm,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .color!
                            .withOpacity(0.6)),
                  ),
                ],
              )
            ],
          ),
          Gap(H: 10.sm),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: 450.sm),
            decoration: BoxDecoration(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withOpacity(0.1)),
            child: post.type == PostType.image
                ? FadeInImage(
                    fadeInDuration: Duration(milliseconds: 100),
                    fit: BoxFit.cover,
                    image: NetworkImage(post.post!),
                    placeholder: AssetImage(dummyProfilePicture))
                : FadeInImage(
                    fadeInDuration: Duration(milliseconds: 100),
                    fit: BoxFit.cover,
                    image: NetworkImage(post.videoThumbnail!),
                    placeholder: AssetImage(dummyProfilePicture)),
          ),
          Gap(H: 5.sm),
          IconTheme(
            data: Theme.of(context).iconTheme,
            child: Row(
              children: [
                BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    log("nwe State listen");
                  },
                  builder: (context, state) {
                    log("nwe State");
                    return IconButton(
                      onPressed: () {
                        if (post.lights.contains(Global.USER_DATA.id)) {
                          context.read<InterMediatCubit>().likeOrDislikePost(
                              shouldLike: false, postId: post.postId);

                          log("${post.lights}");
                        } else {
                          log("${post.lights}");

                          context.read<InterMediatCubit>().likeOrDislikePost(
                              shouldLike: true, postId: post.postId);
                        }
                      },
                      icon: Icon(
                        Icons.favorite,
                      ),
                    );
                  },
                ),
                IconButton(
                    onPressed: () {
                      context
                          .read<CommentCubit>()
                          .getAllComments(postId: post.postId);

                      Navigator.pushNamed(context, DETAIL_FEED_SCREEN,
                          arguments:
                              ScreenArgs(args: {'post': post, 'user': user}));
                    },
                    icon: Icon(FontAwesomeIcons.comment)),
                IconButton(onPressed: () {}, icon: Icon(Icons.share)),
              ],
            ),
          ),
          post.discription == null
              ? SizedBox()
              : ReadMoreText(
                  post.discription!,
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  trimCollapsedText: 'Read More',
                  trimExpandedText: 'Read Less',
                  lessStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 13.sm,
                      color: primaryColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500),
                  moreStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 13.sm,
                      color: primaryColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 15.sm),
                ),
          Gap(H: 10.sm),
          Row(
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  log("nwe State liekd");
                  return Text(
                    "${post.lights.length} Likes",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: primaryColor, fontSize: 13.sm),
                  );
                },
              ),
              Gap(W: 20.sm),
              Text(
                "${post.comments.length} Comments",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: primaryColor, fontSize: 13.sm),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
