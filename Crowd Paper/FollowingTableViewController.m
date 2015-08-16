//
//  FollowingTableViewController.m
//  Crowd Paper
//
//  Created by Ehud Adler on 3/25/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "FollowingTableViewController.h"
#import "FollowingTableViewCell.h"
#import <Parse/Parse.h>
@interface FollowingTableViewController ()

@end
@implementation FollowingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
		{
		self.edgesForExtendedLayout = UIRectEdgeNone;
		
		}
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchResultsUpdater = self;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.searchController.searchBar.barStyle = UISearchBarStyleMinimal;
	self.searchController.hidesNavigationBarDuringPresentation = NO;
	self.searchController.searchBar.barTintColor = [UIColor whiteColor];
	self.searchController.searchBar.translucent = YES;
	self.searchController.searchBar.tintColor = [UIColor whiteColor];
	self.definesPresentationContext = YES;
	[self.searchController.searchBar sizeToFit];
	self.searchController.delegate = self;
	self.searchController.searchBar.delegate = self;
	
	[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedText:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"IowanOldStyle-Bold" size:13.0]}]];
	[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];

	
	[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search to follow" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"IowanOldStyle-Bold" size:13.0]}]];
	[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor blackColor]];

	
	[[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
		[UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"IowanOldStyle-Bold" size:18.0], NSFontAttributeName, nil]forState:UIControlStateNormal];
	
	[self.searchController.searchBar setBackgroundImage:[[UIImage alloc]init]];

	self.tableView.tableHeaderView = self.searchController.searchBar;

	[self findFriends];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (self.searchController.active){
	return self.people.count;
	}else{
	return self.friends.count;
	}

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	FollowingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[FollowingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
 if (self.searchController.active){
	PFUser *People = [self.people objectAtIndex:indexPath.row];

	 if ([self.searchController.searchBar.text length] > 0) {
	NSString *username = People.username;
	cell.following.text = username;
	 
	 for (PFUser *user in self.savedFriends){
		 if ([user.username isEqualToString:People.username]) {
			 [cell.yesNo setOn:YES animated:YES];
			 cell.yesNo.enabled = false;
			 
			 break;
		 }else{
			 [cell.yesNo setOn:NO animated:YES];
			 cell.yesNo.enabled = true;

	 	 }
	  }
		 
	 }
	
 }else{
	 PFUser *People = [self.friends objectAtIndex:indexPath.row];
	 NSString *username = People.username;
	 cell.following.text = username;
	 [cell.yesNo setOn:YES animated:YES];
	 cell.yesNo.enabled = true;

 }
	
	return cell;

	
}
- (void)setOn:(BOOL)on animated:(BOOL)animated{
	
}





// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



- (IBAction)switchMoved:(id)sender {
	CGPoint loc = [self.tableView.panGestureRecognizer locationInView:self.tableView];
	NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:loc];
	
	if(self.searchController.active){
		
	PFObject *People = [self.people objectAtIndex:hitIndex.row];
	PFQuery *query = [PFUser query];
	
	[query whereKey:@"username" equalTo:[[People objectForKey:@"username"]
										 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	PFUser *user = (PFUser *)[query getFirstObject];
	PFUser *current = [PFUser currentUser];
	PFRelation *friendsRelation = [current relationForKey:@"friendsRelation"];
				if ([self isFriend:user]) {
						// Remove friend
		
					for (PFUser *friend in self.friended) {
		
						if ([friend.objectId isEqualToString:user.objectId]) {
							[self.friended removeObject:friend];
							break;
						}
					}
					[friendsRelation removeObject:user];
				} else {
					[self.savedFriends addObject:user];
					[friendsRelation addObject:user];
					[[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
						if (error) {
							NSLog(@"%@ %@", error, [error userInfo]);
						}else{
		
							self.people = nil;
						

						}
					}];
				}

	}else{
	PFObject *People = [self.friends objectAtIndex:hitIndex.row];
	PFQuery *query = [PFUser query];
	[query whereKey:@"username" equalTo:[[People objectForKey:@"username"]
											 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	PFUser *user = (PFUser *)[query getFirstObject];
	PFUser *current = [PFUser currentUser];
	PFRelation *friendsRelation = [current relationForKey:@"friendsRelation"];
	[friendsRelation removeObject:user];
	[current saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if(!error){
			[self findFriends];
		}else{
			
		}
	}];
		
	}
}
-(void)findFriends{
	self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
	PFQuery *query = [self.friendsRelation query];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"Error: %@ %@", error, error.userInfo);
		} else {
			self.friends = objects;
			[self.tableview reloadData];
			[self.tableView reloadData];
	
		}
	}];

}

- (BOOL)isFriend:(PFUser *)user
{
	for (PFUser *friend in self.friended) {
		if ([friend.objectId isEqualToString:user.objectId]) {
			[self.tableview reloadData];
			return YES;
			
		}
	}
	return NO;
}



-(void)viewWillDisappear:(BOOL)animated{
	
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

	[self updateSearchResultsForSearchController:self.searchController];

	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	[self findFriends];

}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{

	NSLog(@"Update");

	NSString *searchString = searchController.searchBar.text;
	[self searchForText:searchString];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

	self.savedFriends = [NSMutableArray arrayWithArray:self.friends];
	self.friends = nil;
	[self.tableview reloadData];
	[self.tableView reloadData];
}

- (void)searchForText:(NSString *)searchText{
	if([searchText length] > 0){
	NSLog(@"Search for - %@",searchText);
	PFQuery *query = [PFUser query];
	[query whereKey:@"username" containsString:searchText];
	[query findObjectsInBackgroundWithTarget:self selector:@selector(Callback:error:)];
	 
	}else{
		self.people = nil;
		[self.tableview reloadData];
		[self.tableView reloadData];
	}
}
- (void)Callback:(NSArray *)results error:(NSError *)error {
	self.people = nil;
	self.people = results;
	NSLog(@"MATCHED - %@",self.people);
	[self.tableview reloadData];
	[self.tableView reloadData];
	
								
		}
@end
