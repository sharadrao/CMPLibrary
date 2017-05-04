//
//  ReviewPlayerControlsController.h
//  CLLibrary
//
//  Created by Madhuri on 3/20/15.
//  Copyright (c) 2015 Prime Focus Technology. All rights reserved.
//

#import "PlayerControlsControllerBase.h"
//#import "PlayListItem.h"
//#import "PlayerConfig.h"
#import "PlayerProductConstants.h"
@interface ReviewPlayerControlsController : PlayerControlsControllerBase



@property (nonatomic,strong) id<PlayerControlsDelegate> delegate;
@property (nonatomic, weak) IBOutlet    UIButton                *segmentPoint;
@property (nonatomic, weak) IBOutlet    UIButton                *segmentBegin;
@property (nonatomic, weak) IBOutlet    UIButton                *segmentEnd;

-(void)enableSegmentOption:(BOOL)sender;
-(void)hideSegments:(BOOL)isHideSegments withHideProgressBar:(BOOL)isHideProgressBar;

-(IBAction)segmentAction:(UIButton*)sender;
-(IBAction)markTouchAction:(UIButton*)sender;
-(IBAction)progressSliderAction:(UISlider*)sender;
-(IBAction)markTouchUpAction:(UIButton*)sender;
-(IBAction)markPanAction:(UIButton*)control withEvent:(UIEvent*)event;

@end
