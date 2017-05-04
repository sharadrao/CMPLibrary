//
//  CustomPlayerController
//  CM Library
//
//  Created by Saravana Kumar on 11/24/15.
//  Copyright © 2015 Prime Focus Technologies. All rights reserved.
//

#import "CustomPlayerController.h"

#import "PlayerItem.h"
#import "PlayerTrack.h"
#import "PlayerCache.h"

#import "MongooseDaemon.h"
#import "PlayerUtilities.h"
#import "PlayerProductConstants.h"

#import "PlayerControlsContainer.h"
#import "PlayerControlsControllerBase.h"
#import "PlayerSettingsPopupInterface.h"
#import "ReviewPlayerControlsController.h"

#import "PlayerControlsDelegate.h"
#import "PlayerViewDelegate.h"

#import "GestureHandler.h"
#import "WatermarkHandler.h"
#import "ConstraintsHandler.h"
#import "WaterMarkView.h"

@interface CustomPlayerController () < UIGestureRecognizerDelegate,PlayerViewDelegate,PlayerControlsDelegate,WaterMarkDelegate>

#pragma mark - Controls Container/Delegste
@property (nonatomic, weak) PlayerControlsContainer                         *container;
@property (nonatomic, weak) id <PlayerSettingsPopUpDelegate>                playerSettingsdelegate;

#pragma mark - Offline Playback 
@property (nonatomic, strong) MongooseDaemon                                *server;

#pragma mark - Player Subtitle Data
@property (nonatomic, weak) IBOutlet SubtitleItemView                       *subtitleView;

#pragma mark - Gesture/Constraints 
@property (nonatomic,strong) GestureHandler                                 *gestureHandler;
@property (nonatomic,strong) WatermarkHandler                               *watermarkHandler;
@property (nonatomic,strong) ConstraintsHandler                             *constraintsHandler;

#pragma mark - Required Player Items
@property (nonatomic, strong, readwrite)    PlayerItem                      *selectedItem;
@property (nonatomic, assign, readwrite)    NSInteger                       selectedItemIndex;
@property (nonatomic, strong) NSTimer                                       *timer;

#pragma mark - Water Contraints Properties
@property (nonatomic, weak) IBOutlet NSLayoutConstraint                     *waterMarkHolderX;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint                     *waterMarkHolderY;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint                     *waterMarkWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint                     *waterMarkHeight;

#pragma mark - Playback Variable Checks
@property (nonatomic, assign) BOOL                                          canStopLoader;
@property (nonatomic, assign) BOOL                                          canSaveLastPlaybackTime;
@property (nonatomic, assign) BOOL                                          playerStopped;
@property (nonatomic, assign) BOOL                                          advancedPlayer;
@property (nonatomic, assign) BOOL                                          autoPause;
@property (nonatomic, assign) BOOL                                          isSeeked;
@property (nonatomic, assign) BOOL                                          fromReel;
@property (nonatomic, assign) BOOL                                          isStatusBar;
@property (nonatomic, assign) BOOL                                          isPlaylistClipSequenceMode;         // To play selected clips of playlist in sequence..
@property (nonatomic, assign) BOOL                                          isOnScreenPlayerInitialised;        // To check which player is initialised.
@property (nonatomic, assign) BOOL                                          isOffScreenPlayerInitialised;       // To check which player is initialised.
@property (nonatomic, assign) BOOL                                          isScene;
@property (nonatomic, assign) BOOL                                          isAutoPlay;
@property (nonatomic, assign) BOOL                                          isManualPause;
@property (nonatomic, assign) BOOL                                          isLocked;
@property (nonatomic, assign) BOOL                                          isPlayerReady;
@property (nonatomic, assign) BOOL                                          isPlayerItemEndNotificationCalled;
@property (nonatomic, assign) BOOL                                          isDraggingSeekbar;
@property (nonatomic, assign) BOOL                                          isResumePlayback;
@property (nonatomic, assign) BOOL                                          isSekedToLastPlaybackTime;
@property (nonatomic, assign) BOOL                                          isLastPlaybackTimeResponseReady;
@property (nonatomic, assign) BOOL                                          isDropFrame;
@property (nonatomic, assign) BOOL                                          isInitialLock;


#pragma mark - Player Controls Instance
@property (nonatomic, weak)     PlayerControlsContainer                     *playerControlsContainer;
@property (nonatomic, strong)   PlayerSettingsPopupViewController           *playerSettingscontroller;


#pragma mark - Player Instance Outlets
@property (nonatomic, weak) IBOutlet PlayerView                             *offScreenPlayer;
@property (nonatomic, weak) IBOutlet PlayerView                             *onScreenPlayer;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint                     *playerBottomCons;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint                     *playerTopCons;

#pragma mark - Player UI Outlets
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView                *progressInd;
@property (nonatomic, weak) IBOutlet UIView                                 *headerView;
@property (nonatomic, weak) IBOutlet UIView                                 *controlsView;
@property (nonatomic, weak) IBOutlet UIView                                 *playerContainerSuperView;
@property (nonatomic, weak) IBOutlet UIView                                 *playerContainerView;
@property (nonatomic, weak) IBOutlet UIView                                 *settingsHolderView;
@property (nonatomic, weak) IBOutlet UILabel                                *playbackErrorLabel;
@property (nonatomic, weak) IBOutlet UIImageView                            *airPlayImageView;

@property (nonatomic, weak) IBOutlet UIView                                 *playbackSpeedView;
@property (nonatomic, weak) IBOutlet UILabel                                *speedLbl;
@property (nonatomic, weak) IBOutlet UILabel                                *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel                                *timeCodeInLbl;
@property (nonatomic, weak) IBOutlet UILabel                                *timeCodeOutLbl;
@property (nonatomic, weak) IBOutlet UIButton                               *startOverBut;
@property (nonatomic, weak) IBOutlet UIButton                               *resumeBut;
@property (nonatomic, weak) IBOutlet UIImageView                            *contentImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint                     *timeCodeOutLabelBottomConstraints;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint                     *timeCodeInLabelBottonConstraints;
@property (nonatomic, weak) IBOutlet UIView                                 *waterMarkHolderView;

#pragma mark - Playback Information
@property (nonatomic, assign) CMTime                                        playerUpdateTime;
@property (nonatomic, strong) NSString                                      *segmentSwapTime;
@property (nonatomic, assign) CGFloat                                       seekedSeconds;
@property (nonatomic, assign) CGFloat                                       playerBotConstant;

@property (nonatomic, assign) NSInteger                                     prevClip;
@property (nonatomic, assign) NSInteger                                     playersReady;
@property (nonatomic, assign) NSInteger                                     activePlayer;
@property (nonatomic, assign) NSInteger                                     currentSegment;


@property (nonatomic, weak) UIView                                          *superView;
@property (nonatomic, strong) UIWindow                                      *externalWindow;
@property (nonatomic, strong) WaterMarkView                                 *watermarkView;
@property (nonatomic, assign) CGFloat                                       initialSeekIn;
@property (nonatomic, assign) CGFloat                                       initialSeekOut;
@property (nonatomic, assign) CGRect                                        superviewFrame;
@property (nonatomic, assign) NSInteger                                     playbackRetryCount;

@property (nonatomic, assign) CGFloat                                       timeCodeOutLabelConstant;
@property (nonatomic, assign) CGFloat                                       timeCodeInLabelConstant;
@property (assign, nonatomic) CGFloat                                       gestureScale;
@property (nonatomic, assign) CGFloat                                       scenceDuration;
@property (nonatomic, assign) CGFloat                                       scenceStartTime;
@property (nonatomic, assign) CGFloat                                       scenceTcOut;


@property (nonatomic, assign, getter=isDurationUpdated) BOOL                updateDuraton;

@property (nonatomic, assign) BOOL                                          isPlayerInitialised;
@property (nonatomic, assign) BOOL                                          autoPlay;
@property (nonatomic, assign) BOOL                                          isExternalScreenConnected;
@property (nonatomic, assign) CGFloat                                       totalReelTime;
@property (nonatomic, strong) NSString                                      *segmentEndTime;
@property (nonatomic, strong) NSString                                      *segmentStartTime;
@property (nonatomic, assign) CGFloat                                       reelPlayed;
@property (nonatomic, assign) NSInteger                                     reelIndex;

@property (nonatomic, assign)   CGFloat                                     lastPlayBackSpeed;

@property (nonatomic, assign) BOOL                                          isAppInBackground;


@end



@implementation CustomPlayerController

#pragma mark - Custom Observer Methods
-(void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenModeDidChange:) name:UIScreenModeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(externalScreenDidDisconnect:) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hibernatePlayers) name:CMP_EXTERNAL_PAUSE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenModeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CMP_EXTERNAL_PAUSE object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)didOrientationChanged:(NSNotification*)notification
{
    if (!IS_IPHONE) {
        return;
    }
    
    //TO:DO Screen Lock Code goes here
    
     //if comment or review or other popover is enabled dont rotate
    //TO;DO Popup present Check Code goes here
    
    //Don't update for UIDeviceOrientationPortraitUpsideDown orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice]orientation];
    [self setIsFullScreen:UIDeviceOrientationIsLandscape(orientation)];
}

#pragma mark - App State Methods
-(void)appEnterBackground:(NSNotification*)notification
{
    //Disconnect app from external screen when app going to background
    [self externalScreenDidDisconnect:notification];
}

-(void)applicationWillResignActive:(NSNotification*)notification
{
    //Pause the player and reset playback speed when app going to background.
    _isAppInBackground = YES;
    _lastPlayBackSpeed = [[self getActivePlayer] getPlayerRate];
    [self hibernatePlayers];
    
    //If player is not started playback then do not save last playback time
    if (self.canSaveLastPlaybackTime) {
    //    [self makeRequestToSaveLastPlayBackTime];
    }
}

-(void)appEnterForeground:(NSNotification*)notification
{
    //Playback is freezing when playing Fastforward/Reverse playback then going to backgrodund and coming to foreground. To avoid this seek player to one frame back when launching player from background.
    if (_lastPlayBackSpeed > 1 || _lastPlayBackSpeed < 0) {
        [[self getActivePlayer] stepFrame:NO];
    }
}

#pragma mark - AirPlay Methods
- (void)setupExternalScreen
{
    // Setup screen mirroring for an existing screen
    NSArray *connectedScreens = [UIScreen screens];
    DLog(@"connectedScreens count:%lu: ",(unsigned long)connectedScreens.count);
    if ([connectedScreens count] > 1)
    {
        UIScreen *mainScreen = [UIScreen mainScreen];
        for (UIScreen *aScreen in connectedScreens)
        {
            if (aScreen != mainScreen)
            {
                [self configureExternalScreen:aScreen];
                break;
            }
        }
    }
}

-(void)configureExternalScreen:(UIScreen *)externalScreen
{
    _isExternalScreenConnected = YES;
    [_airPlayImageView setHidden:NO];
    
    if(!_externalWindow) {
        _externalWindow = [[UIWindow alloc] initWithFrame:[externalScreen bounds]];
    }
    
    [[_externalWindow screen] setOverscanCompensation:UIScreenOverscanCompensationScale];
    [[_externalWindow layer] setContentsGravity:kCAGravityResizeAspect];
    [_externalWindow setScreen:externalScreen];
    [_externalWindow makeKeyAndVisible];
    
    [_externalWindow setHidden:NO];
    
    [_playerContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    for(NSLayoutConstraint *c in _playerContainerSuperView.constraints)
    {
        if(c.firstItem == _playerContainerView || c.secondItem == _playerContainerView) {
            [_playerContainerSuperView removeConstraint:c];
        }
    }
    
    [_playerContainerView setFrame:[_externalWindow bounds]];
    [_externalWindow addSubview:_playerContainerView];
    
    [_playerContainerView updateConstraintsIfNeeded];
    [_playerContainerView setNeedsLayout];
    [_playerContainerView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self getActivePlayer].playerLayer.frame = _playerContainerView.bounds;
    
    [_watermarkView renderWatermark:^(BOOL success)
     {
         [self.constraintsHandler updateWatermarkConstraints];
         [self showWatermark];
     }];
}

-(void)externalScreenDidConnect:(NSNotification*)notification
{
    UIScreen *externalScreen = [notification object];
    [self configureExternalScreen:externalScreen];
}

-(void)externalScreenDidDisconnect:(NSNotification*)notification
{
    _isExternalScreenConnected = NO;
    
    [_airPlayImageView setHidden:YES];
    [_playerContainerView setFrame:[_playerContainerSuperView bounds]];
    [_playerContainerSuperView addSubview:_playerContainerView];
    [self getActivePlayer].playerLayer.frame = _playerContainerView.bounds;
    [self.constraintsHandler updatePlayerContainerConstraints];
    
    [_playerContainerView updateConstraintsIfNeeded];
    [_playerContainerView setNeedsLayout];
    [_playerContainerView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    if(_externalWindow)
    {
        [_externalWindow setHidden:YES];
        [_externalWindow resignKeyWindow];
    }
    _externalWindow = nil;
    
    [_watermarkView renderWatermark:^(BOOL success)
     {
         [self.constraintsHandler updateWatermarkConstraints];
         [self showWatermark];
     }];
}

-(void)externalScreenModeDidChange:(NSNotification*)notification
{
    [_watermarkView renderWatermark:^(BOOL success)
     {
         [self.constraintsHandler updateWatermarkConstraints];
         [self showWatermark];
     }];
}

#pragma mark - Watermark Methods
-(void)showWatermark
{
    if ([self canShowWaterMark]) {
        [_waterMarkHolderView setHidden:NO];
    }
}

-(BOOL)canShowWaterMark {
    return ((self.selectedItem == nil) || (self.config.itemType != Audio));
}


-(void)setWatermark:(WaterMarkModel *)watermodel
{
    if (self.config) {
        [self.config setWatermarkModel:watermodel];
    }
}

-(void)updateWatermarkRect:(CGRect)rect
{
    [_waterMarkHolderX setConstant:rect.origin.x];
    [_waterMarkHolderY setConstant:rect.origin.y];
    [_waterMarkWidth setConstant:rect.size.width];
    [_waterMarkHeight setConstant:rect.size.height];
    
    [_waterMarkHolderView updateConstraintsIfNeeded];
    [_waterMarkHolderView setNeedsLayout];
    [_watermarkView updateConstraintsIfNeeded];
    [_watermarkView setNeedsLayout];
    
    // For subtitle full screen and normal screen action
    [self.constraintsHandler updateSubtitleConstraintsInRect:[self getVideoRect]];
}


#pragma mark - Player Item Intialisation Methods
-(void)setPlayerItems:(NSArray*)playerIitems
{
    if (self.config) {
        [self.config setItemArray:playerIitems];
    }
}

-(void)playItemAtIndex:(NSInteger)index
{
    if (self.config.itemType == Playlist) {
        [self initialiseReelModeFromIndex:index];
    }
    else
    {
        [self.onScreenPlayer cleanup];
        [self.offScreenPlayer cleanup];
        
        self.isPlayerInitialised            = NO;
        _isPlayerItemEndNotificationCalled  = NO;
        
        if(index >= [self.config.itemArray count]) {
            return;
        }
        
        [_progressInd startAnimating];
        
        _prevClip               = _selectedItemIndex;
        _selectedItemIndex      = index;
        _playbackRetryCount     = 0;
        
        self.playersReady       = 0;
        self.activePlayer       = OFF_SCREEN_PLAYER;
        
        [self.onScreenPlayer setAlpha:0.0f];
        [self.offScreenPlayer setAlpha:1.0f];
        
        if (!(self.selectedItem != nil) && self.config.itemType == Reel) {
            [self performSelector:@selector(updatePlayerDuration) withObject:nil afterDelay:0.2];
        }
        
        [self loadPlaylistItemAtIndex:index];
    }
}

#pragma mark - Player Playback Time Methods
-(CMTime)getItemDuration
{
    CMTime currentDuration = [[self getActivePlayer] getDuration];
    return currentDuration;
}

#pragma mark - private methods
-(void)initialise
{
    _superView              = [self.view superview];
    _playerBotConstant      = [_playerBottomCons constant];
    _playerTopCons.constant = 0.0f;
    
    [self.playbackErrorLabel setHidden:YES];
}

- (void)updatePlayerDuration {
    [self updatePlayerTimeCodeForFrameRate:[self getFrameRate:self.activePlayer]];
}

-(void)resetPlayersAfterSpeedPlayBack
{
    if (self.config.itemType == Playlist)
    {
        [self initialiseReelModeFromIndex:self.selectedItemIndex];
        [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] resetPlayerSpeed:0.0f];
        self.autoPlay                           = NO;
        self.autoPause                          = NO;
        self.isManualPause                      = NO;
    } else {
        [self stopPlayers];
    }
    _isPlayerItemEndNotificationCalled = YES;
    [self updateProgress:0.0 withFrameRate:25];
    [self performSelector:@selector(updateEndPlayBackNotificationStatus) withObject:nil afterDelay:0.6];
}


#pragma mark - public methods

/**
 * Return active player's object
 */
-(PlayerView *)getActivePlayer
{
    if(self.activePlayer == ON_SCREEN_PLAYER) {
        return self.onScreenPlayer;
    }
    else {
        return self.offScreenPlayer;
    }
}

-(CGFloat)calculateDuration
{
    CGFloat duration = 0.0f;
    
     if (self.config.itemType == Playlist)
    {
        //Playlist Segemtn Changes
        PlayerItem *clip =  self.config.itemArray[self.selectedItemIndex];
        
        if ([clip.startTime length] || [clip.endTime length]) {
            
            CGFloat startTime = [PlayerUtilities getSecondsFromTimeCode:clip.startTime withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
            CGFloat endTime   = [PlayerUtilities getSecondsFromTimeCode:clip.endTime withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
            
            clip.duration = [NSString stringWithFormat:@"%f",endTime - startTime];
        }
        
        duration = [[clip duration] floatValue];
    }
    else
    {
        PlayerItem *clip = self.config.itemArray[self.selectedItemIndex];
        
        if([clip.duration floatValue] <= 0.0f)
        {
            if(self.activePlayer == ON_SCREEN_PLAYER) {
                clip.duration = [NSString stringWithFormat:@"%f", [self.onScreenPlayer durationInSeconds]];
            }
            else {
                clip.duration = [NSString stringWithFormat:@"%f", [self.offScreenPlayer durationInSeconds]];
            }
        }

        duration = [[clip duration] floatValue];
    }
    
    return duration;
}




-(void)calculateTotalReelModeTime:(NSInteger)index
{
    CGFloat reelTime = 0.0f;

    for (NSInteger i = index; i < [self.config.itemArray count]; i++)
    {
        PlayerItem *clip = self.config.itemArray[i];
        NSString *clipURL = [clip mediaURL];
        
        if([clip.startTime length] || [clip.endTime length])
        {
            CGFloat startTime = [PlayerUtilities getSecondsFromTimeCode:clip.startTime withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
            CGFloat endTime   = [PlayerUtilities getSecondsFromTimeCode:clip.endTime withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
            CGFloat segmentTime = endTime - startTime;
            reelTime += segmentTime;
        }
        else {
            reelTime += [[clip duration] floatValue];
        }
        
        if (![clipURL isEqualToString:@""]) {
            clipURL = [self getDecodedM3U8:clipURL];
        }
    }
    
    self.totalReelTime =  reelTime;
}

-(void)initialiseReelModeFromIndex:(NSInteger)index
{
    [_onScreenPlayer cleanup];
    [_offScreenPlayer cleanup];
    
    self.config.itemType = Playlist;
    self.fromReel                           = YES;
    self.isSeeked                           = NO;
    self.isPlayerInitialised                = NO;
    _isPlayerItemEndNotificationCalled      = NO;

    [self.progressInd startAnimating];
    
    self.prevClip       = self.selectedItemIndex;
    self.selectedItemIndex   = index;
    self.currentSegment = 0;
   
    if([self.config.itemArray count] == 1 || (self.config.itemArray.count > 1 && self.selectedItemIndex == self.config.itemArray.count -1)) {
        self.playersReady = 1;
    }
    else {
        self.playersReady = 0;
    }
    
    [self calculateTotalReelModeTime:index];
    
    self.reelPlayed = 0.0f;
    
    NSMutableArray *onScreenPlayerUrls  = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *offScreenPlayerUrls = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = _selectedItemIndex; i < [self.config.itemArray count]; i++)
    {
        PlayerItem *clip = self.config.itemArray[i];
        
        if (i % 2 == 0) {
            [onScreenPlayerUrls addObject:clip.mediaURL];
        }
        else {
            [offScreenPlayerUrls addObject:clip.mediaURL];
        }
    }

    if (_selectedItemIndex % 2 == 0)
    {
        self.activePlayer = ON_SCREEN_PLAYER;
        [self.onScreenPlayer setAlpha:1.0f];
        [self.offScreenPlayer setAlpha:0.0f];
    }
    else
    {
        self.activePlayer = OFF_SCREEN_PLAYER;
        [self.onScreenPlayer setAlpha:0.0f];
        [self.offScreenPlayer setAlpha:1.0f];
    }

    if (onScreenPlayerUrls.count) {
        [self.onScreenPlayer initWithURLList:onScreenPlayerUrls andDelegate:self];
    }
    
    if (offScreenPlayerUrls.count) {
        [self.offScreenPlayer initWithURLList:offScreenPlayerUrls andDelegate:self];
    }

    [self updatePlayerDuration];
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] resetPlayerSpeed:1.0f];
}

-(CGFloat)getFrameRate:(NSInteger)player
{
    NSInteger index = _selectedItemIndex;
    if ( (self.config.itemType == Playlist) && !_isPlayerInitialised && player != self.activePlayer)
    {
        if (self.config.itemArray.count > (_selectedItemIndex +1)) {
            ++index;
        }
    }
    
    //Specified Playlist/Video/Reel Clip Frame rates
     return [(PlayerItem*) self.config.itemArray[self.selectedItemIndex] frameRate];
}

-(void)showAnnotationComment:(CGFloat)timeCode {
    
}

-(void)showRangeComment:(CGFloat)timeCodeIn andTimeCodeEnd:(CGFloat)timeCodeEnd {
    
}

-(NSArray*)getNextTimeSegment:(NSInteger)playlistIndex forClip:(NSInteger)selectedIndex
{
    //If Selected Index greater then no of player items return
    if(selectedIndex >= [self.config.itemArray count]) {
        return nil;
    }
    
    //Stack Array for Tcin/Tcout
    NSArray *segmentTime = nil;
    selectedIndex = playlistIndex;
    
    //Get the selecetdIndex Player Item
    PlayerItem *previewClip = self.config.itemArray[selectedIndex];
  
    NSInteger nextSegment = playlistIndex + 1;
    
    //Need to rethink on this logic and modify
    if(nextSegment < [ self.config.itemArray count])
    {
        if(self.activePlayer == ON_SCREEN_PLAYER) {
            _advancedPlayer = ON_SCREEN_PLAYER;
        }
        else {
            _advancedPlayer = OFF_SCREEN_PLAYER;
        }
        
        PlayerItem *nextClipItem =  self.config.itemArray[nextSegment];
        if([nextClipItem.startTime length] && [nextClipItem.endTime length])
        {
            segmentTime = @[nextClipItem.startTime, nextClipItem.endTime];
            return segmentTime;
        }
        else
        {
            PlayerItem *segment =  self.config.itemArray[nextSegment];
            segmentTime = @[@"00:00:00:00", [PlayerUtilities getTimeCodeFromSeconds:[[segment duration] floatValue] isDF:previewClip.isDF doFrameCount:YES]];
            
            return segmentTime;
        }
    }
    
    return segmentTime;
}

-(void)swapPlayers
{
    _isPlayerItemEndNotificationCalled = YES;
    [[self getActivePlayer] setPlaybackRate:1.0f];
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] resetPlayerSpeed:1.0f];
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enableSpeedButtons:YES];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:EDITOR_MOVE_TO_NEXT_CLIP object:@{TOTOAL_REEL_TIME:[NSNumber numberWithFloat:self.totalReelTime],SELECTED_CLIP:[NSNumber numberWithInteger:_selectedItemIndex]}];
    
    self.activePlayer = !self.activePlayer;
    
    //calculate the next segment
    NSArray *timeCode = [self getNextTimeSegment:self.currentSegment forClip:self.selectedItemIndex];
    
    if(self.activePlayer == ON_SCREEN_PLAYER)
    {
        [self.onScreenPlayer setAlpha:1.0f];
        [self.offScreenPlayer setAlpha:0.0f];
        
        if(_advancedPlayer == ON_SCREEN_PLAYER)
        {
            [self.offScreenPlayer advanceNextItem];
            _advancedPlayer = -1;
        }
        
        if(timeCode)
        {
            [self.offScreenPlayer seekToTimeCode:timeCode[0] completionHandler:^(BOOL success) {
                [self.offScreenPlayer pause:nil];
            }];
        }
        else {
            //reel play ended
        }
    }
    else
    {
        [self.offScreenPlayer setAlpha:1.0f];
        [self.onScreenPlayer setAlpha:0.0f];
        
        if(_advancedPlayer == OFF_SCREEN_PLAYER)
        {
            [self.onScreenPlayer advanceNextItem];
            _advancedPlayer = -1;
        }
        
        if(timeCode)
        {
            [self.onScreenPlayer seekToTimeCode:timeCode[0] completionHandler:^(BOOL success) {
                [self.onScreenPlayer pause:nil];
            }];
        }
        else {
            //reel play ended
        }
    }
    [self playActivePlayer];
    [self performSelector:@selector(updateEndPlayBackNotificationStatus) withObject:nil afterDelay:0.6];
}

-(void)updateEndPlayBackNotificationStatus {
    _isPlayerItemEndNotificationCalled = NO;
}


-(void)playActivePlayer
{
    /*
    if (_isPopupPresent && IS_IPHONE)
    {
        _isPopupPresent = NO;
        [self playAction:NO];
        return;
    }
    */
    
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] selectPlayButton:YES];
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enablePlayButton:YES];
  
    
    if(self.activePlayer == ON_SCREEN_PLAYER) {
        [self.onScreenPlayer play:nil];
    }
    else {
        [self.offScreenPlayer play:nil];
    }
}



-(void)hibernatePlayers
{
    self.autoPause = NO;
    [self pausePlayers];
}

-(void)startTimer
{
//    if([[self delegate] respondsToSelector:@selector(startTimer)]) {
//        [[self delegate] startTimer];
//    }
}


-(NSString*)getDecodedM3U8:(NSString*)clipURL {
    return clipURL;
}

-(NSArray*)getCurrentTimeSegment
{
    //Playlist Functionality Need to go throught once
    PlayerItem *clip =  self.config.itemArray [self.currentSegment];
    NSArray *timeSegment = nil;
    
    if([clip.startTime length] || [clip.endTime length]) {
            timeSegment = @[clip.startTime, clip.endTime];
    }
    else
    {
        clip =  self.config.itemArray[self.selectedItemIndex];
        timeSegment = @[@"00:00:00:00", [PlayerUtilities getTimeCodeFromSeconds:[[clip duration] floatValue] isDF:clip.isDF doFrameCount:YES]];
    }
    
    return timeSegment;
}

-(void)initRelativeWithSegment
{
    self.advancedPlayer = -1;
    NSArray *currentSegment = [self getCurrentTimeSegment];
    if(currentSegment)
    {
        [[self getActivePlayer] seekToTimeCode:[currentSegment firstObject] completionHandler:^(BOOL success)
         {
             //calculate the next segment
             NSArray *timeCode = [self getNextTimeSegment:self.currentSegment forClip:self.selectedItemIndex];
             if(timeCode)
             {
                 if (_activePlayer == ON_SCREEN_PLAYER) {
                     [self.offScreenPlayer seekToTimeCode:[timeCode firstObject] completionHandler:^(BOOL success) {
                         [self.offScreenPlayer pause:nil];
                     }];
                 } else {
                     [self.onScreenPlayer seekToTimeCode:[timeCode firstObject] completionHandler:^(BOOL success) {
                         [self.onScreenPlayer pause:nil];
                     }];
                 }
             }
             [self.progressInd stopAnimating];
             [self playerReadyToPlay];
         }];
    }
    else {
        //TODO:: error
    }
}

-(void)initWithSeekReel
{
    self.advancedPlayer = -1;
    
    self.activePlayer = ON_SCREEN_PLAYER;
    
    [self.onScreenPlayer setAlpha:1.0f];
    [self.offScreenPlayer setAlpha:0.0f];
    
    NSString *timeCode = [PlayerUtilities getTimeCodeFromSeconds:_seekedSeconds isDF:NO doFrameCount:YES];
    
    [self.onScreenPlayer seekToTimeCode:timeCode completionHandler:^(BOOL success)
    {
         //calculate the next segment
         NSArray *timeCode = [self getNextTimeSegment:self.currentSegment forClip:self.selectedItemIndex];
         if(timeCode)
         {
             [self.offScreenPlayer seekToTimeCode:[timeCode firstObject] completionHandler:^(BOOL success) {
                 [self.offScreenPlayer pause:nil];
             }];
         }
         
         [self.progressInd stopAnimating];
         
         self.isSeeked = NO;
         
        [self playerReadyToPlay];
    }];
}


-(void)waterMarkSetUp {
    
}

-(void)updateProgress:(CGFloat)progress withFrameRate:(CGFloat)frameRate
{
    //if([[NSUserDefaults standardUserDefaults] boolForKey:IS_DROP_FRAME] && !_isDropFrame){
      //  _isDropFrame = YES;
 //   }
    
    PlayerItem *clip = self.config.itemArray[_selectedItemIndex];
    
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updatedProgressValue:progress];
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTimeCode:progress forFrameRate:frameRate withSOM:clip.som dropFrame:_isDropFrame];
    
    //To update take count time of scence only in playlist
    [self updateTakeDuration:progress withFrameRate:frameRate withSom:0.0f];
    
    if (IS_IPHONE)
    {
        if(self.config.itemType != Reel) {
        }
        else {
            //If Reel playback check for progress to play next reel clip
            [self updateSceneWithReel:[self calculateDuration] withReel:progress];
        }
    }
    else
    {
        if(self.config.itemType != Reel) {
            //TO:DO - Editot Scence  - Different Value
        }
        else
        {
            //TO:DO - Editot Scence  - Total Duration and Progrss Value
            
            //If Reel playback check for progress to play next reel clip
            [self updateSceneWithReel:[self calculateDuration] withReel:progress];
        }
    }
}

//Fucntion to check for Reel Next Clip Playback
-(void)updateSceneWithReel:(CGFloat)totalReelTime withReel:(CGFloat)reelTime
{
    CGFloat currentProgress        = reelTime;
    
    NSInteger index             = [self.config.itemArray indexOfObjectPassingTest:^BOOL(PlayerItem *item  , NSUInteger idx, BOOL * _Nonnull stop)
    {
        CGFloat tcout           = [PlayerUtilities getSecondsFromTimeCode:item.endTime isDF:NO];
        return currentProgress < tcout;
    }];
    
    //To overcome the issue of selected scence is shown as deselected
    if ((self.scenceTcOut != 0) && (currentProgress >= self.scenceTcOut)) {
        return;
    }
    
    if((index != NSNotFound) && (index != _reelIndex))
    {
        PlayerItem *item = self.config.itemArray[index];
        _reelIndex = index;
        [self updateDurationInScene:YES];
        [self updateScenceDurationWith:item.startTime andOut:item.endTime];
        
        //TO:DO - Notify to Viewer for cahnge of reel clip
        if ([[self delegate] respondsToSelector:@selector(didSwitchToPlayerItem:playlistType:)]) {
            [[self delegate] didSwitchToPlayerItem:index - 1 playlistType:Reel];
        }
    }
    else if (index == NSNotFound) {
        [self updateDurationInScene:NO];
    }
    else if (_scenceStartTime != 0) {
        _scenceStartTime = 0;
    }
}

-(void)updateTimelineForClipInReel:(NSInteger)selectedIndex
{
    if (self.config.itemType == Playlist)
    {
        [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTimeCode:0.0f forFrameRate:0.0f withSOM:0.0f dropFrame:_isDropFrame];
        
        //To update take count time of scence in playlist
        [self updateTakeDuration:0.0f withFrameRate:0.0f withSom:0.0f];
        
        CGFloat startTime   = 0.0f;
        CGFloat endTime     = 0.0f;
        
        if (selectedIndex < [self.config.itemArray count])
        {
            PlayerItem *item                    = self.config.itemArray[selectedIndex];
            startTime                           = [PlayerUtilities getSecondsFromTimeCode:item.startTime withFrameRate:[[self getActivePlayer] getFrameRate] isDF:_isDropFrame];
            endTime                             = [PlayerUtilities getSecondsFromTimeCode:item.endTime   withFrameRate:[[self getActivePlayer] getFrameRate] isDF:_isDropFrame];
            
            item.duration                       = [NSString stringWithFormat:@"%f",endTime - startTime];
            
            [(PlayerControlsControllerBase *)[self.playerControlsContainer getCurrentController] updateProgressMax:[item.duration floatValue]];
       
            if (IS_IPHONE)
            {
                NSString *totalDuration = [NSString stringWithFormat:@"/ %@", [PlayerUtilities getTimeCodeFromSeconds:[[item duration] floatValue] + item.som forFrameRate:[[self getActivePlayer] getFrameRate] isDF:_isDropFrame doFrameCount:YES]];
                [_timeCodeOutLbl setText:totalDuration];
            }
            else {
                [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTimeCodeOut:[[item duration] floatValue] forFrameRate:[[self getActivePlayer] getFrameRate] withSOM:item.som dropFrame:_isDropFrame];
            }
        }
    }
}

-(void)updatePauseIconForButton {
    
}



-(CGFloat)getReelTimeFromIndex:(NSInteger)index
{
    CGFloat reelTime = 0.3f;
    
    if(index >= [self.config.itemArray count]) {
        return  reelTime;
    }
    
    for (NSInteger i = 0; i < index; i++)
    {
        PlayerItem *clip = self.config.itemArray[i];
        if([clip.startTime length] || [clip.endTime length])
        {
            CGFloat startTime = [PlayerUtilities getSecondsFromTimeCode:clip.startTime withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
            CGFloat endTime   = [PlayerUtilities getSecondsFromTimeCode:clip.endTime withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
            CGFloat segmentTime = endTime - startTime;
            
            reelTime += segmentTime;
        }
        else {
            reelTime += [[clip duration] floatValue];
        }
    }
    
    return reelTime;
}

//Playlist Functionalli Chnaged
//Testing Should be made
-(void)findSeekInReel:(CGFloat)seconds
{
    CGFloat reelTime = 0.0f;
    BOOL doBreak = NO;
    
    for (NSInteger i = 0; ((i < [self.config.itemArray count]) && (!doBreak)); i++)
    {
        PlayerItem *clip = self.config.itemArray[i];
        
        if([clip.startTime length] || [clip.endTime length])
        {
            CGFloat startTime = [PlayerUtilities getSecondsFromTimeCode:clip.startTime withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
            CGFloat endTime   = [PlayerUtilities getSecondsFromTimeCode:clip.endTime withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
            CGFloat segmentTime = endTime - startTime;
          
            reelTime += segmentTime;
            
            if(reelTime >= seconds)
            {
                self.prevClip = self.selectedItemIndex;
                self.selectedItemIndex = i;
                _reelPlayed = reelTime - segmentTime;
                
                CGFloat seekTime = segmentTime - (reelTime - seconds);
                [self seekInReel:seekTime];
                
                doBreak = YES;
                break;
            }
        }
        else
        {
            CGFloat segmentTime = [[clip duration] floatValue];
            reelTime += segmentTime;
            if(reelTime >= seconds)
            {
                self.prevClip = self.selectedItemIndex;
                self.selectedItemIndex = i;
                _reelPlayed = reelTime - segmentTime;
                
                CGFloat seekTime = segmentTime - (reelTime - seconds);
                [self seekInReel:seekTime];
                doBreak = YES;
            }
        }
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:EDITOR_MOVE_TO_NEXT_CLIP object:@{TOTOAL_REEL_TIME:[NSNumber numberWithFloat:self.totalReelTime],SELECTED_CLIP:[NSNumber numberWithInteger:_selectedItemIndex]}];
}

-(void)seekInReel:(CGFloat)seekSeconds
{
    _fromReel = YES;
    self.isSeeked = YES;
    
    [self.progressInd startAnimating];
    
    self.playersReady = 0;
    self.isPlayerInitialised = NO;
    
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *clips = [self.config.itemArray mutableCopy];
    for (NSInteger i = self.selectedItemIndex; i < [clips count]; i++)
    {
        PlayerItem *clip = self.config.itemArray[i];
        NSString *clipURL = [clip mediaURL];
        if ([clipURL length])
        {
            clipURL = [self getDecodedM3U8:clipURL];
            [urls addObject:clipURL];
        }
    }
    
    NSArray *timeSegment = [self getCurrentTimeSegment];
    self.seekedSeconds = [PlayerUtilities getSecondsFromTimeCode:timeSegment[0] withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO] + seekSeconds;
    
    //load all the items into the queue
    [self.onScreenPlayer initWithURLList:urls andDelegate:self];
    [self.offScreenPlayer initWithURLList:urls andDelegate:self];
}




-(void)playPlaylistFromSeekedTime:(CGFloat)seekedTime
{
    NSArray *timeSegment    = [self getCurrentTimeSegment];
    self.seekedSeconds      = [PlayerUtilities getSecondsFromTimeCode:timeSegment[0] withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO] + seekedTime;
    NSString *timeCode      = [PlayerUtilities getTimeCodeFromSeconds:_seekedSeconds isDF:NO doFrameCount:YES];
    
    [[self getActivePlayer] seekToTimeCode:timeCode completionHandler:^(BOOL success)
     {
         [self playActivePlayer];
         [self.progressInd stopAnimating];
         self.autoPause = self.isManualPause = YES;
     }];
}


-(void)seekToTimeWithPosition:(CGFloat)position withAutoPlay:(BOOL)autoPlay
{
    CGFloat seekTime = position;
     if (self.config.itemType == Playlist) {
        seekTime = position * self.totalReelTime;
    }
    else {
        seekTime = position *  [self calculateDuration];
    }
    
    [self seekToTime:seekTime withAutoPlay:YES];
}

-(void)initialiseWithLastPlaybackTime:(CGFloat)time withAutoPlay:(BOOL)autoPlay
{
    self.autoPause = autoPlay;
    
    [self.progressInd startAnimating];
    
    CMTime seekTime = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
     if (self.config.itemType != Playlist)
    {
        [self.offScreenPlayer seekToCMTime:seekTime completionHandler:^(BOOL success)
         {
             [self.progressInd stopAnimating];
             [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enableStopControls:YES mode:NO];
             [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enablePlayButton:YES];
            [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updatedProgressValue:time];
         }];
    }
    else {
        [self findSeekInReel:time];
    }
}

-(void)seekToTime:(CGFloat)time withAutoPlay:(BOOL)autoPlay
{
    self.autoPause = autoPlay;
    
    [self.progressInd startAnimating];
    
    CMTime seekTime = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
  if (self.config.itemType != Reel)
    {
        [self.offScreenPlayer seekToCMTime:seekTime completionHandler:^(BOOL success)
        {
             [self.progressInd stopAnimating];
            if(self.autoPlay) {
                [self playActivePlayer];
            }
        }];
    }
    else {
        [self findSeekInReel:time];
    }
}

-(BOOL)prefersStatusBarHidden {
    return _isStatusBar;
}


-(void)setIsFullScreen:(BOOL)isFullscreen
{
    if (!_superView) {
        _superView = [self.view superview];
    }
    
    if(isFullscreen)
    {
        //Delegate Method triggered when switched to full screen
        if ([[self delegate] respondsToSelector:@selector(didSwitchToFullScreen:)]) {
            [[self delegate] didSwitchToFullScreen:isFullscreen];
        }
        
        //Status Bar Update
        
        [PlayerUtilities addPlayerToRootViewController:self.view];
        [_playerBottomCons setConstant:0.0f];
    }
    else
    {
        if ([[self delegate] respondsToSelector:@selector(didSwitchToFullScreen:)]) {
            [[self delegate] didSwitchToFullScreen:isFullscreen];
        }
        
        //Status Bar Update

        
        //Normale Screen Code Writtern here
        [self.view setFrame:_superView.bounds];
        [_superView addSubview:self.view];
        _superView = nil;
        [_playerBottomCons setConstant:_playerBotConstant];
    }
    
   
    //If AirPlayer Not Connected and Player is in FullScreen
    if (!_isExternalScreenConnected)
    {
        [self.constraintsHandler updatePlayerContainerConstraints];
        [_playerContainerView updateConstraintsIfNeeded];
        [_playerContainerView setNeedsLayout];
    }
    
    //Last Update the Player Controller Constraints
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
    
    self.isFullscreen = isFullscreen;
    
    if (!_isExternalScreenConnected)
    {
        
        [_watermarkView renderWatermark:^(BOOL success)
        {
            [self.constraintsHandler updateWatermarkConstraints];
            [self performSelector:@selector(showWatermark) withObject:nil afterDelay:0.0];
        }];

        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            [_watermarkView renderWatermark:^(BOOL success)
            {
                [self.constraintsHandler updateWatermarkConstraints];
                [self performSelector:@selector(showWatermark) withObject:nil afterDelay:0.00];
            }];
        });
    }
    
    if(self.isFullscreen)
    {
        [self showHeaderAndControlsView];
        
//        if (self.delegate && [[self delegate]respondsToSelector:@selector(dismissKeyboard)]) {
//            [[self delegate] dismissKeyboard];
//        }
    }
    else
    {
        _timeCodeInLabelBottonConstraints.constant  = _timeCodeInLabelConstant;
        _timeCodeOutLabelBottomConstraints.constant = _timeCodeOutLabelConstant;
        [self.playerContainerView layoutIfNeeded];
        
        self.headerView.hidden    = YES;
        self.controlsView.hidden  =  NO;
    }
    
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] selectScreenSizeButton];
}

#pragma mark - self methods
-(void)initHUD
{
    //Gesture and Constraints Setup
    [self setUpGestureHandler];
    [self setUpConstraintsHandler];
   
    //Default Playback Speed View
    [self.playbackSpeedView setHidden:YES];
  
    //Auto Default as YES.
    [self setAutoPlay:YES];
    
    //Update the Streaming Decrytion Key
    [[self offScreenPlayer] setStreamDectrypterKey:[self streamDecryptionKey]];
    [[self onScreenPlayer] setStreamDectrypterKey:[self streamDecryptionKey]];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initHUD];

    /*
        _isInitialLock = NO;
        _isSekedToLastPlaybackTime = NO;
        _isDropFrame = NO;
    */
    
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enablePlayButton:NO];
    [self.headerView setHidden:YES];
    
   [self addObservers];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!_isLocked) {
        [self initialise];
        [self initialiseOffline];
        _isLocked = YES;
    }
    
    [self setupExternalScreen];
}

-(void)initialiseOffline
{
    if (self.config.isOffline)
    {
        for(PlayerItem *item in self.config.itemArray)
        {
            if ([item.mediaURL  rangeOfString:@"file:/"].location != NSNotFound)
            {
                NSString *filePath          = [item.mediaURL stringByReplacingOccurrencesOfString:@"file:/" withString:@""];
                NSString *offlineURL        = [NSString stringWithFormat:@"http://127.0.0.1:8080/%@",filePath];
                
                [item setMediaURL:offlineURL];
            }
        }
        
         [self startServer];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_progressInd stopAnimating];
    
    if (_isExternalScreenConnected) {
        [self externalScreenDidDisconnect:nil];
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    [super viewWillDisappear: animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_offScreenPlayer cleanup];
    [_onScreenPlayer cleanup];
    
    [super viewDidDisappear:animated];
}

-(void)viewDidLayoutSubviews
{
    if(!_watermarkView)
    {
        _watermarkView  = (WaterMarkView*)[PlayerUtilities getViewWithXIBId:@"WaterMarkView" owner:self];
        [_watermarkView setDelegate:self];
        [_waterMarkHolderView setHidden:YES];
        [_waterMarkHolderView addSubview:_watermarkView];
        [_watermarkView setWaterMarkModel:self.config.watermarkModel];
        
        self.constraintsHandler.waterMarkView = self.watermarkView;
    }
    
    [self.constraintsHandler updateWatermarkConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    DLog(@"player controller deallocation called ...");
  
    [self removeObservers];
    self.playerSettingscontroller   = nil;
    self.segmentSwapTime            = nil;
    
    
    //Make Constraints/Gesture Nil
    self.constraintsHandler     = nil;
    
    //Make Watermark nil
    self.watermarkView              = nil;

}


#pragma mark - PlayerViewDelegate methods
-(void)retryFailedClip {
    [self playItemAtIndex:self.selectedItemIndex];
   // [self defaultToClip:self.selectedItemIndex];
}

-(void)playerInitializationFailed:(NSInteger)player
{
    if(!_playbackRetryCount)
    {
        _playbackRetryCount = 1;
        [self performSelector:@selector(retryFailedClip) withObject:nil afterDelay:10.0f];
    }
}

-(void)playerInitialised:(NSInteger)player
{
    if(self.isPlayerReady && self.config.itemType != Playlist) {
        return;
    }
    self.isPlayerReady = YES;
    
    PlayerItem *clip = self.config.itemArray[self.selectedItemIndex];
    if([clip.duration floatValue] <= 0.0f || (clip.duration.floatValue > [[self getActivePlayer] durationInSeconds]))
    {
        if(self.activePlayer == ON_SCREEN_PLAYER) {
            clip.duration = [NSString stringWithFormat:@"%f", [self.onScreenPlayer durationInSeconds]];
        }
        else {
            clip.duration = [NSString stringWithFormat:@"%f", [self.offScreenPlayer durationInSeconds]];
        }
    }
    
    
    [self.watermarkView renderWatermark:^(BOOL success)
     {
         [self.watermarkView setHidden:NO];
         [self.constraintsHandler updateWatermarkConstraints];
          if (_isExternalScreenConnected && [self canShowWaterMark])
         {
             [_watermarkView renderWatermark:^(BOOL success)
             {
                 [self performSelector:@selector(showWatermark) withObject:nil afterDelay:.1];
                 [self.constraintsHandler updateWatermarkConstraints];
                 [_waterMarkHolderView setHidden:NO];
             }];
         }
         else {
             [self performSelector:@selector(showWatermark) withObject:nil afterDelay:.1];
         }
     }];

    if(self.isPlayerInitialised) {
        return;
    }
    
    [self pausePlayers];
    
     if (self.config.itemType == Playlist)
    {
        ++self.playersReady;
        if(self.playersReady == 2)
        {
            if(!_isSeeked) {
                [self initRelativeWithSegment];
            }
            else {
                [self initWithSeekReel];
            }
        }
    }
    else
    {
        self.fromReel = NO;
        [self playerReadyToPlay];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayerInitialised" object:nil userInfo:nil];
}

-(void)playerTimeUpdate:(NSInteger)player time:(CMTime)time
{
    if(!self.isPlayerInitialised) {
        return;
    }
    
    int frameRate = 25;
    
    //avoid playing inactive player
    if(self.activePlayer != player)
    {
        if(player == OFF_SCREEN_PLAYER)
        {
            [self.offScreenPlayer pause:nil];
            frameRate = [self.offScreenPlayer framesPerSecond];
        }
        else
        {
            [self.onScreenPlayer pause:nil];
            frameRate = [self.onScreenPlayer framesPerSecond];
        }
        
        return;
    }
    
    if([self.progressInd isAnimating]) {
        [self.progressInd stopAnimating];
    }
    
    CGFloat seconds = CMTimeGetSeconds(time);
     if (self.config.itemType == Playlist)
    {
        NSArray *timeCode       = [self getCurrentTimeSegment];
        CGFloat startSegment    = [PlayerUtilities getSecondsFromTimeCode:timeCode[0] withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
        CGFloat endSegment      = [PlayerUtilities getSecondsFromTimeCode:timeCode[1] withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
        
        CGFloat clipFrames      =  (seconds - startSegment);
        
        [self updateProgress:clipFrames withFrameRate:[[self getActivePlayer] framesPerSecond]];
        
        if(seconds > endSegment)
        {
            //calculate the total reel has been played
            _reelPlayed += (endSegment - startSegment);
            ++self.currentSegment;
        
            if(self.currentSegment >= [self.config.itemArray count])
            {
                self.prevClip = self.selectedItemIndex;
                self.selectedItemIndex = self.currentSegment;
                
                //reset the current segment to first segment of the next clip
                self.currentSegment = 0;
                
                if(self.selectedItemIndex >= [self.config.itemArray count])
                {
                    [self stopPlayers];
                    return;
                }
            }
            
            [self updateTimelineForClipInReel:self.currentSegment];
            
            [self swapPlayers];
        }
    }
    else
    {
        PlayerItem *clip = self.config.itemArray[self.selectedItemIndex];
        if((seconds > [[clip duration] floatValue]) || isnan(seconds)) {
            [self stopPlayers];
        }
        else {
            [self updateProgress:seconds withFrameRate:[[self getActivePlayer] framesPerSecond]];
        }
    }
}

-(void)playerTimeUpdate:(NSInteger)player time:(CMTime)time withFrameRate:(Float64)frameRate
{
    if(!self.isPlayerInitialised || _isPlayerItemEndNotificationCalled) {
        return;
    }
    
    CGFloat seconds = (CGFloat)time.value / (CGFloat)time.timescale;
    //    DLog(@"playerTimeUpdate fps : %f, frame %d",frameRate, frame);
    //avoid playing inactive player
    if(self.activePlayer != player)
    {
        if(player == OFF_SCREEN_PLAYER) {
            [self.offScreenPlayer pause:nil];
        }
        else {
            [self.onScreenPlayer pause:nil];
        }
        return;
    }
    
    if([self.progressInd isAnimating]) {
        [self.progressInd stopAnimating];
    }
    
     if (self.config.itemType == Playlist)
     {
        //Get the current playlist time code for
        NSArray *timeCode       = [self getCurrentTimeSegment];
         
        CGFloat startSegment    = [PlayerUtilities getSecondsFromTimeCode:timeCode[0] withFrameRate:frameRate isDF:NO];
        CGFloat endSegment      = [PlayerUtilities getSecondsFromTimeCode:timeCode[1] withFrameRate:frameRate isDF:NO];
        
        if (([[self getActivePlayer] getPlayerRate] < 0.0) && seconds <= startSegment)
        {
            [self resetPlayersAfterSpeedPlayBack];
            return;
        }
        
        CGFloat clipFrames      =  (seconds - startSegment);
        if (!_isDraggingSeekbar && ![[self getActivePlayer] isSeeking]) {
         [self updateProgress:clipFrames withFrameRate:[[self getActivePlayer] framesPerSecond]];
        }
         
        if(seconds > endSegment)
        {
            //calculate the total reel has been played
            _reelPlayed += (endSegment - startSegment);
            ++self.currentSegment;
            
            if(self.currentSegment >= [self.config.itemArray count])
            {
                //reset the current segment to first segment of the next clip

                self.prevClip = self.selectedItemIndex;
                self.selectedItemIndex = self.currentSegment;
                self.currentSegment = 0;
                
                if(self.selectedItemIndex >= [self.config.itemArray count])
                {
                    [self stopPlayers];
                    return;
                }
            }
            
            [self updateTimelineForClipInReel:self.currentSegment];
            
            [self swapPlayers];
        }
    }
    else
    {
        //Check if player playing reverse playback and duration is less than or equal to zero then stop players
        if (([[self getActivePlayer] getPlayerRate] < 0.0) && seconds <= 0.0) {
            [self resetPlayersAfterSpeedPlayBack];
            return;
        }

        PlayerItem *clip = self.config.itemArray[self.selectedItemIndex];
        if((seconds > [[clip duration] floatValue]) || isnan(seconds)) {
            [self stopPlayers];
        }
        else {
            if (!_isDraggingSeekbar && ![[self getActivePlayer] isSeeking]) {
                [self updateProgress:seconds withFrameRate:frameRate];
            }
        }
    }
}

-(void)playerDidEndClip:(NSInteger)player
{
    if(self.config.itemType == Playlist) {
        [self stopPlayers];
    }
}

-(void)playerDidResumePlay:(NSInteger)player
{
    if(_isPlayerInitialised) {
        [self.progressInd stopAnimating];
    }
    
    if ([[self getActivePlayer] isFastOrReversePlayback]) {
        return;
    }
    
    if(self.autoPause)
    {
        if(self.activePlayer == player) {
            [self playActivePlayer];
        }
    }
}

-(void)playerDidPause:(NSInteger)player
{
    if(_isPlayerInitialised || player == _activePlayer ) {
        [self.progressInd startAnimating];
    }
    
    if ([[self getActivePlayer] isFastOrReversePlayback]) {
        return;
    }
    
    if (self.config.itemType == Playlist)
    {
        if (player == ON_SCREEN_PLAYER) {
            [_onScreenPlayer pause:nil];
        }
        else {
            [_offScreenPlayer pause:nil];
        }
        
        if (player == _activePlayer) {
            [self updatePauseIconForButton];
        }
    }
    else {
        [self pausePlayers];
    }
}

/**
 @abstract  Called when clip finished playing. If player playing reverse playback and reach to 0th second then stop player and reset playback rate to 1. For forward playback on end of clip move to next clip and reset playback rate to 1.
 @sender    PlayerView instance
 */
- (void)videoPlayerDidFinishPlayback:(id)sender
{
    if (![[self getActivePlayer] isFastOrReversePlayback] && _isPlayerItemEndNotificationCalled) {
        return;
    }

     if (self.config.itemType != Playlist){
        [self resetPlayersAfterSpeedPlayBack];
    }
    else
    {
        CGFloat frameRate   = [[self getActivePlayer] getFrameRate];
        CMTime  time        = [[self getActivePlayer] getCurrentTime];
        
        CGFloat seconds     = (CGFloat)time.value / (CGFloat)time.timescale;
        
        NSArray *timeCode       = [self getCurrentTimeSegment];
        CGFloat startSegment    = [PlayerUtilities getSecondsFromTimeCode:timeCode[0] withFrameRate:frameRate isDF:NO];
        CGFloat endSegment      = [PlayerUtilities getSecondsFromTimeCode:timeCode[1] withFrameRate:frameRate isDF:NO];
        
        if ([[self getActivePlayer] getPlayerRate] < 0.0) {
            [self resetPlayersAfterSpeedPlayBack];
            return;
        }
        CGFloat clipFrames      =  (seconds - startSegment);
        
        [self updateProgress:clipFrames withFrameRate:[[self getActivePlayer] framesPerSecond]];
        
        //calculate the total reel has been played
        _reelPlayed += (endSegment - startSegment);
        ++self.currentSegment;
        
        if(self.currentSegment >= [self.config.itemArray count])
        {
            self.prevClip = self.selectedItemIndex;
            self.selectedItemIndex = self.currentSegment;
            
            //reset the current segment to first segment of the next clip
            self.currentSegment = 0;
            
            if(self.selectedItemIndex >= [self.config.itemArray count])
            {
                [self stopPlayers];
                return;
            }
        }
    
        [self updateTimelineForClipInReel:self.currentSegment];
        [self swapPlayers];
    }
}


/**
 This method will call when user tap on previous frame or previous second button. Here we are checking if time code is less than start time of clip then reset it to start time of clip and if "time" is invalid then reset to kCMTimeZero.

 @param time    The time wich you want to validate.
 @return Valid  CMTime object
 */
-(CMTime)checkAndGetValidStartClipTime:(CMTime)time
{
    if (self.config.itemType == Playlist)
    {
        NSArray *currentSegment = [self getCurrentTimeSegment];
        
        if(currentSegment)
        {
            NSString *timeCode  = [currentSegment firstObject];
            CMTime startTime    = CMTimeMakeWithSeconds([PlayerUtilities getSecondsFromTimeCode:timeCode withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO], NSEC_PER_SEC);
            
            int32_t compare     = CMTimeCompare(time, startTime); //(-1 = if time less than to startTime , 1 = greater than, 0 = equal).
            
            if(compare == -1) {
                time = startTime;
            }
        }
    }
    else
    {
        int32_t compare = CMTimeCompare(time, kCMTimeZero); //(-1 = if time less than kCMTimeZero, 1 = greater than, 0 = equal).
        
        if(compare == -1) {
            time = kCMTimeZero;
        }
    }
    
    if(CMTIME_IS_INVALID(time)) {
        time = kCMTimeZero;
    }
    return time;
}

#pragma mark - segment handlers

-(void)playScene:(NSString*)timeIn andOut:(NSString*)timeOut
{
    _isScene = YES;
    _initialSeekIn = [PlayerUtilities getSecondsFromTimeCode:timeIn withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
    _initialSeekOut = [PlayerUtilities getSecondsFromTimeCode:timeOut withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
    
    [self.progressInd startAnimating];
    [self seekActivePlayer:timeIn];
}

-(void)seekActivePlayer:(NSString*)seekTime
{
    if(self.activePlayer == ON_SCREEN_PLAYER)
    {
        [self.onScreenPlayer seekToTimeCode:seekTime completionHandler:^(BOOL success)
         {
             [self.progressInd stopAnimating];
             [self playAction:YES];
         }];
    }
    else
    {
        [self.offScreenPlayer seekToTimeCode:seekTime completionHandler:^(BOOL success)
         {
             [self.progressInd stopAnimating];
             [self playAction:YES];
         }];
    }
}


-(void)enablePlayerControls:(BOOL)isEnable {
    
}

-(void)updateSettingButtonStatus
{
    [self enableSettingsButton:YES];
    [self highlightSettingsButton:NO];
    [self selectSettingsButton:NO];
}

#pragma mark - PlayerSettingsPopUpDelegate methods

-(NSArray*)getAudioTracks {
    return [[self getActivePlayer] getAudioTracks];
}

-(NSArray *)getSubTitles {
    return  [[self getActivePlayer] getSubTitles];
}

-(NSString*)getCurrentAudioTrackName {
    return [[self getActivePlayer] getCurrentAudioTrackName];
}

-(NSString *)getCurrentSubtitleName {
    return [[self getActivePlayer]getCurrentSubtitleName];
}

-(NSString*)getCurrentURLFromDataSource {
    return [[self getActivePlayer] getCurrentURLFromDataSource];
}

-(NSString*)getCurrentBitRate {
    return [[self getActivePlayer] getCurrentBitRate];
}

-(NSString*)getCurrentURLFromPlayer {
     return [[self getActivePlayer] getCurrentURLFromPlayer];
}

-(void)switchAudioTrack:(PlayerTrack*)track
{
    [[self getActivePlayer] switchAudioTrack:track];
    
    [self showSettingsView:NO];
}

-(void)switchSubtitle:(PlayerTrack *)track
{
    [self showSettingsView:NO];
    [[self getActivePlayer] switchSubtitle:track];
}

-(void)switchBitrate:(Bitrate*)bitrate
{
    [self showSettingsView:NO];
    [[self getActivePlayer] switchBitrate:bitrate];
}

-(void)moveCommentUp
{
//    if([[self delegate] respondsToSelector:@selector(moveCommentUp)]) {
//        [[self delegate] moveCommentUp];
//    }
}

-(void)moveCommentDown
{
//    if([[self delegate] respondsToSelector:@selector(moveCommentDown)]) {
//        [[self delegate] moveCommentDown];
//    }
}

-(void)moveCommentLeft
{
//    if([[self delegate] respondsToSelector:@selector(moveCommentLeft)]) {
//        [[self delegate] moveCommentLeft];
//    }
}

-(void)moveCommentRight
{
//    if([[self delegate] respondsToSelector:@selector(moveCommentRight)]) {
//        [[self delegate] moveCommentRight];
//    }
}

-(void)increaseCommentTextFontSize
{
//    if([[self delegate] respondsToSelector:@selector(increaseCommentTextFontSize)]) {
//        [[self delegate] increaseCommentTextFontSize];
//    }
}

-(void)decreaseCommentTextFontSize
{
//    if([[self delegate] respondsToSelector:@selector(decreaseCommentTextFontSize)]) {
//        [[self delegate] decreaseCommentTextFontSize];
//    }
}

-(void)setCommentTextColor:(UIColor *)color
{
//    if([[self delegate] respondsToSelector:@selector(setCommentTextColor:)]) {
//        [[self delegate] setCommentTextColor:color];
//    }
}

#pragma mark - CBCRCPlayerDelegate methods
-(void)bitrateSwiched {
    DLog(@"Bitrate Switched...");
}

-(void)audioTrackSwitched {
    self.autoPause = self.isManualPause = YES;
}

-(void)subtitleSwitched
{
    self.autoPause = self.isManualPause = YES;
    [self playerDidResumePlay:[self activePlayer]];
}

-(void)subtitleSwitchedWithError
{
//    if([[self delegate] respondsToSelector:@selector(subtitleSwitchedWithError)]) {
//        [[self delegate] subtitleSwitchedWithError];
//    }
}

- (void)subtitleloadingWithObject:(PlayerTrack *)track
{
//    if([[self delegate] respondsToSelector:@selector(subtitleloadingWithObject:)]) {
//        [[self delegate] subtitleloadingWithObject:assetTrack];
//    }
}


#pragma mark - UIGesture delegate method
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *) otherGestureRecognizer {
    return YES;
}


-(IBAction)tapGestureAction:(UITapGestureRecognizer *)sender
{
    if (_playerSettingscontroller.view) {
        [self showSettingsView:NO];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_playerSettingscontroller.view]) {
        return NO;
    }
    
    return YES;
}




-(BOOL)enablePlayerControls {
    return YES;
}

#pragma mark - airplay connection methods



-(NSString*)getCurrentTimeCode {
    return [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] getTimeCodeIn];
}

#pragma mark - watermark delegate methods
-(CGRect)getVideoRect {
    return [[[self getActivePlayer] playerLayer] videoRect];
}



-(NSMutableArray*)configureSubtitleSetting:(NSMutableArray *)settingArray
{
    BOOL isSubtitleEnable = YES;
    NSString *urlString = [[self getActivePlayer] getCurrentURLFromPlayer];
    
    if (!self.config.isSubtitleEnabled) {
        isSubtitleEnable = NO;
    }
    else if([urlString rangeOfString:@".m3u8"].location != NSNotFound) {
        isSubtitleEnable = YES;
    }
    else
    {
        NSData *subtitleData = [PlayerCache objectForKey:SUBTITLE_CACHE_FILENAME];
        if (!subtitleData){
            isSubtitleEnable = NO;
        }
    }
    
    if (!isSubtitleEnable) {
        [settingArray removeObject:@"Subtitles"];
    }
    
    return settingArray;
}

-(void)updateControlType:(NSInteger)playerType {
    
}





- (IBAction)fullscreenActionHandler:(id)sender
{
    if(IS_IPAD)
    {
        self.isFullscreen = !self.isFullscreen;
        [self setIsFullScreen:self.isFullscreen];
    }
    else
    {
        if(self.isFullscreen) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        }
        else {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];
        }
    }
}



#pragma mark - Mongoose

-(void)startServer
{
    if (!_server)
    {
        _server = [[MongooseDaemon alloc] init];
        [_server startMongooseDaemon:@"8080" withRootPath:NSHomeDirectory()];
    }
}

-(void)stopServer
{
    if(_server) {
        [_server stopMongooseDaemon];
    }
    
    _server = nil;
}

#pragma mark - helpers

-(void)selectSettingsButton:(BOOL)selected {
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] selectSettingsButton:selected];
}

-(void)enableSettingsButton:(BOOL)enable {
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enableSettingsButton:enable];
}

-(void)highlightSettingsButton:(BOOL)highlight {
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] highlightSettingsButton:highlight];
}



-(void)updatePlayerTimeCodeForFrameRate:(CGFloat)frameRate
{
    CGFloat duration                = [self calculateDuration];
    PlayerItem *clip                = self.config.itemArray[self.selectedItemIndex];
    _isDropFrame                    = [clip isDF];
    
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateProgressMax:duration];
    
    if (IS_IPHONE) {
        [ _timeCodeOutLbl setText:[NSString stringWithFormat:@"%@",[PlayerUtilities getTimeCodeFromSeconds:(duration + clip.som) forFrameRate:frameRate isDF:_isDropFrame doFrameCount:YES]]];
    }
    else {
        [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTimeCodeOut:duration forFrameRate:frameRate withSOM:clip.som dropFrame:_isDropFrame];
    }
}

-(void)playerReadyToPlay
{
    [self updatePlayerTimeCodeForFrameRate:[[self getActivePlayer] getFrameRate]];
    self.isPlayerInitialised = YES;
    if(_isLastPlaybackTimeResponseReady  && (!self.isSekedToLastPlaybackTime)) {
        [self beginPlay];
    }
    else {
        [self enableTimeLineControls];
    }
}

-(void)beginPlay
{
    [self enableTimeLineControls];
    
    if (_lastPlaybackTime > 0)
    {
        _isSekedToLastPlaybackTime = YES;
        [self initialiseWithLastPlaybackTime:_lastPlaybackTime withAutoPlay:YES];
    }
    
    [self playerReadyToPlay];
    
    if([self.config isOffline]){
        [self enableSettingsButton:NO];
    }
}

-(void)enableTimeLineControls
{
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enableStopControls:YES mode:NO];
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enablePlayButton:YES];
    
    PlayerControlType controlType = self.config.controlType;
    if ((controlType == CONTROL_TYPE_REVIEW | controlType == CONTROL_TYPE_ADVANCED | controlType == CONTROL_TYPE_EXECUTIVE) && ![self.config isOffline]) {
        // [self enableSegmentsControlsFromPermission];
    }
}

/*
 -(void)enableSegmentsControlsFromPermission
 {
     NSArray *permissions = [NSKeyedUnarchiver unarchiveObjectWithData:[PlayerCache objectForKey:CL_PREVIEW_SCREEN_PERMISSIONS]];
     
     
     NSUInteger index     = [permissions indexOfObjectPassingTest:^BOOL(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     return [obj isEqualToString:@"A_C"];
     }];
     
     if (index == NSNotFound || !self.isPlayerInitialised) {
     [(ReviewPlayerControlsController*)[self.playerControlsContainer getCurrentController] enableSegmentOption:NO];
     }
     else {
     [(ReviewPlayerControlsController*)[self.playerControlsContainer getCurrentController] enableSegmentOption:YES];
     }
 }

*/


/*
    Methods for Handling Sequencial Reel Clip Playback
*/
-(void)updateScenceDurationWith:(NSString *)tcin andOut:(NSString *)tcout
{
    self.scenceStartTime         = [PlayerUtilities getSecondsFromTimeCode:tcin withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
    self.scenceDuration          = [PlayerUtilities getSecondsFromTimeCode:tcout withFrameRate:[[self getActivePlayer] framesPerSecond] isDF:NO];
}

-(void)updateDurationInScene:(BOOL)isUpdated {
    [self setUpdateDuraton:isUpdated];
}

-(void)updateTakeDuration:(CGFloat)seconds withFrameRate:(CGFloat)frameRate withSom:(CGFloat)som
{
    if(self.config.itemType == Playlist)
    {
        if (!self.isDurationUpdated)
        {
            [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTakeTimeCode:0.0f forFrameRate:0.0f withSOM:0.0f dropFrame:_isDropFrame];
            return;
        }
        
        //To make seconds to 0 if seconds is not in between TcIn and TcOut of selected reel clip
        if ((seconds < self.scenceStartTime) || (seconds > self.scenceDuration)) {
            seconds = 0.0f;
        }
        
        //To calculate the scence duration from the actual time duration of asset
        seconds = seconds - self.scenceStartTime;
        
        //To make seconds to 0 if player is still updating the progress after click on next/previous buttons
        if (seconds < 0) {
            seconds = 0.0f;
        }
    
        if (self.scenceStartTime > 0) {
            [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTakeTimeCode:(seconds - self.scenceDuration) forFrameRate:frameRate withSOM:0.0f dropFrame:_isDropFrame];
        }
        else {
            [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTakeTimeCode:seconds forFrameRate:frameRate withSOM:0.0f dropFrame:_isDropFrame];
        }
    }
}


#pragma mark - ScreenerPlayerDelegate


-(void)playAction:(BOOL)isPlay{
    
}


-(void)reelPlaybackFinished
{
    [self initialiseReelModeFromIndex:0];
    
    //[self notifyToHeighlightClipInPlaylistTable];
    //It should be part of the PlayerCustomDelegate
}

-(void)playFromSeekedTime:(CGFloat)seekedTime
{
   // [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTimeCode:seekedTime forFrameRate:[[self getActivePlayer] getFrameRate] withSOM:0.0f dropFrame:_isDropFrame];
    
    self.autoPause = self.isManualPause;
    
    if (![[self server] isRunning])  {
        [self.progressInd startAnimating];
    }
    
    [self performSelector:@selector(updateDraggingStatus) withObject:nil afterDelay:.1];
    
    CMTime seekTime = CMTimeMakeWithSeconds(seekedTime, NSEC_PER_SEC);
     if (self.config.itemType != Playlist)
    {
        [self.offScreenPlayer seekToCMTime:seekTime completionHandler:^(BOOL success) {
             self.autoPause = self.isManualPause = YES;
         }];
    }
    else {
        [self playPlaylistFromSeekedTime:seekedTime];
    }
}

-(void)adjustPlayerSpeed:(CGFloat)playbackRate
{
    if (IS_IPHONE)
    {
        NSString *currentTimeCode =  _timeCodeInLbl.text;
        //Do not perform reversePlayback If player's current time is less than or equal to 0.0
        if([currentTimeCode isEqualToString:@"00:00:00:00"] && playbackRate < 0)
        {
            [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] resetPlayerSpeed:playbackRate + 1];
            return;
        }
    }
    
    [_speedLbl setText:[NSString stringWithFormat:@"%.1f x", playbackRate]];
    
    [_playbackSpeedView.layer removeAllAnimations];
    [_playbackSpeedView setAlpha:1.0f];
    [_playbackSpeedView setHidden:NO];
    
    [UIView animateWithDuration:0.7f delay:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [_playbackSpeedView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [_playbackSpeedView setHidden:YES];
        
        [[self getActivePlayer] setPlaybackRate:playbackRate];
        [[self getActivePlayer] play:nil];
        
        BOOL isPlay = (playbackRate == 1);
        [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] selectPlayButton:isPlay];
    }];
}
-(void)reelPlayActionHandler{
    
}
-(void)listSegments{
    
}
-(void)editClips:(BOOL)enable{
    
}
-(void)changePlaylistClip:(int)clipIndex{
    
}

-(void)fullScreenAction:(UIButton*)sender{
    
}
-(void)showSettingsView:(BOOL)isShow
{
    [self enableSettingsButton:NO];
    
    if(isShow)
    {
        self.isManualPause = self.autoPause;
        
        self.autoPause = NO;
        [self pausePlayers];
        
        [_settingsHolderView setHidden:NO];
        [self highlightSettingsButton:YES];
        [self selectSettingsButton:YES];
        
        PlayerSettingsPopupInterface *interface = [[PlayerSettingsPopupInterface alloc] init];
        
        NSMutableArray *settingAttriuteArray = [NSMutableArray arrayWithObjects:@"Audio", @"Quality",@"Subtitles" ,nil];
        settingAttriuteArray = [self configureSubtitleSetting:settingAttriuteArray];
        [interface setCategoryArray:[settingAttriuteArray copy]];
        
    
        PlayerControlType controlType = self.config.controlType;
        if(controlType == CONTROL_TYPE_PUBLISH || controlType == CONTROL_TYPE_ANNOTATION || controlType == CONTROL_TYPE_RANGE_COMMENT)
        {
            settingAttriuteArray = [NSMutableArray arrayWithObjects:@"Audio", @"Quality",@"Annotation",@"Subtitles" ,nil];
            if (!self.config.isCommentOverLayEnabled) {
                [settingAttriuteArray removeObject:@"Annotation"];
            }
            
            settingAttriuteArray = [self configureSubtitleSetting:settingAttriuteArray];
            [interface setCategoryArray:[settingAttriuteArray copy]];
        }
        
        if(!_playerSettingscontroller)
        {
            _playerSettingscontroller = (PlayerSettingsPopupViewController*)[PlayerSettingsPopupViewController initWithInterface:interface withDelegate:self];
            self.constraintsHandler.playerSettingscontroller    = self.playerSettingscontroller;
            self.constraintsHandler.settingsHolderView          = self.settingsHolderView;
        }
        
        [self addChildViewController:_playerSettingscontroller];
        [_playerSettingscontroller.view setFrame:_settingsHolderView.frame];
        [_settingsHolderView addSubview:_playerSettingscontroller.view];
        _settingsHolderView.layer.zPosition = MAXFLOAT;
        
        [[_settingsHolderView layer] setCornerRadius:5.0f];
        [_settingsHolderView layer].masksToBounds = YES;
        
        [[self view] bringSubviewToFront:_settingsHolderView];
        [self.constraintsHandler updateSettingsPopupConstraints];
        
        [_settingsHolderView setAlpha:1.0f];
        [self enableSettingsButton:YES];
    }
    else
    {
        self.autoPause = self.isManualPause;
        [self playerDidResumePlay:[self activePlayer]];
        [_playerSettingscontroller removeFromParentViewController];
        [_playerSettingscontroller.view removeFromSuperview];
        [_settingsHolderView setHidden:YES];
        [self performSelector:@selector(updateSettingButtonStatus) withObject:nil afterDelay:0.1];
    }
}

-(void)showPlayerInFullScreen {
    
}
-(void)showHelpScreen:(BOOL)isShow {
    
}


-(void)cancelTimerAndReinitiate:(BOOL)shouldReinitiate{
    
}
-(NSInteger)getPreviewType{
    return -1;
}


#pragma mark - Player Controls Private Method
-(void)pausePlayers
{
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] selectPlayButton:NO];
    
    [self.onScreenPlayer pause:nil];
    [self.offScreenPlayer pause:nil];
}

-(void)stepFrameActionHandler:(NSInteger)isNext
{
    self.autoPlay = NO;
    self.autoPause = NO;
    
    [self pausePlayers];
    
    if(self.activePlayer == ON_SCREEN_PLAYER) {
        [self.onScreenPlayer stepFrame:isNext];
    }
    else {
        [self.offScreenPlayer stepFrame:isNext];
    }
}

-(void)stepSecondActionHandler:(NSInteger)isNext
{
    self.autoPlay = NO;
    self.autoPause = NO;
    [self pausePlayers];
    
    if(self.activePlayer == ON_SCREEN_PLAYER) {
        [self.onScreenPlayer stepBySeconds:isNext];
    }
    else {
        [self.offScreenPlayer stepBySeconds:isNext];
    }
    
}

-(void)stopPlayers
{
    if ([[self delegate] respondsToSelector:@selector(didCompletePlayback:)]) {
        [[self delegate] didCompletePlayback:self.config.itemType];
    }
    
    [_offScreenPlayer cleanup];
    [_onScreenPlayer cleanup];
    
    self.watermarkView.hidden               = YES;
    self.isPlayerInitialised                = NO;
    self.playerStopped                      = YES;
    self.autoPlay                           = NO;
    self.autoPause                          = NO;
    self.isPlayerReady                      = NO;
    self.isManualPause                      = NO;
    _isPlayerItemEndNotificationCalled      = YES;
    
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] resetPlayerSpeed:0.0f];
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enableSpeedButtons:NO];
    
    if (self.config.itemType == Playlist) {
        [self reelPlaybackFinished];
    }
    else {
        [self playItemAtIndex:self.selectedItemIndex];
    }
    
    //    if([[self delegate] respondsToSelector:@selector(removeCommentView)]) {
    //        [[self delegate] removeCommentView];
    //    }
    // [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_STOPPED_NOTIFICATION object:nil];
    [self performSelector:@selector(updateEndPlayBackNotificationStatus) withObject:nil afterDelay:0.6];
    
    if (IS_IPHONE) {
        [ _timeCodeInLbl setText:[PlayerUtilities getTimeCodeFromSeconds:0.0f forFrameRate:0.0f isDF:NO doFrameCount:YES]];
    }
    else
    {
        [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTimeCode:0.0f forFrameRate:0.0f withSOM:0.0f dropFrame:_isDropFrame];
        
        //To update take count time of scence after player stops
        [self updateTakeDuration:0.0f withFrameRate:0.0f withSom:0.0f];
    }
    
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] selectPlayButton:NO];
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enableStopControls:NO mode:NO];
    
}

-(void)initSegment
{
    if (IS_IPAD) {
        self.segmentStartTime = ((PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController]).timeCodeInLbl.text;
    }
    else {
        self.segmentStartTime = _timeCodeInLbl.text;
    }
}

-(void)updateSegment
{
    PlayerItem *clip = self.config.itemArray [self.selectedItemIndex];
    
    if(self.activePlayer == OFF_SCREEN_PLAYER)
    {
        self.segmentStartTime = [PlayerUtilities getTimeCodeFromTime:[self.offScreenPlayer getCurrentTimeWithTime] forFrameRate:[self.offScreenPlayer framesPerSecond] som:[clip som] isDF:NO doFrameCount:YES];
    }
    else
    {
        self.segmentStartTime = [PlayerUtilities getTimeCodeFromTime:[self.onScreenPlayer getCurrentTimeWithTime] forFrameRate:[self.onScreenPlayer framesPerSecond] som:[clip som] isDF:NO doFrameCount:YES];
    }
}

-(void)createSegment
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
    ^{
        if (IS_IPHONE) {
            self.segmentEndTime = _timeCodeInLbl.text;
        } else {
            self.segmentEndTime = ((PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController]).timeCodeInLbl.text;
            
        }
        
        if([self.segmentStartTime isEqualToString:@""]) {
            self.segmentStartTime = @"00:00:00:00";
        }
        
        if([self.segmentEndTime isEqualToString:@""]) {
            self.segmentEndTime = @"00:00:00:00";
        }
        
        NSLog(@"Start Time:%@",self.segmentStartTime);
        
        NSLog(@"End Time:%@",self.segmentEndTime);
        //To:DO implement the Custom PLayer Controller Delegate create segement
    });
}

-(void)pointSegment
{
    [self initSegment];
    [self createSegment];
    
  //  if (self.interface.orderConfigName && [[self.interface orderConfigName] caseInsensitiveCompare:CONTENT_TYPE_PREVIEW_VIDEO ] == NSOrderedSame) {
  //      [self createPointSegment];
  //  }
  //  else {
  //      [self createSegment];
  //  }
}

-(void)cancelSegment
{
    self.segmentStartTime = nil;
    self.segmentEndTime = nil;
}

#pragma mark - Player Controls Delegate
// play, pause, next, previous events
-(void)didPressPlayPauseBtnInControlView:(UIView *)controlView
{
    BOOL isSelected = [(UIButton*)controlView isSelected];
    self.autoPause = isSelected;
    
    if(isSelected)
    {
        [[self getActivePlayer] setPlaybackRate:1.0];
        [self playActivePlayer];
        
        if ([[self delegate] respondsToSelector:@selector(didPlay)]) {
            [[self delegate] didPlay];
        }
    }
    else
    {
        [self pausePlayers];
        if ([[self delegate] respondsToSelector:@selector(didPause)]) {
            [[self delegate] didPause];
        }
    }
}

-(void)didPressStopBtnInControlView:(UIView*)controlView {
    [self stopPlayers];
}

-(void)didPressStepFrameBtnInControlView:(UIView*)controlView {
    [self stepFrameActionHandler:[controlView tag]];
}

-(void)didPresseStepSecondBtnInControlView:(UIView*)controlView {
    [self stepSecondActionHandler:[controlView tag]];
}

-(void)willPressRangeMarkInBtn {
    [self initSegment];
}

-(void)didPressRangerMarkOutBtn {
    [self createSegment];
}
    
-(void)didPressPointMarkBtn
{
    [self pausePlayers];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self pointSegment];
    });
}

-(void)didPressRangeMarkInBtn {
    [self cancelSegment];
}

-(void)updateDraggingStatus {
    _isDraggingSeekbar = NO;
}

-(void)didBeginDragActionWithProgress {
    //TO:DO Comment Overlay Delegate Handler
    _isDraggingSeekbar = YES;
}

-(void)didSeekToTime:(CGFloat)time {
    [self playFromSeekedTime:time];
}

-(void)didChangePlayerSpeed:(CGFloat)speed inControlView:(UIView*)controlView
{
    [self adjustPlayerSpeed:speed];
//    [[self getActivePlayer] setPlaybackRate:speed];
//    [[self getActivePlayer] play:nil];
//    
//    BOOL isPlay = (speed == 1);
//    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] selectPlayButton:isPlay];
}

-(void)didPressFullScreenBtnInControlView:(UIView*)controlView
{
    if(IS_IPHONE)
    {
        if(self.isFullscreen) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        }
        else {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];
        }
    }
    else
    {
        self.isFullscreen = !self.isFullscreen;
        [self setIsFullScreen:self.isFullscreen];
    }
}

-(void)didPressSettingsBtn:(BOOL)isEnable inControlView:(UIView*)controlView{
    [self showSettingsView:isEnable];
}
-(void)didPressHelpBtn:(bool)willShowHelpView InControlView:(UIView*)contrololView{
    
}

#pragma mark - helpers

- (void)showHeaderAndControlsView
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    if(self.config.controlType == CONTROL_TYPE_EXECUTIVE){
        self.headerView.hidden   = YES;
    }else{
        self.headerView.hidden   = NO;
    }
    
    self.controlsView.hidden = NO;
    
    if (IS_IPHONE && !self.isExternalScreenConnected)
    {
        _timeCodeInLabelBottonConstraints.constant  = _timeCodeInLabelBottonConstraints.constant + (self.controlsView.frame.size.height - _timeCodeInLabelBottonConstraints.constant);
        _timeCodeOutLabelBottomConstraints.constant = _timeCodeOutLabelBottomConstraints.constant +(self.controlsView.frame.size.height - _timeCodeOutLabelBottomConstraints.constant);
        [self.playerContainerView layoutIfNeeded];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideHeaderAndControlsView) userInfo:nil repeats:NO];
}

- (void)hideHeaderAndControlsView
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    [UIView transitionWithView:self.headerView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    
    self.headerView.hidden = YES;
    
    if(self.isFullscreen)
    {
        [UIView transitionWithView:self.controlsView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
        self.controlsView.hidden = YES;
        
        if (IS_IPHONE)
        {
            _timeCodeInLabelBottonConstraints.constant  = _timeCodeInLabelConstant;
            _timeCodeOutLabelBottomConstraints.constant = _timeCodeOutLabelConstant;
            
            [self.playerContainerView layoutIfNeeded];
        }
    }
}

-(void)showProgressIndicator{
    [self.progressInd startAnimating];
}

-(void)hideProgressIndicator{
    [self.progressInd stopAnimating];
}

/*
-(void)hideAndShowPlayerControlsBasedOnViewerMode{
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] hideAndShowPlayerControlsBasedOnViewerMode:self.controlType];
}
*/
-(void)hideSegmentsOption:(bool)hide{
     [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] hideSegmentsOption:hide];
}

-(void)updateProgressMax:(CGFloat)duration{
     [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateProgressMax:duration];
}

-(void)updateTimeCodeOut:(CGFloat) seconds forFrameRate:(CGFloat)frameRate withSOM:(CGFloat)som dropFrame:(BOOL)isDf{
       [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTimeCodeOut:seconds forFrameRate:frameRate withSOM:som dropFrame:isDf];
}

-(void)updateTimeCode:(CGFloat) seconds forFrameRate:(CGFloat)frameRate withSOM:(CGFloat)som dropFrame:(BOOL)isDf
{
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTimeCode:seconds forFrameRate:frameRate withSOM:som dropFrame:isDf];
}

-(void)updateTakeTimeCode:(CGFloat)seconds forFrameRate:(CGFloat)frameRate withSOM:(CGFloat)som dropFrame:(BOOL)isDf{
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] updateTakeTimeCode:seconds forFrameRate:frameRate withSOM:som  dropFrame:_isDropFrame];
}

-(Float64)getFrameRate{
    return [[self getActivePlayer] getFrameRate];
}

-(void)enablePlayButton:(bool)enable{
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enablePlayButton:enable];
}
-(void)enableSegmentOption:(bool)enable{
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enableSegmentOption:enable];
}
-(void)enableStopControls:(bool)enable mode:(bool)mode{
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] enableStopControls:enable mode:mode];
}

-(void)hideRangeComment{
     [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] hideRangeComment];
}
-(void)renderAnnotationComment:(CGFloat)time{
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] renderAnnotationComment:time];
}

-(void)updatedProgressValue:(CGFloat)seconds{
        [(PlayerControlsControllerBase *)[self.playerControlsContainer getCurrentController] updatedProgressValue:seconds];
}
-(void)renderRangeComment:(CGFloat)timeCodeIn timeCodeEnd:(CGFloat)timeCodeEnd{
     [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] renderRangeComment:timeCodeIn timeCodeEnd:timeCodeEnd];
}
-(void)resetPlayerSpeed:(CGFloat)speed{
    [(PlayerControlsControllerBase*)[self.playerControlsContainer getCurrentController] resetPlayerSpeed:speed];
}

-(void)selectPlayButton:(bool)select{
     [(PlayerControlsControllerBase *)[self.playerControlsContainer getCurrentController] selectPlayButton:select];
}

-(void)loadPlaylistItemAtIndex:(NSInteger)index
{
    if(index >= [self.config.itemArray count]) {
        return;
    }
    
    PlayerItem *item = self.config.itemArray[index];
    
    [_titleLbl setText:[item name]];
  
    [self.offScreenPlayer initWithURLString:[item mediaURL] andDelegate:self];
    [self.offScreenPlayer setFramesPerSecond:item.frameRate];
    
    if (IS_IPHONE && self.config.itemType == Playlist)
    {
        NSString *totalDuration = [NSString stringWithFormat:@"/ %@", [PlayerUtilities getTimeCodeFromSeconds:[[item duration] floatValue] + item.som forFrameRate:[[self getActivePlayer] getFrameRate] isDF:_isDropFrame doFrameCount:YES]];
        [_timeCodeOutLbl setText:totalDuration];
    }
}

-(void)setOffScreenPlayerUrl:(NSString*)url frameRate:(CGFloat)frameRate
{
   
     [self.offScreenPlayer initWithURLString:url andDelegate:self];
     [self.offScreenPlayer setFramesPerSecond:frameRate];
}

-(CGFloat)getProgressValue
{
    CGFloat currentTime = [(PlayerControlsControllerBase *)[self.playerControlsContainer getCurrentController] getProgressValue];
    return currentTime;
}


-(void)hideSegments:(BOOL)isHideSegments withHideProgressBar:(BOOL)isHideProgressBar {
    [(ReviewPlayerControlsController *)[self.playerControlsContainer getCurrentController] hideSegments:YES withHideProgressBar:YES];
}


-(NSString *)getTimeCodeInTxt{
    return ((PlayerControlsControllerBase *)[self.playerControlsContainer getCurrentController]).timeCodeInLbl.text;
}

-(CMTime)getPlayerDuration {
    return [[self getActivePlayer] getDuration];
}

-(void)setUpGestureHandler
{
    self.gestureHandler                             = [[GestureHandler alloc] initWithController:self];
    self.gestureHandler.playerControlsView          = [self controlsView];
    self.gestureHandler.playerContainerView         = [self playerContainerView];
    self.gestureHandler.playerContainerSuperView    = [self playerContainerSuperView];
    self.gestureHandler.playerHeaderView            = [self headerView];
   
    [self.gestureHandler addPlayerGesture];
}

-(void)setUpConstraintsHandler
{
    self.constraintsHandler                             = [[ConstraintsHandler alloc]init];
    self.constraintsHandler.waterMarkHolderView         = self.waterMarkHolderView;
    self.constraintsHandler.playerContainerView         = self.playerContainerView;
    self.constraintsHandler.playerContainerSuperView    = self.playerContainerSuperView;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueId   =   [segue identifier];
    if([segueId isEqualToString:PLAYER_CONTROLS_CONTAINER_SEGUE])
    {
        self.playerControlsContainer = (PlayerControlsContainer*)[segue destinationViewController];
        [self.playerControlsContainer setDelegate:self];
    }
}



@end
