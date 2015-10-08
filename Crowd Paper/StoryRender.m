//
//  StoryRender.m
//  Crowd Paper
//
//  Created by Ehud Adler on 5/7/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "StoryRender.h"
#import <Parse/Parse.h>
@implementation StoryRender
NSAttributedString *decodedString;
CGSize size;
UITextView *calculationView;



-(NSAttributedString *)Story:(NSString *)ID viewSize:(float)Size{
	NSAttributedString *story;
	NSLog(@"ID = %@",ID);


	return story;
}

//-(NSArray *)Friends{
//	self.savedFriends = [[NSMutableArray alloc]init];
//	self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
//	PFQuery *query = [self.friendsRelation query];
//	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//		if (error) {
//			NSLog(@"Error: %@ %@", error, error.userInfo);
//		} else {
//			self.friends = objects;
//			
//			for (PFUser *user in self.friends){
//				[self.savedFriends addObject:user.username];
//				NSLog(@"Friends are: %@",self.savedFriends);
//			}
//			
//		}
//	}];
//	
//}
@end
