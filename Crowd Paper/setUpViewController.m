//
//  setUpViewController.m
//  Crowd Paper
//
//  Created by Ehud Adler on 3/25/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "setUpViewController.h"
#import <Parse/Parse.h>
@interface setUpViewController ()

@end

@implementation setUpViewController

-(void)viewWillAppear:(BOOL)animated{
    
    
    _signin.layer.cornerRadius = _signin.frame.size.height/2;
    _signup.layer.cornerRadius = _signup.frame.size.height/2;
	self.navigationController.navigationBar.hidden = true;
	
	NSLog(@"USER = %@",[PFUser currentUser].username);
	if ([PFUser currentUser] == nil) {
	}else{
		[self performSegueWithIdentifier:@"toApp" sender:self];
	}
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = true;
    
    NSLog(@"USER = %@",[PFUser currentUser].username);
    if ([PFUser currentUser] == nil) {
    }else{
        [self performSegueWithIdentifier:@"toApp" sender:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self.username resignFirstResponder];
    [self.password resignFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)signIn:(id)sender {
 NSString *username = self.username.text;
	
	NSString *password = self.password.text;
	
	if ([username length] == 0 || [password length] == 0) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
															message:@"Make sure you enter a username and password!"
														   delegate:Nil cancelButtonTitle:@"Okey"
												  otherButtonTitles:nil];
		[alertView show];
	} else {
		[PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
			if (error) {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
																	message:[error.userInfo objectForKey:@"error"]
																   delegate:Nil cancelButtonTitle:@"Ok"
														  otherButtonTitles:nil];
				[alertView show];
			} else {
				[self performSegueWithIdentifier:@"toApp" sender:self];
			}
		}];
	}

}
- (IBAction)signUp:(id)sender {

							  // use UIAlertController
        UIAlertController *alert= [UIAlertController
								   alertControllerWithTitle:@"Finish"
								   message:@"Enter Phone Number Below"
								   preferredStyle:UIAlertControllerStyleAlert];
    

        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault
												   handler:^(UIAlertAction * action){
														   //Do Some action here
													   UITextField *textField = alert.textFields[0];
													   NSLog(@"number is %@", textField.text);
													   NSLog(@"message sent....");
                                                       
													   NSString *username = self.username.text;
													   
													   
													   NSString *password = self.password.text;
													   
													   
													   PFUser *newUser = [PFUser user];
                                                       
													   [newUser setUsername:username];
													  //[newUser setEmail:textField.text];
													   [newUser setPassword:password];
													   
													   if ([username length] == 0 || [password length] == 0) {
														   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
																											   message:@"Make sure you enter a username, password and an email!"
																											  delegate:Nil cancelButtonTitle:@"Okey"
																									 otherButtonTitles:nil];
														   [alertView show];
													   }else if ([username length] > 7){
														   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
																											   message:@"Usernames cannot exceed 7 characters in length"
																											  delegate:Nil cancelButtonTitle:@"Okey"
																									 otherButtonTitles:nil];
														   [alertView show];
												
													   } else {
													
														   
														   [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
															   if (error) {
																   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
																													   message:[error.userInfo objectForKey:@"error"]
																													  delegate:Nil cancelButtonTitle:@"Ok"
																											 otherButtonTitles:nil];
																   [alertView show];
															   } else {
																   
        // [self performSegueWithIdentifier:@"toApp" sender:self];
        NSLog(@"PFUSER = %@",[PFUser currentUser].username);
        UIAlertController *verifyalert= [UIAlertController
    alertControllerWithTitle:@"Finish" message:@"Enter Phone Number Below" preferredStyle:UIAlertControllerStyleAlert];
UIAlertAction* verok = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action){
                                    UITextField *textField = verifyalert.textFields[0];
                                
                        [PFCloud callFunctionInBackground:@"phoneVerificationCode" withParameters:@{@"phoneNumber":
                                                                                                        
                                                                                                        textField.text}];
                      
                            
                            }];
    UIAlertAction* vercancel = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                                }];
                                                                   
                                                                   [verifyalert addAction:verok];
                                                                   [verifyalert addAction:vercancel];
                                                                   
                                                                   [verifyalert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                                                       textField.placeholder = @"Phone Number";
                                                                       textField.keyboardType = UIKeyboardTypeDefault;
                                                                   }];
                                                                   
                                                                   [self presentViewController:verifyalert animated:YES completion:nil];
                                                               
                                                               
                                                               }
                                                                   
															   
														   }];
													   }
												   }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       NSLog(@"cancel btn");
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
						  
        [alert addAction:ok];
        [alert addAction:cancel];
						  
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
			textField.placeholder = @"Phone Number";
			textField.keyboardType = UIKeyboardTypeDefault;
		}];
						  
        [self presentViewController:alert animated:YES completion:nil];
						  
						  }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSLog(@"%@", [alertView textFieldAtIndex:0].text);
	
	if (buttonIndex == 0) {
		NSLog(@"registering....");
		NSString *username = self.username.text;
		
		
		NSString *password = self.password.text;
		
  
		PFUser *newUser = [PFUser user];
		[newUser setUsername:username];
		[newUser setPassword:password];
		if ([username length] == 0 || [password length] == 0) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
																message:@"Make sure you enter a username, password and an email!"
															   delegate:Nil cancelButtonTitle:@"Okey"
													  otherButtonTitles:nil];
			[alertView show];
		} else {
			
			
			
			[newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				if (error) {
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
																		message:[error.userInfo objectForKey:@"error"]
																	   delegate:Nil cancelButtonTitle:@"Ok"
															  otherButtonTitles:nil];
					[alertView show];
				} else {
					
					[self performSegueWithIdentifier:@"toApp" sender:self];
					
				}
			}];
		}
	}
	
	
}
-(BOOL)prefersStatusBarHidden{
    
    return true;
    
}

@end
