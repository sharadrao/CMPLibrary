//
//  WaterMarkModel.m
//  CM Library
//
//  Created by vinay.kiran on 7/25/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import "WaterMarkModel.h"

@implementation WaterMarkModel

@synthesize contentTypeId,eventId,ruleObject,actualText,fontFamily,fontSize,horizontalAlignment,verticalAlignment,isCustom,landscapeRotation,potraitRotation,opacity,stroke,strokeSize,watermarkText,textColor,xOffset,yOffset,watermarkPosition,watermarkBackgroundColor,isTimeStampEnabled,isWatermarkEnabled;

#pragma mark - self methods
-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.actualText             =   @"";
        self.fontFamily             =   @"";
        self.horizontalAlignment    =   @"";
        self.verticalAlignment      =   @"";
        self.watermarkText          =   @"";
        self.textColor              =   @"";
        self.watermarkPosition      =   @"";
        self.watermarkBackgroundColor =   @"";
        
        self.isCustom           = FALSE;
        self.isTimeStampEnabled = FALSE;
        self.isWatermarkEnabled = FALSE;
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.watermarkText forKey:@"watermarkText"];
    [encoder encodeObject:self.actualText forKey:@"actualText"];
    [encoder encodeObject:self.fontFamily forKey:@"fontFamily"];
    [encoder encodeObject:self.horizontalAlignment forKey:@"horizontalAlignment"];
    [encoder encodeObject:self.verticalAlignment forKey:@"verticalAlignment"];
    [encoder encodeObject:self.stroke forKey:@"stroke"];
    [encoder encodeObject:self.textColor forKey:@"textColor"];
    [encoder encodeObject:self.watermarkPosition forKey:@"watermarkPosition"];
    [encoder encodeObject:self.watermarkBackgroundColor forKey:@"watermarkBackgroundColor"];
    
    [encoder encodeInteger:self.contentTypeId forKey:@"contentTypeId"];
    [encoder encodeInteger:self.eventId forKey:@"eventId"];
    [encoder encodeInteger:self.ruleObject forKey:@"ruleObject"];
    [encoder encodeInteger:self.landscapeRotation forKey:@"landscapeRotation"];
    [encoder encodeInteger:self.potraitRotation forKey:@"potraitRotation"];
    [encoder encodeInteger:self.strokeSize forKey:@"strokeSize"];
    [encoder encodeInteger:self.xOffset forKey:@"xOffset"];
    [encoder encodeInteger:self.yOffset forKey:@"yOffset"];
    [encoder encodeInteger:self.fontSize forKey:@"fontSize"];
    [encoder encodeFloat:self.opacity forKey:@"opacity"];
    
    [encoder encodeBool:self.isWatermarkEnabled forKey:@"isWatermarkEnable"];
    [encoder encodeBool:self.isCustom forKey:@"isCustom"];
    [encoder encodeBool:self.isTimeStampEnabled forKey:@"isTimeStampEnabled"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if(self)
    {
        self.watermarkText                  = [decoder decodeObjectForKey:@"watermarkText"];
        self.actualText                     = [decoder decodeObjectForKey:@"actualText"];
        self.fontFamily                     = [decoder decodeObjectForKey:@"fontFamily"];
        self.horizontalAlignment            = [decoder decodeObjectForKey:@"horizontalAlignment"];
        self.verticalAlignment              = [decoder decodeObjectForKey:@"verticalAlignment"];
        self.stroke                         = [decoder decodeObjectForKey:@"stroke"];
        self.textColor                      = [decoder decodeObjectForKey:@"textColor"];
        self.watermarkPosition              = [decoder decodeObjectForKey:@"watermarkPosition"];
        self.watermarkBackgroundColor       = [decoder decodeObjectForKey:@"watermarkBackgroundColor"];
        
        self.contentTypeId                  = [decoder decodeIntegerForKey:@"contentTypeId"];
        self.eventId                        = [decoder decodeIntegerForKey:@"eventId"];
        self.ruleObject                     = [decoder decodeIntegerForKey:@"ruleObject"];
        self.landscapeRotation              = [decoder decodeIntegerForKey:@"landscapeRotation"];
        self.potraitRotation                = [decoder decodeIntegerForKey:@"potraitRotation"];
        self.strokeSize                     = [decoder decodeIntegerForKey:@"strokeSize"];
        self.xOffset                        = [decoder decodeIntegerForKey:@"xOffset"];
        self.yOffset                        = [decoder decodeIntegerForKey:@"yOffset"];
        self.fontSize                       = [decoder decodeIntegerForKey:@"fontSize"];
        self.opacity                        = [decoder decodeFloatForKey:@"opacity"];
        
        self.isWatermarkEnabled             = [decoder decodeBoolForKey:@"isWatermarkEnabled"];
        self.isCustom                       = [decoder decodeBoolForKey:@"isCustom"];
        self.isTimeStampEnabled             = [decoder decodeBoolForKey:@"isTimeStampEnabled"];
        
    }
    
    return self;
}

-(void)dealloc
{
    self.actualText                 =   nil;
    self.fontFamily                 =   nil;
    self.horizontalAlignment        =   nil;
    self.verticalAlignment          =   nil;
    self.watermarkText              =   nil;
    self.textColor                  =   nil;

    self.watermarkPosition          =   nil;
    self.watermarkBackgroundColor   =   nil;
}

@end
