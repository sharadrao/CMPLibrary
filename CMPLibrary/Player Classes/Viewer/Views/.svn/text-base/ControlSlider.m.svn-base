//
//  ControlSlider.m
//  ClearBCProduct
//
//  Created by Vital on 30/07/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import "ControlSlider.h"
#import "PlayerProductConstants.h"

#define CBC_SLIDER_HANDLE(__TYPE__) [NSString stringWithFormat:@"control_slider_handle_%d", __TYPE__]
#define CBC_SLIDER_MIN(__TYPE__)    [NSString stringWithFormat:@"control_slider_min_%d", __TYPE__]
#define CBC_SLIDER_MAX(__TYPE__)    [NSString stringWithFormat:@"control_slider_max_%d", __TYPE__]

@interface ControlSlider ()

@property (nonatomic, assign) int  style;
@property (nonatomic, assign) BOOL seekingActionCompleted;

@end

@implementation ControlSlider

#pragma mark - Private methods

#pragma mark - Public methods
-(void)setControlStyle:(int)style
{
    _style = style;

    UIImage *minImg     = [UIImage imageNamed:CBC_SLIDER_MIN(style)];
    UIImage *maxImg     = [UIImage imageNamed:CBC_SLIDER_MAX(style)];
    UIImage *thumbImg   = [UIImage imageNamed:CBC_SLIDER_HANDLE(style)];
    
    //To change of progress bar onlly for lighting app players
    if (_style == PLAYER_SLIDER_CUSTOM_COLOR)
    {
        //Transparent image which can be filled with different color and can be scaled to different size also
        UIImage *image      = [UIImage imageNamed:@"transparent"];
        UIColor *minColor   = [UIColor colorWithRed:21.0/255.0 green:212.0/255.0 blue:243.0/255.0 alpha:1.0];
        UIColor *maxColor   = [UIColor colorWithRed:86.0/255.0 green:86.0/255.0 blue:86.0/255.0 alpha:1.0];

        //Images for max and min ranges of scruber
        minImg              = [self imageWithImage:image scaledToSize:CGSizeMake(2, 2) color:minColor];
        maxImg              = [self imageWithImage:image scaledToSize:CGSizeMake(2, 2) color:maxColor];

        //Image for scruber/thumb
        thumbImg            = [self imageWithImage:thumbImg scaledToSize:CGSizeMake(16, 16) color:minColor];
        thumbImg            = [self getRoundedImage:thumbImg];
    }
    
    minImg  = [minImg stretchableImageWithLeftCapWidth:9 topCapHeight:0];
    maxImg  = [maxImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];

    [self setMinimumTrackImage:minImg forState:UIControlStateNormal];
    [self setMaximumTrackImage:maxImg forState:UIControlStateNormal];
    
    [self setThumbImage:thumbImg forState:UIControlStateNormal];
    [self setThumbImage:thumbImg forState:UIControlStateHighlighted];
    
    //To maintain a flag to find wether user is seeking the scrubber or not
    _seekingActionCompleted = YES;
}

- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize color:(UIColor*)color
{
    //Pass 1.0 to force exact pixel size.
    //Pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    CGContextRef context    = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage       = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*)getRoundedImage:(UIImage*)image
{
    CALayer *imageLayer         = [CALayer layer];
    imageLayer.frame            = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents         = (id) image.CGImage;
    imageLayer.masksToBounds    = YES;
    imageLayer.cornerRadius     = image.size.height / 2;
    imageLayer.shadowColor      = [[UIColor blackColor] CGColor];
    imageLayer.shadowRadius     = 1.0f;
    imageLayer.shadowOpacity    = 1.0f;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage       = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return roundedImage;
}

-(NSString*)getMaxImage {
    return CBC_SLIDER_MIN(_style);
}

-(NSString*)getScrubImage {
    return CBC_SLIDER_HANDLE(_style);
}

-(void)updateThumb:(int)style
{
    [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE(style)] forState:UIControlStateNormal];
    [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE(style)] forState:UIControlStateHighlighted];
}

-(void)updateMinImage:(int)style
{
    /*UIImage *minImg = [[UIImage imageNamed:CBC_SLIDER_MIN(style)] stretchableImageWithLeftCapWidth:9 topCapHeight:0];
    UIImage *maxImg = [[UIImage imageNamed:CBC_SLIDER_MAX(_style)] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE(_style)] forState:UIControlStateNormal];
    [self setThumbImage:[UIImage imageNamed:CBC_SLIDER_HANDLE(_style)] forState:UIControlStateHighlighted];
    
    [self setMinimumTrackImage:minImg forState:UIControlStateNormal];
    [self setMaximumTrackImage:maxImg forState:UIControlStateNormal];*/
}

-(void)updateSlider:(NSInteger)handle withMax:(CGFloat)max andValue:(CGFloat)value
{    
    [self setMaximumValue:max];
    [self setValue:value animated:YES];
}

#pragma mark - self methods
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if([[self delegate] respondsToSelector:@selector(didBeginTrackingProgress:)]) {
        [[self delegate] didBeginTrackingProgress:[self value]];
    }
    
    return [super beginTrackingWithTouch:touch withEvent:event];
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    if([[self delegate] respondsToSelector:@selector(didEndTrackingProgress:)]) {
        [[self delegate] didEndTrackingProgress:[self value]];
    }
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    
//    //To kill the timer to avoid hidding of player controls when is touching on seek bar
//    if([[self delegate] respondsToSelector:@selector(cancelTimerAndReinitiate:)]) {
//        [[self delegate] cancelTimerAndReinitiate:NO];
//    }
//}
//
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    
//    //To initiate the timer to dismiss player controls
//    if([[self delegate] respondsToSelector:@selector(cancelTimerAndReinitiate:)]) {
//        [[self delegate] cancelTimerAndReinitiate:YES];
//    }
//}
//
//-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [super touchesCancelled:touches withEvent:event];
//    
//    //To initiate the timer to dismiss player controls
//    if([[self delegate] respondsToSelector:@selector(cancelTimerAndReinitiate:)]) {
//        [[self delegate] cancelTimerAndReinitiate:YES];
//    }
//}

@end
