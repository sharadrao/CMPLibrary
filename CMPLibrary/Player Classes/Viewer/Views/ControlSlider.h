//
//  ControlSlider.h
//  ClearBCProduct
//
//  Created by Vital on 30/07/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressSliderDelegate <NSObject>

@optional
-(void)didBeginTrackingProgress:(CGFloat)progress;
-(void)didEndTrackingProgress:(CGFloat)seekedTime;

@end


@interface ControlSlider : UISlider

@property (nonatomic, weak) IBOutlet id <ProgressSliderDelegate> delegate;

-(void)setControlStyle:(int)style;
-(void)updateSlider:(NSInteger)handle withMax:(CGFloat)max andValue:(CGFloat)value;
-(void)updateMinImage:(int)style;
-(NSString*)getMaxImage;
-(NSString*)getScrubImage;

@end
