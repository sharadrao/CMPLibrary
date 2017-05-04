//
//  PlayerUtilities.m
//  ClearBCProduct
//
//  Created by Saravana Kumar on 8/21/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import "PlayerUtilities.h"
#import "PlayerAPI.h"
#import "PlayerProductConstants.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "Base64.h"

#define CM_THEME_COLORS     @"CMTheme.plist"

#define DECRYPT_CHUNK_SIZE  16

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static PlayerUtilities *instance;
static BOOL cancelDecryption;
//static BOOL cancelEncryption;
static id mainViewController;


@interface PlayerUtilities()

@end


@implementation PlayerUtilities

static PlayerUtilities *sharedInstance = nil;

#pragma mark - WaterMark Methods
+(CGFloat)getWaterMarkWidth:(CGFloat)angle withRect:(CGRect)sourceRect andWidthFactor:(CGFloat)widthFactor
{
    CGFloat newWidth = 0.0f;
    CGFloat x1,x2,x3,x4;
    
    widthFactor = widthFactor * 0.01f;
    
    x1 = RadianToDegree(atan((sourceRect.size.height/2) / (sourceRect.size.width/2)));
    x2 = 180 - x1;
    x3 = 180 + x1;
    x4 = 360 - x1;
    
    if(angle < x1 || (angle > x2 && angle < x3) || angle > x4) {
        return newWidth = fabs(widthFactor * (sourceRect.size.width / cosf(DegreeToRadian(angle))));
    }
    
    if((angle > x1 && angle < x2) || (angle > x3 && angle < x4)) {
        return newWidth = fabs(widthFactor * (sourceRect.size.height / sinf(DegreeToRadian(angle))));
    }
    
    return 0;
}


#pragma mark - Date Conversions Methods 
//This method can be used for displaying date and time on UI (API response Date to User Preferred timezone)
+(NSString *)convertResponseDateToUserPreferredTimeZone:(NSString *)dateString withDateFormat:(NSString *)dateFormat
                                         sourceTimezone:(NSString*)sourceTimezone preferedTimeZone:(NSString*)perferedTimezone
{
    NSDateFormatter *dateFormatter      =   [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat            =   dateFormat;

    //Converting responseDate in UTC Format -> Example (Apr 01, 2016 16:20:23 UTC)
    NSString *responseDateString        =   [NSString stringWithFormat:@"%@ %@",dateString,sourceTimezone];
    NSDate *responseDateInUTC       =   [dateFormatter dateFromString:responseDateString];
    
    dateFormatter.dateFormat        =   dateFormat;
    dateFormatter.timeZone          =   [NSTimeZone timeZoneWithAbbreviation:perferedTimezone];//User preferedTimeZone
    
    return [dateFormatter stringFromDate: responseDateInUTC];
}

#pragma mark -- TimeCode related methods
+(NSString*)timeCodeFromDFSeconds:(CGFloat)secs frameRate:(CGFloat)frameRate
{
    NSInteger   frameRate10Minutes = frameRate * 60 * 10;
    NSInteger   frameRateMinute    = frameRate * 60;
    
    NSInteger frameNumber              = roundf(secs * frameRate);
    NSInteger framePer10Minutes        = roundf(frameNumber / frameRate10Minutes);
    NSInteger frameRemainsPer10Minutes = roundf(frameNumber % frameRate10Minutes);
    
    frameNumber +=  18 * framePer10Minutes + 2 * roundf(((frameRemainsPer10Minutes - 2) / frameRateMinute));
    
    NSInteger ceiledFrameRate = ceilf(frameRate);
    
    NSInteger frames    = frameNumber % ceiledFrameRate;
    NSInteger seconds   = (NSInteger)((frameNumber / ceiledFrameRate) % 60);
    NSInteger minutes   = (NSInteger)roundf(((frameNumber / ceiledFrameRate) / 60) % 60);
    NSInteger hours     = (NSInteger)roundf((((frameNumber / ceiledFrameRate) / 60) / 60) % 24);
    
    NSString *timeCode = [NSString stringWithFormat:@"%02ld:%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds, (long)frames];
    
     DLog(@"time code %@", timeCode);
    
    return timeCode;
}


+(CGFloat)getSecondsFromTimeCode:(NSString*)timeCode isDF:(BOOL)isDF {
   return [PlayerUtilities getSecondsFromTimeCode:timeCode withFrameRate:FRAME_RATE isDF:isDF];
}

/*
+(NSString *)appendPathExtension:(NSString *)ext forAssetUrl:(NSString *)url
{
    NSURL *strUrl = [NSURL URLWithString:url];
    NSString *fileId = [[url lastPathComponent] stringByDeletingPathExtension];
    NSURL *filename = [[[[strUrl URLByDeletingPathExtension] URLByDeletingLastPathComponent] URLByDeletingLastPathComponent] URLByDeletingLastPathComponent] ;
    filename = [[[filename URLByAppendingPathComponent:@"others"] URLByAppendingPathComponent:fileId] URLByAppendingPathExtension:ext];
    return [filename absoluteString];
}
*/

+(CGFloat)getSecondsFromTimeCode:(NSString*)timeCode withFrameRate:(CGFloat)frameRate isDF:(BOOL)isDF
{
    if([timeCode rangeOfString:@":" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        return 0.0f;
    }
    
    NSArray *components = [timeCode componentsSeparatedByString:@":"];
    if(![components count]) {
        return 0.0f;
    }
    
    float hourToSec = [components[0] floatValue] * 3600;
    float minToSec  = [components[1] floatValue] * 60.0f;
    float sec       = [components[2] floatValue];
    float frame     = 0.0f;
    
    if (!frameRate) {
        frameRate = FRAME_RATE;
    }
    
    if([components count] > 3) {
        frame = [[components objectAtIndex:3] floatValue] * (1.0f / frameRate);
    }
    
    CGFloat seconds = hourToSec + minToSec + sec + frame;
    
    if(isDF) {
        seconds = [self secondsFromHour:hourToSec minutes:minToSec seconds:sec frames:frame andFrameRate:frameRate];
    }
    
    return seconds;
}

+(CGFloat)secondsFromHour:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)secs frames:(NSInteger)frames andFrameRate:(CGFloat)frameRate
{
    NSInteger totalMinutes = (60 * hours) + minutes;
    NSInteger frameNumber  = (108000 * hours) + (1800 * minutes) + (30 * secs) + ((frames - 2) * (totalMinutes - (totalMinutes / 10)));
    
    CGFloat seconds = roundf((frameNumber / frameRate));
    
    return seconds;
}


+(NSString*)getTimeCodeFromMilliSeconds:(CGFloat)milliSeconds forFrameRate:(CGFloat)frameRate isDF:(BOOL)isDF
{
    CGFloat seconds = (milliSeconds * 0.001f);
    return [PlayerUtilities getTimeCodeFromSeconds:seconds forFrameRate:frameRate isDF:isDF doFrameCount:YES];
}

+(NSString*)getTimeCodeFromTime:(CMTime)time forFrameRate:(CGFloat)frameRate som:(CGFloat)som isDF:(BOOL)isDF doFrameCount:(BOOL)doFrameCount
{
    if (!frameRate) {
        frameRate = FRAME_RATE;
    }
    
    CGFloat seconds = roundf(time.value / time.timescale);
    seconds        += som;
    
    return [self getTimeCodeFromSeconds:seconds forFrameRate:frameRate isDF:isDF doFrameCount:YES];
}

+(NSString*)getTimeCodeFromSeconds:(CGFloat)seconds isDF:(BOOL)isDF doFrameCount:(BOOL)doFrameCount {
    return [PlayerUtilities getTimeCodeFromSeconds:seconds forFrameRate:FRAME_RATE isDF:isDF doFrameCount:YES];
}

+(NSString*)getTimeCodeFromSecondsForScene:(CGFloat)seconds forFrameRate:(CGFloat)frameRate isDF:(BOOL)isDF doFrameCount:(BOOL)doFrameCount
{
    NSString *timeCode = [PlayerUtilities getTimeCodeFromSeconds:seconds forFrameRate:frameRate isDF:isDF doFrameCount:doFrameCount];
    
    NSArray *timeCodes = [timeCode componentsSeparatedByString:@":"];
    
    if([timeCodes count] > 2) {
        timeCode = [NSString stringWithFormat:@"%@:%@", timeCodes[1], timeCodes[2]];
    }
    
    return timeCode;
}

+(NSString*)getTimeCodeFromSeconds:(CGFloat)seconds forFrameRate:(CGFloat)frameRate isDF:(BOOL)isDF doFrameCount:(BOOL)doFrameCount
{
    if(frameRate == 0.0f) {
        frameRate = 25.0f;
    }
    
    if(!seconds) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d:%02ld",00, 00, 00,(long)00];
    }
    
    if(isDF) {
        return [self timeCodeFromDFSeconds:seconds frameRate:frameRate];
    }
    
    return[self timeCodeFromNDFSeconds:seconds frameRate:frameRate];
}

+(NSString*)timeCodeFromNDFSeconds:(CGFloat)secs frameRate:(CGFloat)frameRate
{
    NSInteger totalFrameCount   = roundf(secs * frameRate);
    
    NSInteger framesPerHour     = roundf(frameRate * 60 * 60);
    NSInteger framesPer24Hours  = framesPerHour * 24;
    
    if(totalFrameCount < 0) {
        totalFrameCount = framesPer24Hours + totalFrameCount;
    }
    
    totalFrameCount = totalFrameCount % framesPer24Hours;
    
    NSInteger fr = roundf(frameRate);
    NSInteger fph = 3600 * fr;
    NSInteger fpm = 60 * fr;
    
    NSInteger hh = floorf(totalFrameCount / fph);
    NSInteger mm = floorf((totalFrameCount - (hh * fph)) / (60 * fr));
    NSInteger ss = floorf((totalFrameCount - (hh * fph) - (mm * fpm)) / fr);
    NSInteger ff = roundf((totalFrameCount - (hh * fph) - (mm * fpm) - (ss * fr)));
    
    // NSLog(@"seconds %d", ss);
    
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld:%02ld", (long)hh, (long)mm, (long)ss, (long)ff];
    
    /* NSInteger sec     = (NSInteger)secs % 60;
     NSInteger min     = ((NSInteger)secs / 60) % 60;
     NSInteger hours   = (NSInteger)secs / 3600;
     
     CMTime currentTime      = CMTimeMakeWithSeconds(secs, NSEC_PER_SEC);
     CMTime currentTimeF     = CMTimeConvertScale(currentTime, frameRate, kCMTimeRoundingMethod_Default);
     NSInteger frames        = fmodf(currentTimeF.value, frameRate);
     
     return [NSString stringWithFormat:@"%02ld:%02ld:%02ld:%02ld",(long)hours, (long)min, (long)sec,(long)frames];
     
     //    NSInteger frameNumber   = roundf(secs * frameRate);
     //
     //    NSInteger frameRateInt  = (NSInteger)ceilf(frameRate);
     //    NSInteger frames        = frameNumber % frameRateInt;
     //    NSInteger seconds       = ((NSInteger)roundf((frameNumber / frameRate))) % 60;
     //    NSInteger minutes       = ((NSInteger)roundf(((frameNumber / frameRate) / 60))) % 60;
     //    NSInteger hours         = ((NSInteger)roundf((((frameNumber / frameRate) / 60) / 60))) % 24;
     //
     //    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds,(long)frames]; */
    
}

+(NSString*)getTimeCodeFromMilliSecondsInHHMMSSFormat:(CGFloat)milliSeconds forFrameRate:(CGFloat)frameRate
{
    CGFloat seconds = (milliSeconds * 0.001f);
    
    if(frameRate == 0.0f) {
        frameRate = 25.0f;
    }
    
    int sec     = (int)seconds % 60;
    int min     = ((int)seconds / 60) % 60;
    int hours   = (int)seconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, min, sec];
}

+(NSString*)getTimeCodeFromTimeForStoryTeller:(CMTime)time forFrameRate:(CGFloat)frameRate som:(CGFloat)som isDF:(BOOL)isDF doFrameCount:(BOOL)doFrameCount
{
    if (!frameRate) {
        frameRate = FRAME_RATE;
    }
    
    CGFloat seconds = (CGFloat)time.value / (CGFloat)time.timescale;
    seconds        += som;
    
    return [self getTimeCodeFromSeconds:seconds forFrameRate:frameRate isDF:isDF doFrameCount:YES];
}

+(NSString*)getsceneTimeCodeFromSeconds:(CGFloat)seconds
{
    int sec = ((int)seconds) % 60;
    int min = (lroundf(seconds) / 60) % 60;
   
    return [NSString stringWithFormat:@"%02d:%02d", min, sec];
}

+(NSString*)getMinutesTimeCodeFromSeconds:(CGFloat)seconds
{
    int sec     = (int)seconds % 60;
    int min     = ((int)seconds / 60) % 60;
    int hours   = (int)seconds / 3600;
    
    if (hours == 0 ) {
        return [NSString stringWithFormat:@"%02d:%02d",min, sec];
    }

    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, min, sec];
}


#pragma mark- M3u8 parsing and checking master
+(NSString*)getM3u8Url:(NSString*)clipURL
{
    if ([clipURL rangeOfString:[NSString stringWithFormat:@".%@", M3U8]].location != NSNotFound) {
        return clipURL;
    }
    else if(![[clipURL pathExtension] length])
    {
        NSURL *url = [NSURL URLWithString:clipURL];
        
        NSString *decodedPath = [[[clipURL lastPathComponent] base64DecodedString] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        url = [[url URLByDeletingLastPathComponent] URLByAppendingPathComponent:decodedPath];
        
        NSString *fileName  = [[url lastPathComponent] stringByDeletingPathExtension];
        clipURL  = [[[[url URLByDeletingLastPathComponent] URLByDeletingLastPathComponent] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/sec-hls/%@.%@", fileName, fileName,M3U8]] absoluteString];
    }
    else {
        return nil;
    }
    
    return clipURL;
}

/**
 * Download m3u8 file form url and then parse and return bandwidth's array.
 */

+(void)downloadM3u8AndParseBandwidth:(NSString *)urlString completionHandler:(void (^)(NSArray *bandWidths , NSUInteger errorCode))completionHandler
{
    NSString *m3u8URL   =  [PlayerUtilities getM3u8Url:urlString];
    
    DLog(@"m3u8URL:%@",m3u8URL);
    
    if (!m3u8URL) {
        completionHandler(nil ,TRACE_CODE_NETWORK_ERROR);
    }
    else
    {
        [PlayerAPI asyncDataDownload:m3u8URL withProgressHandler:nil andCompletionHandler:^(NSData *m3u8Data, NSUInteger errorCode)
         {
             if(errorCode == TRACE_CODE_SUCCESS)
             {
                 NSString *m3u8String    = [[NSString alloc] initWithData:m3u8Data encoding:NSUTF8StringEncoding];
                 NSArray *bandwidthsArray = [PlayerUtilities getBitratesFromM3u8:m3u8String withURL:m3u8URL];
                 
                 if([m3u8String rangeOfString:@"File or directory not found"].location != NSNotFound) {
                     completionHandler(nil,TRACE_CODE_FILE_SYSTEM_ERROR);
                 } else {
                     completionHandler(bandwidthsArray,TRACE_CODE_SUCCESS);
                 }
             }
             else {
                 completionHandler(nil,TRACE_CODE_NETWORK_ERROR);
             }
         }];
    }
}

/**
 * Parse bandwidths from master .m3u8 file and return sorted array of bandwidths
 */
+(NSArray*)getBitratesFromM3u8:(NSString*)m3u8String withURL:(NSString*)urlString
{
   DLog(@"Master m3u8 url:%@", urlString);
    if ([m3u8String isEqualToString:@""] || !m3u8String) {
        return nil;
    }
    
    NSMutableArray *bandwidths = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *m3u8Playlist = [m3u8String componentsSeparatedByString:@"\n"];
    
    if([m3u8String rangeOfString:@"BANDWIDTH="].location != NSNotFound)
    {
        NSMutableArray *bandwidthStrings = [[NSMutableArray alloc] init];
        
        int index = 1;
        for (NSString *streamString in m3u8Playlist)
        {
            if([streamString rangeOfString:@"BANDWIDTH="].location != NSNotFound)
            {
                [bandwidthStrings addObject:streamString];
                
                NSRange bandwidthRange = [streamString rangeOfString:@"BANDWIDTH="];
                NSString *bandwidthString = [streamString substringFromIndex:bandwidthRange.location + bandwidthRange.length];
                NSString *value;
                NSRange commaRange = [bandwidthString rangeOfString:@","];
                if (NSNotFound == commaRange.location) {
                    value = bandwidthString;
                } else {
                    value = [bandwidthString substringToIndex:commaRange.location];
                }
                NSString *playlistURL   = m3u8Playlist[index];
                if (playlistURL)
                {
                    Bitrate *bitrate   = [[Bitrate alloc] init];
                    bitrate.bitrate      =  value.doubleValue;
                    bitrate.birtateTitle = [PlayerUtilities getBitrateName:[value doubleValue]];
                   DLog(@"bit rate %f", bitrate.bitrate);
                    
                    bitrate.URL          = [playlistURL stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    if(![bitrate.URL hasPrefix:@"http"]) {
                        bitrate.URL = [[[[[NSURL URLWithString:urlString] URLByDeletingLastPathComponent] URLByAppendingPathComponent:bitrate.URL]  absoluteString]stringByRemovingPercentEncoding];
                    }
                    DLog(@"Bitrate:%f, and corresponding m3u8 url:%@",value.doubleValue,bitrate.URL);
                    [bandwidths addObject:bitrate];
                }
            }
            ++index;
        }
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"bitrate"  ascending:YES];
        NSArray *sortedArray = [bandwidths sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
        
        bandwidths = [NSMutableArray arrayWithArray:sortedArray];
    }
    
    return bandwidths;
}

+ (NSString *)getBitrateName:(double)bitrate
{
    if (bitrate  >= 1048576)
    {
        bitrate = bitrate/(1024*1024);
        bitrate = ceilf(10 * bitrate)/ 10;
        return [NSString stringWithFormat:@"%.1f Mbps",bitrate];
    }
    else if (bitrate >= 1024)
    {
        bitrate = bitrate/1024;
        bitrate = ceilf(10 * bitrate)/10;
        return [NSString stringWithFormat:@"%.1f Kbps",bitrate];
    }
    else if (bitrate < 1024) {
        return [NSString stringWithFormat:@"%.1f bps",bitrate];
    }
    
    return [NSString stringWithFormat:@"%f",bitrate];
}



+(id)getControllerWithStoryBoardId:(NSString *)storyBoardId
{
    UIStoryboard *storyboard =  nil;
    NSString *storyBoardName    = @"Player_iPad";
    
    if(IS_IPHONE) {
        storyBoardName    = @"Player_iPhone";
    }
    
    storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:[NSBundle mainBundle]];
    
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    return controller;
}

+(void)addPlayerToRootViewController:(UIView*)playerView
{
    UIViewController *rootViewController = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows)
    {
        rootViewController = window.rootViewController;
        break;
    }
    
    UIViewController *controller = nil;
    if([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController *)rootViewController;
        controller  = [[navController viewControllers] lastObject];
    }
    else {
        controller = rootViewController;
    }
    
    [playerView setFrame:[controller.view bounds]];
    [controller.view addSubview:playerView];
}

+(CGSize)getSizeOfString:(NSString*)text withFont:(UIFont*)font
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:text attributes:attributes] size];
}

+(NSString *)getLanguageNameFromLanguageCode:(NSString *)languageCode
{
    languageCode            = [PlayerUtilities checkForNull:languageCode];
    NSLocale *englishLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSString *displayName   = [[englishLocale displayNameForKey:NSLocaleLanguageCode value:languageCode] capitalizedString];
    displayName             = [PlayerUtilities checkForNull:displayName];
    
    if (!displayName || !displayName.length || [displayName isEqualToString:AUDIO_TRACK_NAME_UNKNOWN_LANGUAGE]) {
        displayName         = AUDIO_TRACK_NAME_TRACK;
    }
    return displayName;
}


+(NSString*)checkForNull:(NSString*)value
{
    if([value isKindOfClass:[NSNull class]]) {
        return @"";
    }
    else if (!value) {
        return @"";
    }
    else if (([value isKindOfClass:[NSString class]] && ([value isEqualToString:@""]))) {
        return @"";
    }
    else {
        return value;
    }
}

+(id)getViewWithXIBId:(NSString*)xibId owner:(id)owner
{
    NSArray *xibviews = [[NSBundle mainBundle] loadNibNamed:xibId owner:owner options:nil];
    return [xibviews firstObject];
}

#pragma mark - decryption method

/*
+ (void)decryptFile:(NSString*)srcPath toDestinationPath:(NSString*)destPath withKey:(NSData*)keyData completionHandler:(completionHandler)completionhandler progress:(progressHandler)progresshandler
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    int blockSize = 128 * 1024;
    CGFloat total = 0;
    CGFloat fileSize = (CGFloat)[[[NSFileManager defaultManager] attributesOfItemAtPath:srcPath error:nil] fileSize];
    
    DLog(@"file size %f", fileSize);
    
    if (fileSize  == 0) {
        completionhandler(NO);
    }
    
    NSInputStream *cryptedStream = [NSInputStream inputStreamWithFileAtPath:srcPath];
    NSOutputStream *decryptedStream = [NSOutputStream outputStreamToFileAtPath:destPath append:NO];
    
    [cryptedStream open];
    [decryptedStream open];
    
    __block RNDecryptor *decryptor = nil;
    decryptor = [[RNDecryptor alloc] initWithEncryptionKey:keyData HMACKey:nil handler:^(RNCryptor *cryptor, NSData *data)
                 {
                     [decryptedStream write:data.bytes maxLength:data.length];
                     data = nil;
                     
                     dispatch_semaphore_signal(semaphore);
                 }];
    
    
    while (cryptedStream.hasBytesAvailable)
    {
        @autoreleasepool
        {
            uint8_t buf[blockSize];
            NSUInteger bytesRead = [cryptedStream read:buf maxLength:blockSize];
            if ((bytesRead > 0) && (!cancelDecryption))
            {
                NSData *data = [NSData dataWithBytes:buf length:bytesRead];
                
                total = total + bytesRead;
                
                CGFloat totalProgress = (total / fileSize) * 100.0f;
                progresshandler(totalProgress);
                [decryptor addData:data];
            }
            else {
                [decryptor finish];
            }
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    }
    
    DLog(@"while exit");
    
    [decryptedStream close];
    [cryptedStream close];
    
    completionhandler(!cancelDecryption);
}
*/





@end
