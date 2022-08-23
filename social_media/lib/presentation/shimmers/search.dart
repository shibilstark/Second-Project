import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class SearchShimmerTiles extends StatelessWidget {
  const SearchShimmerTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                radius: 15.sm,
                backgroundColor: primaryColor.withOpacity(0.1),
              ),
              title: Row(
                children: [
                  Container(
                    height: 20.sm,
                    width: 100.sm,
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.sm)),
                  ),
                ],
              ),
            ),
        separatorBuilder: (context, index) => Gap(
              H: 10.sm,
            ),
        itemCount: 6);
  }
}
