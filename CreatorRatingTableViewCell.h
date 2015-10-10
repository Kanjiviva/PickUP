//
//  CreatorRatingTableViewCell.h
//  PickUP
//
//  Created by Steve on 2015-10-06.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rating.h"

@interface CreatorRatingTableViewCell : UITableViewCell


-(void)updateStars:(int)rating;
-(void)enableStarButtons:(BOOL)enabled;
@property (strong, nonatomic) Rating *rating;

@end
