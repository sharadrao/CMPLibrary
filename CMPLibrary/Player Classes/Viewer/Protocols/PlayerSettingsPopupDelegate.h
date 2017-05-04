//
//  PlayerSettingsPopUpDelegate.h
//  CM Library
//
//  Created by Paridhi Malviya on 5/20/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlayerTrack;
@class Bitrate;

@protocol PlayerSettingsPopUpDelegate <NSObject>

//annotation delegate methods
-(void)moveCommentUp;
-(void)moveCommentDown;
-(void)moveCommentRight;
-(void)moveCommentLeft;
-(void)increaseCommentTextFontSize;
-(void)decreaseCommentTextFontSize;
-(void)setCommentTextColor:(UIColor*)color;

//audiotrack and bitrate delegate methods
-(NSArray*)getAudioTracks;
-(NSString*)getCurrentAudioTrackName;
-(NSString*)getCurrentURLFromPlayer;
-(NSString*)getCurrentURLFromDataSource;
-(NSString*)getCurrentBitRate;
-(void)switchAudioTrack:(PlayerTrack *)audioTrack;
-(void)switchBitrate:(Bitrate*)bitrate;

//subtitles Delegate Method
-(NSArray *)getSubTitles;
-(void)switchSubtitle:(PlayerTrack *)subtitle;
-(NSString *)getCurrentSubtitleName;
@end
