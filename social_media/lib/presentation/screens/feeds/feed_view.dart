import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:social_media/application/home/home_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/presentation/screens/feeds/feeds.dart';
import 'package:social_media/presentation/widgets/gap.dart';

final PageStorageBucket globalBucket = PageStorageBucket();
final PageStorageKey _key = PageStorageKey('home_feed');

final ScrollController homeLIstViewScrollController = ScrollController();

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: globalBucket,
      key: _key,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 10.sm),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Container(
                child: CircularProgressIndicator(
                  color: primaryColor,
                  strokeWidth: 1.5.sm,
                ),
              );
            } else if (state is HomeSuccess) {
              return ListView.separated(
                  controller: homeLIstViewScrollController,
                  itemBuilder: (context, index) {
                    final user = state.homeFeed[index].user;
                    final post = state.homeFeed[index].post;
                    return index == 0
                        ? Column(
                            children: [
                              SuggestionViewWidget(peoples: state.peoples),
                              Gap(H: 10.sm),
                              Padding(
                                padding: EdgeInsets.only(left: 10.sm),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Latest Feeds For You",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 15.sm,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ),
                              Gap(H: 10.sm),
                              FeedWidget(
                                post: post,
                                user: user,
                              ),
                            ],
                          )
                        : FeedWidget(
                            post: post,
                            user: user,
                          );
                  },
                  separatorBuilder: (context, index) => Gap(H: 15.sm),
                  itemCount: state.homeFeed.length);
            } else {
              return Container(
                child: Center(
                    child: Text(
                  "Some thing went wrong",
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
              );
            }
          },
        ),
      ),
    );
  }
}
