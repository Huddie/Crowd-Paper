//
//  StoryRender.h
//  Crowd Paper
//
//  Created by Ehud Adler on 5/7/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface StoryRender : NSObject

@property (nonatomic, strong) PFObject *selectedMessage;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *savedFriends;
@property (nonatomic, strong) PFRelation *friendsRelation;

-(NSAttributedString *)Story:(NSString*)ID viewSize:(float)Size;

-(NSArray *)Friends;

@end
