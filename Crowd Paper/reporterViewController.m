//
//  reporterViewController.m
//  Crowd Paper
//
//  Created by Ehud Adler on 9/16/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "reporterViewController.h"
#import <Parse/Parse.h>
@interface reporterViewController ()

@end

@implementation reporterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submit:(id)sender {
    
    
    if(_articleTitle.text.length > 1 && _article.text.length > 1){
        
        PFObject *newStory = [PFObject objectWithClassName:@"Story"];
        newStory[@"Domain"] = @"Reporter";
        newStory[@"Date"] = [NSDate date];
        newStory[@"Title"] = _articleTitle;
        newStory[@"Summary"] = _article;
        newStory[@"Author"] = [[PFUser currentUser]username];
        newStory[@"wordCount"] = @"100";
        newStory[@"Story"] = _article;
        newStory[@"People"] = [PFUser currentUser].username;
        newStory[@"SharedBy"] = [PFUser currentUser].username;
        
        
        
        [newStory saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if(error)
                 NSLog(@"Error saving %@", error);
             
             else
                 NSLog(@"Successfully added a group");
             
             
         }];

        
    }else{
        
    }
    
}

@end
