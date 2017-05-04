//
//  SubtitleFormatingTextModel.m
//  ClearBC
//
//  Created by Damodar Namala on 13/01/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//

#import "SubtitleFormatingTextModel.h"

@implementation SubtitleFormatingTextModel
- (instancetype)init
{
    self = [super init];
    if (self) {
       _formatingTextXpos       =   @"";
       _formatingTextYpos       =   @"";
       _formatingTextColor      =   @"";
       _formatingTextRGB        =   @"";
       _formatingTextFontStyle  =   @"";

    }
    return self;
}
-(void)dealloc {

    _formatingTextXpos       =   nil;
    _formatingTextYpos       =   nil;
    _formatingTextColor      =   nil;
    _formatingTextRGB        =   nil;
    _formatingTextFontStyle  =   nil;

}


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        self.formatingTextXpos                  =       [decoder decodeObjectForKey:@"formatingTextXpos"];
        self.formatingTextYpos                  =       [decoder decodeObjectForKey:@"formatingTextYpos"];
        self.formatingTextColor                 =       [decoder decodeObjectForKey:@"formatingTextColor"];
        self.formatingTextRGB                   =       [decoder decodeObjectForKey:@"formatingTextRGB"];
        self.formatingTextFontStyle             =       [decoder decodeObjectForKey:@"formatingTextFontStyle"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.formatingTextXpos                forKey:@"formatingTextXpos"];
    [encoder encodeObject:self.formatingTextYpos                forKey:@"formatingTextYpos"];
    [encoder encodeObject:self.formatingTextColor               forKey:@"formatingTextColor"];
    [encoder encodeObject:self.formatingTextRGB                 forKey:@"formatingTextRGB"];
    [encoder encodeObject:self.formatingTextFontStyle           forKey:@"formatingTextFontStyle"];
}

@end
