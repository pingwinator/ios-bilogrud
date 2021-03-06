//
//  StatusCell.m
//  FaceBookUserInfo
//
//  Created by Natasha on 03.09.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "StatusCell.h"

@implementation StatusCell
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize messageTextView;
@synthesize photoImageView;
@synthesize name;
@synthesize time;
@synthesize photo;
@synthesize message;

-(void)dealloc{
    self.nameLabel = nil;
    self.timeLabel = nil;
    self.messageTextView = nil;
    self.photoImageView = nil;
    [super dealloc];
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTime:(NSDate *)c {
    if (![c isEqual:self.time]) {
        self.time = [c copy];
        timeLabel.text = self.time;
    }
}

- (void)setName:(NSString *)n {
    if (![n isEqualToString:name]) {
        name = [n copy];
        nameLabel.text = name;
    }
}

@end
