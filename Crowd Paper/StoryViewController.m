//
//  StoryViewController.m
//  Crowd Paper
//
//  Created by Ehud Adler on 3/24/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "StoryViewController.h"
#import <Parse/Parse.h>
#import "TopCell.h"
#import "BottomCell.h"
#import "StoryRender.h"

@interface StoryViewController ()<UIAlertViewDelegate>

@end
NSString *ID;
NSString *dateString;
NSString *sharedBy;
NSString *titleText;
NSURL *Url;
UIView *navTitle;
float scale;
NSAttributedString *decodedString;
CGSize size;
UITextView *calculationView;
UIPanGestureRecognizer *pan;
UILabel *fromLabel;
StoryRender *storyRender;
UILongPressGestureRecognizer *longpress;
@implementation StoryViewController

-(void)viewDidDisappear:(BOOL)animated{


}
-(void)viewWillAppear:(BOOL)animated{

	
}
- (void)viewDidLoad {
    [super viewDidLoad];
	scale = 14;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	ID = [defaults objectForKey:@"ID"];

	[self find];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)find{
	
	PFQuery *query = [PFQuery queryWithClassName:@"Story"];
	
	self.selectedMessage = [query getObjectWithId:ID];
	calculationView = [[UITextView alloc] init];
	NSString *encodedString = [self.selectedMessage objectForKey:@"Story"];
	decodedString = [[NSAttributedString alloc] initWithData:[encodedString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
	
	NSLog(@"Decoded String = %@",decodedString);
	
	[calculationView setAttributedText:decodedString];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = 3;
	paragraphStyle.headIndent = 10;
	paragraphStyle.tailIndent = self.view.frame.size.width-20;
	paragraphStyle.firstLineHeadIndent = 20;
	paragraphStyle.paragraphSpacing = 15;
		//paragraphStyle.minimumLineHeight = .5;
	calculationView.attributedText = decodedString;
	NSMutableAttributedString *nsat = [calculationView.attributedText mutableCopy];
	
	[nsat beginEditing];
	[nsat addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, decodedString.length)];
	[nsat endEditing];
	[calculationView setAttributedText:nsat];
		//UIFont *newFont = [calculationView.font fontWithSize:scale];
	calculationView.font = [UIFont fontWithName:@"Caviar Dreams" size:scale];
	
	size = [calculationView sizeThatFits:CGSizeMake(275, CGFLOAT_MAX)];
	[calculationView setAttributedText:decodedString];
	
	calculationView.font = [UIFont fontWithName:@"Caviar Dreams" size:scale];

	size = [calculationView sizeThatFits:CGSizeMake(275, CGFLOAT_MAX)];

	NSString *date = [self.selectedMessage objectForKey:@"Date"];
	if (![date isKindOfClass:[NSNull class]]){
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		NSLog(@"Date = %@",date);
		[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
		NSDate *dateFromString = [[NSDate alloc] init];
			// voila!
		dateFromString = [dateFormatter dateFromString:date];
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"dd/MM/yyyy"];
		dateString = [dateFormatter stringFromDate:dateFromString];
	}
	
	NSString *author = [self.selectedMessage objectForKey:@"Author"];
	if (![author isKindOfClass:[NSNull class]]){

		sharedBy = author;
	}
	titleText = [self.selectedMessage objectForKey:@"Title"];

	[self.tableView reloadData];



}
- (IBAction)forward:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forward"
													message:@"Press forward to pass on this article"
												   delegate:self
										  cancelButtonTitle:@"Nevermind"
										  otherButtonTitles:@"Forward", nil];
	
	alert.tag = 100;
	
	[alert show];
	
	
		//[alert release];
	
	
	
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	

	if (alertView.tag == 100) {

		if (buttonIndex == 0) {// 1st Other Button
		}
		else if (buttonIndex == 1) {// 2nd Other Button
			
				//NSLog(@"BUTTON 1)");
			PFQuery *query = [PFQuery queryWithClassName:@"Story"];
			[query whereKey:@"objectId" equalTo:ID];
			[query getFirstObjectInBackgroundWithBlock:^(PFObject * Story, NSError *error) {
				if (!error) {
					NSLog(@"Story = %@",Story);
					[Story addUniqueObject:[PFUser currentUser].username forKey:@"People"];
					[Story saveInBackground];
				} else {
					NSLog(@"Error: %@", error);
				}
			}];
		}
		
	}
	else {

		
	}
	
}



-(BOOL)prefersStatusBarHidden{
	return  true;
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"cellOne";
	TopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[TopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	static NSString *CIdentifier = @"cellTwo";
	BottomCell *twocell = [tableView dequeueReusableCellWithIdentifier:CIdentifier];
	if (!twocell) {
		twocell = [[BottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CIdentifier];
	}
	
	
	if(indexPath.row == 0){
		
	cell.date.text = dateString;
	cell.title.text = titleText;
	cell.author.text = sharedBy;
		
	return cell;
		
	}else if(indexPath.row == 1){
		NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
		paragraphStyle.lineSpacing = 3;
		paragraphStyle.headIndent = 10;
		paragraphStyle.tailIndent = self.view.frame.size.width-20;
		paragraphStyle.firstLineHeadIndent = 20;
		paragraphStyle.paragraphSpacing = 15;
			//paragraphStyle.minimumLineHeight = .5;
		twocell.story.attributedText = decodedString;
		NSMutableAttributedString *nsat = [twocell.story.attributedText mutableCopy];
		
		[nsat beginEditing];
		[nsat addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, decodedString.length)];
		[nsat endEditing];
		[twocell.story setAttributedText:nsat];
		
		twocell.story.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
		NSMutableAttributedString *res = [twocell.story.attributedText mutableCopy];
		[res beginEditing];
		[res enumerateAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(0,res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
			
			if (value){
				[res addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleNone) range:range];
				[res endEditing];
				[twocell.story setAttributedText:res];
				
			}
		}];

//		UIFont *newFont = [twocell.story.font fontWithSize:scale];

		
		twocell.story.font = [UIFont fontWithName:@"Caviar Dreams" size:scale];


	return twocell;
	}
	
	return nil;
}
- (CGFloat)textViewHeightForAttributedTextWidth: (CGFloat)width {
NSLog(@"size = %f",size.height);
return size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == 0){
		return 126;
	}else{
		return [self textViewHeightForAttributedTextWidth:self.tableView.frame.size.width];
	}
}





@end
