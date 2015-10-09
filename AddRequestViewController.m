//
//  AddRequestViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-06.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "AddRequestViewController.h"
#import "Request.h"
#import <CoreLocation/CoreLocation.h>
#import "User.h"
#import "PickUp.h"



@interface AddRequestViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *itemTitle;
@property (weak, nonatomic) IBOutlet UITextField *pickUplocation;
@property (weak, nonatomic) IBOutlet UITextField *dropOffLocation;
@property (weak, nonatomic) IBOutlet UITextField *itemCost;
@property (weak, nonatomic) IBOutlet UITextField *itemDescription;
@property (weak, nonatomic) IBOutlet UITextField *contactLabel;

@end

@implementation AddRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.itemImage.clipsToBounds = YES;
    self.itemImage.layer.cornerRadius = self.itemImage.frame.size.width/2;
    self.itemImage.layer.borderWidth = 5.0f;
    self.itemImage.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.itemTitle.text = @"Test";
    self.pickUplocation.text = @"Richmond";
    self.dropOffLocation.text = @"Vancouver";
    self.itemCost.text = @"10000";
    self.itemDescription.text = @"Test";
}

#pragma mark - Helper Method -

- (void)saveData{
    
    Request *request = [Request object];
    User *currentUser = [User currentUser];
    PickUp *pickUp = [PickUp object];
    
    request.creatorUser = currentUser;
    request.itemTitle = self.itemTitle.text;
    request.itemDescription = self.itemDescription.text;
    request.itemCost = [self.itemCost.text floatValue];
    request.deliverLocation = self.dropOffLocation.text;
//    request.delCoordinate = [self address:request.deliverLocation];
    
    pickUp.location = self.pickUplocation.text;
//    pickUp.coordinate = [self address:pickUp.location];

    
    request.pickupLocation = pickUp;
    
    request.itemCost = [self.itemCost.text floatValue];
    // Item Image
    NSData *imageData = UIImageJPEGRepresentation(self.itemImage.image, 0.95);
    PFFile *imageFile = [PFFile fileWithName:@"itemPicture.png" data:imageData];
    request.itemImage = imageFile;
    
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.height = MAX(rect.size.height, rect.size.width);
    rect.size.width = MAX(rect.size.height, rect.size.width);
    UIView *overlayView = [[UIView alloc] initWithFrame:rect];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=self.view.center;
    [self.view addSubview:activityView];
    [self.view addSubview:overlayView];
    [activityView startAnimating];
    
    
    
    [self geocodeRequest:request completion:^{
        [self geocodePickupLocation:pickUp completion:^{
            
            [pickUp saveInBackground];
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (succeeded) {
                    [self.delegate didAddNewItem];
                    // stop spinning
                    [activityView stopAnimating];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }
            }];
            
            
        }];
    }];
    
    
    

    
}

#pragma mark - Geocoder -

-(void)geocodePickupLocation:(PickUp *)pickup completion:(void (^)())completion {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:pickup.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            PFGeoPoint *newLoc = [PFGeoPoint new];
            
            newLoc.longitude = placemark.location.coordinate.longitude;
            newLoc.latitude = placemark.location.coordinate.latitude;
            
            
            pickup.coordinate = newLoc;
            pickup.cityName = placemark.locality;
            [pickup saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                completion();
                
            }];
        } else {
            completion();
        }
    }];
}

-(void)geocodeRequest:(Request *)req completion:(void (^)(void))completion {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];

    [geocoder geocodeAddressString:req.deliverLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            PFGeoPoint *newLoc = [PFGeoPoint new];
            
            newLoc.longitude = placemark.location.coordinate.longitude;
            newLoc.latitude = placemark.location.coordinate.latitude;
            
            
            req.delCoordinate = newLoc;
            req.cityName = placemark.locality;
            [req saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                completion();
                
            }];
        }
    }];

}

#pragma mark - Actions -

- (IBAction)selectPhoto:(UITapGestureRecognizer *)sender {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    
    UIAlertController *view = [UIAlertController
                               alertControllerWithTitle:nil
                               message:nil
                               preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photo = [UIAlertAction
                            actionWithTitle:@"Photo Library"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                [self presentViewController:pickerController animated:YES completion:nil];
                                
                            }];
    UIAlertAction *camera = [UIAlertAction
                             actionWithTitle:@"Camera"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                 [self presentViewController:pickerController animated:YES completion:nil];
                                 
                             }];
    
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [view addAction:photo];
    
    [view addAction:cancel];
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        [view addAction:camera];
    }
    
    pickerController.delegate = self;
    
    [self presentViewController:view animated:YES completion:nil];
    
    
}
- (IBAction)savePost:(UIBarButtonItem *)sender {
    
    [self saveData];
    
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Posts" bundle:nil];
    //    UINavigationController *nav = [storyboard instantiateViewControllerWithIdentifier:@"navController"];
    //    [self showViewController:nav sender:nil];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePicker Delegate -

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.itemImage.image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
