//
//  PlayerConfig.h
//  PlayerTest
//
//  Created by sharad.rao on 04/04/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerProductConstants.h"
#import "WaterMarkModel.h"

@interface PlayerConfig : NSObject

@property(nonatomic, strong) NSArray                    *itemArray;                 //Default is nil. Used for playback of Video/Playlist/Reel
@property(nonatomic, assign) PlayerControlType          controlType;                //Default is "Preview".
@property(nonatomic, assign) CMPItemType                itemType;                   //Default is "Video". Should Specifies the Type(Recomended).
@property(nonatomic, strong) WaterMarkModel             *watermarkModel;

@property(nonatomic, assign) BOOL                       enableControl;              //Default is "YES". If "NO", hide the Player Controls
@property(nonatomic, assign) BOOL                       repeat;                     //Default is "YES". If "NO", Playback of item repeats
@property(nonatomic, assign) BOOL                       isOffline;                  //Default is "NO". Make "Yes" if streaming Offline
@property(nonatomic, assign) BOOL                       autoStart;                  //Default is "NO". If "YES", starts playing again once player finished playback
@property(nonatomic, assign) BOOL                       isEnableWatermark;
@property(nonatomic, assign) BOOL                       isSubtitleEnabled;          //Default is "NO". If "YES", Subittle Enabled
@property(nonatomic, assign) BOOL                       isCommentOverLayEnabled;    //Default is "NO". If "YES", Comment Overlay Enabled
@property(nonatomic, assign) BOOL                       isPlayerSettingsEnabled;    //Default is "NO". If "YES", Settings Enabled


#pragma mark -  Intializer Methods
-(instancetype)initWithControlType:(PlayerControlType)controlType;
-(instancetype)initWithControlType:(PlayerControlType)controlType  withPlayer:(PlayerType)playerType;

+(instancetype)configWithControlType:(PlayerControlType)controlType;
+(instancetype)configWithControlType:(PlayerControlType)controlType  withPlayer:(PlayerType)playerType;

@end
