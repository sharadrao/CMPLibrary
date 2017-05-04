//
//  ProgressSlider.m
//  ClearBCProduct
//
//  Created by Vital on 30/07/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import "ProgressSlider.h"

#define CBC_SLIDER_HANDLE_COMMON        @"rc_progress_slider_handle"
#define CBC_SLIDER_HANDLE_NONE          @"progress_slider_handle_none"
#define CBC_SLIDER_HANDLE_LEFT          @"rc_progress_slider_handle_left"
#define CBC_SLIDER_HANDLE_RIGHT         @"rc_progress_slider_handle_right"

#define CBC_SLIDER_MIN                  @"rc_progress_slider_min"
#define CBC_SLIDER_MAX                  @"rc_progress_slider_max"

#define CBC_SLIDER_HANDLE_SPORTS         @"thumb_btn"

@interface ProgressSlider ()

@end

@implementation ProgressSlider

#pragma mark - private methods
-(void)setUp
{
    UIImage *minImg = [[UIImage imageNamed:CBC_SLIDER_MIN] stretchableImageWithLeftCapWidth:9 topCapHeight:0];
    UIImage *maxImg = [[UIImage imageNamed:CBC_SLIDER_MAX] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    [self setMinimumTrackImage:minImg forState:UIControlStateNormal];
    [self setMaximumTrackImage:maxImg forState:UIControlStateNormal];
    
    [self setValue:0.0f];

    [self setHandleStyle:HANDLE_STYLE_COMMON];
}

-(void)setHandleStyle:(NSInteger)handleStyle
{
    switch (handleStyle)
    {
        case HANDLE_STYLE_COMMON:
            [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE_COMMON] forState:UIControlStateNormal];
            [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE_COMMON] forState:UIControlStateHighlighted];
            break;
        case HANDLE_STYLE_LEFT:
            [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE_LEFT] forState:UIControlStateNormal];
            [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE_LEFT] forState:UIControlStateHighlighted];
            break;
        case HANDLE_STYLE_RIGHT:
            [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE_RIGHT] forState:UIControlStateNormal];
            [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE_RIGHT] forState:UIControlStateHighlighted];
            break;
        case HANDLE_STYLE_NONE:
            [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE_NONE] forState:UIControlStateNormal];
            [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE_NONE] forState:UIControlStateHighlighted];
            break;
        case HANDLE_STYLE_SPORTS:
            [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE_SPORTS] forState:UIControlStateNormal];
            [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE_SPORTS] forState:UIControlStateHighlighted];

        default:
            break;
    }
}

#pragma mark - public methods
-(void)updateSlider:(NSInteger)handle withMax:(CGFloat)max andValue:(CGFloat)value
{
    [super updateSlider:handle withMax:max andValue:value];
    
    [self setHandleStyle:handle];
}

#pragma mark - self methods
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

@end
