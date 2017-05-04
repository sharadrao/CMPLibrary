//
//  PlayerSettingsPopupInterface.m
//  CM Library
//
//  Created by Paridhi Malviya on 5/20/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import "PlayerSettingsPopupInterface.h"

@implementation PlayerSettingsPopupInterface

@synthesize categoryArray;

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

-(void)dealloc
{
    categoryArray = nil;
}

@end
