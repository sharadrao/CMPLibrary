//
//  PlayerControlsDelegate.h
//  ClearBC
//
//  Created by Deep Arora on 3/7/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//


//Need to separate datasource and delegate

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@protocol PlayerControlsDelegate <NSObject>

//Delgate Event Triger for initialising the Start Time (TCin) for Segment
-(void)willPressRangeMarkInBtn;

//Delgate Event Triger for de initialising the Segment Start Time
-(void)didPressRangeMarkInBtn;

//Delgate Event Triger when Mark Out button is pressed to create the segment with Start Time and End Time
-(void)didPressRangerMarkOutBtn;

//Delgate Event Triger to perform the Point break of Segment as Start and End Time as Same
-(void)didPressPointMarkBtn;

//Delgate Event Triger when performing Play/Pause Action
-(void)didPressPlayPauseBtnInControlView:(UIView*)controlView;

//Delgate Event Triger when performing Stop Action
-(void)didPressStopBtnInControlView:(UIView*)controlView;

//Delgate Event Triger when performing Step Frame Action
-(void)didPressStepFrameBtnInControlView:(UIView*)controlView;

//Delgate Event Triger when performing Step Second Action
-(void)didPresseStepSecondBtnInControlView:(UIView*)controlView;

//Delegate Event Triger when progress bar is draged
-(void)didBeginDragActionWithProgress;

//Delegate Event Triger when Progress bar end the tracking
-(void)didSeekToTime:(CGFloat)progress;

//Delegate Event Triger when performed the Farward/Rewind Playback
-(void)didChangePlayerSpeed:(CGFloat)speed inControlView:(UIView*)controlView;

//Delegate Event Triger when performed action on Fullscreen button
-(void)didPressFullScreenBtnInControlView:(UIView*)controlView;

//Delegate Event Triger when performed action on player setting button
-(void)didPressSettingsBtn:(BOOL)isEnable inControlView:(UIView*)controlView;

//Delegate Event Triger when performed action on player help button
-(void)didPressHelpBtn:(BOOL)willShowHelpView InControlView:(UIView*)contrololView;









-(NSInteger)getPlayertype;
-(NSInteger)getPreviewType;
-(id)getSelectedAsset;


//-(void)playAction:(BOOL)isPlay;
//-(void)dragActionBegan;
//
//-(void)pausePlayers;
//-(void)stopPlayers;
//-(void)playFromSeekedTime:(CGFloat)seekedTime;

//-(void)stepFrameActionHandler:(NSInteger)isNext;
//-(void)nextPrevSecondActionHandler:(NSInteger)isNext;

//-(void)adjustPlayerSpeed:(CGFloat)speed;
-(void)reelPlayActionHandler;
-(void)listSegments;
-(void)editClips:(BOOL)enable;
-(void)changePlaylistClip:(int)clipIndex;

//-(void)initSegment;
//-(void)createSegment;
//-(void)cancelSegment;
//-(void)pointSegment;
-(void)trackingProgressValue:(CGFloat)progress;
//-(void)fullScreenAction:(UIButton*)sender;
//-(void)landScapeWaterMarkPosition;
//-(void)showSettingsView:(BOOL)isShow;
//-(void)showHelpScreen:(BOOL)isShow;
//-(void)showPlayerInFullScreen;
-(void)cancelTimerAndReinitiate:(BOOL)shouldReinitiate;


@end
