//
//  CBCScreenerPreviewPlayerControlsController.h
//  CM Library
//
//  Created by Saravana Kumar on 9/23/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerControlsDelegate.h"

@class ControlSlider;
@interface PlayerControlsControllerBase : UIViewController

@property (nonatomic, weak) IBOutlet ControlSlider              *progressSlider;
@property (nonatomic, weak) IBOutlet ControlSlider              *speedSlider;

@property (nonatomic, weak) IBOutlet UIButton                   *playBut;
@property (nonatomic, weak) IBOutlet UIButton                   *fullscreenBut;
@property (nonatomic, weak) IBOutlet UIButton                   *markStart;
@property (nonatomic, weak) IBOutlet UIButton                   *markEnd;
@property (weak, nonatomic) IBOutlet UIButton                   *pointBtn;

@property (nonatomic, weak) IBOutlet UIButton                   *settingBtn;
@property (nonatomic, weak) IBOutlet UIButton                   *screenSizeBtn;
@property (nonatomic, weak) IBOutlet UIButton                   *helpBtn;
@property (nonatomic, weak) IBOutlet UIButton                   *playerStopBtn;
@property (nonatomic, weak) IBOutlet UIButton                   *playerPrevBtn;
@property (nonatomic, weak) IBOutlet UIButton                   *playerNextBtn;
@property (nonatomic, weak) IBOutlet UIButton                   *playerPrevSpeedBtn;
@property (nonatomic, weak) IBOutlet UIButton                   *playerNextSpeedBtn;
@property (nonatomic, weak) IBOutlet UIButton                   *playerPrevClipBtn;
@property (nonatomic, weak) IBOutlet UIButton                   *playerNextClipBtn;
@property (nonatomic, weak) IBOutlet UIButton                   *playerNextSecondBtn;
@property (nonatomic, weak) IBOutlet UIButton                   *playerPrevSecondBtn;

@property (nonatomic, weak) IBOutlet UIView                     *screenerPreviewControlsPlaceHolder;
@property (nonatomic, weak) IBOutlet UIView                     *screenerPreviewThumbTrackPlaceHolder;
@property (nonatomic, weak) IBOutlet UIView                     *progressView;

@property (nonatomic, weak) IBOutlet UILabel                    *timeCodeInLbl;
@property (nonatomic, weak) IBOutlet UILabel                    *timeCodeOutLbl;
@property (nonatomic, weak) IBOutlet UILabel                    *takeTimeCodeLbl;
@property (nonatomic, weak) IBOutlet UILabel                    *takeTimeNameLbl;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint         *previousClipButtonWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint         *fastRewindButtonWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint         *timeInLabelCenter;

@property (nonatomic, assign) BOOL                              isCommentMarker;
@property (nonatomic, weak) id <PlayerControlsDelegate>         delegate;



-(IBAction)playAction:(UIButton*)sender;
-(IBAction)stopAction:(id)sender;
-(IBAction)stepFrameAction:(UIButton*)sender;
-(IBAction)speedSliderAction:(UIButton*)sender;
-(IBAction)fullscreenDownAction:(UIButton*)sender;
-(IBAction)progressViewTapHandler:(UIGestureRecognizer*)sender;
-(IBAction)videoSettingAction:(UIButton *)sender;
-(IBAction)chagneScreenSizeAction:(UIButton *)sender;
-(IBAction)helpAction:(UIButton *)sender;
-(IBAction)changeClipAction:(UIButton *)sender;

-(void)selectPlayButton:(BOOL)selected;
-(void)selectSettingsButton:(BOOL)selected;
-(void)highlightSettingsButton:(BOOL)highlighted;
-(void)enableSettingsButton:(BOOL)enabled;
-(void)selectScreenSizeButton;
-(void)enablePlayButton:(BOOL)enabled;
-(void)updateProgressMax:(CGFloat)maxValue;
-(void)updatedProgressValue:(CGFloat)value;
-(void)updateTimeCodeOut:(CGFloat)seconds forFrameRate:(CGFloat)frameRate withSOM:(CGFloat)som dropFrame:(BOOL)isDf;
-(void)updateTimeCode:(CGFloat)seconds forFrameRate:(CGFloat)frameRate withSOM:(CGFloat)som dropFrame:(BOOL)isDf;
-(void)updateTakeTimeCode:(CGFloat)seconds forFrameRate:(CGFloat)frameRate withSOM:(CGFloat)som dropFrame:(BOOL)isDf;
-(void)updateFullscreenValue:(NSInteger)isFullScreen;
-(void)triggerPlayActionHandler;
-(void)updateSpeedValue:(int)value;
-(void)enableStopControls:(BOOL)enable mode:(BOOL)reelMode;
-(void)disableControlsForAudio:(BOOL)enable;
-(void)trackingProgressValue:(CGFloat)progress;
-(void)renderAnnotationComment:(CGFloat)timeCode;
-(void)renderRangeComment:(CGFloat)timeCode timeCodeEnd:(CGFloat)timeCodeEnd;
-(void)hideAnnotationComment;
-(void)hideRangeComment;
-(void)updateMarker:(BOOL)marker;
-(void)selectFullScreenButton:(BOOL)isSelected;
-(NSString*)getTimeCodeIn;
-(NSString*)getTimeCodeOut;
-(CGFloat)getControlsHeight;
-(CGFloat)getProgressValue;
-(void)enableSegmentOption:(BOOL)enable;
-(void)hideSegmentsOption:(BOOL)isHide;
//-(void)hideAndShowPlayerControlsBasedOnViewerMode:(NSInteger)viewerMode;
-(void)resetPlayerSpeed:(CGFloat)speed;
-(void)enableSpeedButtons:(BOOL)enable;
-(void)resetSpeedPlayBack;

@end
