import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class HomeShimmerWidget extends StatelessWidget {
  const HomeShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSeggestionWIdget(),
          Gap(H: 20.sm),
          Container(
            height: 20.sm,
            width: 120.sm,
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.sm)),
          ),
          Gap(H: 20.sm),
          ShimmerFeedsWidget()
        ],
      ),
    );
  }
}

class ShimmerFeedsWidget extends StatelessWidget {
  const ShimmerFeedsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(
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
            Row(
              children: [
                CircleAvatar(
                  radius: 20.sm,
                  backgroundColor: primaryColor.withOpacity(0.1),
                ),
                Gap(W: 10.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 15.sm,
                      width: 80.sm,
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.sm)),
                    ),
                    Gap(H: 5.sm),
                    Container(
                      height: 10.sm,
                      width: 40.sm,
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.sm)),
                    ),
                  ],
                ),
              ],
            ),
            Gap(H: 10.sm),
            Container(
              height: 250.sm,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.sm)),
            ),
            Gap(H: 10.sm),
            Gap(H: 10.sm),
          ],
        ),
      ),
      separatorBuilder: (context, index) => Gap(H: 15.sm),
      itemCount: 4,
    );
  }
}

class ShimmerSeggestionWIdget extends StatelessWidget {
  const ShimmerSeggestionWIdget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.sm),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 20.sm,
              width: 80.sm,
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.sm)),
            ),
          ),
        ),
        Gap(H: 10.sm),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 10.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sm),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withOpacity(0.3),
                blurRadius: 1.sm,
                blurStyle: BlurStyle.outer,
              )
            ],
          ),
          constraints: BoxConstraints(minHeight: 160.sm, maxHeight: 165.sm),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 20.sm),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sm),
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withOpacity(0.03),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.sm,
                    backgroundColor: primaryColor.withOpacity(0.1),
                  ),
                  Gap(H: 10.sm),
                  Container(
                    height: 20.sm,
                    width: 80.sm,
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.sm)),
                  ),
                ],
              ),
            ),
            separatorBuilder: (context, index) => Gap(W: 15.sm),
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}
