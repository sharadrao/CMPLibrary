 //
//  ReviewPlayerControlsController.m
//  CLLibrary
//
//  Created by Madhuri on 3/20/15.
//  Copyright (c) 2015 Prime Focus Technology. All rights reserved.
//

#import "ReviewPlayerControlsController.h"
#import "PlayerProductConstants.h"
#import "ProgressSlider.h"
#import "ControlSlider.h"

#import "PlayerCache.h"

#import "ClearFont.h"
#import "CustomPlayerController.h"

#define SEGMENT_BEGIN   0
#define SEGMENT_END     1
#define SEGMENT_POINT   2

@interface ReviewPlayerControlsController ()

@property (nonatomic, strong) NSArray                           *permissions;
@property (nonatomic, assign) BOOL                              isSegmentActive;
@property (nonatomic, assign) BOOL                              addCommentRightAvailable;
@property (nonatomic, assign) PlayerControlType                 controlType;
@property (nonatomic, assign) CMPItemType                       playlistType;

@end

@implementation ReviewPlayerControlsController

-(void)viewDidLoad {
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

-(void)hideSegmentsOption:(BOOL)isHide
{
    [self.segmentBegin setHidden:isHide];
    [self.segmentEnd setHidden:isHide];
    [self.segmentPoint setHidden:isHide];
}

-(void)initHUD
{
    [self enableSegmentOption:YES];
    [self hideSegments:NO withHideProgressBar:NO];

    
    [self.progressSlider setControlStyle:PLAYER_SLIDER_CUSTOM_COLOR];
    [self.speedSlider setControlStyle:PLAYER_SLIDER_CUSTOM_COLOR];
    [self.progressSlider updateSlider:0 withMax:1.0f andValue:0.0f];
    
    if (_controlType == CONTROL_TYPE_EXECUTIVE)
    {
        //To set image for player controls buttons
        CGSize imgSize = CGSizeMake(26, 26);
        
        [self.playBut setImage:[UIImage imageWithIcon:@"clear-new_playButton" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateNormal];
        [self.playBut setImage:[UIImage imageWithIcon:@"clear-new_pauseButton" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateSelected];
        [self.playerPrevClipBtn setImage:[UIImage imageWithIcon:@"clear-new_rewindButton" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateNormal];
        [self.playerNextClipBtn setImage:[UIImage imageWithIcon:@"clear-new_forwardButton" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateNormal];
        [self.playerPrevSpeedBtn setImage:[UIImage imageWithIcon:@"clear-new_playSlower" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateNormal];
        [self.playerNextSpeedBtn setImage:[UIImage imageWithIcon:@"clear-new_playFaster" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateNormal];
        [self.playerPrevBtn setImage:[UIImage imageWithIcon:@"clear-new_previousButton" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateNormal];
        [self.playerNextBtn setImage:[UIImage imageWithIcon:@"clear-new_nextButton" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateNormal];
        
        imgSize = CGSizeMake(40, 40);
        
        [self.settingBtn setImage:[UIImage imageWithIcon:@"clear-new_settings" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateNormal];
        [self.settingBtn setImage:[UIImage imageWithIcon:@"clear-new_settings" backgroundColor:nil iconColor:[UIColor colorWithRed:21.0/255.0 green:212.0/255.0 blue:243.0/255.0 alpha:1.0] andSize:imgSize] forState:UIControlStateSelected];
        [self.screenSizeBtn setImage:[UIImage imageWithIcon:@"clear-new_fullScreen" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateNormal];
        [self.screenSizeBtn setImage:[UIImage imageWithIcon:@"clear-new_fullScreen_exit" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateSelected];
        [self.helpBtn setImage:[UIImage imageWithIcon:@"clear-help_outline" backgroundColor:nil iconColor:[UIColor whiteColor] andSize:imgSize] forState:UIControlStateNormal];
        
        //To check if the current viewer mode is Advance or not
        [self hideAndShowPlayerControlsBasedOnViewerMode:Review];
        
        //To hide scences duration label for non reel assets
        
        if(_playlistType == Playlist || _playlistType == Reel)
        {
            [self.fastRewindButtonWidth setConstant:0];
            
            //To hide take counter label and show the time counter label in center of the player controls screen if asset type is not REEL
            //  if ([asset.playlistType caseInsensitiveCompare:REEL] != NSOrderedSame)
            if(_playlistType != Playlist)
            {
                [self.takeTimeNameLbl setHidden:YES];
                [self.takeTimeCodeLbl setHidden:YES];
                
                [self.timeInLabelCenter setConstant:0];
            }
        }

    }
}

-(IBAction)segmentAction:(UIButton*)sender
{
    if([sender tag] == 2)
    {
        [self updateSegmentEnd:NO tag:sender.tag];
        return;
    }
    
    if(_isSegmentActive)
    {
        [self updateSegmentEnd:NO tag:sender.tag];
        [_segmentPoint setEnabled:YES];
    }
    else
    {
        [self updateSegmentBegin:YES];
        [_segmentPoint setEnabled:NO];
    }
}

-(void)updateMarker:(BOOL)marker
{
    CGRect progressFrame    = [self.progressSlider frame];
    CGFloat progress        = [self.progressSlider value] / [self.progressSlider maximumValue];
    
    if(isnan(progress)) {
        return;
    }
    
    if(marker == SEGMENT_END)
    {
        CGFloat markPos = (progressFrame.origin.x + self.markEnd.frame.size.width * 0.5f) + (progress * (progressFrame.size.width - self.markEnd.frame.size.width));
        [self.markEnd setCenter:CGPointMake(markPos, self.markEnd.center.y)];
        [self.markEnd setTranslatesAutoresizingMaskIntoConstraints:YES];
    }
    else
    {
        CGFloat markPos = (progressFrame.origin.x + self.markStart.frame.size.width * 0.5f) + (progress * (progressFrame.size.width - self.markStart.frame.size.width));
        [self.markStart setCenter:CGPointMake(markPos, self.markStart.center.y)];
        [self.markStart setTranslatesAutoresizingMaskIntoConstraints:YES];
    }
}

#pragma mark - Public methods
-(void)enableSegmentOption:(BOOL)enable
{
    [_segmentBegin setEnabled:enable];
    [_segmentPoint setEnabled:enable];
}

-(void)hideSegments:(BOOL)isHideSegments withHideProgressBar:(BOOL)isHideProgressBar
{
    [_segmentBegin setHidden:isHideSegments];
    [_segmentEnd setHidden:isHideSegments];
    [_segmentPoint setHidden:isHideSegments];
    
    [self.progressSlider setHidden:isHideProgressBar];
}

-(void)enableStopControls:(BOOL)enable mode:(BOOL)reelMode
{
    [super enableStopControls:enable mode:reelMode];
    //[self enableSegmentOption:NO];
    
    if(!enable) {
        [self updateSegmentEnd:NO tag:SEGMENT_BEGIN];
    }
}

-(void)updateSegmentBegin:(BOOL)active
{
    _isSegmentActive = active;
    
    if(active)
    {
        [_segmentBegin setImage:[UIImage imageNamed:@"segment_start_close"] forState:UIControlStateNormal];
        [self updateSegmentEnd:YES tag:SEGMENT_BEGIN];
    }
    else {
        [_segmentBegin setImage:[UIImage imageNamed:@"segment_start"] forState:UIControlStateNormal];
    }
}

-(void)updateSegmentEnd:(BOOL)active tag:(NSInteger)tag
{
    if(active)
    {
        [_segmentEnd setEnabled:YES];
        [_segmentEnd setImage:[UIImage imageNamed:@"segment_end_save"] forState:UIControlStateNormal];
        
        [self updateMarker:SEGMENT_BEGIN];
        [self updateMarker:SEGMENT_END];
        
        [self.markStart setHidden:NO];
        [self.markEnd setHidden:NO];
        
        if ([[self delegate] respondsToSelector:@selector(willPressRangeMarkInBtn)]) {
            [[self delegate] willPressRangeMarkInBtn];
        }
    }
    else
    {
        [_segmentEnd setEnabled:NO];
        [_segmentEnd setImage:[UIImage imageNamed:@"segment_end"] forState:UIControlStateNormal];
        
        [self.markStart setHidden:YES];
        [self.markEnd setHidden:YES];
        
        [self.progressSlider setUserInteractionEnabled:YES];
        [self updateSegmentBegin:NO];
        
        if(tag == SEGMENT_BEGIN)
        {
            if([[self delegate] respondsToSelector:@selector(didPressRangeMarkInBtn)]) {
                [[self delegate] didPressRangeMarkInBtn];
            }
        }
        else if(tag==SEGMENT_POINT)
        {
            if([[self delegate] respondsToSelector:@selector(didPressPointMarkBtn)]) {
                [[self delegate] didPressPointMarkBtn];
            }
        }
        else
        {
            //if(IS_IPHONE && [[self delegate] respondsToSelector:@selector(playAction:)]) {
         //       [[self delegate] playAction:NO];
         //  }
            
           if([[self delegate] respondsToSelector:@selector(didPressRangerMarkOutBtn)]) {
                [[self delegate] didPressRangerMarkOutBtn];
           }
        }
    }
}

-(void)updatedProgressValue:(CGFloat)value
{
    [super updatedProgressValue:value];
    
    if((![self.markStart isHidden]) && (!self.isCommentMarker)) {
        [self updateMarker:SEGMENT_END];
    }
}

-(IBAction)markTouchAction:(UIButton*)sender
{
    if([[self delegate] respondsToSelector:@selector(didBeginDragActionWithProgress)]) {
        [[self delegate] didBeginDragActionWithProgress];
    }
    
    [sender.superview bringSubviewToFront:sender];
    [sender setTranslatesAutoresizingMaskIntoConstraints:YES];
}

-(IBAction)progressSliderAction:(UISlider*)sender {
    [self updateMarker:SEGMENT_END];
}

-(IBAction)markTouchUpAction:(UIButton*)sender
{    
    [self.markEnd.superview bringSubviewToFront:self.markEnd];
    [self.markEnd setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    CGRect sliderFrame          =   [self.progressSlider frame];

    CGFloat ratio = ((self.markEnd.center.x - self.markEnd.frame.size.width * 0.5f) - sliderFrame.origin.x) / (sliderFrame.size.width - self.markEnd.frame.size.width);
   
    if ([[self delegate] respondsToSelector:@selector(didSeekToTime:)]) {
        [[self delegate] didSeekToTime:(ratio * [[self progressSlider] maximumValue])];
    }
}

-(IBAction)markPanAction:(UIButton*)control withEvent:(UIEvent*)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:control.superview];
    
   // [super trackingProgressValue:[self.progressSlider value]];
    
    CGPoint markStartCenter     =   [self.markStart center];
    CGPoint markEndCenter       =   [self.markEnd center];
    CGRect sliderFrame          =   [self.progressSlider frame];
    
    CGFloat ratio = ((point.x - control.frame.size.width * 0.5f) - sliderFrame.origin.x) / (sliderFrame.size.width - control.frame.size.width);
    
    if(control.tag == SEGMENT_BEGIN)
    {
        if(point.x <= sliderFrame.origin.x) {
            point.x = sliderFrame.origin.x;
        }
        else if(point.x >= markEndCenter.x) {
            point.x = markEndCenter.x;
        }
        else {
            
        }
    }
    else
    {
        if(point.x <= markStartCenter.x) {
            point.x = markStartCenter.x;
        }
        else if(point.x >= (sliderFrame.origin.x + sliderFrame.size.width - control.frame.size.width * 0.5f)) {
            point.x = sliderFrame.origin.x + sliderFrame.size.width - control.frame.size.width * 0.5f;
        }
        else {
            [self.progressSlider setValue:ratio * [self.progressSlider maximumValue]];
        }
    }
    
    control.center = CGPointMake(point.x, control.center.y);
}

-(void)hideAndShowPlayerControlsBasedOnViewerMode:(PlayerType)viewerMode
{
    if (viewerMode == Advanced)//For Advance mode
    {
        [self.playerPrevBtn setHidden:YES];
        [self.playerNextBtn setHidden:YES];
        [self.playerPrevSpeedBtn setHidden:YES];
        [self.playerNextSpeedBtn setHidden:YES];
        [self.segmentBegin setHidden:YES];
        [self.segmentEnd setHidden:YES];
        [self.segmentPoint setHidden:YES];
        
        if ((self.playlistType == Playlist) || (self.playlistType == Reel)) {
            [self.previousClipButtonWidth setConstant:44];
        }
        else {
            [self.previousClipButtonWidth setConstant:0];
        }
    }
    else
    {
        [self.playerPrevBtn setHidden:NO];
        [self.playerNextBtn setHidden:NO];
        [self.playerPrevSpeedBtn setHidden:NO];
        [self.playerNextSpeedBtn setHidden:NO];
        
        //To hide pre/next clips button
        [self.previousClipButtonWidth setConstant:0];
        
        if (viewerMode == Review)//For Review mode
        {
            [self.segmentBegin setHidden:NO];
            [self.segmentEnd setHidden:NO];
            [self.segmentPoint setHidden:NO];
        }
        else//For Information mode
        {
            [self.segmentBegin setHidden:YES];
            [self.segmentEnd setHidden:YES];
            [self.segmentPoint setHidden:YES];
        }
    }
}

@end
