//
//  ProfileController.m
//  TinderStoryboard
//
//  Created by Stefan Lage on 12/01/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//

#import "ProfileController.h"

@interface ProfileController ()

@property (nonatomic, strong) UIImageView* titleView;

@end

@implementation ProfileController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        UIImage *logo = [UIImage imageNamed:@"profile"];
        logo = [logo imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _titleView = [[UIImageView alloc] initWithImage:logo];
        self.navigationItem.titleView = _titleView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *logo = [UIImage imageNamed:@"profile"];
    logo = [logo imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _titleView = [[UIImageView alloc] initWithImage:logo];
    self.navigationItem.titleView = self.titleView;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell                         = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
															  reuseIdentifier:cellIdentifier];
		cell.textLabel.numberOfLines = 0;
	}
	
	return cell;
}

@end
