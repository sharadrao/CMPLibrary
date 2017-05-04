//
//  PlayListItem.m
//  ClearBC
//
//  Created by Deep Arora on 3/16/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//

#import "PlayerItem.h"

@implementation PlayerItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        //TO::DO Initialise
    }
    
    return self;
}


-(instancetype)initWithItemURL:(NSString *)srcURL withFrame:(CGFloat)frameRate
{
    self = [super init];
    if (self)
    {
        //TO:DO Initialise
        _mediaURL   = srcURL;
        _frameRate  = frameRate;
    }
    return self;
}

+(instancetype)playerWithItemURL:(NSString *)srcURL withFrame:(CGFloat)frameRate
{
    PlayerItem *item = [[PlayerItem alloc] init];
    [item setMediaURL:srcURL];
    [item setFrameRate:frameRate];
    
    return item;
}

@end
