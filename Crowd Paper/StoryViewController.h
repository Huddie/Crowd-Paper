//
//  StoryViewController.h
//  Crowd Paper
//
//  Created by Ehud Adler on 3/24/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface StoryViewController : UIViewController <UIAlertViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) PFObject *selectedMessage;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forward;
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *savedFriends;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
