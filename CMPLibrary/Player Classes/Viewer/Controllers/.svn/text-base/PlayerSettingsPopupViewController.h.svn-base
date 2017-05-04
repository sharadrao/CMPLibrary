//
//  PlayerSettingsPopupViewController.h
//  CM Library
//
//  Created by Paridhi Malviya on 5/20/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerSettingsPopupInterface.h"
#import "PlayerSettingsPopUpDelegate.h"

@interface PlayerSettingsPopupViewController : UIViewController

+(UIViewController*)initWithInterface:(PlayerSettingsPopupInterface*)interface withDelegate:(id)delegate;

@property (nonatomic, weak) id <PlayerSettingsPopUpDelegate>         delegate;
@property (nonatomic, strong) IBOutlet UICollectionView                *categoriesCollectionView;

-(void)switchCategoryOption:(NSInteger)index;
@end
