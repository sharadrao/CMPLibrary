//
//  PlayerTrack.m
//  PlayerTest
//
//  Created by sharad.rao on 03/04/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import "PlayerTrack.h"

@implementation PlayerTrack

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.trackName                      =   @"";
        self.trackURL                       =   @"";
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        self.trackName                      = [decoder decodeObjectForKey:@"trackName"];
        self.trackURL                       = [decoder decodeObjectForKey:@"trackURL"];
        self.enabled                        = [decoder decodeBoolForKey:@"enabled"];
        self.trackID                        = [decoder decodeIntegerForKey:@"trackID"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.trackName forKey:@"trackName"];
    [encoder encodeObject:self.trackURL forKey:@"trackURL"];
    [encoder encodeBool:self.enabled forKey:@"enabled"];
    [encoder encodeInteger:self.trackID forKey:@"trackID"];
}

-(void)dealloc
{
    self.trackName              = nil;
    self.trackURL               = nil;
}


@end
