//
//  FollowingTableViewCell.h
//  Crowd Paper
//
//  Created by Ehud Adler on 3/25/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowingTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *following;
@property (strong, nonatomic) IBOutlet UISwitch *yesNo;

@end
