import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:review_app/constants/boarder.dart';
import 'package:review_app/constants/color.dart';
import 'package:review_app/features/reviews/presentation/widgets/shadow.dart';
import 'package:review_app/utils/fonts.dart';

class ReviewModel extends StatefulWidget {
  const ReviewModel({super.key});

  @override
  State<ReviewModel> createState() => _ReviewModelState();
}

class _ReviewModelState extends State<ReviewModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
          color: AppColors.primaryColor30,
          borderRadius:
              BorderRadius.circular(AppBoarderRadius.reviewModelRadius),
          boxShadow: ContainerShadow.boxShadow),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppBoarderRadius.reviewModelRadius),
                  child: Image.network(
                      'https://th.bing.com/th/id/OIG.lVXjWwlHyIo4QdjnC1YE',
                      fit: BoxFit.cover)),
              Positioned(
                top: 8,
                left: 8,
                child: Row(
                  children: [
                    Text('\u{20B9}',
                        style: subReviewPrice(
                            color: AppColors.secondaryColor10,
                            boxShadow: TextShadow.textShadow)),
                    Text('${1040}',
                        style:
                            subReviewPrice(boxShadow: TextShadow.textShadow)),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      shadows: [TextShadow.textShadow],
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Text('Nike Air Force (White)', style: reviewTitle()),
              SizedBox(height: 8),
              Text('Men\'s clothing', style: reviewCategory()),
              SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('12/04/2023', style: dateReview()),  
              Row(
                children: [
                  Icon(Icons.star, size: 17, color: Colors.yellow),
                  Icon(Icons.star, size: 17, color: Colors.yellow),
                  Icon(Icons.star, size: 17, color: Colors.yellow),
                  Icon(Icons.star, size: 17, color: AppColors.iconColor),
                  Icon(Icons.star, size: 17, color: AppColors.iconColor),
                ],
              )
            ],
          ),

           
          
        ],
      ),
    );
  }
}