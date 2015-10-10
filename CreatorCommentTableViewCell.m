//
//  CreatorCommentTableViewCell.m
//  PickUP
//
//  Created by Steve on 2015-10-06.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "CreatorCommentTableViewCell.h"

@interface CreatorCommentTableViewCell ()
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@end

@implementation CreatorCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)textChanged:(id)sender {
    
    self.rating.comment = self.commentsTextField.text;
    
}

@end
