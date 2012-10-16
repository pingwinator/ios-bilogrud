//
//  BGView.m
//  TetrisNew
//
//  Created by Natasha on 07.10.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "BGView.h"
#import "BGViewBorder.h"
@interface BGView()

- (void)customInit;

@end
@implementation BGView
@synthesize viewBorder;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    if(isiPhone) {
        self.viewBorder = [[[BGViewBorder alloc] initWithFrame:self.frame andOffset:0] autorelease ];
        self.viewBorder.backgroundColor = [UIColor colorWithRed:39.0f/255.0f green:64.0f/255.0f blue:139.0f/255.0f alpha:1];
        [self addSubview:self.viewBorder];
    } else {
        UIImageView* bgImage = [[[UIImageView alloc] initWithFrame:self.frame] autorelease];
        bgImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;;

        [bgImage setImage:[UIImage imageNamed:@"sea.jpeg"] ];
        bgImage.alpha = 0.7f;
        [self addSubview:bgImage];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
}
*/
@end