//
//  WaterMarkModel.h
//  CM Library
//
//  Created by vinay.kiran on 7/25/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaterMarkModel : NSObject

@property (nonatomic, assign) NSInteger         contentTypeId;
@property (nonatomic, assign) NSInteger         eventId;
@property (nonatomic, assign) NSInteger         ruleObject;
@property (nonatomic, assign) NSInteger         landscapeRotation;
@property (nonatomic, assign) NSInteger         potraitRotation;
@property (nonatomic, assign) float             opacity;
@property (nonatomic, assign) NSInteger         strokeSize;
@property (nonatomic, assign) NSInteger         xOffset;
@property (nonatomic, assign) NSInteger         yOffset;
@property (nonatomic, assign) NSInteger         fontSize;

@property (nonatomic, strong) NSString          *actualText;
@property (nonatomic, strong) NSString          *fontFamily;
@property (nonatomic, strong) NSString          *horizontalAlignment;
@property (nonatomic, strong) NSString          *verticalAlignment;
@property (nonatomic, strong) NSString          *stroke;
@property (nonatomic, strong) NSString          *watermarkText;
@property (nonatomic, strong) NSString          *textColor;
@property (nonatomic, strong) NSString          *watermarkPosition;
@property (nonatomic, strong) NSString          *watermarkBackgroundColor;


@property (nonatomic, assign) BOOL              isCustom;
@property (nonatomic, assign) BOOL              isWatermarkEnabled;
@property (nonatomic, assign) BOOL              isTimeStampEnabled;
@end
