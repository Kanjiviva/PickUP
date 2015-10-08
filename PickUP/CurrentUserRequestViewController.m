//
//  CurrentUserRequestViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-07.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "CurrentUserRequestViewController.h"

@interface CurrentUserRequestViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchStatus;

@end

@implementation CurrentUserRequestViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.statusLabel.text = @"Active Requests";
}

#pragma mark - Actions -

- (IBAction)switchStatusControl:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        self.statusLabel.text = @"Active Requests";
        
    } else if (sender.selectedSegmentIndex == 1) {
        self.statusLabel.text = @"Accepted Requests";
        
    }
    
}

#pragma mark - Tableview Data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    return cell;
}

@end
