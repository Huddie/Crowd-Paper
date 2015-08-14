//
//  ArticlesViewController.h
//  Crowd Paper
//
//  Created by Ehud Adler on 3/9/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import <Parse/Parse.h>
@interface ArticlesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,MWFeedParserDelegate,UIGestureRecognizerDelegate> {
	
		// Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
		// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
	

}
@property (nonatomic, strong) NSArray *itemsToDisplay;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *username;

@property (nonatomic, strong) NSArray *stories;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (copy, nonatomic) NSString *url;
@property (nonatomic,strong) NSString *strings;

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *savedFriends;
@property (nonatomic, strong) PFRelation *friendsRelation;
@end
