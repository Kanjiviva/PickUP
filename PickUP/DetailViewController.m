//
//  DetailViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-08.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "DetailViewController.h"
#import "PickUp.h"
#import "CreatorTableViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemDescription;
@property (weak, nonatomic) IBOutlet UILabel *itemCost;
@property (weak, nonatomic) IBOutlet UILabel *itemPickUpLocation;
@property (weak, nonatomic) IBOutlet UILabel *itemDeliverLocation;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setRequest:(Request *)request {
    _request = request;
    
    [self setup];
}

- (void)setup {
    
    if (self.request) {
        self.itemTitle.text = self.request.itemTitle;
        self.itemDescription.text = self.request.itemDescription;
        self.itemCost.text = [NSString stringWithFormat:@"%.2f", self.request.itemCost];
        self.itemPickUpLocation.text = self.request.pickupLocation.location;
        self.itemDeliverLocation.text = self.request.deliverLocation;
        
        PFFile *imageFile = self.request.itemImage;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            self.itemImage.image = [UIImage imageWithData:data];
        }];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCreator"]) {
        CreatorTableViewController *creatorVC = segue.destinationViewController;
        creatorVC.request = self.request;
    }
}

@end
