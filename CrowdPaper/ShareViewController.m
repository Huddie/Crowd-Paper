//
//  ShareViewController.m
//  CrowdPaper
//
//  Created by Ehud Adler on 4/1/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
@interface ShareViewController ()

@end
NSArray *newUrl;
NSTimer *timer;
@implementation ShareViewController

-(void)viewDidLoad{


	
	NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
	NSItemProvider *itemProvider = item.attachments.firstObject;
	if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
		[itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *url, NSError *error) {
			NSUserDefaults *userDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.crowdPaper"];
			
			NSArray *array = [userDefaults objectForKey:@"URL"];
			NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
			[mArray addObject:url.absoluteString];
			NSArray *nArray = [NSArray arrayWithArray:mArray];
			newUrl = nArray;
			
			NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.crowdPaper"];
			[shared setObject:newUrl forKey:@"URL"];
			[shared synchronize];
			
	
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	NSLog(@"EXIT");
	[self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
});
			
		}];
	}
	

}
-(void)viewWillAppear:(BOOL)animated{
	[self.visualEffect.layer setCornerRadius:self.visualEffect.frame.size.height/2];
		// border
	[self.visualEffect.layer setBorderColor:[UIColor lightGrayColor].CGColor];
	[self.visualEffect.layer setBorderWidth:.5f];
	
		// drop shadow
	[self.visualEffect.layer setShadowColor:[UIColor blackColor].CGColor];
	[self.visualEffect.layer setShadowOpacity:0.8];
	[self.visualEffect.layer setShadowRadius:3.0];
	[self.visualEffect.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}
- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}



- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
