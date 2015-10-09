//
//  CreatorRatingTableViewCell.m
//  PickUP
//
//  Created by Steve on 2015-10-06.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "CreatorRatingTableViewCell.h"
#import "Rating.h"

@implementation CreatorRatingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)firstStar:(UIButton *)sender {
    NSLog(@"Pressed!");
//    [[self.firstStar setImage:[UIImage ImageNamed:@"unselectedImage.png"] forState: UIControlStateNormal];
    [self.firstStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.secondStar setImage:[UIImage imageNamed:@"emptyStar.png"] forState:UIControlStateNormal];
    [self.thirdStar setImage:[UIImage imageNamed:@"emptyStar.png"] forState:UIControlStateNormal];
    [self.forthStar setImage:[UIImage imageNamed:@"emptyStar.png"] forState:UIControlStateNormal];
    [self.fifthStar setImage:[UIImage imageNamed:@"emptyStar.png"] forState:UIControlStateNormal];
    
    Rating *rating = [Rating object];
    rating.score = 1;
    [rating saveInBackground];
}
- (IBAction)secondStar:(UIButton *)sender {
    [self.firstStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.secondStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.thirdStar setImage:[UIImage imageNamed:@"emptyStar.png"] forState:UIControlStateNormal];
    [self.forthStar setImage:[UIImage imageNamed:@"emptyStar.png"] forState:UIControlStateNormal];
    [self.fifthStar setImage:[UIImage imageNamed:@"emptyStar.png"] forState:UIControlStateNormal];
    Rating *rating = [Rating object];
    rating.score = 2;
    [rating saveInBackground];
}
- (IBAction)thirdStar:(UIButton *)sender {
    [self.firstStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.secondStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.thirdStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.forthStar setImage:[UIImage imageNamed:@"emptyStar.png"] forState:UIControlStateNormal];
    [self.fifthStar setImage:[UIImage imageNamed:@"emptyStar.png"] forState:UIControlStateNormal];
    Rating *rating = [Rating object];
    rating.score = 3;
    [rating saveInBackground];
    
}
- (IBAction)forthStar:(UIButton *)sender {
    [self.firstStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.secondStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.thirdStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.forthStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.fifthStar setImage:[UIImage imageNamed:@"emptyStar.png"] forState:UIControlStateNormal];
    Rating *rating = [Rating object];
    rating.score = 4;
    [rating saveInBackground];
    
}
- (IBAction)fifthStar:(UIButton *)sender {
    [self.firstStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.secondStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.thirdStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.forthStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    [self.fifthStar setImage:[UIImage imageNamed:@"filledStar.png"] forState:UIControlStateNormal];
    Rating *rating = [Rating object];
    rating.score = 5;
    [rating saveInBackground];
    
}

@end
