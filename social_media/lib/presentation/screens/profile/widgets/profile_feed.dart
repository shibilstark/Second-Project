// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:social_media/application/profile/profile_cubit.dart';
// import 'package:social_media/core/constants/constants.dart';
// import 'package:social_media/domain/models/post_model/post_model.dart';
// import 'package:social_media/domain/models/user_model/user_model.dart';
// import 'package:social_media/presentation/screens/feeds/feeds.dart';
// import 'package:social_media/presentation/widgets/common_appbar.dart';

// class ProfileFeedScreen extends StatelessWidget {
//   const ProfileFeedScreen({Key? key, required this.post, required this.user})
//       : super(key: key);
//   final UserModel user;
//   final PostModel post;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           child: CommonAppBar(title: "Post"), preferredSize: appBarHeight),
//       body: Container(
//         padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 15.sm),
//         child: BlocBuilder<ProfileCubit, ProfileState>(
//           builder: (context, state) {
//             final newPost = (state as ProfileSuccess)
//                 .posts
//                 .firstWhere((element) => element.postId == post.postId);
//             return FeedWidget();
//           },
//         ),
//       ),
//     );
//   }
// }
