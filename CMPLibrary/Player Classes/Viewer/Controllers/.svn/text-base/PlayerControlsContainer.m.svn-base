//
//  CBCScreenerPlayerControlsController.m
//  CM Library
//
//  Created by Saravana Kumar on 9/23/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import "PlayerControlsContainer.h"
#import "PlayerProductConstants.h"
#import "PlayerUtilities.h"
#import "PlayerControlsControllerBase.h"
#import "CustomPlayerController.h"

@interface PlayerControlsContainer ()
//Player Controls Controller object
@property (nonatomic, weak) UIViewController                    *controller;
@end

@implementation PlayerControlsContainer

#pragma mark - private methods
-(void)initHUD
{    
    UIViewController    *controller = nil;

    CustomPlayerController *playController  = (CustomPlayerController*)self.delegate;
    NSInteger controlType       = playController.config.controlType;
  
    switch (controlType)
    {
        case CONTROL_TYPE_PUBLISH:
        case CONTROL_TYPE_FULLFILLMENT:
            controller = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_PUBLISH_CONTROLS];
            break;
        case CONTROL_TYPE_ADVANCED:
            controller = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_REVIEW_CONTROLS];
            break;
        case CONTROL_TYPE_INFORMATION:
            controller = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_STANDARD_CONTROLS];
            break;
        case CONTROL_TYPE_REVIEW:
            controller = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_REVIEW_CONTROLS];
            break;
        case CONTROL_TYPE_PREVIEW:
            controller = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_PREVIEW_CONTROLS];
            break;
        case CONTROL_TYPE_ANNOTATION:
            controller = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_ANNOTATION_CONTROLS];
            break;
        case CONTROL_TYPE_RANGE_COMMENT:
            controller = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_RANGE_ANNOTATION_CONTROLS];
            break;
        case CONTROL_TYPE_EXECUTIVE:
            controller = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_EXECUTIVE_PLAYER_CONTROLS];
            break;
        default:
            controller = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_PREVIEW_CONTROLS];
            break;
    }
    
    _controller = controller;
    
    //Set the Delgate Object
    [(PlayerControlsControllerBase*)_controller setDelegate:self.delegate];
    
    [_controller.view setFrame:[self.view bounds]];
    [_controller.view setAlpha:0.0f];
    [self.view addSubview:_controller.view];
    [self addChildViewController:_controller];
    
    [UIView animateWithDuration:0.2f animations:^{ 
        [_controller.view setAlpha:1.0f];
    } completion:nil];
    
}


#pragma mark - public method
-(UIViewController*)getCurrentController {
    return _controller;
}

#pragma mark - self methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initHUD];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
}

@end
