//
//  PlayerUtilities.h
//  ClearBCProduct
//
//  Created by Saravana Kumar on 8/21/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Bitrate.h"



#define FRAME_RATE 25.0f

typedef void (^completionHandler)(BOOL success);
typedef void (^progressHandler)(CGFloat progress);

@interface PlayerUtilities : NSObject

#pragma mark - Player Timecode Methods
+(NSString*)getsceneTimeCodeFromSeconds:(CGFloat)seconds;
+(NSString*)getMinutesTimeCodeFromSeconds:(CGFloat)seconds;
+(CGFloat)getSecondsFromTimeCode:(NSString*)timeCode isDF:(BOOL)isDF;
+(NSString*)getTimeCodeFromSeconds:(CGFloat)seconds isDF:(BOOL)isDF doFrameCount:(BOOL)doFrameCount;
+(CGFloat)getSecondsFromTimeCode:(NSString*)timeCode withFrameRate:(CGFloat)frameRate isDF:(BOOL)isDF;
+(NSString*)getTimeCodeFromMilliSecondsInHHMMSSFormat:(CGFloat)milliSeconds forFrameRate:(CGFloat)frameRate;
+(NSString*)getTimeCodeFromMilliSeconds:(CGFloat)milliSeconds forFrameRate:(CGFloat)frameRate isDF:(BOOL)isDF;
+(NSString*)getTimeCodeFromSeconds:(CGFloat)seconds forFrameRate:(CGFloat)frameRate isDF:(BOOL)isDF doFrameCount:(BOOL)doFrameCount;
+(NSString*)getTimeCodeFromSecondsForScene:(CGFloat)seconds forFrameRate:(CGFloat)frameRate isDF:(BOOL)isDF doFrameCount:(BOOL)doFrameCount;
+(NSString*)getTimeCodeFromTime:(CMTime)time forFrameRate:(CGFloat)frameRate som:(CGFloat)som isDF:(BOOL)isDF doFrameCount:(BOOL)doFrameCount;
+(NSString*)getTimeCodeFromTimeForStoryTeller:(CMTime)time forFrameRate:(CGFloat)frameRate som:(CGFloat)som isDF:(BOOL)isDF doFrameCount:(BOOL)doFrameCount;

#pragma mark - API Response Methods
+(BOOL)isNotNil :(NSObject *)classObject;
+(CGSize)getSizeOfString:(NSString*)text withFont:(UIFont*)font;

#pragma mark - Audio/Bitrate Methods
+(NSString*)getM3u8Url:(NSString*)clipURL;
+ (NSString *)getBitrateName:(double)bitrate;
+(NSString *)getLanguageNameFromLanguageCode:(NSString *)languageCode;
+(NSArray*)getBitratesFromM3u8:(NSString*)m3u8String withURL:(NSString*)urlString;
+(void)downloadM3u8AndParseBandwidth:(NSString *)urlString
                   completionHandler:(void (^)(NSArray *bandWidths , NSUInteger errorCode))completionHandler;

#pragma mark - Storyboard/XIB Methods
+(id)getViewWithXIBId:(NSString*)xibId owner:(id)owner;
+(id)getControllerWithStoryBoardId:(NSString *)storyBoardId;
+(void)addPlayerToRootViewController:(UIView*)playerView;

#pragma mark - WaterMark Methods
+(CGFloat)getWaterMarkWidth:(CGFloat)angle withRect:(CGRect)sourceRect andWidthFactor:(CGFloat)widthFactor;

#pragma mark - TImezone Methods
+(NSString *)convertResponseDateToUserPreferredTimeZone:(NSString *)dateString withDateFormat:(NSString *)dateFormat
                                         sourceTimezone:(NSString*)sourceTimezone preferedTimeZone:(NSString*)perferedTimezone;

@end
