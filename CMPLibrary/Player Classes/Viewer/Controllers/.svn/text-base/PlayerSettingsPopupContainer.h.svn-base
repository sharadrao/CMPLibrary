//
//  PlayerSettingsPopupContainer.h
//  CM Library
//
//  Created by Paridhi Malviya on 5/20/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerSettingsPopUpDelegate.h"

@protocol CBCPlayerSettingsSwitchOptionDelegate <NSObject>

-(void)switchCategoryOption:(NSInteger)index;

@end


@interface PlayerSettingsPopupContainer : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, weak) id <PlayerSettingsPopUpDelegate> delegate;
@property (nonatomic, weak) id <CBCPlayerSettingsSwitchOptionDelegate> switchOptionDelegate;

-(void)switchToSelectedOption:(NSInteger)item;
-(void)getCategories:(NSArray *)categoryArray;

@end
