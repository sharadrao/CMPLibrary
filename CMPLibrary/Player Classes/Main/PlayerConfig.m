//
//  PlayerConfig.m
//  PlayerTest
//
//  Created by sharad.rao on 04/04/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import "PlayerConfig.h"

@implementation PlayerConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        //TO::DO Initialise
    }
    return self;
}

-(instancetype)initWithControlType:(PlayerControlType)controlType
{
    self = [super init];
    if (self) {
        //TO::DO Intialise
        _controlType = controlType;
    }
    
    return self;
}

-(instancetype)initWithControlType:(PlayerControlType)controlType withPlayer:(PlayerType)playerType
{
    self = [super init];
    if (self)
    {
        //TO::DO Intialise
        _controlType = controlType;
    }
    
    return self;
}

+(instancetype)configWithControlType:(PlayerControlType)controlType {
    
    PlayerConfig *config = [[PlayerConfig alloc] init];
    [config setControlType:controlType];
    
    return config;
}

+(instancetype)configWithControlType:(PlayerControlType)controlType withPlayer:(PlayerType)playerType
{
    PlayerConfig *config = [[PlayerConfig alloc] init];
    [config setControlType:controlType];
    return config;
}

@end
