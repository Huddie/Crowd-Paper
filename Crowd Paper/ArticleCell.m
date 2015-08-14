//
//  ArticleCell.m
//  Crowd Paper
//
//  Created by Ehud Adler on 3/9/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "ArticleCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation ArticleCell
@synthesize articleStory,Summary,sharedBy,articleImage,articleTitle,genre,wordCount,bottomView,Mainview;
- (void)awakeFromNib {

	
	
//	UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:articleImage.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(20.0, 20.0)];
//	
//	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//	maskLayer.path  = maskPath.CGPath;
//	articleImage.layer.mask = maskLayer;
//	
//	UIBezierPath *bottommaskPath = [UIBezierPath bezierPathWithRoundedRect:bottomView.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(30.0, 30.0)];
//	
//	
//	CAShapeLayer *bottommaskLayer = [[CAShapeLayer alloc] init];
//	bottommaskLayer.path  = bottommaskPath.CGPath;
//	bottomView.layer.mask = bottommaskLayer;






	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	if (selected) {
	}else{

	}
    // Configure the view for the selected state
}

@end
