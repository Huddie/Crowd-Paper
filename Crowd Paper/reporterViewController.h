//
//  reporterViewController.h
//  Crowd Paper
//
//  Created by Ehud Adler on 9/16/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "ViewController.h"
#import <WordPress-iOS-Editor/WPEditorViewController.h>

@interface reporterViewController : WPEditorViewController <WPEditorViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *article;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UITextField *articleTitle;


@end
