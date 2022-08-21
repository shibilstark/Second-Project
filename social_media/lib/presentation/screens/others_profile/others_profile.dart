import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media/application/others_profile/others_profile_cubit.dart';
import 'package:social_media/core/constants/constants.dart';
import 'package:social_media/presentation/screens/profile/profile.dart';
import 'package:social_media/presentation/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/presentation/screens/feeds/feeds.dart';
import 'package:social_media/presentation/screens/profile/widgets/post_sculpter.dart';
import 'package:social_media/presentation/screens/profile/widgets/profile_info_section.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class OthersProfileScreen extends StatelessWidget {
  const OthersProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: CommonAppBar(title: "Profile"), preferredSize: appBarHeight),
        body: BlocBuilder<OthersProfileCubit, OthersProfileState>(
          builder: (context, state) {
            if (state is OthersProfileSuccess) {
              return Container(
                padding:
                    EdgeInsets.symmetric(vertical: 10.sm, horizontal: 10.sm),
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
        ));
  }
}
