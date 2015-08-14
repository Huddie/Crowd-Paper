//
//  FollowingTableViewController.h
//  Crowd Paper
//
//  Created by Ehud Adler on 3/25/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface FollowingTableViewController : UITableViewController<UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *friended;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSArray *people;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *savedFriends;
@property (nonatomic, strong) PFRelation *friendsRelation;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarTop;


@end
