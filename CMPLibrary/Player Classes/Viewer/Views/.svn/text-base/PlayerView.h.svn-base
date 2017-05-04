//
//  CBCAVPlayer.h
//  ClearBCProduct
//
//  Created by Bishwajit on 7/25/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CoreMedia/CMTime.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "Bitrate.h"
#import "PlayerTrack.h"

@interface PlayerView : UIView

@property (nonatomic, assign)   CMTime      currentSomTime;
@property (nonatomic, assign)   CGFloat     framesPerSecond;
@property (nonatomic, assign)   NSInteger   liveDuration;
@property (nonatomic, assign)   BOOL        isLiveAsset;
@property (nonatomic,strong)    NSString    *streamDectrypterKey;

- (void)initWithURLString:(NSString*)urlString andDelegate:(id)delegate;
- (void)initWithURLList:(NSArray*)urlList andDelegate:(id)delegate;

- (CGFloat)durationInSeconds;
- (CGFloat)currentPosInSeconds;
- (CGFloat)getPlayerVolume;
- (CGFloat)getPlayerRate;
- (BOOL)isFastOrReversePlayback;
- (BOOL)isSeeking;

- (void)stepFrame:(BOOL)next;
- (void)stepBySeconds:(NSInteger)tag;

- (void)setPlaybackRate:(float)rateVal;
- (void)setPlayerVolume:(CGFloat)volume;
- (void)setFrameRateForVideo:(Float64)frames;

- (void)play:(id)sender;
- (void)pause:(id)sender;
- (void)replaceCurrentItem:(NSString*)urlString;
- (void)reloadItems:(NSArray*)items;
- (void)advanceNextItem;

- (void)seekToTimeCode:(NSString *)timeCode completionHandler:(void (^)(BOOL success))completionHandler;
- (void)seekToCMTime:(CMTime)seekTime completionHandler:(void (^)(BOOL success))completionHandler;
- (void)seekToLastPlaybackTimeCode:(CGFloat)timeCode completionHandler:(void (^)(BOOL success))completionHandler;

- (NSString*)getCurrentTimeWithFramePrecision;
- (CMTime)getDuration;
- (CMTime)getSOM;
- (Float64)getFrameRate;

- (BOOL)isMediaInitialized;
- (BOOL)isUrlLiveStreaming:(NSURL*)URL;
- (BOOL)isPlaying;
- (void)setLiveAsset:(BOOL)isLive;

- (CMTime)getCurrentTime;
- (int64_t)getCurrentTimeInTicks;

- (void)cleanup;
- (void)scrub:(float)progressValue completionHandler:(void (^)(BOOL))completionHandler;
- (CGFloat)getCurrentTimeInseconds;
- (CMTime)getCurrentTimeWithTime;

- (NSArray*)getAudioTracks;
- (NSString*)getCurrentAudioTrackName;
- (NSString*)getCurrentURLFromPlayer;
- (NSString*)getCurrentURLFromDataSource;
- (NSString*)getCurrentBitRate;
- (void)switchBitrate:(Bitrate *)track;
- (void)switchAudioTrack:(PlayerTrack *)track;
- (AVPlayerLayer *)playerLayer;

//For SubTitles
- (NSArray *)getSubTitles;
- (void)switchSubtitle:(PlayerTrack*)subtitle;
- (NSString *)getCurrentSubtitleName;

@end
