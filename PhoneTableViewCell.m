//
//  PhoneTableViewCell.m
//  PickUP
//
//  Created by Steve on 2015-10-06.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "PhoneTableViewCell.h"

@interface PhoneTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@end

@implementation PhoneTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
