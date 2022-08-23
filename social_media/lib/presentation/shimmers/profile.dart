import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/presentation/shimmers/home.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class ProfileShimmerWidget extends StatelessWidget {
  const ProfileShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 13.sm),
      child: Column(
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
                    )),
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
          Container(
            height: 20.sm,
            width: 120.sm,
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.sm)),
          ),
          Gap(H: 10.sm),
          Container(
            height: 50.sm,
            width: MediaQuery.of(context).size.width * 0.7.sm,
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.sm)),
          ),
          Gap(H: 10.sm),
          Row(
            children: [
              Expanded(
                  child: Container(
                height: 100.sm,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.sm)),
              )),
              Gap(W: 15.sm),
              Expanded(
                  child: Container(
                height: 100.sm,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.sm)),
              )),
              Gap(W: 15.sm),
              Expanded(
                  child: Container(
                height: 100.sm,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.sm)),
              )),
            ],
          ),
          Gap(H: 10.sm),
          // Expanded(child: ShimmerFeedsWidget())
        ],
      ),
    );
  }
}
