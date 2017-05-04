//
//  TouchManager.h
//  PlayerTest
//
//  Created by Deep Arora on 3/27/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
# import "CustomPlayerController.h"

@interface GestureHandler : NSObject <UIGestureRecognizerDelegate>

@property(nonatomic,weak) CustomPlayerController                *playerController;
@property(nonatomic,weak) UIView                                *playerControlsView;
@property(nonatomic,weak) UIView                                *playerContainerSuperView;
@property(nonatomic,weak) UIView                                *playerContainerView;
@property(nonatomic,weak) UIView                                *playerHeaderView;


-(instancetype)initWithController:(CustomPlayerController *)controller;
-(void)addPlayerGesture;

@end
