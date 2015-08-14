//
//  RSSEntry.m
//  Crowd Paper
//
//  Created by Ehud Adler on 3/26/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "RSSEntry.h"

@implementation RSSEntry
@synthesize blogTitle = _blogTitle;
@synthesize articleTitle = _articleTitle;
@synthesize articleUrl = _articleUrl;
@synthesize articleDate = _articleDate;

- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate
{
	if ((self = [super init])) {
		_blogTitle = [blogTitle copy];
		_articleTitle = [articleTitle copy];
		_articleUrl = [articleUrl copy];
		_articleDate = [articleDate copy];
	}
	return self;
}

- (void)dealloc {
	_blogTitle = nil;
	_articleTitle = nil;
	_articleUrl = nil;
	_articleDate = nil;
}

@end