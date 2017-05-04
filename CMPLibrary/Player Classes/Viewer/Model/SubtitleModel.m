//
//  SubtitleModel.m
//  ClearBC
//
//  Created by Damodar Namala on 13/01/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//

#import "SubtitleModel.h"

@implementation SubtitleModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _textEntitlements    =   [[NSMutableArray alloc] init];
        _tcIn                =   @"";
        _tcOut               =   @"";
        _duration            =   @"";
        _index               =   @"";
        _sccOriginalTcIn     =   @"";
        _sccOriginalTcOut    =   @"";
        _textSubtitle        =   @"";
    }
    return self;
}

- (void)dealloc
{
    _textEntitlements    =   nil;
    _tcIn                =   nil;
    _tcOut               =   nil;
    _duration            =   nil;
    _index               =   nil;
    _sccOriginalTcIn     =   nil;
    _sccOriginalTcOut    =   nil;
    _textSubtitle        =   nil;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        self.duration            =       [decoder decodeObjectForKey:@"duration"];
        self.index               =       [decoder decodeObjectForKey:@"index"];
        self.sccOriginalTcIn     =       [decoder decodeObjectForKey:@"sccOriginalTcIn"];
        self.sccOriginalTcOut    =       [decoder decodeObjectForKey:@"sccOriginalTcOut"];
        self.tcIn                =       [decoder decodeObjectForKey:@"tcIn"];
        self.tcOut               =       [decoder decodeObjectForKey:@"tcOut"];
        self.textEntitlements    =       [decoder decodeObjectForKey:@"textEntitlements"];
        self.textSubtitle        =       [decoder decodeObjectForKey:@"textSubtitle"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.duration                 forKey:@"duration"];
    [encoder encodeObject:self.index                    forKey:@"index"];
    [encoder encodeObject:self.sccOriginalTcIn          forKey:@"sccOriginalTcIn"];
    [encoder encodeObject:self.sccOriginalTcOut         forKey:@"sccOriginalTcOut"];
    [encoder encodeObject:self.tcOut                    forKey:@"tcOut"];
    [encoder encodeObject:self.tcIn                     forKey:@"tcIn"];
    [encoder encodeObject:self.textEntitlements         forKey:@"textEntitlements"];
    [encoder encodeObject:self.textSubtitle             forKey:@"textSubtitle"];
}
@end
