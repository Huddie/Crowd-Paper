//
//  RSSEntry.h
//  Crowd Paper
//
//  Created by Ehud Adler on 3/26/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSEntry : NSObject {
	NSString *_blogTitle;
	NSString *_articleTitle;
	NSString *_articleUrl;
	NSDate *_articleDate;
}

@property (copy) NSString *blogTitle;
@property (copy) NSString *articleTitle;
@property (copy) NSString *articleUrl;
@property (copy) NSDate *articleDate;

- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate;

@end