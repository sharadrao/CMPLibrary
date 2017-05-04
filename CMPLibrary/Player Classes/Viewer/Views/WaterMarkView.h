//
//  CMWaterMarkView.h
//  CM Library
//
//  Created by Paridhi Malviya on 2/2/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterMarkModel.h"

typedef void (^isSuccess)(BOOL success);

@protocol WaterMarkDelegate <NSObject>

@required
-(CGRect)getVideoRect;
-(void)updateWatermarkRect:(CGRect)rect;

@optional
-(void)updateWatermarkPosition:(CGFloat)X YPosition:(CGFloat)Y;
-(void)updateWatermarkWidthHeight:(CGFloat)width height:(CGFloat)height;
-(void)updateWatermarkWithRect:(CGRect)sourceRect andAngle:(CGFloat)angle;

@end

@interface WaterMarkView : UIView

@property (nonatomic, weak) IBOutlet UIView             *containerView;
@property (nonatomic, weak) IBOutlet UILabel            *watermarkLabel;

@property (nonatomic, strong) WaterMarkModel            *waterMarkModel;
@property (nonatomic, strong) NSString                  *sourceTimeZone;        //Format  : UTC-8:00
@property (nonatomic, strong) NSString                  *preferedTimeZone;      //Format  : UTC+5:30


@property (nonatomic, weak) id <WaterMarkDelegate> delegate;

-(void)renderWatermark:(isSuccess)isSuccess;
-(void)removeWaterMarkView;
@end
