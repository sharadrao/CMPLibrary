//
//
//  @class PFTPlayerController A class that encapsulates PLayerView and provides control over the playback as well as holds the state of the player and notifies about status updates.
//
//  Created by Deep Arora on 2/23/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import "PlayerFactory.h"
#import "CustomPlayerController.h"


@implementation PlayerFactory

+(UIViewController*)renderPlayerInContainer:(UIViewController *)controller withConfig:(PlayerConfig *)playerConfig
{
    //Get the desired Player Controller based on Device (iPad/iPhone)
    CustomPlayerController *playerController = (CustomPlayerController *)[PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_PLAYER_CONTROLLER];
    
    //Set the Delegate to CustomPlayerDelegate Protocol
    [playerController setDelegate:(id)controller];
    
    //Set the Player Config to the Player Config 
    [playerController setConfig:playerConfig];
    
    //Adding Player Controller as Child Controller
    [controller addChildViewController:playerController];
    [playerController.view setFrame:[controller.view frame]];
    [controller.view addSubview:playerController.view];
    [playerController willMoveToParentViewController:controller];
   
    return playerController;
}


@end
