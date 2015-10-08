//
//  TopCell.h
//  Crowd Paper
//
//  Created by Ehud Adler on 4/3/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *author;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *aritcleImage;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *VEV;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;

@end
