//
//  GridGraphic.h
//  EndlessGrid
//
//  Created by Natasha on 24.09.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingView;
@protocol SettingsViewDelegate;

@interface GridGraphic : UIView 
@property (retain, nonatomic) NSNumber* cellHeight;
@property (retain, nonatomic) NSNumber* cellWidth;
@property (assign, nonatomic) CGFloat gridOffsetX;
@property (assign, nonatomic) CGFloat gridOffsetY;

@property (nonatomic) ActionType actionType;

- (void)addCustomShape:(NSMutableArray*)point;
- (void)clearBoard;
@end
