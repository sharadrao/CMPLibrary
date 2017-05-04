//
//  CMPlayerController.h
//  CM Library
//
//  Created by Saravana Kumar on 11/24/15.
//  Copyright © 2015 Prime Focus Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLayerView.h"
#import "SubtitleItemView.h"

#import "PlayerItem.h"
#import "PlayerConfig.h"
#import "CustomPlayerDelegate.h"

#import "PlayerControlsContainer.h"
#import "PlayerControlsControllerBase.h"
#import "PlayerSettingsPopupViewController.h"


#define ON_SCREEN_PLAYER    1
#define OFF_SCREEN_PLAYER   0

@interface CustomPlayerController : UIViewController

#pragma mark - Player Configuration
@property(nonatomic, assign) PlayerState                                        playerState;
@property(nonatomic, strong) PlayerConfig                                       *config;
@property(nonatomic, strong) NSNumber                                           *playbackPosition;
@property(nonatomic, strong) NSString                                           *streamDecryptionKey;

#pragma mark - Player Delegate
@property(nonatomic, weak)  id<CustomPlayerDelegate>                            delegate;

#pragma mark -  Player Features
@property(nonatomic, assign) BOOL                                               isFullscreen;
@property(nonatomic, assign) CGFloat                                            lastPlaybackTime;

@property(nonatomic, strong, readonly)  PlayerItem                              *selectedItem;
@property(nonatomic, assign, readonly)  NSInteger                               selectedItemIndex;


#pragma mark - Player Item Intialisation Methods
-(void)setPlayerItems:(NSArray*)playerIitems;
-(void)playItemAtIndex:(NSInteger)index;

#pragma mark - Player Essence Functionality
-(void)seekToTime:(CGFloat)time withAutoPlay:(BOOL)autoPlay;

#pragma mark - Player Playback Methods
-(void)play;
-(void)pausePlayers;
-(void)stopPlayers;
-(void)setIsFullScreen:(BOOL)isFullscreen;
-(void)setLastPlaybackTime:(CGFloat)lastPlaybackTime;

-(void)showProgressIndicator;
-(void)hideProgressIndicator;

#pragma mark - Player Playback Time Methods
-(CMTime)getItemDuration;

#pragma mark - Watermark Methods
-(void)setWatermark:(WaterMarkModel*)watermodel;

#pragma mark - Player UI Updates
-(void)showHeaderAndControlsView;
-(void)hideHeaderAndControlsView;

@end
