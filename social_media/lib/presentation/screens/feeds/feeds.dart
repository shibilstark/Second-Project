import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/application/comment/comment_cubit.dart';
import 'package:social_media/application/main/main_cubit.dart';
import 'package:social_media/application/others_profile/others_profile_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/presentation/router/router.dart';
import 'package:social_media/presentation/screens/home/home.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/presentation/widgets/gap.dart';
import 'package:video_player/video_player.dart';

class SuggestionViewWidget extends StatelessWidget {
  const SuggestionViewWidget({
    Key? key,
    required this.peoples,
  }) : super(key: key);

  final List<UserModel> peoples;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.sm),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Suggested For You",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 15.sm,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
        Gap(H: 10.sm),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 10.sm),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .textTheme
                .bodyMedium!
                .color!
                .withOpacity(0.03),
            borderRadius: BorderRadius.circular(10.sm),
            border: Border.all(
                width: 0.01,
                color: Theme.of(context).textTheme.bodyLarge!.color!),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withOpacity(0.3),
                blurRadius: 1.sm,
                blurStyle: BlurStyle.outer,
                // offset: Offset.fromDirection(1, -1),
              )
            ],
          ),
          constraints: BoxConstraints(minHeight: 180.sm, maxHeight: 185.sm),
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) =>
                SuggestionWidget(user: peoples[index]),
            separatorBuilder: (context, index) => Gap(W: 15.sm),
            itemCount: peoples.length,
          ),
        ),
      ],
    );
  }
}

class SuggestionWidget extends StatelessWidget {
  const SuggestionWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 20.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sm),
            border: Border.all(
                width: 0.1,
                color: Theme.of(context).textTheme.bodyLarge!.color!),
          ),
          child: Column(
            children: [
              user.profileImage == null
                  ? CircleAvatar(
                      radius: 40.sm,
                      backgroundColor: primaryColor,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(user.profileImage!),
                      radius: 40.sm,
                      backgroundColor: primaryColor,
                    ),
              Gap(H: 10.sm),
              Text(
                user.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 16.sm),
              ),
              Gap(H: 5.sm),
              InkWell(
                onTap: () {
                  if (user.userId != Global.USER_DATA.id) {
                    context
                        .read<OthersProfileCubit>()
                        .getProfileById(userId: user.userId);
                    Navigator.pushNamed(context, OTHERS_PROFILE_SCREEN);
                  } else {
                    gotoProfileView();
                  }
                },
                child: Container(
                  width: 100.sm,
                  height: 30.sm,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(5.sm)),
                  child: Align(
                    child: Text(
                      "See Profile",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14.sm,
                          fontWeight: FontWeight.w500,
                          color: commonWhite),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.all(6.sm),
        //   child: Opacity(
        //     opacity: 0.6,
        //     child: InkWell(
        //       onTap: () {},
        //       child: Icon(
        //         Icons.close,
        //         size: 20.sm,
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}

class FeedWidget extends StatelessWidget {
  const FeedWidget({
    Key? key,
    required this.user,
    required this.post,
  }) : super(key: key);

  final UserModel user;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        // height: 400.sm,
        padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 10.sm),
        width: double.infinity,
        decoration: BoxDecoration(
          color:
              Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.03),
          borderRadius: BorderRadius.circular(10.sm),
          border: Border.all(
              width: 0.01,
              color: Theme.of(context).textTheme.bodyLarge!.color!),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .color!
                  .withOpacity(0.3),
              blurRadius: 1.sm,
              blurStyle: BlurStyle.outer,
              // offset: Offset.fromDirection(1, -1),
            )
          ],
        ),
        child: Column(
          children: [
            FeedUserInfoSection(user: user, post: post),
            Gap(H: 10.sm),
            PostWidget(post: post),
            Gap(H: 10.sm),
            FeedActionButtons(post: post),
            Gap(H: 10.sm),
            PostDiscriptionWidget(disc: post.discription),
          ],
        ),
      ),
    );
  }
}

class PostDiscriptionWidget extends StatelessWidget {
  const PostDiscriptionWidget({
    Key? key,
    required this.disc,
  }) : super(key: key);

  final String? disc;
  @override
  Widget build(BuildContext context) {
    return disc == null
        ? SizedBox()
        : Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                ReadMoreText(
                  "${disc}   ",
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  trimCollapsedText: 'Read More',
                  trimExpandedText: '',
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
                      .copyWith(fontSize: 14.sm),
                ),
                Gap(H: 10.sm),
              ],
            ),
          );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.sm),
      child: post.type == PostType.video
          ? FeedVideoPlayer(size: size, post: post)
          : Container(
              // height: 300.sm,
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: size.height / 2),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),

                // image:
                //     DecorationImage(image: NetworkImage(post.post!), fit: BoxFit.cover),
              ),
              child: Image.network(post.post!),
            ),
    );
  }
}

class FeedVideoPlayer extends StatelessWidget {
  FeedVideoPlayer({
    Key? key,
    required this.size,
    required this.post,
  }) : super(key: key);

  final Size size;
  final PostModel post;

  ValueNotifier<bool> isVideoPlaying = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isVideoPlaying,
        builder: (context, bool isPlaying, _) {
          return Stack(
            children: [
              isVideoPlaying.value
                  ? Container(
                      width: size.width,
                      height: 100,
                      color: primaryColor,
                      child: OnlineVideoPlayer(path: post.post!),
                    )
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                      ),
                      constraints: BoxConstraints(maxHeight: size.height / 2),
                      child: Image.network(
                        post.videoThumbnail!,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
              IconButton(
                  onPressed: () {
                    if (isPlaying) {
                      isVideoPlaying.value = false;
                    } else {
                      isVideoPlaying.value = true;
                    }
                  },
                  icon: Icon(
                    Icons.play_arrow_rounded,
                  )),
            ],
          );
        });
  }
}

class FeedActionButtons extends StatelessWidget {
  const FeedActionButtons({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: Theme.of(context).primaryIconTheme,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "${post.lights.length} Likes",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 13.sm),
              ),
              Gap(W: 10.sm),
              Text(
                "${post.comments.length} Comments",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 13.sm),
              ),
            ],
          ),
          Row(
            children: [
              Builder(builder: (context) {
                late bool isLiked;

                if (post.lights.contains(Global.USER_DATA.id)) {
                  isLiked = true;
                } else {
                  isLiked = false;
                }
                return IconButton(
                    onPressed: () {
                      if (isLiked) {
                        context
                            .read<MainCubit>()
                            .likePost(postId: post.postId, shouldLike: false);
                      } else {
                        context
                            .read<MainCubit>()
                            .likePost(postId: post.postId, shouldLike: true);
                      }
                    },
                    icon: isLiked
                        ? Icon(
                            Icons.favorite_rounded,
                            color: primaryColor,
                          )
                        : Icon(
                            Icons.favorite_outline,
                          ));
              }),
              IconButton(
                  onPressed: () {
                    context
                        .read<CommentCubit>()
                        .getAllComments(postId: post.postId);
                    Navigator.pushNamed(context, COMMENTS_SCREEN,
                        arguments: ScreenArgs(args: {'postId': post.postId}));
                  },
                  icon: Icon(
                    FontAwesomeIcons.comment,
                    size: 20,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class FeedUserInfoSection extends StatelessWidget {
  const FeedUserInfoSection({Key? key, required this.user, required this.post})
      : super(key: key);

  final UserModel user;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (user.userId != Global.USER_DATA.id) {
              context
                  .read<OthersProfileCubit>()
                  .getProfileById(userId: user.userId);
              Navigator.pushNamed(context, OTHERS_PROFILE_SCREEN);
            } else {
              gotoProfileView();
            }
          },
          child: Column(
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
            ],
          ),
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
        ),
        Spacer(),
        IconButton(
            splashRadius: 15,
            padding: EdgeInsets.zero,
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  context: context,
                  builder: (context) => Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.sm),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            post.userId == Global.USER_DATA.id
                                ? ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showDeletePostDialog(context,
                                          post: post.post!,
                                          postId: post.postId);
                                    },
                                    leading: IconTheme(
                                        data: Theme.of(context).iconTheme,
                                        child: Icon(Icons.delete)),
                                    title: Text(
                                      "Delete post",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 15.sm),
                                    ),
                                  )
                                : SizedBox(),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              leading: IconTheme(
                                  data: Theme.of(context).iconTheme,
                                  child: Icon(Icons.report_problem)),
                              title: Text(
                                "Report post",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 15.sm),
                              ),
                            ),
                          ]),
                        ),
                      ));
            },
            icon: Icon(
              Icons.more_vert,
              size: 15.sm,
            ))
      ],
    );
  }
}

showDeletePostDialog(BuildContext context,
    {required String postId, required String post}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text(
              "Do you want to delete this post?",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 14.sm, color: primaryColor),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context
                        .read<MainCubit>()
                        .deletePost(postId: postId, postUrl: post);
                    showDeletePostLoading(context);
                  },
                  child: Text(
                    "Delete",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 14.sm, color: primaryColor),
                  )),
            ],
          ));
}

showDeletePostLoading(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSuccess || state is ProfileError) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              return WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  content: Row(children: [
                    SizedBox(
                      height: 20.sm,
                      width: 20.sm,
                      child: CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 1.5.sm,
                      ),
                    ),
                    Gap(W: 20.sm),
                    Text(
                      "Loading...",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 15.sm, fontWeight: FontWeight.bold),
                    )
                  ]),
                ),
              );
            },
          ));
}

class OnlineVideoPlayer extends StatefulWidget {
  OnlineVideoPlayer({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  State<OnlineVideoPlayer> createState() => _OnlineVideoPlayerState();
}

class _OnlineVideoPlayerState extends State<OnlineVideoPlayer> {
  late VideoPlayerController onlineVideoPlayerController;
  @override
  void initState() {
    onlineVideoPlayerController = VideoPlayerController.network(widget.path,
        videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: false, mixWithOthers: false))
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize().then((value) => value);
    super.initState();
  }

  _getPosition() {
    final duration = Duration(
        milliseconds:
            onlineVideoPlayerController.value.position.inMilliseconds.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, "0"))
        .join(":");
  }

  @override
  void dispose() {
    onlineVideoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AspectRatio(
                aspectRatio: onlineVideoPlayerController.value.aspectRatio,
                child: VideoPlayer(onlineVideoPlayerController)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.sm),
              child: Row(
                children: [
                  Text(
                    _getPosition(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: pureWhite, fontSize: 12.sm),
                  ),
                  Gap(
                    W: 5.sm,
                  ),
                  Expanded(
                    child: VideoProgressIndicator(
                      onlineVideoPlayerController,
                      allowScrubbing: true,
                      padding: EdgeInsets.all(3),
                      colors: VideoProgressColors(
                          playedColor: pureWhite,
                          bufferedColor: pureWhite,
                          backgroundColor: commonBlack.withOpacity(0.5)),
                    ),
                  ),
                  // IconButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         if (onlineVideoPlayerController.value.isPlaying) {
                  //           onlineVideoPlayerController.pause();
                  //         } else {
                  //           onlineVideoPlayerController.play();
                  //         }
                  //       });
                  //     },
                  //     icon: Icon(
                  //       onlineVideoPlayerController.value.isPlaying
                  //           ? Icons.pause
                  //           : Icons.play_arrow,
                  //       color: pureWhite,
                  //     ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
