//
//  PlayerTrack.h
//  PlayerTest
//
//  Created by sharad.rao on 03/04/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerTrack : NSObject

@property (nonatomic, strong) NSString                          *trackName;
@property (nonatomic, strong) NSString                          *trackURL;
@property (nonatomic, assign) NSInteger                         trackID;
@property (nonatomic, assign, getter=isEnabled) BOOL            enabled;

+(instancetype)trackWithName:(NSString*)trackName URL:(NSString*)tarckURL enable:(BOOL)isEnable;
+(instancetype)trackWithName:(NSString*)trackName URL:(NSString*)tarckURL;

-(instancetype)initWithName:(NSString*)trackName URL:(NSString*)trackURL;
-(instancetype)initWithName:(NSString*)trackName URL:(NSString*)trackURL enable:(BOOL)isEnable;

@end
