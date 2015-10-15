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
#import "PickUP-Swift.h"
#import "SearchViewController.h"

#define kOFFSET_FOR_KEYBOARD 160.0


@interface AddRequestViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, SearchViewControllerDelegate, SearchViewControllerDropOffDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButtonOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButtonOutlet;

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *itemTitle;
@property (weak, nonatomic) IBOutlet UITextField *pickUplocation;
@property (weak, nonatomic) IBOutlet UITextField *dropOffLocation;
@property (weak, nonatomic) IBOutlet UITextField *itemCost;
@property (weak, nonatomic) IBOutlet UITextField *itemDescription;

@property (strong, nonatomic) Request *request;
@property (strong, nonatomic) PickUp *pickUp;
@end

@implementation AddRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.itemImage.clipsToBounds = YES;
    self.itemImage.layer.cornerRadius = self.itemImage.frame.size.width/2;
    self.itemImage.layer.borderWidth = 5.0f;
    self.itemImage.layer.borderColor = [[UIColor alloc] initWithNetHex: 0x989898].CGColor;
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:255 green:255 blue:255];

    self.request = [Request object];
    self.pickUp = [PickUp object];
    
    
    self.itemTitle.text = @"Test";
//    self.pickUplocation.text = @"Richmond";
//    self.dropOffLocation.text = @"Vancouver";
    self.itemCost.text = @"10000";
    self.itemDescription.text = @"Test";
    
    self.itemTitle.textColor = [[UIColor alloc] initWithNetHex:0x16528E];
    self.pickUplocation.textColor = [[UIColor alloc] initWithNetHex:0x16528E];
    self.dropOffLocation.textColor = [[UIColor alloc] initWithNetHex:0x16528E];
    self.itemCost.textColor = [[UIColor alloc] initWithNetHex:0x16528E];
    self.itemDescription.textColor = [[UIColor alloc] initWithNetHex:0x16528E];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:YES];
}

#pragma mark - Helper Method -

- (void)dropOffLocation:(NSString *)dropOffLocation coordinate:(CLLocationCoordinate2D)coordinate cityName:(NSString *)cityName {
    self.dropOffLocation.text = dropOffLocation;
    self.request.deliverLocation = self.dropOffLocation.text;
    self.request.cityName = cityName;
    
    PFGeoPoint *geopint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    self.request.delCoordinate = geopint;
    
}

- (void)searchedLocation:(NSString *)locationName coordinate:(CLLocationCoordinate2D)coordinate cityName:(NSString *)cityName{
    
    self.pickUplocation.text = locationName;
    self.pickUp.location = self.pickUplocation.text;
    
    PFGeoPoint *geopoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    self.pickUp.coordinate = geopoint;
    self.pickUp.cityName = cityName;
}

- (void)saveData{
    
//    Request *request = [Request object];
    User *currentUser = [User currentUser];
//    PickUp *pickUp = [PickUp object];
    
    self.request.creatorUser = currentUser;
    self.request.itemTitle = self.itemTitle.text;
    self.request.itemDescription = self.itemDescription.text;
    self.request.itemCost = [self.itemCost.text floatValue];
//    self.request.deliverLocation = self.dropOffLocation.text;
//    self.pickUp.location = self.pickUplocation.text;
    self.request.pickupLocation = self.pickUp;
    self.request.itemCost = [self.itemCost.text floatValue];
    // Item Image
    NSData *imageData = UIImageJPEGRepresentation(self.itemImage.image, 0.95);
    PFFile *imageFile = [PFFile fileWithName:@"itemPicture.png" data:imageData];
    self.request.itemImage = imageFile;
    
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
    
    
    
//    [self geocodeRequest:request completion:^{
//        [self geocodePickupLocation:pickUp completion:^{
//            
            [self.pickUp saveInBackground];
            [self.request saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (succeeded) {
                    [self.delegate didAddNewItem:self.request];
                    // stop spinning
                    [activityView stopAnimating];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }
            }];
//
//            
//        }];
//    }];
   
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

- (void)checkSavingTime {
    self.cancelButtonOutlet.enabled = YES;
}

- (IBAction)savePost:(UIBarButtonItem *)sender {
    
    if (![self.pickUplocation.text isEqualToString:@""] || ![self.dropOffLocation.text isEqualToString:@""] || self.itemImage.image != nil) {
        [self saveData];
        self.saveButtonOutlet.enabled = NO;
        self.cancelButtonOutlet.enabled = NO;
        [NSTimer scheduledTimerWithTimeInterval:10.0
                                         target:self
                                       selector:@selector(checkSavingTime)
                                       userInfo:nil
                                        repeats:NO];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Oops!!!"
                                                                       message:@"Please fill up the requirement fields!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate -

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
   
}

-(void)keyboardWillHide {
   
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (self.pickUplocation == textField) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GooglePlaces" bundle:nil];
        SearchViewController *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        searchVC.delegate = self;
        
        
//        searchVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self showViewController:searchVC sender:nil];
//           [self.navigationController presentViewController:searchVC animated:YES completion:nil];
//        [self.navigationController pushViewController:searchVC animated:YES];
//        [self.navigationController presentViewController:searchVC animated:YES completion:nil];
//        [self.navigationController popToViewController:searchVC animated:YES]; BAD
        
        
        
    } else if (self.dropOffLocation == textField) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GooglePlaces" bundle:nil];
        SearchViewController *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        searchVC.dropOffDelegate = self;
        [self showViewController:searchVC sender:nil];
    }
    
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // move the view's origin up so that the text field that will be hidden come above the keyboard
        // increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


#pragma mark - UIImagePicker Delegate -

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.itemImage.image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
