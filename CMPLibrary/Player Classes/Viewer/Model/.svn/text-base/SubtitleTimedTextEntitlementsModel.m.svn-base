//
//  SubtitleTimedTextEntitlementsModel.m
//  ClearBC
//
//  Created by Damodar Namala on 13/01/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//

#import "SubtitleTimedTextEntitlementsModel.h"

@implementation SubtitleTimedTextEntitlementsModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _text                           = @"";
        _lineNumber                     = @"";
        _formatingTextEntitlements      = [[NSMutableArray alloc] init];

    }
    return self;
}
-(void)dealloc {
    _text                           = nil;
    _lineNumber                     = nil;
    _formatingTextEntitlements      = nil;

}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        self.text                       =       [decoder decodeObjectForKey:@"text"];
        self.lineNumber                 =       [decoder decodeObjectForKey:@"lineNumber"];
        self.formatingTextEntitlements  =       [decoder decodeObjectForKey:@"formatingTextEntitlements"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.text                             forKey:@"text"];
    [encoder encodeObject:self.lineNumber                       forKey:@"lineNumber"];
    [encoder encodeObject:self.formatingTextEntitlements        forKey:@"formatingTextEntitlements"];
}

@end
