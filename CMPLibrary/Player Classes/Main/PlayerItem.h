//
//  PlayListItem.h
//  ClearBC
//
//  Created by Deep Arora on 3/16/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface PlayerItem : NSObject

@property(nonatomic, strong) NSString                   *itemID;         //deafult is nil
@property(nonatomic, strong) NSString                   *name;           //deafult is nil
@property(nonatomic, strong) NSString                   *mediaURL;       //deafult is nil
@property(nonatomic, strong) NSString                   *duration;       //deafult is nil
@property(nonatomic, strong) NSString                   *startTime;      //deafult is nil
@property(nonatomic, strong) NSString                   *endTime;        //deafult is nil
@property(nonatomic, strong) NSString                   *imageURL;       //deafult is nil
@property(nonatomic, assign) CGFloat                    som;             //default is nil. If not nil, timecode will be in Start of Media (SOM)
@property(nonatomic, assign) CGFloat                    frameRate;       //default will be "25.0f".
@property(nonatomic, assign) BOOL                       isDF;            //default is "NO". If yes, enabled the Drop Frame feature
@property(nonatomic, strong) NSArray                    *srcTracks;       //default is nil. Used for Player Track for Bitrate, Audio Track, Close Caption


#pragma mark -  Initializer Methods
-(instancetype)initWithItemURL:(NSString *)srcURL withFrame:(CGFloat)frameRate;

+(instancetype)playerWithItemURL:(NSString *)srcURL withFrame:(CGFloat)frameRate;

@end
