//
//  ArticleCell.h
//  Crowd Paper
//
//  Created by Ehud Adler on 3/9/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>
@interface ArticleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UILabel *genre;
@property (strong, nonatomic) IBOutlet UILabel *wordCount;
@property (strong, nonatomic) IBOutlet UIImageView *articleImage;
@property (strong, nonatomic) IBOutlet UILabel *sharedBy;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UILabel *articleStory;
@property (strong, nonatomic) IBOutlet UIView *Mainview;
@property (strong, nonatomic) IBOutlet UILabel *Summary;



@end
