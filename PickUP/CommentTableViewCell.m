//
//  CommentTableViewCell.m
//  PickUP
//
//  Created by Steve on 2015-10-06.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "User.h"

@interface CommentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingCreatorLabel;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setRating:(Rating *)rating {
    _rating = rating;
    [self setup];
}

- (void)setup {
    self.commentLabel.text = self.rating.comment;
    
    self.ratingCreatorLabel.text = self.rating.ratingCreator.fullName;
}
@end
