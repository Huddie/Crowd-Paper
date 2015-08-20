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
UIImage *mainAritcleImage;
UIView *navTitle;
float scale;
BOOL visualEffect;
NSAttributedString *decodedString;
CGSize size;
UITextView *calculationView;
UIPanGestureRecognizer *pan;
UILabel *fromLabel;
StoryRender *storyRender;
NSMutableParagraphStyle *paragraphStyle;
UILongPressGestureRecognizer *longpress;
CGRect originalFrame;
@implementation StoryViewController

-(void)viewDidDisappear:(BOOL)animated{


}
-(void)viewWillAppear:(BOOL)animated{
    originalFrame = self.tabBarController.tabBar.frame;
    BottomCell *bottomCell = [[BottomCell alloc]init];
    TopCell *topCell = [[TopCell alloc]init];

    topCell.VEV.frame = CGRectMake(topCell.VEV.frame.origin.x, topCell.VEV.frame.origin.y, self.tableView.frame.size.width, topCell.frame.size.height);
    topCell.aritcleImage.frame = CGRectMake(topCell.aritcleImage.frame.origin.x, topCell.aritcleImage.frame.origin.y, self.tableView.frame.size.width, topCell.frame.size.height);

    
    
    bottomCell.story.frame = CGRectMake(bottomCell.story.frame.origin.x, bottomCell.story.frame.origin.y, self.tableView.frame.size.width, bottomCell.story.frame.size.height);
}
- (void)viewDidLoad {
    [super viewDidLoad];

    paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.headIndent = 10;
    paragraphStyle.tailIndent = self.view.frame.size.width-20;
    paragraphStyle.firstLineHeadIndent = 20;
    paragraphStyle.paragraphSpacing = 15;
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
	
    NSMutableAttributedString *nsat = [decodedString mutableCopy];
    [nsat beginEditing];
    [nsat addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, decodedString.length)];
    [nsat endEditing];
    
    [calculationView setAttributedText:nsat];
    
    calculationView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSMutableAttributedString *res = [calculationView.attributedText mutableCopy];
    [res beginEditing];
    [res enumerateAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(0,res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        if (value){
            [res addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleNone) range:range];
            [res endEditing];
            [calculationView setAttributedText:res];
            
        }
    }];
    
    calculationView.font = [UIFont fontWithName:@"Caviar Dreams" size:scale];
    
	size = [calculationView sizeThatFits:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)];

    NSLog(@"Size = %f",size.height);
    
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

    NSString *imageURL = [self.selectedMessage objectForKey:@"ImageURL"];

    
    NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:imageURL]];
    mainAritcleImage = [UIImage imageWithData: data];
    
    
    
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
    cell.aritcleImage.image = mainAritcleImage;
    
        if (mainAritcleImage) {
            NSLog(@"THIS PAGE HAS AN IMAGE");
            cell.VEV.alpha = 1;
            cell.seperatorView.hidden = YES;
        }else{
            
            cell.VEV.alpha = 0;
            cell.seperatorView.hidden = NO;

        }
	return cell;
		
	}else if(indexPath.row == 1){

        
		NSMutableAttributedString *nsat = [decodedString mutableCopy];
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

		twocell.story.font = [UIFont fontWithName:@"Caviar Dreams" size:scale];

        size = [twocell.story sizeThatFits:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)];

	return twocell;
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == 0){
		return 126;
	}else{
        return size.height;
	}
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    UITabBar *tb = self.tabBarController.tabBar;
//    NSInteger yOffset = scrollView.contentOffset.y;
//    if (yOffset > 0) {
//        tb.frame = CGRectMake(tb.frame.origin.x, originalFrame.origin.y + yOffset, tb.frame.size.width, tb.frame.size.height);
//
//    }
//    if (yOffset < 1) tb.frame = originalFrame;
//
//}


@end
