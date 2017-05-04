//
//  ConstraintsHandler.h
//  PlayerTest
//
//  Created by Deep Arora on 3/27/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterMarkView.h"
#import "PlayerSettingsPopupViewController.h"
#import "SubtitleItemView.h"

@interface ConstraintsHandler : NSObject

@property (nonatomic,weak) UIView                               *settingsHolderView;
@property(nonatomic, weak) UIView                               *playerContainerView;
@property(nonatomic, weak) UIView                               *waterMarkHolderView;
@property(nonatomic, weak) UIView                               *playerContainerSuperView;


@property(nonatomic, weak) WaterMarkView                        *waterMarkView;
@property (nonatomic,weak) SubtitleItemView                     *subtitleView;
@property (nonatomic,weak) PlayerSettingsPopupViewController    *playerSettingscontroller;

-(void)updatePlayerContainerConstraints;
-(void)updateSettingsPopupConstraints;
-(void)updateWatermarkConstraints;
-(void)updateSubtitleConstraintsInRect:(CGRect)rect;

@end
