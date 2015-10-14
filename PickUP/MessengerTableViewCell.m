//
//  MessengerTableViewCell.m
//  PickUP
//
//  Created by Steve on 2015-10-12.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "MessengerTableViewCell.h"

@interface MessengerTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userProfilePicture;

@end

@implementation MessengerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setConversation:(Conversation *)conversation {
    _conversation = conversation;
    
    [self setup];
}
- (void)setup {
    self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.size.width/2;
    self.userProfilePicture.clipsToBounds = YES;
    
    if ([self.conversation.receiverUser.objectId isEqualToString:[User currentUser].objectId]) {
        
        self.userNameLabel.text = self.conversation.senderUser.fullName;
        PFFile *imageFile = self.conversation.senderUser.profilePicture;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            self.userProfilePicture.image = [UIImage imageWithData:data];
        }];
    } else {
    
        self.userNameLabel.text = self.conversation.receiverUser.fullName;
        PFFile *imageFile = self.conversation.receiverUser.profilePicture;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            self.userProfilePicture.image = [UIImage imageWithData:data];
        }];
    }
    
    
    
}
@end
