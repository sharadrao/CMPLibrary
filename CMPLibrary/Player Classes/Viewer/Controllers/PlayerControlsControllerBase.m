//
//  CBCScreenerPreviewPlayerControlsController.m
//  CM Library
//
//  Created by Saravana Kumar on 9/23/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import "PlayerControlsControllerBase.h"
#import "PlayerUtilities.h"
#import "PlayerProductConstants.h"
#import "ControlSlider.h"
#import "CommentsRangeHighightView.h"
#import "CustomPlayerController.h"


#define PLAYER_MAX_SPEED        4.0f
#define PLAYER_MIN_SPEED       -4.0f

typedef NS_ENUM(NSInteger, PlayerControlButtonTag) {
    ReversePlaybackButton,
    FastForwardButton,
};

@interface PlayerControlsControllerBase () <ProgressSliderDelegate>

@property (nonatomic, assign) CGFloat                           playerSpeed;
@property (nonatomic, assign) BOOL                              isFullscreen;

@property (nonatomic, strong) CommentsRangeHighightView       *commentsRangeView;

@end

@implementation PlayerControlsControllerBase


#pragma mark - private methods
-(void)initHUD
{
//    [_screenerPreviewControlsPlaceHolder setBackgroundColor:[PlayerUtilities getThemeColor:SCREENER_PREVIEW_CONTROLS_PLACEHOLDER_COLOR]];
//    [_screenerPreviewThumbTrackPlaceHolder setBackgroundColor:[PlayerUtilities getThemeColor:SCREENER_PREVIEW_THUMBTACK_PLACEHOLDER_COLOR]];
    
    //[self.progressSlider setControlStyle:PLAYER_CBC_SLIDER_SALES_PREVIEW_PROGRESS];
    
    [self.fullscreenBut setBackgroundImage:nil forState:UIControlStateSelected];//zoomIn ZoomIn
    [self.fullscreenBut setBackgroundImage:nil forState:UIControlStateNormal];
}

-(IBAction)playAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    
    //If player on pause status because of speed playback and user tap on play button then reset player speed.
    if(sender.selected)
    {
        _playerSpeed = 1.0f;
        [self enableSpeedButtons:YES];
    }
        
    if([[self delegate] respondsToSelector:@selector(didPressPlayPauseBtnInControlView:)]) {
        [[self delegate] didPressPlayPauseBtnInControlView:sender];
    }
}

-(IBAction)stopAction:(id)sender
{
    _playerSpeed = 1.0f;
    
    if([[self delegate] respondsToSelector:@selector(didPressStopBtnInControlView:)]) {
        [[self delegate] didPressStopBtnInControlView:sender];
    }
    
    [self hideAnnotationComment];
    [self hideRangeComment];
}

-(IBAction)stepFrameAction:(UIButton*)sender
{
    if([[self delegate] respondsToSelector:@selector(didPressStepFrameBtnInControlView:)]) {
        [[self delegate] didPressStepFrameBtnInControlView:sender];
        [self resetSpeedPlayBack];
    }
}

- (IBAction)nextPrevSecondAction:(UIButton *)sender
{
    if([[self delegate] respondsToSelector:@selector(didPresseStepSecondBtnInControlView:)]) {
        [[self delegate] didPresseStepSecondBtnInControlView:sender];
        [self resetSpeedPlayBack];
    }
}

-(IBAction)speedSliderAction:(UIButton*)sender
{
    NSString *currentTimeCode = _timeCodeInLbl.text;
    
    //Do not perform reversePlayback If player's current time is less than or equal to 0.0
    if(IS_IPAD && [currentTimeCode isEqualToString:@"00:00:00:00"] && !sender.tag) {
        return;
    }
    
    if(sender.tag == FastForwardButton)  //For Fast forward
    {
        if (_playerSpeed == -2) {
            _playerSpeed = 0;
        }
        _playerSpeed += 1.0f;
    }
    else //For Reverse Playback
    {
        if (_playerSpeed == 1 || _playerSpeed == 0) {
            _playerSpeed = -1; //Portal not playing speed of -1x so for similarty we are doing same.
        }
        _playerSpeed -= 1.0f;
    }
    
    _playerSpeed = MIN(PLAYER_MAX_SPEED, MAX(_playerSpeed, PLAYER_MIN_SPEED));
    
    if(_playerSpeed == PLAYER_MIN_SPEED) {
        [_playerPrevSpeedBtn setEnabled:NO];
    }
    else if(_playerSpeed == PLAYER_MAX_SPEED) {
        [_playerNextSpeedBtn setEnabled:NO];
    }
    else
    {
        [_playerNextSpeedBtn setEnabled:YES];
        [_playerPrevSpeedBtn setEnabled:YES];
    }
    
    if([[self delegate] respondsToSelector:@selector(didChangePlayerSpeed:inControlView:)]) {
        [[self delegate] didChangePlayerSpeed:_playerSpeed inControlView:sender];
    }
}

#pragma Progress Bar Delegate Methods

-(void)didBeginTrackingProgress:(CGFloat)progress
{
    if([[self delegate] respondsToSelector:@selector(didBeginDragActionWithProgress)]) {
        [[self delegate] didBeginDragActionWithProgress];
    }
}

-(void) didEndTrackingProgress:(CGFloat)progress
{
    [self updatedProgressValue:progress];
    
    if([[self delegate] respondsToSelector:@selector(didSeekToTime:)]) {
        [[self delegate] didSeekToTime:progress];
    }
}

-(IBAction)fullscreenDownAction:(UIButton*)sender
{
   /* if([[self delegate] respondsToSelector:@selector(fullscreenAlertHandler:)]) {
        [[self delegate] fullscreenAlertHandler:_isFullscreen];
    }
    */
}

-(IBAction)fullscreeOutsideAction:(UIButton*)sender
{
    /*if([[self delegate] respondsToSelector:@selector(fullscreenAlertHandler:)]) {
        [[self delegate] fullscreenAlertHandler:_isFullscreen];
    }*/
}

-(IBAction)fullscreenAction:(UIButton*)sender
{
    if ([[self delegate] respondsToSelector:@selector(didPressFullScreenBtnInControlView:)]) {
        [[self delegate] didPressFullScreenBtnInControlView:sender];
    }
    
}

- (IBAction)videoSettingAction:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
    
    if ([[self delegate] respondsToSelector:@selector(didPressSettingsBtn:inControlView:)]) {
        [[self delegate] didPressSettingsBtn:sender.isSelected inControlView:sender];
    }
    
    NSLog(@"Setting Screen Functionality");
}

- (IBAction)chagneScreenSizeAction:(UIButton *)sender
{
    if([[self delegate] respondsToSelector:@selector(showPlayerInFullScreen)]) {
       // [[self delegate] showPlayerInFullScreen];
    }
}

- (IBAction)helpAction:(UIButton *)sender
{
    if([[self delegate] respondsToSelector:@selector(showHelpScreen:)]) {
      //  [[self delegate] showHelpScreen:YES];
    }
}

- (IBAction)changeClipAction:(UIButton *)sender
{
    if([[self delegate] respondsToSelector:@selector(changePlaylistClip:)]) {
        [[self delegate] changePlaylistClip:(int)sender.tag];
    }
}

-(void)updateMarker:(BOOL)marker {
    
}

-(void)playFromSeekedTime:(CGFloat)seekedTime
{
    [self updatedProgressValue:seekedTime];
    
    if([[self delegate] respondsToSelector:@selector(playFromSeekedTime:)]) {
        //[[self delegate] playFromSeekedTime:seekedTime];
    }
}

-(IBAction)progressViewTapHandler:(UIGestureRecognizer*)sender
{
    CGPoint touchLocation   =   [sender locationInView:sender.view];
    CGFloat sliderWidth     =   [self.progressSlider bounds].size.width;
    
    CGFloat progress        =   ((touchLocation.x - [self.progressSlider frame].origin.x) / sliderWidth) * [self.progressSlider maximumValue];
    
    [self.progressSlider setValue:progress];
    [self updateMarker:YES];
    
    if([[self delegate] respondsToSelector:@selector(didSeekToTime:)]) {
        [[self delegate] didSeekToTime:progress];
    }
}

#pragma mark - UIGesture delegate method
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (_settingBtn.isSelected)
    {
        if ([[self delegate] respondsToSelector:@selector(didPressSettingsBtn:inControlView:)]) {
            [[self delegate] didPressSettingsBtn:!_settingBtn.isSelected inControlView:_settingBtn];
        }
    }
    return YES;
}

#pragma mark - public methods

-(NSString*)getTimeCodeIn {
    return [_timeCodeInLbl text];
}

-(NSString*)getTimeCodeOut {
    return [_timeCodeOutLbl text];
}

-(void)selectPlayButton:(BOOL)selected
{
    if (_playerSpeed > 1 || _playerSpeed < 0) {
        [_playBut setSelected:NO];
    } else {
        [_playBut setSelected:selected];

    }
}

-(void)highlightSettingsButton:(BOOL)highlighted {
    [_settingBtn setHighlighted:highlighted];
}

-(void)selectSettingsButton:(BOOL)selected {
    [_settingBtn setSelected:selected];
}

-(void)enableSettingsButton:(BOOL)enabled {
    [_settingBtn setEnabled:enabled];
}

-(void)selectScreenSizeButton {
    [_screenSizeBtn setSelected:!_screenSizeBtn.selected];
}

-(void)selectFullScreenButton:(BOOL)isSelected
{
    if (isSelected) {
        [self.fullscreenBut setImage:[UIImage imageNamed:@"ZoomIn"] forState:UIControlStateNormal];
    }
    else {
        [self.fullscreenBut setImage:[UIImage imageNamed:@"fullscreen_s_icon"] forState:UIControlStateNormal];
    }
}

-(void)enablePlayButton:(BOOL)enabled {
    [_playBut setEnabled:enabled];
}

-(CGFloat)getProgressValue {
    return self.progressSlider.value;
}

-(void)updatedProgressValue:(CGFloat)value
{
    if((![self.markEnd isHidden]) && (self.isCommentMarker))
    {
        CGFloat offset      = [UIImage imageNamed:[_progressSlider getScrubImage]].size.width * 0.5f;
        CGFloat rangeEndX   = ((value / [_progressSlider maximumValue]) * _progressSlider.bounds.size.width) +  offset;
        
        if(rangeEndX > self.markEnd.center.x)
        {
            [self.progressSlider setValue:value animated:YES];
            
            if([[self delegate] respondsToSelector:@selector(playAction:)]) {
               // [[self delegate] playAction:NO];
            }
            
            [self hideRangeComment];
            return;
        }
    }
    
    [self.progressSlider setValue:value animated:YES];    
}

-(void)triggerPlayActionHandler {
    [self playAction:_playBut];
}

-(void)updateFullscreenValue:(NSInteger)isFullScreen {
    _isFullscreen = isFullScreen;
}

-(void)updateSpeedValue:(int)value {
    _playerSpeed = value;
}

-(void)enableSegmentOption:(BOOL)enable {
    
}

-(void)enableStopControls:(BOOL)enable mode:(BOOL)reelMode
{
    [_settingBtn setEnabled:enable];
    [_playBut setEnabled:enable];
    [_playerStopBtn setEnabled:enable];
    [_playerPrevBtn setEnabled:enable];
    [_playerNextBtn setEnabled:enable];
    [_playerNextSpeedBtn setEnabled:enable];
    [_playerPrevSpeedBtn setEnabled:enable];
    [_playerPrevClipBtn setEnabled:enable];
    [_playerNextClipBtn setEnabled:enable];
    [_playerNextSecondBtn setEnabled:enable];
    [_playerPrevSecondBtn setEnabled:enable];
    
    [self.progressSlider setEnabled:enable];
    [self.progressSlider setValue:0 animated:NO];
    
    [self hideRangeComment];
    [self hideAnnotationComment];
    
    if(_playerSpeed < PLAYER_MAX_SPEED && _playerSpeed > PLAYER_MIN_SPEED)
    {
        [_playerNextSpeedBtn setEnabled:enable];
        [_playerPrevSpeedBtn setEnabled:enable];
    }
}

-(void)disableControlsForAudio:(BOOL)enable
{
    [_playerNextBtn setHidden:enable];
    [_playerPrevBtn setHidden:enable];
    [_playerNextSpeedBtn setHidden:enable];
    [_playerPrevSpeedBtn setHidden:enable];
}

-(void)updateProgressMax:(CGFloat)maxValue {
    [_progressSlider setMaximumValue:maxValue];
}

-(void)updateTimeCodeOut:(CGFloat)seconds forFrameRate:(CGFloat)frameRate withSOM:(CGFloat)som dropFrame:(BOOL)isDf
{
    CGFloat durationSec = seconds + som;
    [_timeCodeOutLbl setText:[NSString stringWithFormat:@"/ %@", [PlayerUtilities getTimeCodeFromSeconds:durationSec forFrameRate:frameRate isDF:isDf doFrameCount:YES]]];
}

-(void)updateTimeCode:(CGFloat)seconds forFrameRate:(CGFloat)frameRate withSOM:(CGFloat)som dropFrame:(BOOL)isDf
{
    CGFloat playedFrames = seconds + som;
    [_timeCodeInLbl setText:[PlayerUtilities getTimeCodeFromSeconds:playedFrames forFrameRate:frameRate isDF:isDf doFrameCount:YES]];
}

-(void)updateTakeTimeCode:(CGFloat)seconds forFrameRate:(CGFloat)frameRate withSOM:(CGFloat)som dropFrame:(BOOL)isDf
{
    CGFloat playedFrames = seconds + som;
    [_takeTimeCodeLbl setText:[PlayerUtilities getTimeCodeFromSeconds:playedFrames forFrameRate:frameRate isDF:isDf doFrameCount:YES]];
}

-(void)renderAnnotationComment:(CGFloat)timeCode
{
    self.isCommentMarker = YES;
    
    if(_commentsRangeView) {
        [_commentsRangeView removeFromSuperview];
    }
    _commentsRangeView =  nil;
    
    CGFloat offset = [UIImage imageNamed:[_progressSlider getScrubImage]].size.width * 0.5f;
    
    CGFloat commentX = (_progressSlider.frame.origin.x + offset) + (timeCode / [_progressSlider maximumValue]) * [_progressSlider frame].size.width;
    [self.markStart setCenter:CGPointMake(commentX, _progressSlider.center.y)];
    [self.markStart setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [self.markStart setHidden:NO];
}

-(void)renderRangeComment:(CGFloat)timeCode timeCodeEnd:(CGFloat)timeCodeEnd
{
    self.isCommentMarker = YES;
    
    if(!_commentsRangeView)
    {
        _commentsRangeView = [[CommentsRangeHighightView alloc] initWithFrame:CGRectZero];
        [[_commentsRangeView layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[_commentsRangeView layer] setCornerRadius:3.0f];
        [[_commentsRangeView layer] setBackgroundColor:[UIColor colorWithRed:0.3f green:0.3f blue:0.5f alpha:0.7f].CGColor];
        [[_commentsRangeView layer] setBorderWidth:1.0f];
        
        [_progressSlider insertSubview:_commentsRangeView atIndex:2];
        
       // [self.view insertSubview:_commentsRangeView belowSubview:_commentStartImg];
    }
    
    CGFloat height = [UIImage imageNamed:[_progressSlider getMaxImage]].size.height * 2.2f;
    CGFloat offset = [UIImage imageNamed:[_progressSlider getScrubImage]].size.width * 0.5f;
    
    CGFloat rangeStartX = (_progressSlider.frame.origin.x + offset) + (timeCode / [_progressSlider maximumValue]) * [_progressSlider frame].size.width;
    CGFloat rangeEndX   = (_progressSlider.frame.origin.x + offset) + (timeCodeEnd / [_progressSlider maximumValue]) * [_progressSlider frame].size.width;
    
    [self.markStart setCenter:CGPointMake(rangeStartX, _progressSlider.center.y)];
    [self.markEnd setCenter:CGPointMake(rangeEndX, _progressSlider.center.y)];
    [_commentsRangeView setFrame:CGRectMake(rangeStartX, _progressSlider.center.y - height * 0.5f, (rangeEndX - rangeStartX), height)];

    [self.markStart setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.markEnd setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_commentsRangeView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [self.markEnd setHidden:NO];
    [self.markStart setHidden:NO];
}

-(void)hideAnnotationComment
{
    self.isCommentMarker = NO;
    
    [self.markStart setHidden:YES];
}

-(void)hideRangeComment
{
    self.isCommentMarker = NO;
    
    [self.markStart setHidden:YES];
    [self.markEnd setHidden:YES];
    
    if(_commentsRangeView) {
        [_commentsRangeView removeFromSuperview];
    }
    _commentsRangeView = nil;
}

#pragma mark - self methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    _playerSpeed = 1.0f;
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

-(CGFloat)getControlsHeight {
    return [self.view bounds].size.height;
}

-(void)hideSegmentsOption:(BOOL)isHide {
    
}

-(void)resetPlayerSpeed:(CGFloat)speed {
    _playerSpeed = speed;
}

-(void)enableSpeedButtons:(BOOL)enable
{
    [_playerNextSpeedBtn setEnabled:enable];
    [_playerPrevSpeedBtn setEnabled:enable];
}

-(void)resetSpeedPlayBack
{
    [self resetPlayerSpeed:0.0f];
    [self enableSpeedButtons:YES];
}

/*
-(void)hideAndShowPlayerControlsBasedOnViewerMode:(NSInteger)viewerMode {
    
}
*/
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //To initiate the timer to dismiss player controls
    [self cancelTimerAndReinitiate:YES];
}

-(void)cancelTimerAndReinitiate:(BOOL)shouldReinitiate
{
    if ([[self delegate] respondsToSelector:@selector(cancelTimerAndReinitiate:)]) {
        [[self delegate] cancelTimerAndReinitiate:shouldReinitiate];
    }
}

@end
