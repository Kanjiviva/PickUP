//
//  LoginViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface LoginViewController () <PFLogInViewControllerDelegate>

@end

@implementation LoginViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![PFUser currentUser]) {
        PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
        logInController.fields = (PFLogInFieldsFacebook);
        logInController.delegate = self;
        logInController.view.backgroundColor = [UIColor blackColor];
//        logInController.facebookPermissions = @[ @"friends_about_me" ];
        [self presentViewController:logInController animated:YES completion:nil];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PFLogInViewControllerDelegate -

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    // Do nothing, as the view controller dismisses itself
}

#pragma mark - PFSignUpViewControllerDelegate -

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    // Do nothing, as the view controller dismisses itself
}

@end
