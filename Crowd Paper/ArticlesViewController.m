//
//  ArticlesViewController.m
//  Crowd Paper
//
//  Created by Ehud Adler on 3/9/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "ArticlesViewController.h"
#import "ArticleCell.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>
#import "TLYShyNavBarManager.h"
#import <AudioToolbox/AudioServices.h>
#import <CFNetwork/CFNetwork.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import "Base64Transcoder.h"
@interface ArticlesViewController ()<SKPSMTPMessageDelegate>

@end
NSArray *Url;
NSString *ID;
NSString *failedLink;
UIView *navTitle;
UIView *navBottom;
CGRect *rect;
long sections;
UIView *sectionView;
NSMutableArray *images;
UILongPressGestureRecognizer *longpress;
NSMutableParagraphStyle *paragraphStyle;
@implementation ArticlesViewController
@synthesize itemsToDisplay;

-(void)viewDidDisappear:(BOOL)animated{
    [navTitle removeFromSuperview];
    [navBottom removeFromSuperview];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    }
    navTitle = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    navTitle.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    
    navBottom = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height,self.navigationController.navigationBar.frame.size.width,.8)];
    navBottom.backgroundColor = [UIColor blackColor];
    navBottom.alpha = 1;
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0,0,navTitle.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    title.text = @"News";
    title.font = [UIFont fontWithName:@"IowanOldStyle-Bold" size:33.0];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor darkGrayColor];
    [navTitle addSubview:title];
    
    
    [self.navigationController.navigationBar addSubview:navTitle];
    [self.navigationController.navigationBar addSubview:navBottom];
    [self doBackgroundColorAnimation];
    
    
    
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    longpress = [[UILongPressGestureRecognizer alloc]
                 initWithTarget:self action:@selector(handleLongPress:)];
    
    longpress.minimumPressDuration = .5; //seconds
    longpress.delegate = self;
    [self.view addGestureRecognizer:longpress];
    
    
    
    Url = [[NSMutableArray alloc]init];
    self.savedFriends = [[NSMutableArray alloc]init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    self.username.text = [PFUser currentUser].username;
    
    [self findFriends];
    
    
    
    
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}
-(void)viewDidAppear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return parsedItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PFObject *items = [parsedItems objectAtIndex:section];
    sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
    UILabel *label;
    UIImageView *imager;
    imager = [[UIImageView alloc]init];
    if ([[images objectAtIndex:section] isKindOfClass:[NSString class]]) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width-20, 70)];
        [sectionView sizeToFit];
        
    }else{
        
        
        
        
        imager.image = [self convertImageToGrayScale:[UIImage imageWithData:[images objectAtIndex:section]]];
        label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, tableView.frame.size.width-90, 70)];
        [sectionView sizeToFit];
        imager.frame = CGRectMake(10, sectionView.frame.size.height/2-30, 60, 60);
        imager.clipsToBounds = YES;
        imager.contentMode = UIViewContentModeScaleAspectFill;
        imager.layer.cornerRadius = 30;
        [sectionView addSubview:imager];
    }
    
    NSString *string =[items objectForKey:@"Title"];
    [label setText:string];
    label.numberOfLines = 3;
    [label setFont:[UIFont fontWithName:@"IowanOldStyle-Bold" size:16]];
    [label setMinimumScaleFactor:12.0/[UIFont labelFontSize]];    label.textColor = [UIColor whiteColor];
    [sectionView addSubview:label];
    
    [sectionView setBackgroundColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1.0]]; //your background color...
    label.textColor = [UIColor darkGrayColor];
    
    
    //NSLog(@"section height here = %f",sectionView.frame.size.height);
    
    
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, sectionView.frame.size.height-.5, sectionView.frame.size.width-20, .5)];
    bottom.backgroundColor = [UIColor lightGrayColor];
    [sectionView addSubview:bottom];
    return sectionView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PFObject *items = [parsedItems objectAtIndex:indexPath.section];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] setObject:items.objectId forKey:@"ID"];
    [defaults synchronize];
    
    [self performSegueWithIdentifier:@"show" sender:self];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ID";
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PFObject *items = [parsedItems objectAtIndex:indexPath.section];
    if (items) {
        // Process
        
        cell.articleTitle.text =[items objectForKey:@"Title"];
        
        NSString *encodedString = [items objectForKey:@"Summary"];
        
        NSAttributedString *decodedString = [[NSAttributedString alloc] initWithData:[encodedString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
        
        cell.Summary.attributedText = decodedString;
        cell.Summary.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:15];
        cell.Summary.textColor = [UIColor lightGrayColor];
        
        
        
        
        cell.wordCount.text = [NSString stringWithFormat:@"%.2fm",(float)[[items objectForKey:@"wordCount"]intValue]/1437];
        
        NSString *sharedBy = [items objectForKey:@"SharedBy"];
        if (![sharedBy isKindOfClass:[NSNull class]]){
            //NSString *sharedBy;
            
            //				NSScanner *scanner = [NSScanner scannerWithString:author];
            //				NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            //
            //				[scanner scanUpToCharactersFromSet:numbers intoString:&sharedBy];
            
            if([self.savedFriends containsObject:sharedBy]){
                cell.sharedBy.text = sharedBy;
            }else{
                NSMutableArray *peopleArray = [items objectForKey:@"People"];
                
                NSArray *matched = arrayUsingComp(peopleArray,self.savedFriends);
                
                cell.sharedBy.text = [NSString stringWithFormat:@"%@ via %@",sharedBy,matched.firstObject];
                NSLog(@"Shared by: %@ :: Friends - %@ :: People - %@ :: Matched - %@",sharedBy,self.savedFriends,peopleArray,matched);
                
            }
            
        }
        
    }
    
    return cell;
}


NSArray *arrayUsingComp(NSMutableArray *arr1, NSMutableArray *arr2)
{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity: arr1.count + arr2.count];
    
    // Assumes input arrays are sorted. If not, uncomment following two lines.
    //    [arr1 sortUsingSelector: @selector(compare:)];
    //    [arr2 sortUsingSelector: @selector(compare:)];
    
    int i = 0;
    int j = 0;
    while ((i < arr1.count) && (j < arr2.count))
    {
        switch ([[arr1 objectAtIndex: i] compare: [arr2 objectAtIndex: j]])
        {
            case NSOrderedSame:
                [results addObject: [arr1 objectAtIndex: i]];
                i++, j++;
                break;
            case NSOrderedAscending:
                i++;
                break;
            case NSOrderedDescending:
                j++;
                break;
        }
    }
    
    // NOTE: results are sorted too.
    // NOTE 2: loop must go "backward".
    for (NSInteger k = results.count - 1; k > 0; k--)
        if ([[results objectAtIndex: k] isEqual: [results objectAtIndex: k-1]])
            [results removeObjectAtIndex: k];
    
    return results;
}


-(BOOL)prefersStatusBarHidden{
    
    return true;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Remove Article";
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *items = [parsedItems objectAtIndex:indexPath.section];
    NSString *current = [PFUser currentUser].username;
    
    if([[items objectForKey:@"SharedBy"] isEqualToString:current]){
        NSLog(@"Items = %@",items);
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        PFObject *items = [parsedItems objectAtIndex:indexPath.section];
        [items deleteInBackgroundWithTarget:self selector:@selector(retrieve)];
        
        
        
        
    }
}
-(void)refreshTriggered{
    [self findFriends];
    [self retrieve];
}
-(void)retrieve{
    
    
    
    images = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Story"];
    [query whereKey:@"People" containedIn:self.savedFriends];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (PFObject *pics in objects){
            NSData *data = [NSData dataWithContentsOfURL :[NSURL URLWithString:[pics objectForKey:@"ImageURL"]]];
            if(data != nil){
                [images addObject:data];
            }else{
                [images addObject:@"noImage"];
            }
            
        }
        parsedItems = [NSMutableArray arrayWithArray:objects];
        NSLog(@"Retrived = %lu",(unsigned long)parsedItems.count);
        [self.tableView reloadData];
    }];
}


-(void)Upload:(NSString *)url {
    
    NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.readability.com/api/content/v1/parser?url=%@/&token=773b509e25b6dc4b1376ffb5665ea73f1989acbf", url]];
    
    NSLog(@"Readablilty--- %@",myURL);
    
    NSLog(@"text --- %@",url);
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL];
    [request setTimeoutInterval: 10.0]; // Will timeout after 10 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (data != nil && error == nil && data.length > 600)
                               {
                                   NSLog(@"Data = %lu",(unsigned long)data.length);
                                   [self fetchedData:data];
                                   
                               }
                               else
                               {
                                   failedLink = [NSString stringWithFormat:@"%@",myURL];
                                   NSLog(@"Failed Upload");
                                   [self sendEmailInBackground];
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                                   message:@"One of the links obtained was invalid - Error report sent"
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"Ok"
                                                                         otherButtonTitles:nil];
                                   
                                   alert.tag = 102;
                                   
                                   [alert show];
                                   NSUserDefaults *userDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.crowdPaper"];
                                   [userDefaults setObject:nil forKey:@"URL"];
                                   
                               }
                               
                           }];
    
    
    
}
- (void)preUpload{
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.crowdPaper"];
    Url = [userDefaults objectForKey:@"URL"];
    NSMutableArray *finalArray = [NSMutableArray arrayWithArray:Url];
    NSLog(@"URL = %@",Url);
    
    if (Url != nil) {
        for (NSString *theUrl in finalArray){
            [self Upload:theUrl];
            
        }
    }else{
        [self retrieve];
    }
    
}

-(NSString *)flattenHTML:(NSString *)html {
    NSLog(@"html = %@",html);
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        if (![text hasPrefix:@"<img"]){
            html = html;
            
        }else{
            if ([[text lowercaseString] containsString:[@"width" lowercaseString]]){
                NSLog(@"TEXT REGEX: %@",text);
                NSString *expression = @"([Ww]idth)=\"([\\d.]{3,})\"";
                NSError *err;
                
                NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:expression options:0 error:&err];
                NSLog(@"REGEX REGEX: %@",regex);
                
                
                NSString *string = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:[NSString stringWithFormat:@"width=\"%f\"",self.view.frame.size.width-40]];
                NSLog(@"String REGEX: %@",string);
                
                html = [html stringByReplacingOccurrencesOfString:text withString:string];
                
                
            }else{
                
                
                html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:[NSString stringWithFormat:@"%@ width=\"%f\">", text,self.view.frame.size.width-40] ];
            }
            NSLog(@"New html = %@",html);
            
        }
    }
    
    return html;
}

- (void)fetchedData:(NSData *)responseData {
    NSMutableArray *substrings = [NSMutableArray new];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray *types = @[@"domain",@"date_published",@"lead_image_url",@"title",@"excerpt",@"author",@"word_count",@"content"];
    for (NSString *objects in types){
        NSString* addObject = [json objectForKey:objects];
        if ([objects isEqualToString:@"content"]) {
            NSString *contentString = [self flattenHTML:addObject];
            if (contentString != NULL && ![addObject isKindOfClass:[NSNull class]]){
                [substrings addObject:contentString];
            }else{
                contentString = @" ";
                [substrings addObject:contentString];
            }
            
        }else{
            if (addObject != NULL && ![addObject isKindOfClass:[NSNull class]]) {
                [substrings addObject:addObject];
            }else{
                addObject = @" ";
                NSLog(@"OK NUll over here");
                [substrings addObject:addObject];
            }
        }
    }
    
    
    NSAttributedString *attributedSummary = [[NSAttributedString alloc] initWithData:[[substrings objectAtIndex:4] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    //NSString *story = [atrributedHtml string];
    NSString *summary = [attributedSummary string];
    NSMutableArray *peopleArray = [[NSMutableArray alloc]init];
    [peopleArray addObject:[PFUser currentUser].username];
    NSLog(@"String = %@",substrings);
    PFObject *newStory = [PFObject objectWithClassName:@"Story"];
    newStory[@"Domain"] = [substrings objectAtIndex:0];
    newStory[@"Date"] = [substrings objectAtIndex:1];
    newStory[@"ImageURL"] = [substrings objectAtIndex:2];
    newStory[@"Title"] = [substrings objectAtIndex:3];
    newStory[@"Summary"] = summary;
    newStory[@"Author"] = [substrings objectAtIndex:5];
    newStory[@"wordCount"] = [[substrings objectAtIndex:6]stringValue];
    newStory[@"Story"] = [substrings objectAtIndex:7];
    newStory[@"People"] = peopleArray;
    newStory[@"SharedBy"] = [PFUser currentUser].username;
    
    
    
    [newStory saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if(error)
             NSLog(@"Error saving %@", error);
         
         else
             NSLog(@"Successfully added a group");
         
         NSUserDefaults *userDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.crowdPaper"];
         [userDefaults setObject:nil forKey:@"URL"];
         [self retrieve];
         
         
     }];
    
}
- (IBAction)startRefresh:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                    message:@"Are you sure you want to logout?"
                                                   delegate:self
                                          cancelButtonTitle:@"Nevermind"
                                          otherButtonTitles:@"Yes", nil];
    
    alert.tag = 100;
    
    [alert show];
    
}

-(void)findFriends{
    [self.savedFriends removeAllObjects];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    PFQuery *query = [self.friendsRelation query];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(Callback:error:)];
    
}
- (void)Callback:(NSArray *)results error:(NSError *)error {
    self.friends = results;
    
    for (PFUser *user in self.friends){
        [self.savedFriends addObject:user.username];
        NSLog(@"Friends are: %@",self.savedFriends);
        
    }
    [self preUpload];
    
    
}


-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    NSLog(@"PRESSED");
    
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    
    //Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    if (indexPath == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                        message:@"Are you sure you want to logout?"
                                                       delegate:self
                                              cancelButtonTitle:@"Nevermind"
                                              otherButtonTitles:@"Yes", nil];
        
        alert.tag = 100;
        
        [alert show];
        
    } else {
        
        PFObject *items = [parsedItems objectAtIndex:indexPath.row];
        ID = items.objectId;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forward"
                                                        message:@"Press forward to pass on this article"
                                                       delegate:self
                                              cancelButtonTitle:@"Nevermind"
                                              otherButtonTitles:@"Forward", nil];
        
        alert.tag = 101;
        
        [alert show];
        
    }
    
    
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 101) {
        
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
    else if(alertView.tag == 100){
        if (buttonIndex == 0) {// 1st Other Button
        }
        else if (buttonIndex == 1) {// 2n
            [PFUser logOut];
            [self performSegueWithIdentifier:@"logout" sender:self];
        }
        
    }
    
}



-(void)sunnyControlDidStartAnimation{
    [self findFriends];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [navTitle removeFromSuperview];
    
}


// nav Bar Animation
-(void)doBackgroundColorAnimation {
//    static NSInteger i = 0;
//    NSArray *colors = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor blackColor], nil];
//    
//    if(i >= [colors count]) {
//        i = 0;
//    }
//    
//    [UIView animateWithDuration:10.0f animations:^{
//        navBottom.backgroundColor = [colors objectAtIndex:i];
//    } completion:^(BOOL finished) {
//        ++i;
//        [self doBackgroundColorAnimation];
//    }];
//
    navBottom.backgroundColor = [UIColor lightGrayColor];
}



// Sending Error Link Report
-(void)sendEmailInBackground{
}
//    NSLog(@"Start Sending");
//    NSDate *today = [NSDate date];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"dd/MM/yyyy hh-mm:ss"];
//    NSString *dateString = [dateFormat stringFromDate:today];
//    SKPSMTPMessage *emailMessage = [[ SKPSMTPMessage alloc]init];
//    emailMessage.fromEmail = @"par.3inc@gmail.com";
//    emailMessage.toEmail =  @"par.3inc@gmail.com";
//    emailMessage.relayHost = @"smtp.gmail.com";
//    emailMessage.requiresAuth = YES;
//    emailMessage.login =  @"par.3inc@gmail.com";
//    emailMessage.pass = @"*******";
//    emailMessage.subject = @"Crowd Paper Error \n Link obtained is Invalid";
//    emailMessage.wantsSecure = YES;
//    emailMessage.delegate = self;
//    NSString *messageBody = [NSString stringWithFormat:@"Bug Report \n \n  Date = %@ \n \n ------------------------------------------------- \n \n \n User ID = %@ \n \n Username = %@ \n \n Link = %@ \n \n ",[PFUser currentUser].objectId,[PFUser currentUser].username,failedLink,dateString];
//    
//    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,messageBody,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
//    
//    emailMessage.parts = [NSArray arrayWithObjects:plainPart, nil];
//    [emailMessage send];
//    
//    
//}
//-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
//    NSLog(@"Message Failed to send");
//    failedLink = nil;
//}
//-(void)messageSent:(SKPSMTPMessage *)message{
//    NSLog(@"Message Sent");
//    failedLink = nil;
//    
//}
//


@end
