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
    if (![User currentUser]) {
        PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
        logInController.fields = (PFLogInFieldsFacebook);
        logInController.delegate = self;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -200, 200, 300)];
        UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, 200, 200)];
        logoImage.image = [UIImage imageNamed:@"pickUpIcon"];
        
        
//        NSLayoutConstraint *logoTop = [NSLayoutConstraint
//                                       constraintWithItem:logoImage
//                                                attribute:NSLayoutAttributeTop
//                                                relatedBy:NSLayoutRelationEqual
//                                                   toItem:view
//                                                attribute:NSLayoutAttributeTopMargin
//                                               multiplier:1
//                                                 constant:0];
//        
//        NSLayoutConstraint *logoLeft = [NSLayoutConstraint
//                                        constraintWithItem:logoImage
//                                        attribute:NSLayoutAttributeLeft
//                                        relatedBy:NSLayoutRelationEqual
//                                        toItem:view
//                                        attribute:NSLayoutAttributeLeftMargin
//                                        multiplier:1
//                                        constant:0];
//        NSLayoutConstraint *logoWidth = [NSLayoutConstraint
//                                        constraintWithItem:logoImage
//                                        attribute:NSLayoutAttributeWidth
//                                        relatedBy:NSLayoutRelationEqual
//                                        toItem:nil
//                                        attribute:NSLayoutAttributeNotAnAttribute
//                                        multiplier:1
//                                        constant:200];
//        NSLayoutConstraint *logoHeight = [NSLayoutConstraint
//                                        constraintWithItem:logoImage
//                                        attribute:NSLayoutAttributeHeight
//                                        relatedBy:NSLayoutRelationEqual
//                                        toItem:nil
//                                        attribute:NSLayoutAttributeNotAnAttribute
//                                        multiplier:1
//                                        constant:200];
//        
//        [logoImage addConstraints:@[logoTop, logoLeft, logoWidth, logoHeight]];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 100)];
//        label.text = @"Pick UP";
        
        
        [view addSubview:logoImage];
//        [view addSubview:label];
        logInController.logInView.logo = view;
        logInController.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:240.0/255.0 blue:215.0/255.0 alpha:1.0];
        [self presentViewController:logInController animated:YES completion:nil];
        
    }else {
        [self pushToTabBar];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PFLogInViewControllerDelegate -

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {

    User *myUser = (User*)user;
    
    [self loadData:myUser];
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

- (void)loadData:(User *)user {
    
    
    
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
            user.fullName = name;
            [user saveInBackground];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:pictureURL
                                                                completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                    
                                                                    NSData *imageData = [NSData dataWithContentsOfURL:location];
                                                                    PFFile *file = [PFFile fileWithData:imageData];
                                                                    
                                                                    user.profilePicture = file;
                                                                    [user saveInBackground];
                                                                    
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                                                                                        UIUserNotificationTypeBadge |
                                                                                                                        UIUserNotificationTypeSound);
                                                                        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                                                                                 categories:nil];
                                                                        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                                                                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                                                                    });
                                                                    
                                                                    
                                                                }];
            [downloadTask resume];
        }
    }];
}
@end
        
