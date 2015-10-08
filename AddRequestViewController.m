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
    request.delCoordinate = [self address:request.deliverLocation];
    
    
    // PROBLEM!
    pickUp.location = self.pickUplocation.text;
    pickUp.coordinate = [self address:pickUp.location];
    
    request.pickupLocation = pickUp;
    
    request.itemCost = [self.itemCost.text floatValue];
    
    // Item Image
    NSData *imageData = UIImageJPEGRepresentation(self.itemImage.image, 0.95);
    PFFile *imageFile = [PFFile fileWithName:@"itemPicture.png" data:imageData];
    request.itemImage = imageFile;
    [pickUp saveInBackground];
    //start spinning
    
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (succeeded) {
            [self.delegate didAddNewItem];
            
            // stop spinning
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
}

#pragma mark - Geocoder -

- (PFGeoPoint *)address:(NSString *)location{
    
    PFGeoPoint *newLoc = [PFGeoPoint new];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    NSString *address = location;
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            newLoc.longitude = placemark.location.coordinate.longitude;
            newLoc.latitude = placemark.location.coordinate.latitude;
        }
    }];
    return newLoc;
}

// >>>>> Ask <<<<<

- (void)city:(PFGeoPoint *)coordinate completion:(void (^)(NSString *loc))completion {
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coordinate.longitude longitude:coordinate.latitude];
    
    CLGeocoder *geocoder = [CLGeocoder new];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            completion(placemark.locality);
        }
    }];
    
}

// >>>>> ASK <<<<<
     
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
