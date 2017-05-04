//
//  PlayerSettingsPopupBaseController.h
//  CM Library
//
//  Created by Paridhi Malviya on 5/20/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerSettingsPopUpDelegate.h"

@interface PlayerSettingsPopupBaseController : UIViewController

@property (nonatomic, weak) id <PlayerSettingsPopUpDelegate> delegate;


@end
