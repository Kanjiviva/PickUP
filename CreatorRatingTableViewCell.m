//
//  CreatorRatingTableViewCell.m
//  PickUP
//
//  Created by Steve on 2015-10-06.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "CreatorRatingTableViewCell.h"
#import "Rating.h"

@interface CreatorRatingTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *firstStar;
@property (weak, nonatomic) IBOutlet UIButton *secondStar;
@property (weak, nonatomic) IBOutlet UIButton *thirdStar;
@property (weak, nonatomic) IBOutlet UIButton *forthStar;
@property (weak, nonatomic) IBOutlet UIButton *fifthStar;
@end

@implementation CreatorRatingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)enableStarButtons:(BOOL)enabled {

    self.firstStar.enabled = enabled;
    self.secondStar.enabled = enabled;
    self.thirdStar.enabled = enabled;
    self.forthStar.enabled = enabled;
    self.fifthStar.enabled = enabled;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)firstStar:(UIButton *)sender {
    [self updateStars:1];
}
- (IBAction)secondStar:(UIButton *)sender {
    [self updateStars:2];
}
- (IBAction)thirdStar:(UIButton *)sender {
    [self updateStars:3];
}
- (IBAction)forthStar:(UIButton *)sender {
    [self updateStars:4];
}
- (IBAction)fifthStar:(UIButton *)sender {
    [self updateStars:5];
}

-(void)updateStars:(int)rating {

    
    self.rating.score = rating;
    
    UIImage *filled = [UIImage imageNamed:@"filledStar"];
    UIImage *empty = [UIImage imageNamed:@"emptyStar"];
    
    UIImage *firstStar = (rating > 0 ? filled : empty);
    UIImage *secondStar = (rating > 1 ? filled : empty);
    UIImage *thirdStar = (rating > 2 ? filled : empty);
    UIImage *forthStar = (rating > 3 ? filled : empty);
    UIImage *fifthStar = (rating > 4 ? filled : empty);
    
    [self.firstStar setImage:firstStar forState:UIControlStateNormal];
    [self.secondStar setImage:secondStar forState:UIControlStateNormal];
    [self.thirdStar setImage:thirdStar forState:UIControlStateNormal];
    [self.forthStar setImage:forthStar forState:UIControlStateNormal];
    [self.fifthStar setImage:fifthStar forState:UIControlStateNormal];
    
}

@end
