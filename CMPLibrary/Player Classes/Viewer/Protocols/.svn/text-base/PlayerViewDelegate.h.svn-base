//
//  PlayerViewDelegate.h
//  ClearBC
//
//  Created by Deep Arora on 3/7/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerTrack.h"

@protocol PlayerViewDelegate <NSObject>



@optional

- (void)playerInitialised:(NSInteger)player;
- (void)playerDidPause:(NSInteger)player;
- (void)playerDidResumePlay:(NSInteger)player;
- (void)playerDidEndClip:(NSInteger)player;
- (void)playerTimeUpdate:(NSInteger)player time:(CMTime)time;
- (void)playerTimeUpdate:(NSInteger)player time:(CMTime)time withFrameRate:(Float64)frameRate;
- (void)updatePlayerTime:(CGFloat)time player:(NSInteger)player withFrameRate:(Float64)frameRate;


- (void)bitrateSwiched;
- (void)audioTrackSwitched;
- (void)subtitleSwitched;
- (void)subtitleSwitchedWithError;
- (void)videoPlayerDidFinishPlayback:(id)sender;


- (void)playPauseButtonSyncRequired:(id) sender;
- (void)videoPlayConfirmationRequired:(id) sender;
- (void)scrubberSyncRequired:(CMTime) time;
- (void)disableVideoControls:(id) sender;
- (void)enableVideoControls:(id) sender;
- (void)updatingSpeedrateLabel:(float)rateValue;

- (void)subtitleloadingWithObject:(PlayerTrack *)track;

-(NSString*)getCurrentTimeCode;

-(CGFloat)getFrameRate:(NSInteger)player;
-(CMTime)checkAndGetValidStartClipTime:(CMTime)time;

// story teller delegates CMStoryTellerdelegates

- (void)playerInitializationFailed:(NSInteger)player;
- (void)playerInitializationStatusUnknown:(NSInteger)player;
- (void)playerTimeUpdate:(NSInteger)player time:(CMTime)time currentItemIndex:(NSInteger)index;
- (void)playerDidEndClipAtIndex:(NSInteger)index;
- (void)playerDidEndClip:(NSInteger)player currentItemIndex:(NSInteger)index;
- (void)playerDidEndPlayNotification;
- (void)isLiveAssetGrowingProxy:(BOOL)isActualLive;


@end
