 //
//  CBCAVPlayer.m
//  ClearBCProduct
//
//  Created by Bishwajit on 7/25/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import "PlayerView.h"

#import "PlayerProductConstants.h"
#import "PlayerAPI.h"

#import "NSData+MD5.h"
#import "PlayerUtilities.h"
#import "Base64.h"
#import "PlayerCache.h"
#import "NSString+MD5.h"
#import "PlayerViewDelegate.h"

#define BUFFER_RESUME       5.0f
#define CUSTOM_SCHEME       @"cspum3u8"


#define TIME_OUT_INTERVAL_REQUEST       300.0f
#define TIME_OUT_INTERVAL_RESOURCE      60.0f


// Contexts for KVO
static void *kAirplayKVO                = &kAirplayKVO;
static void *kBufferEmptyKVO            = &kBufferEmptyKVO;
static void *kStatusDidChangeKVO        = &kStatusDidChangeKVO;
static void *kTimeRangesKVO             = &kTimeRangesKVO;
static void *kBufferKeepupKVO           = &kBufferKeepupKVO;
static void *kRateDidChangeKVO          = &kRateDidChangeKVO;


@interface PlayerView() <AVAssetResourceLoaderDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <PlayerViewDelegate> delegate;

@property (nonatomic, assign)   CMTime              duration;
@property (nonatomic, assign)   Float64             framerateFractionValue;
@property (nonatomic, assign)   CGFloat             playSpeedRate;
@property (nonatomic, assign)   CMTime              lastPlayTime;

@property (nonatomic, assign)   BOOL                isBitRateSwitched;
@property (nonatomic, assign)   BOOL                isPlayerInitialized;
@property (nonatomic, assign)   BOOL                isKeyColonAvailable;
@property (nonatomic, assign)   BOOL                isSeeking;

@property (nonatomic, strong)   AVPlayerLayer       *playerLayer;
@property (nonatomic, strong)   AVQueuePlayer       *player;
@property (nonatomic, strong)   id                  playerTimeObserver;
@property (nonatomic, strong)   NSString            *curBitrate;
@property (nonatomic, strong)   NSString            *curAudioTrack;
@property (nonatomic, strong)   NSString            *currentSubTitle;
@property (nonatomic, strong)   NSMutableArray      *videos;
@property (nonatomic, strong)   NSArray             *availableAudioTracks;
@property (nonatomic, strong)   AVURLAsset          *lastSubtitleAsset;

@end


@implementation PlayerView

@dynamic player;
@dynamic playerLayer;
@dynamic duration;


#pragma mark - private methods
-(void)setup
{
    [self.playerLayer setOpacity:1.0];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [self.playerLayer setNeedsDisplayOnBoundsChange:YES];
    [self.layer setNeedsDisplayOnBoundsChange:YES];

    _framerateFractionValue = 0.2f;
    _playSpeedRate = 1.0f;
    
    self.player = [[AVQueuePlayer alloc] init];
    self.player.closedCaptionDisplayEnabled = YES;
}

- (void)addObservers
{
    //remove all old observers
    [self removeObservers];
    
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:kRateDidChangeKVO];
    [self.player addObserver:self forKeyPath:@"currentItem.playbackBufferEmpty"         options:NSKeyValueObservingOptionNew context:kBufferEmptyKVO];
    [self.player addObserver:self forKeyPath:@"airPlayVideoActive"                      options:NSKeyValueObservingOptionNew context:kAirplayKVO];
    [self.player addObserver:self forKeyPath:@"currentItem.status"                      options:NSKeyValueObservingOptionNew context:kStatusDidChangeKVO];
    [self.player addObserver:self forKeyPath:@"currentItem.loadedTimeRanges"            options:NSKeyValueObservingOptionNew context:kTimeRangesKVO];
    [self.player addObserver:self forKeyPath:@"currentItem.playbackLikelyToKeepUp"      options:NSKeyValueObservingOptionNew context:kBufferKeepupKVO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidEndPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessLogEntry:) name:AVPlayerItemNewAccessLogEntryNotification object:nil];
}

-(void)removeObservers
{
    @try
    {
        [self.player removeObserver:self forKeyPath:@"currentItem.playbackBufferEmpty"      context:kBufferEmptyKVO];
        [self.player removeObserver:self forKeyPath:@"airPlayVideoActive"                   context:kAirplayKVO];
        [self.player removeObserver:self forKeyPath:@"currentItem.status"                   context:kStatusDidChangeKVO];
        [self.player removeObserver:self forKeyPath:@"currentItem.loadedTimeRanges"         context:kTimeRangesKVO];
        [self.player removeObserver:self forKeyPath:@"currentItem.playbackLikelyToKeepUp"   context:kBufferKeepupKVO];
        [self.player removeObserver:self forKeyPath:@"rate"   context:kRateDidChangeKVO];

        if (_playerTimeObserver) {
            [self.player removeTimeObserver:self.playerTimeObserver];
        }
    }
    @catch (NSException *exception) {
        
    }

    [PlayerCache removeCacheSubDirectory:@"cache_m3u8"];
    
    _playerTimeObserver = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemNewAccessLogEntryNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playerTimeUpdate
{
    if([[self delegate] respondsToSelector:@selector(playerTimeUpdate:time:)])
    {
        CMTime curTime = self.player.currentTime;

        if([[self delegate] respondsToSelector:@selector(playerTimeUpdate:time:withFrameRate:)]) {
            [[self delegate] playerTimeUpdate:self.tag time:curTime withFrameRate:_framesPerSecond];
        }
    }
}

#pragma mark - Self methods
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

+ (void)initialize
{
    if (self == [PlayerView class]) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self setup];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObservers];
    
    self.player                 = nil;
    _playerTimeObserver         = nil;
    _curBitrate                 = nil;
    _curAudioTrack              = nil;
    _currentSubTitle            = nil;
    _videos                     = nil;
    _availableAudioTracks       = nil;
    _lastSubtitleAsset          = nil;
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVQueuePlayer *)player
{
    [(AVPlayerLayer *) [self layer] setPlayer:player];
    
    // Optimize for airplay if possible
    if ([player respondsToSelector:@selector(allowsAirPlayVideo)])
    {
        [player setAllowsExternalPlayback:NO];
        [player setUsesExternalPlaybackWhileExternalScreenIsActive:NO];
    }
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)[self layer];
}


#pragma mark - public methods
-(void)initWithURLString:(NSString*)urlString andDelegate:(id)delegate
{
    if (!urlString) {
        urlString = @"";
    }
    
    [self initWithURLList:@[urlString] andDelegate:delegate];
}

-(void)initWithURLList:(NSArray *)urlList andDelegate:(id)delegate
{
    _curBitrate                     = @"Auto:0";
    _delegate                       = delegate;
    _availableAudioTracks           = nil;
    _framesPerSecond                = 0.0f;
    [self setPlaybackRate:1.0f];
    
    [self addObservers];
    
    [self reloadItems:urlList];
}

#pragma mark - time handlers
- (CMTime)duration
{
    // Pefered in HTTP Live Streaming.
    if ([self.player.currentItem respondsToSelector:@selector(duration)])
    {
        if (CMTIME_IS_VALID(self.player.currentItem.duration)) {
            return self.player.currentItem.duration;
        }
    }
    else if (CMTIME_IS_VALID(self.player.currentItem.asset.duration)) {
        return self.player.currentItem.asset.duration;
    }
    
    return kCMTimeInvalid;
}

/*
- (CGFloat)durationInSeconds
{
    CMTime time = [self duration];
    if(!CMTIME_IS_VALID(time)) {
        return 0.0f;
    }
    
    return (CGFloat)time.value / (CGFloat)time.timescale;
}
*/

-(void)setLiveAsset:(BOOL)isLive {
     self.isLiveAsset = isLive;
}

- (CGFloat)durationInSeconds
{
    //If asset is live, read the live duration...
    if (self.isLiveAsset) {
        return  [self getLiveAssetDuration];
    }
    
    CMTime time = [self duration];
    if(!CMTIME_IS_VALID(time)) {
        return 0.0f;
    }
    
    return (CGFloat)time.value / (CGFloat)time.timescale;
}


//Determine the total duration for nonlive Asset. For live pass the current time as the max value for slider...
-(NSInteger) getLiveAssetDuration
{
    NSInteger actualDuration = ceilf(CMTimeGetSeconds(self.duration));
    NSInteger actualSeconds = ceilf(CMTimeGetSeconds(self.player.currentItem.currentTime));
    
    if (_liveDuration<actualSeconds)
    {
        _liveDuration= actualSeconds;
        return actualSeconds;
    }
    else {
        return _liveDuration;
    }
    
    return actualDuration;
}

-(CGFloat)currentPosInSeconds
{
    CMTime currentTime = self.player.currentItem.currentTime;
    CGFloat curPos = CMTimeGetSeconds(currentTime);
    
    return curPos;
}

#pragma mark - volume handlers
-(void)setPlayerVolume:(CGFloat)volume {
    [self.player setVolume:volume];
}

-(CGFloat)getPlayerVolume {
    return [self.player volume];
}

-(CGFloat)getPlayerRate {
    return self.player.rate;
}

-(BOOL)isFastOrReversePlayback {
    return (self.player.rate > 1 || self.player.rate < 0);
}

- (BOOL)isSeeking {
    return _isSeeking;
}


#pragma mark - playback handlers
-(void)play:(id)sender
{
    if (self.player.rate !=_playSpeedRate) {
        [self.player setRate:_playSpeedRate];
    }
}

-(void)pause:(id)sender
{
    if (self.player.rate == 0) {
        return;
    }
    
    [self.player pause];
}

-(void)replaceCurrentItem:(NSString*)urlString {
    [self reloadItems:@[urlString]];
}

-(void)reloadCurrentItem
{
    AVURLAsset *oldAsset = (AVURLAsset*)[[self.player currentItem] asset];
    
    NSMutableDictionary  *headers = [NSMutableDictionary dictionary];
    [headers setObject:@"iPad" forKey:@"User-Agent"];

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:oldAsset.URL options:@{@"AVURLAssetHTTPHeaderFieldsKey" : headers}];
    AVAssetResourceLoader *resourceLoader = asset.resourceLoader;
    [resourceLoader setDelegate:self queue:dispatch_queue_create("PlayerViewAsset loader", nil)];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
    
    [self addObservers];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
}

-(void)reloadItems:(NSArray*)items
{
    _isPlayerInitialized    = NO;
    _videos                 = [items mutableCopy];
    
    [self.player pause];
    [self.player removeAllItems];
    
    for (NSString *urlString in items)
    {
        NSString *urlStr = urlString;
        
        
        if(([urlStr rangeOfString:@".m3u8"].location != NSNotFound) && ([urlStr rangeOfString:@"isml"].location == NSNotFound)) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"http" withString:CUSTOM_SCHEME];
        }                
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        DLog(@"queue player URLS %@", url);
        
        NSMutableDictionary  *headers = [NSMutableDictionary dictionary];
        [headers setObject:@"iPad" forKey:@"User-Agent"];
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:@{@"AVURLAssetHTTPHeaderFieldsKey" : headers}];
   
        AVAssetResourceLoader *resourceLoader = asset.resourceLoader;
        [resourceLoader setDelegate:self queue:dispatch_queue_create("PlayerViewAsset loader", nil)];
        
        AVPlayerItem *playerItem =  [[AVPlayerItem alloc] initWithAsset:asset];
        [playerItem setPreferredPeakBitRate:800000];
        if([self.player canInsertItem:playerItem afterItem:nil]) {
            [self.player insertItem:playerItem afterItem:nil];
        }
    }
}

-(void)advanceNextItem
{
    [self.player advanceToNextItem];
    [self frameRateFromAVPlayer];
}

- (BOOL)isPlaying
{
    if ((self.player.rate != 0) && (!self.player.error)) {
        return YES;
    }
    
    return NO;
}

- (void)setPlaybackRate:(float)rateVal
{
    if(rateVal != _playSpeedRate) {
        _playSpeedRate = rateVal;
    }
}

-(void)stepBySeconds:(NSInteger)next
{
    [self.player pause];
    
    CMTime currentTime      = [self.player.currentItem currentTime];
    CMTime currentTimeScale = CMTimeConvertScale(currentTime, self.framesPerSecond, kCMTimeRoundingMethod_Default);
    
    if(next) {
        currentTimeScale.value += self.framesPerSecond;
    }
    else {
        currentTimeScale.value -= self.framesPerSecond;
    }
    [self validateAndUpdateSeekTime:currentTimeScale forNext:next];
}

- (void)stepFrame:(BOOL)next
{
    [self.player pause];

    CMTime currentTime = [self.player.currentItem currentTime];
    CMTime currentTimeScale = CMTimeConvertScale(currentTime, _framesPerSecond, kCMTimeRoundingMethod_Default);
    
    if(!next) {
        --currentTimeScale.value;
    }
    else {
        ++currentTimeScale.value;
    }
    
    [self validateAndUpdateSeekTime:currentTimeScale forNext:next];
}

/**
 Validate updated time if time is vaild then seek to time. If updated time is invalid and moving to forward then send end clip notification. If updated time is invalid or -ve time and moving on backword direction then seek to start time of clip.

 @param updatedTime     Updated time after tap on Previous Frame/Second button.
 @param isNext          This will tell either moving on forward or backword direction
 */
-(void)validateAndUpdateSeekTime:(CMTime)updatedTime forNext:(BOOL)isNext
{
    if(isNext)
    {
        int32_t compare = CMTimeCompare(updatedTime, [self.player.currentItem duration]); //(-1 = If updatedTime less than player duration, 1 = greater than, 0 = equal).
        
        // If updated time is greater than or equal to player duration then send end clip notification
        if ((compare >= 0 && [_delegate respondsToSelector:@selector(videoPlayerDidFinishPlayback:)]) || (CMTIME_IS_INVALID(updatedTime))) {
                [_delegate videoPlayerDidFinishPlayback:self];
            return;
        }
    }
    else if (_delegate && [_delegate respondsToSelector:@selector(checkAndGetValidStartClipTime:)]) {
        updatedTime = [_delegate checkAndGetValidStartClipTime:updatedTime];
    }
    
    [[self.player currentItem] cancelPendingSeeks];
    [self.player seekToTime:updatedTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        [self.player pause];
    }];
}

-(void)seekToCMTime:(CMTime)seekTime completionHandler:(void (^)(BOOL success))completionHandler
{
    [[self.player currentItem] cancelPendingSeeks];
   
    if(CMTIME_IS_INVALID(seekTime) && completionHandler) {
        completionHandler(YES);
    }
    else
    {
           _isSeeking = NO;
        [self.player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished)
        {
            _isSeeking = NO;
            if(completionHandler) {
                completionHandler(finished);
            }
        }];
    }
}

- (void)seekToTimeCode:(NSString *)timeCode completionHandler:(void (^)(BOOL success))completionHandler
{
    [[self.player currentItem] cancelPendingSeeks];
    if ([timeCode isEqualToString:@""])
    {
        if(completionHandler) {
            completionHandler(YES);
        }
    }
    else
    {
        CMTime seekTime = CMTimeMakeWithSeconds([PlayerUtilities getSecondsFromTimeCode:timeCode withFrameRate:_framesPerSecond isDF:NO], NSEC_PER_SEC);
        [self seekToCMTime:seekTime completionHandler:^(BOOL success)
        {
            if(completionHandler) {
                completionHandler(success);
            }
        }];
    }
}

- (void)seekToLastPlaybackTimeCode:(CGFloat)timeCode completionHandler:(void (^)(BOOL success))completionHandler
{
    CMTime seekTime = CMTimeMakeWithSeconds(timeCode, NSEC_PER_SEC);
    [self seekToCMTime:seekTime completionHandler:^(BOOL success)
    {
         if(completionHandler) {
             completionHandler(success);
         }
    }];
}

-(CMTime)getSOM {
    return self.player.currentTime;
}

-(CMTime)getDuration {
    return self.duration;
}

-(Float64)getFrameRate {
    return _framesPerSecond;
}

- (NSString *)getCurrentTimeWithFramePrecision
{
    NSString *currentTimeInString;
    
    CMTime currentTime = [[self.player currentItem] currentTime];
    if (CMTIME_IS_VALID(currentTime))
    {
        currentTime         = [self getCurrentSomTimeWithFramePrecision:currentTime];
        currentTimeInString = [PlayerUtilities getTimeCodeFromTime:[self.player currentTime] forFrameRate:self.framesPerSecond som:0.0 isDF:NO doFrameCount:YES];
    }
    else {
        currentTimeInString = @"";
    }
    
    return currentTimeInString;
}

-(CGFloat)getCurrentTimeInseconds
{
    CMTime time = [[self.player currentItem] currentTime];
    
    CMTime currentTime25F = CMTimeConvertScale(time, self.framesPerSecond, kCMTimeRoundingMethod_Default);
    
    NSInteger currentSeconds = (NSInteger)currentTime25F.value/self.framesPerSecond;
    
    return currentSeconds;
}

-(CGFloat)frameRateFromAVPlayer
{
    CGFloat fps = 0.0f;
    
    AVPlayerItem *item = self.player.currentItem;
    for (AVPlayerItemTrack *track in item.tracks)
    {
        if ([track.assetTrack.mediaType isEqualToString:AVMediaTypeVideo]) {
            fps = track.currentVideoFrameRate;
        }
    }
    
    if (fps == 0.0f)
    {
        if (self.player.currentItem.asset)
        {
            AVAssetTrack *videoATrack = [[self.player.currentItem.asset tracksWithMediaType:AVMediaTypeVideo] lastObject];
            if(videoATrack) {
                fps = videoATrack.nominalFrameRate;
            }
        }
    }
    
    if([[self delegate] respondsToSelector:@selector(getFrameRate:)])
    {
        fps = [[self delegate] getFrameRate:self.tag];
        if (fps != 0.0) {
            return fps;
        }
    }
    
    if (fps == 0.0f) {
        fps = 25.0f;
    }
    
    return fps;
}

#pragma mark Player settings methods
-(void)setFrameRateForVideo:(Float64)frames {
    _framesPerSecond = frames;
}

-(CMTime)getCurrentSomTimeWithFramePrecision:(CMTime)presentTime
{
    CMTime frameTime = CMTimeAdd(_currentSomTime, presentTime);
    return frameTime;
}

-(void)addPeriodicTimer
{
    if (!_playerTimeObserver)
    {
        Float64 frame = 1.0f/_framesPerSecond;
    
        __unsafe_unretained PlayerView *weakSelf = self;
        _playerTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(frame, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            [weakSelf playerTimeUpdate];
        }];
    }
}

#pragma mark Player observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItemStatus status = self.player.currentItem.status;
    
    if(context == kStatusDidChangeKVO)
    {
        if(status == AVPlayerItemStatusReadyToPlay)
        {
            if (!_framesPerSecond)
            {
                _framesPerSecond = [self frameRateFromAVPlayer];
            }
            
            if(!_isPlayerInitialized)
            {
                if([[self delegate] respondsToSelector:@selector(playerInitialised:)]) {
                    [[self delegate] playerInitialised:self.tag];
                }
                                
                [self setDefaultAudioTrack];
                [self addPeriodicTimer];
                _isPlayerInitialized = YES;
            }
            else
            {
                if(_isBitRateSwitched)
                {
                    [self seekToCMTime:_lastPlayTime completionHandler:^(BOOL success)
                     {
                         [self removeObservers];
                         _isBitRateSwitched = NO;
                         _lastPlayTime = kCMTimeInvalid;
                         [self addObservers];
                         [self addPeriodicTimer];
                     }];
                }
            }
        }
        else if (status == AVPlayerItemStatusFailed)
        {
            [self removeObservers];
            DLog(@"Player Failed :%@",self.player.error.description);
            DLog(@"Player Item Failed :%@",self.player.currentItem.error.description);
            DLog(@"Player Item Error:%@",self.player.currentItem.errorLog);
            DLog(@"Player Item Error:%@",self.player.currentItem.error);
            DLog(@"Player Item Debug Failed :%@",self.player.currentItem.error.debugDescription);
            
            if([[self delegate] respondsToSelector:@selector(playerInitializationFailed:)]) {
                [[self delegate] playerInitializationFailed:self.tag];
            }
            
            /*if(!_isRetrying)
            {
                _isRetrying = YES;
                [self reloadCurrentItem];
            } */
        }
    }
    else if(context == kBufferEmptyKVO)
    {
        if([self.player.currentItem isPlaybackBufferEmpty])
        {
            if([[self delegate] respondsToSelector:@selector(playerDidPause:)]) {
                [[self delegate] playerDidPause:self.tag];
            }
        }
    }
    else if(context == kBufferKeepupKVO)
    {
        if([self.player.currentItem isPlaybackLikelyToKeepUp])
        {
            if([[self delegate] respondsToSelector:@selector(playerDidResumePlay:)] )  {
                [[self delegate] playerDidResumePlay:self.tag];
            }
        }
    }
    else if(context == kTimeRangesKVO)
    {
        NSArray *timeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
        
        if ((![timeRanges isKindOfClass:[NSNull class]]) && [timeRanges count])
        {
            CMTimeRange timerange   = [[timeRanges objectAtIndex:0] CMTimeRangeValue];
            
            CGFloat smartValue = CMTimeGetSeconds(CMTimeAdd(timerange.start, timerange.duration));
            CGFloat duration   = CMTimeGetSeconds(self.player.currentTime);
            if(((smartValue - duration) > BUFFER_RESUME) || smartValue == duration)
            {
                if(!_isSeeking && [self.player.currentItem isPlaybackLikelyToKeepUp] && [[self delegate] respondsToSelector:@selector(playerDidResumePlay:)] )  {
                    [[self delegate] playerDidResumePlay:self.tag];
                }
            }
        }
    }
    else if (kRateDidChangeKVO == context) {
    }
    else {
    }
}

#pragma mark - Properties
- (void)cleanup
{
    [self removeObservers];
    
    [self.player pause];
    _playSpeedRate = 1.0;
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    NSArray *items = [self.player items];
    for (AVPlayerItem *item in items) {
        [(AVURLAsset*)[item asset] cancelLoading];
    }
    
    [self.player removeAllItems];
    [_videos removeAllObjects];
    
    _delegate = nil;
}

- (int64_t)getCurrentTimeInTicks
{
    CMTime tempTime = [self getCurrentSomTimeWithFramePrecision:[self.player.currentItem currentTime]];
    
    Float64 tempTime_value_float = (Float64) tempTime.value;
    
    Float64 temp_float = (tempTime_value_float / tempTime.timescale);
    
    int64_t temp_int = temp_float * self.framesPerSecond;
    
    return temp_int;
}

- (BOOL)isMediaInitialized
{
    if (_isPlayerInitialized && CMTIME_IS_VALID(self.player.currentTime) && CMTIME_IS_VALID(self.duration)) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isUrlLiveStreaming: (NSURL *) URL
{
    BOOL flag = YES;
    
    NSString *URLinString = [URL absoluteString];
    if ([URLinString rangeOfString:M3U8 options:NSCaseInsensitiveSearch].location == NSNotFound) {
        flag = NO;
    }
    
    return flag;
}

- (void)scrub:(float)progressValue completionHandler:(void (^)(BOOL))completionHandler
{
    CMTime seekBarTime = CMTimeMake(progressValue, self.framesPerSecond);
    
    if (CMTIME_COMPARE_INLINE(seekBarTime, <=, self.duration))
    {
        [self.player seekToTime:CMTimeMakeWithSeconds(progressValue, self.framesPerSecond) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            if (finished) {
                completionHandler(finished);
            }
        }];
    }
}

- (CMTime)getCurrentTime {
    return [self.player.currentItem currentTime];
}

- (CMTime)getCurrentTimeWithTime {
    return [self.player.currentItem currentTime];
}

#pragma mark - AVAssetResourceLoader delegate methods
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    NSString *scheme = [[loadingRequest.request URL] scheme];
    
    if([scheme rangeOfString:CUSTOM_SCHEME].location != NSNotFound)
    {
        NSString *customUrl   = [[loadingRequest.request URL] absoluteString];
        NSString *urlString   = [customUrl stringByReplacingOccurrencesOfString:CUSTOM_SCHEME withString:@"http"];
        NSString *playlistUrl = [[NSURL URLWithString:urlString] absoluteString];
                
        [PlayerAPI asyncDataDownload:playlistUrl withProgressHandler:nil andCompletionHandler:^(NSData *response, NSUInteger errorCode)
        {
            if(errorCode == TRACE_CODE_SUCCESS)
            {
                if([playlistUrl rangeOfString:@".ckf"].location != NSNotFound)
                {
                    NSString *strKey        = self.streamDectrypterKey;
                    NSData *decryptedKey    = [response decryptDataWithKey:strKey mode:YES];
                    
                    [loadingRequest.dataRequest respondWithData:decryptedKey];
                    [loadingRequest finishLoading];
                }
                else
                {
                    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:playlistUrl] resolvingAgainstBaseURL:NO];
                    urlComponents.query = nil;
                    NSString *baseURL = [[[urlComponents URL] URLByDeletingLastPathComponent] absoluteString];
                    
                    NSString *m3u8Str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                    if([m3u8Str rangeOfString:@".m3u8"].location != NSNotFound)
                    {
                        NSString *subReplace = @"(\"[a-z0-9/:=~._-]*(\\.m3u8))";
                      //  NSString *subReplace = @"([a-z0-9/:=~._-]*(\\.ts|\\.webvtt|\\.vtt))";
                        NSError *error = NULL;
                        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:subReplace options:NSRegularExpressionCaseInsensitive error:&error];
                        m3u8Str = [regex stringByReplacingMatchesInString:m3u8Str options:0 range:NSMakeRange(0, [m3u8Str length]) withTemplate:[NSString stringWithFormat:@"\"%@^$1", baseURL]];
                        m3u8Str = [m3u8Str stringByReplacingOccurrencesOfString:@"^\"" withString:@""];
                       // m3u8Str = [m3u8Str stringByReplacingOccurrencesOfString:@"^" withString:@""];
                        
                        [PlayerCache setObject:[m3u8Str dataUsingEncoding:NSUTF8StringEncoding] forKey:[playlistUrl MD5] withNewPath:@"cache_m3u8"];
                    }
                    else
                    {
                        NSString *tsReplace = @"([a-z0-9/:~._-]*(\\.ts))";
                        if([m3u8Str rangeOfString:@"http"].location == NSNotFound)
                        {
                            NSError *error = NULL;
                            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:tsReplace options:NSRegularExpressionCaseInsensitive error:&error];
                            m3u8Str = [regex stringByReplacingMatchesInString:m3u8Str options:0 range:NSMakeRange(0, [m3u8Str length]) withTemplate:[NSString stringWithFormat:@"%@$1", baseURL]];
                        
                            if([m3u8Str rangeOfString:@"key"].location == NSNotFound)
                            {
                                NSString *ckfReplace = @"([a-z0-9/:~._-]*\\.ckf)";
                                urlComponents.scheme = [[urlComponents scheme] stringByReplacingOccurrencesOfString:@"http" withString: CUSTOM_SCHEME];
                                regex = [NSRegularExpression regularExpressionWithPattern:ckfReplace options:NSRegularExpressionCaseInsensitive error:&error];
                                baseURL = [[[urlComponents URL] URLByDeletingLastPathComponent] absoluteString];
                                m3u8Str = [regex stringByReplacingMatchesInString:m3u8Str options:0 range:NSMakeRange(0, [m3u8Str length]) withTemplate:[NSString stringWithFormat:@"%@$1", baseURL]];
                            }
                            else {
                                m3u8Str = [m3u8Str stringByReplacingOccurrencesOfString:@"key" withString:CUSTOM_SCHEME];
                            }
                        }
                        else {
                            m3u8Str = [m3u8Str stringByReplacingOccurrencesOfString:@"key" withString:CUSTOM_SCHEME];
                        }
                    }
                    
                    // For Live Asset Check for ENDLIST flag
                    if ([self.delegate respondsToSelector:@selector(isLiveAssetGrowingProxy:)])
                    {
                        if([m3u8Str rangeOfString:@"EXT-X-ENDLIST"].location != NSNotFound) {
                            [_delegate isLiveAssetGrowingProxy:NO];
                        }
                    }

                    
                    DLog(@"m3u8 string %@", m3u8Str);
                    
                    [loadingRequest.dataRequest respondWithData:[m3u8Str dataUsingEncoding:NSUTF8StringEncoding]];
                    [loadingRequest finishLoading];
                }
            }
            else {
                DLog(@"error in key response  %@", response);
            }
        }];
        
        return YES;
    }
    
    return NO;
}

//-(void)startAsyncDownload:(NSString*)urlString progress:(ProgressHandler)progHandler finished:(CompletionHandler)compHandler
//{
////    if ([urlString rangeOfString:@"127.0.0.1:8080"].location == NSNotFound)
////    {
////        if(![Reachability isReachable])
////        {
////            compHandler(nil, TRACE_CODE_NETWORK_NOT_AVAILABLE);
////            return;
////        }
////    }
////    
//    //_progressHandler = progHandler;
//    
//    NSURLSessionConfiguration *sessionConfig    = [NSURLSessionConfiguration defaultSessionConfiguration];
//    sessionConfig.timeoutIntervalForRequest     = TIME_OUT_INTERVAL_REQUEST;
//    sessionConfig.timeoutIntervalForResource    = TIME_OUT_INTERVAL_RESOURCE;
//    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT_INTERVAL_REQUEST];
//    [request setValue:@"iPad" forHTTPHeaderField:@"User-Agent"];
//    
//    NSURLSessionTask   *sessionTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
//                    {
//                        if(error) {
//                            compHandler(error, TRACE_CODE_NETWORK_ERROR);
//                        }
//                        else
//                        {
//                            NSData *data = [NSData dataWithContentsOfURL:location];
//                            compHandler(data, TRACE_CODE_SUCCESS);
//                        }
//                        
//                       // [[CMSessionManager sharedInstance] doLockLockTime:NO];
//                    }];
//  
//    
//    [sessionTask resume];
//    
//    //[[PlayerDownloadManager sharedInstance] doLockLockTime:YES];
//}

-(void)accessLogEntry:(NSNotification *)notification
{
    AVPlayerItemAccessLog *accessLog = [((AVPlayerItem *)notification.object) accessLog];
    AVPlayerItemAccessLogEvent *lastEvent = accessLog.events.lastObject;
    
    float bitRate = lastEvent.indicatedBitrate;
    
    if(bitRate != -1) {
        _curBitrate = [NSString stringWithFormat:@"Auto:%f", bitRate];
    }
    
    DLog(@"bitrate switch %f", bitRate);
  
    if (CMTimeGetSeconds(self.duration) > 0) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:BIT_RATE_CHANGE_NOTIFICATION object:_curBitrate];
    }    
}

-(void)playerDidEndPlaying:(NSNotification *)notification
{
    if ([[self delegate] respondsToSelector:@selector(videoPlayerDidFinishPlayback:)]) {
        [[self delegate] videoPlayerDidFinishPlayback:self];
    }
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForResponseToAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge
{
    NSURLProtectionSpace *protectionSpace = authenticationChallenge.protectionSpace;
    if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [authenticationChallenge.sender useCredential:[NSURLCredential credentialForTrust:authenticationChallenge.protectionSpace.serverTrust] forAuthenticationChallenge:authenticationChallenge];
        [authenticationChallenge.sender continueWithoutCredentialForAuthenticationChallenge:authenticationChallenge];
        
    }
    else {
        
    }
    
    return YES;
}

#pragma mark - Player setting handler methods
-(NSArray *)getSubTitles
{
    NSMutableArray *subtitlesArray                = [NSMutableArray new];
    /*NSData *responseData = [PlayerCache objectForKey:SUBTITLE_CACHE_FILENAME];
    if (responseData)
    {
        NSArray *availableTrack = [NSKeyedUnarchiver unarchiveObjectWithData:responseData];
        subtitlesArray = [availableTrack mutableCopy];
    }*/
    return subtitlesArray;
}

-(void)switchSubtitle:(PlayerTrack *)track
{
    if ([[self delegate] respondsToSelector:@selector(subtitleloadingWithObject:)]) {
        [[self delegate] subtitleloadingWithObject:track];
    }
}

-(NSString *)getCurrentSubtitleName {
    return  _currentSubTitle;
}

-(NSArray*)getAudioTracks
{
    NSMutableArray *audioTracks                 = [NSMutableArray new];
    AVURLAsset *asset                           = (AVURLAsset*)self.player.currentItem.asset;
    
    AVMediaSelectionGroup *group                = [asset mediaSelectionGroupForMediaCharacteristic:AVMediaCharacteristicAudible];
    AVMediaSelectionOption *selectedOption      = [self.player.currentItem selectedMediaOptionInMediaSelectionGroup:group];
    
    for (int i = 0; i < group.options.count; i++)
    {
        AVMediaSelectionOption *option = group.options[i];
        PlayerTrack *track = [[PlayerTrack alloc] init];
        
        NSString *displayName = [self getAudioTrackTitle:option];
        if (![displayName length] || [displayName isKindOfClass:[NSNull class]]) {
           displayName = [NSString stringWithFormat:@"%@ %d",AUDIO_TRACK_NAME_TRACK, i+1];
        }
        
        if ([selectedOption.displayName isEqualToString:[option displayName]]) {
            _curAudioTrack = displayName;
        }
        
        [track setTrackID:i];
        [track setTrackName:displayName];
        [track setEnabled:NO];
        [audioTracks addObject:track];
    }
    
    if (audioTracks.count)
    {
        _availableAudioTracks = [[NSArray alloc] initWithArray:audioTracks];
        return  _availableAudioTracks;
    }
    
    for (int i = 0; i < [[asset tracksWithMediaType:AVMediaTypeAudio] count]; i++)
    {
        AVAssetTrack *option = [asset tracksWithMediaType:AVMediaTypeAudio][i];
        NSString *displayName = [PlayerUtilities getLanguageNameFromLanguageCode:[option languageCode]];
        
        if([displayName isEqualToString:AUDIO_TRACK_NAME_TRACK]) {
            displayName = [NSString stringWithFormat:@"%@ %d",AUDIO_TRACK_NAME_TRACK, i+1];
        }
        if (i == 0) {
            _curAudioTrack = displayName;
        }
        
        PlayerTrack *track = [[PlayerTrack alloc] init];
        [track setTrackID:i];
        [track setTrackName:displayName];
        [track setEnabled:NO];
        [audioTracks addObject:track];
    }
    
    if (audioTracks.count) {
        _availableAudioTracks = [[NSArray alloc] initWithArray:audioTracks];
    }
    
    return audioTracks;
}

-(NSString*)getCurrentAudioTrackName {
    return _curAudioTrack;
}

-(NSString*)getCurrentURLFromDataSource
{
    NSInteger index = [self.player.items indexOfObject:self.player.currentItem];
    if(index > [_videos count] - 1) {
        return _videos[0];
    }
    
    return _videos[index];
}

-(NSString*)getCurrentBitRate {
    return _curBitrate;
}

-(void)replaceVideoItem:(NSString*)videoItem
{
    NSInteger index = [self.player.items indexOfObject:self.player.currentItem];
    _videos[index] = videoItem;
}

-(NSString*)getCurrentURLFromPlayer
{
    if ([self.player.currentItem.asset isKindOfClass:[AVMutableComposition class]])
    {
        AVMutableComposition *composition = (AVMutableComposition *)self.player.currentItem.asset;
        if ([[composition tracksWithMediaType:AVMediaTypeVideo] count])
        {
            AVCompositionTrack  *track = [[composition tracksWithMediaType:AVMediaTypeVideo] firstObject];
            return [[[[track segments] firstObject] sourceURL] absoluteString];
        }
    }
    return [[((AVURLAsset *)self.player.currentItem.asset) URL] absoluteString];
}

-(void)switchAudioTrack:(PlayerTrack *)track
{
    AVURLAsset *asset               = (AVURLAsset *)self.player.currentItem.asset;
   
    //Get Auido Media from M3U8 (In case of M3U8)
    AVMediaSelectionGroup *group    = [asset mediaSelectionGroupForMediaCharacteristic:AVMediaCharacteristicAudible];
    
    //Get Embeded Auido Stream from Video (In case of MP4)
    NSArray *audioStream            = [asset tracksWithMediaType:AVMediaTypeAudio];
    
    for (int i = 0; i < group.options.count; i++)
    {
        AVMediaSelectionOption *option  = group.options[i];
        NSString *displayName           = [self getAudioTrackTitle:option];
        
        if (![displayName length] || [displayName isKindOfClass:[NSNull class]]) {
            displayName = [NSString stringWithFormat:@"%@ %d",AUDIO_TRACK_NAME_TRACK, i+1];
        }
        
        if ([displayName isEqualToString:track.trackName])
        {
            _curAudioTrack = [track trackName];
            if ([self.delegate respondsToSelector:@selector(audioTrackSwitched)]) {
                [self.delegate audioTrackSwitched];
            }
            
            [self.player.currentItem selectMediaOption:option inMediaSelectionGroup:group];
            return;
        }
    }
    
    for (int i = 0; i < [audioStream count]; i++)
    {
        AVAssetTrack *option    = audioStream[i];
        NSString *displayName   = [PlayerUtilities getLanguageNameFromLanguageCode:[option languageCode]];
        if([displayName isEqualToString:AUDIO_TRACK_NAME_TRACK]) {
            displayName = [NSString stringWithFormat:@"%@ %d",AUDIO_TRACK_NAME_TRACK, i+1];
        }
        
        if ([displayName isEqualToString:track.trackName] && i == track.trackID)
        {
            _curAudioTrack = displayName;
            
            NSMutableArray *allAudioParams  = [NSMutableArray array];
            for (AVAssetTrack *track in audioStream)
            {
                float trackVolume = 0.0;
                if (option == track) {
                    trackVolume = 1.0;
                }
                
                AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
                
                [audioInputParams setVolume:trackVolume atTime:kCMTimeZero];
                [audioInputParams setTrackID:[track trackID]];
                [allAudioParams addObject:audioInputParams];
            }
            
            AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
            [audioZeroMix setInputParameters:allAudioParams];
            
            dispatch_async(dispatch_get_main_queue(), ^
           {
               if ([self.delegate respondsToSelector:@selector(audioTrackSwitched)]) {
                   [self.delegate audioTrackSwitched];
               }
               
               [self.player.currentItem setAudioMix:audioZeroMix];
           });
            return;
        }
    }
}

-(void)switchBitrate:(Bitrate *)track
{
    if (track != nil)
    {
        _curBitrate = [NSString stringWithFormat:@"Manual:%f", [track bitrate]];
        [self.player.currentItem setPreferredPeakBitRate:track.bitrate];
    }
}

//Mapping Master M3u8 Language and Name Attirubute For Audio Track
-(NSString *)getAudioTrackTitle:(AVMediaSelectionOption *)mediaOption
{
    NSString *title = nil;
    NSArray *titles = [AVMetadataItem metadataItemsFromArray:[mediaOption commonMetadata] withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
    if ([titles count] > 0)
    {
        // Try to get a title that matches one of the user's preferred languages.
        NSArray *titlesForPreferredLanguages = [AVMetadataItem metadataItemsFromArray:titles filteredAndSortedAccordingToPreferredLanguages:[NSLocale preferredLanguages]];
        if ([titlesForPreferredLanguages count] > 0)
        {
            title = [[titlesForPreferredLanguages objectAtIndex:0] stringValue];
        }
        
        // No matches in any of the preferred languages. Just use the primary title metadata we find.
        if (title == nil)
        {
            title = [[titles objectAtIndex:0] stringValue];
        }
    }
    
    return title;
}

/*
 Setting Initial Audio Stream as default for the Video, Only in case of Embeded Multiple Auido Stream in the videos.
 */
-(void)setDefaultAudioTrack
{
    AVURLAsset *asset                           = (AVURLAsset*)self.player.currentItem.asset;
    NSArray *audioStreams                       = [asset tracksWithMediaType:AVMediaTypeAudio];
    NSMutableArray *allAudioParams              = [NSMutableArray array];
    
    if ([audioStreams count] > 1)
    {
        for (AVAssetTrack *option in audioStreams)
        {
            float trackVolume = 0.0;
            if ([audioStreams firstObject] == option) {
                trackVolume = 1.0;
            }
            
            AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
            
            [audioInputParams setVolume:trackVolume atTime:kCMTimeZero];
            [audioInputParams setTrackID:[option trackID]];
            [allAudioParams addObject:audioInputParams];
        }
        
        AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
        [audioZeroMix setInputParameters:allAudioParams];
        
        [self.player.currentItem setAudioMix:audioZeroMix];
    }
    
}


@end
