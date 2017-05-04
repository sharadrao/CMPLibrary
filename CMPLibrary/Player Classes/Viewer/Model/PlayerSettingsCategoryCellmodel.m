//
//  PlayerSettingsCategoryCellmodel.m
//  CM Library
//
//  Created by Paridhi Malviya on 5/23/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import "PlayerSettingsCategoryCellmodel.h"

@implementation PlayerSettingsCategoryCellmodel

@synthesize categoryName, isSelected;

#pragma mark - self methods

-(id)init
{
    self = [super init];
    
    if(self) {
        categoryName        = @"";
    }
    
    return self;
}

-(void)dealloc {
    categoryName        = nil;
}

@end
