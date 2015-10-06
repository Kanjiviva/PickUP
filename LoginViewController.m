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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "User.h"


@interface LoginViewController () <PFLogInViewControllerDelegate>


@end

@implementation LoginViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (![PFUser currentUser]) {
        PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
        logInController.fields = (PFLogInFieldsFacebook);
        logInController.delegate = self;
        logInController.view.backgroundColor = [UIColor blackColor];
        [self presentViewController:logInController animated:YES completion:nil];
        
//    }else {
//        [self pushToTabBar];
//    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PFLogInViewControllerDelegate -

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self loadData:user];
    [self pushToTabBar];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    // Do nothing, as the view controller dismisses itself
}

#pragma mark - Helper methods -

- (void)pushToTabBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self showViewController:vc sender:nil];
}

- (void)loadData:(PFUser *)user {
    
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
//            NSString *location = userData[@"location"][@"name"];
//            NSString *gender = userData[@"gender"];
//            NSString *birthday = userData[@"birthday"];
//            NSString *relationship = userData[@"relationship_status"];
            [user setObject:name forKey:@"fullName"];
            [user saveInBackground];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:pictureURL
                                                                completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                    
                                                                    NSData *imageData = [NSData dataWithContentsOfURL:location];
                                                                    PFFile *file = [PFFile fileWithData:imageData];
                                                                    
                                                                    [user setObject:file forKey:@"imageFile"];
                                                                    [user saveInBackground];
                                                                }];
            [downloadTask resume];
        }
    }];
}
@end
        
