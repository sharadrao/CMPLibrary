//
//  CMWaterMarkView.m
//  CM Library
//
//  Created by Paridhi Malviya on 2/2/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import "WaterMarkView.h"
#import "PlayerProductConstants.h"
#import "PlayerCache.h"
#import "Base64.h"
#import "NSData+MD5.h"
#import "PlayerUtilities.h"

@interface WaterMarkView ()

@property (nonatomic, assign) CGRect                    videoRect;
@property (nonatomic, assign) NSInteger                 newLines;
@property (nonatomic, assign) BOOL                      isTimeCodeEnabled;

@property (nonatomic, strong) NSTimer                   *Timer;
@property (nonatomic, strong) NSString                  *userName;
@property (nonatomic, strong) NSMutableDictionary       *attributes;
@property (nonatomic, strong) NSString                  *dateFormat;
@property (nonatomic, strong) NSString                  *fontSize;


@end


@implementation WaterMarkView

#pragma mark - self methods
-(id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    
    if (self) {
        [self initHUD];
    }
    
    return  self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initHUD];
    }
    
    return  self;
}

-(void)removeWaterMarkView
{
    [_Timer invalidate];
    _Timer          = nil;
    
    _attributes     = nil;
}

#pragma mark - private methods
- (void)initHUD {
    _attributes     = [[NSMutableDictionary alloc]init];
}

-(void)layoutSubviews
{
    [self layoutIfNeeded];
    [self watermarkTimeCode];
}


#pragma mark - Watermark Time/Timer Methods
/*
 Method to Initiate Timer for Timecode
 Output     - Return the size to used based on fontSize value
 */

-(void)initTimer
{
    [self watermarkTimeCode];
    
    if (!_Timer)
    {
        _Timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(watermarkTimeCode) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_Timer forMode:NSRunLoopCommonModes];
    }
}

/*
 Method to set TimeCode for Watermark Text
 Output     - Update the the Watermark Label Text with Current Timecode
 */
-(void)watermarkTimeCode
{
    if ([_watermarkLabel.text length]) {
        //[_watermarkLabel setText:[self watermarkText]];
        [_watermarkLabel setAttributedText:[self getWaterMarkAttributedText]];
    }
}

/*
 Method to get TimeCode for Watermark Text
 Output     - Returns the Timecode based on Timezone specified
 */
-(NSString*)getTimeCode
{
    NSString        *timeCode;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    
    timeCode      = [dateFormatter stringFromDate:[NSDate date]];
    timeCode      = [PlayerUtilities convertResponseDateToUserPreferredTimeZone:timeCode withDateFormat:self.dateFormat
                                                                     sourceTimezone:@"UTC-10:00" preferedTimeZone:@"UTC+05:30"];
    if ([timeCode length] > 0) {
        return timeCode;
    }
    else{
        return @"";
    }
}


#pragma mark - public methods
//Watermark on player with Offset/Postion Implementation
-(void)renderWatermark:(isSuccess)isSuccess
{
    if ([[self delegate] respondsToSelector:@selector(getVideoRect)]) {
        _videoRect = [[self delegate] getVideoRect];
    }
    
    if ((_videoRect.size.width <= 0)||(_videoRect.size.height <= 0)||isnan(_videoRect.size.width)||isinf(_videoRect.size.width)||isnan(_videoRect.size.height)||isinf(_videoRect.size.height))
    {
        isSuccess(NO);
        return;
    }
    
    if(self.waterMarkModel)
    {
        [self performSelector:@selector(waterMarkSecureDataAndDisplay:) withObject:self.waterMarkModel afterDelay:0.01f];
        isSuccess(YES);
    }
}

#pragma mark - WaterMark Font Size Methods
//Calulating the WaterMark Font Size based on width and Height.
-(UIFont *)getWaterMarkFontWithName:(NSString *)fontName forLabelSize:(CGSize)labelSize
{
    UIFont *tempFont = nil;
    NSString *variableText      = [self getTimeCode];
    
    if([variableText length] < [_userName length]) {
        variableText = _userName;
    }
    
    NSInteger minFont = 8;                      
    NSInteger maxFont = 256;
   
    NSInteger mid = 0;
    NSInteger difference = 0;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    //Calculating Font Size based on the Hieght
    while (minFont <= maxFont)
    {
        mid = minFont + (maxFont - minFont) / 2;
        tempFont = [UIFont fontWithName:fontName size:mid];
        dictionary[NSFontAttributeName] = tempFont;
        difference = labelSize.height - [variableText sizeWithAttributes:dictionary].height;
        
        if (mid == minFont || mid == maxFont) {
            if (difference < 0)
            {
                mid = mid - 1;
                break;
            }
            break;
        }
        
        if (difference < 0) {
            maxFont = mid - 1;
        } else if (difference > 0) {
            minFont = mid + 1;
        } else {
            break;
        }
    }
    
    //Calculating Font Size based on the Width
    return [self getFontForMinimalScaleFactor:mid size:labelSize text:variableText];
}

//Calulating the WaterMark Font Size based on Height.
-(UIFont *)getFontForMinimalScaleFactor:(CGFloat)fontSize size:(CGSize)labelSize text:(NSString *)testString
{
    NSMutableDictionary *attri = [[NSMutableDictionary alloc]initWithDictionary:_attributes];
    attri[NSFontAttributeName] = [UIFont fontWithName:self.waterMarkModel.fontFamily size:fontSize];
    
    CGSize unadjustedSize = [testString sizeWithAttributes:attri];
    CGFloat scaleFactor = labelSize.width / unadjustedSize.width;
    
    // Respect minimumScaleFactor
    scaleFactor = MAX(scaleFactor, _watermarkLabel.minimumScaleFactor);
    
    CGFloat newFontSize = fontSize * scaleFactor;
    
    return [UIFont fontWithName:self.waterMarkModel.fontFamily size:newFontSize];
}

-(NSAttributedString*)getWaterMarkAttributedText
{
    NSAttributedString *attributedText ;
    
    if(!_isTimeCodeEnabled)
    {
        attributedText = [[NSAttributedString alloc]initWithString:_userName attributes:_attributes];
        return attributedText;
    }
    
    NSString *watermark     = [NSString stringWithFormat:@"%@\n%@", _userName, [self getTimeCode]];
    attributedText          = [[NSAttributedString alloc]initWithString:watermark attributes:_attributes];
    
    return attributedText;
}

/*
    Mehtod Calls when GetSecureInfo API returns Response
*/
-(void)waterMarkSecureDataAndDisplay:(WaterMarkModel*)waterMarkModel
{
    if (!waterMarkModel) {
        return;
    }
    
    if (self.waterMarkModel.isWatermarkEnabled) // if isenabled is true means only we allow to display the water mark
    {
        _isTimeCodeEnabled = self.waterMarkModel.isTimeStampEnabled;
        
        if ([self.waterMarkModel.watermarkBackgroundColor length])    //setting BG color
        {
            //Converting hexa decimal to RGB Values
            UIColor *color = [UIColor redColor];//[UIColor colorFromHexString:self.waterMarkModel.watermarkBackgroundColor setAlpha:1.0];
            [_containerView setBackgroundColor:color];
        }
        
        if([self.waterMarkModel.textColor length]) // setting color for name and time label
        {
            float backgroundOpacityFloatValue = 0.75f;
            
            if (self.waterMarkModel.opacity) {
                backgroundOpacityFloatValue = self.waterMarkModel.opacity ;
            }
            
            //Converting hexa decimal to RGB Values
            UIColor *color = [UIColor redColor];//[UIColor colorFromHexString:self.waterMarkModel.textColor setAlpha:backgroundOpacityFloatValue];
            [_watermarkLabel setTextColor:color];
        }
    
        _attributes[NSFontAttributeName] = self.waterMarkModel.fontFamily;
        [self setWaterMarkPosition];
        
        if (_isTimeCodeEnabled) {
            [self initTimer];
        }
        [_containerView setHidden:NO];
    }
    else {
        [_containerView setHidden:YES];
    }
}

-(void)setWaterMarkPosition
{
    NSArray *array      =  [[self.waterMarkModel.actualText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@"#"];
    _userName           = [array firstObject];
    
    NSString *time;
    NSString *date;
    if ([self.waterMarkModel isTimeStampEnabled] && [array count ])
    {
        NSString *format;
        for (NSString *arrayObj in array)
        {
            format = [arrayObj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([format rangeOfString:@"DATE"].location != NSNotFound)
            {
                if (![format caseInsensitiveCompare:@"DATEYYYYMMDD"]) {
                    date = DATEYYYYMMDD;
                }
                else if(![format caseInsensitiveCompare:@"DATEDDMMYYYY"]){
                    date = DATEDDMMYYYY;
                }
                else if(![format caseInsensitiveCompare:@"DATEMMDDYYYY"]){
                    date = DATEMMDDYYYY;
                }
            }
            else if([format rangeOfString:@"TIME"].location != NSNotFound)
            {
                if (![format caseInsensitiveCompare:@"TIME12"]) {
                    time = TIME12;
                }
                else if(![format caseInsensitiveCompare:@"TIME24"]){
                    time = TIME24;
                }
            }
        }
    }
    if ((time != nil)&&(date != nil)) {
        _dateFormat =[NSString stringWithFormat:@"%@ %@",date,time];
    }
    else if (date != nil) {
        _dateFormat =[NSString stringWithFormat:@"%@",date];
        
    }
    else if(time != nil){
        _dateFormat =[NSString stringWithFormat:@"%@",time];
    }
    else{
        _dateFormat = DATE_FORMAT;
    }

    CGFloat size        = self.waterMarkModel.fontSize * 0.01f;
    _newLines           = [self getNewLinesCountFromString:self.waterMarkModel.actualText];
    
    if ([self.waterMarkModel.stroke caseInsensitiveCompare:@"Fill"])
    {
        _attributes[NSStrokeWidthAttributeName] = [NSString stringWithFormat:@"%ld",(long)self.waterMarkModel.strokeSize];
        _attributes[NSStrokeColorAttributeName] = self.waterMarkModel.textColor;
    }
    
    if ((self.waterMarkModel.xOffset != -1)) {
        [self setWaterMarkViewPositionVideo:size withOffset:0.0f andxoffset:self.waterMarkModel.xOffset andyoffset:self.waterMarkModel.yOffset];
    }
    else
    {
        if ((self.waterMarkModel.potraitRotation != 0) || (self.waterMarkModel.landscapeRotation != 0)) {
            [self setWaterMarkViewPosition:self.waterMarkModel.watermarkPosition size:size withOffset:0.0f andAngle:[self getRotationAngle]];
        }
        else {
            [self setWaterMarkViewPosition:self.waterMarkModel.watermarkPosition size:size withOffset:0.0f andAngle:0];
        }
    }
}

/*
 Method to Initiate Watermark on Video/Image/PDF Viewer
 Output     - Sets the Watermark text to Label. Internally calls the
                [CMWatermarkView setWaterMarkViewPosition:size:withOffset: andAngle:]
 */
//-(void)setCMWaterMarkPosition
//{
//    _userName      = [self.waterMarkModel.actualText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    CGFloat size   = [self getWaterMarkSize:_fontSize];
//    _newLines      = [self getNewLinesCountFromString:self.waterMarkModel.actualText];
//    
//  
//    [self setWaterMarkViewPosition:self.waterMarkModel.watermarkPosition size:size withOffset:0.03f andAngle:0];
//}

- (NSInteger)getNewLinesCountFromString:(NSString*)string {
    return [[string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
}


/*
 Method to get Watermark Font Size     - (Clear Boardcast)
 @pramas
 fontSize   - Value define with string macro
 Output     - Return the size to used based on fontSize value
 */

-(CGFloat)getWaterMarkSize:(NSString*)fontSize
{
    CGFloat size = MEDIUM;
    
    if([[fontSize uppercaseString] isEqualToString:@"XSMALL"]) {
        size = XSMALL;
    }
    else if ([[fontSize uppercaseString] isEqualToString:@"SMALL"]) {
        size = SMALL;
    }
    else if ([[fontSize uppercaseString] isEqualToString:@"MEDIUM"]) {
        size = MEDIUM;
    }
    else if ([[fontSize uppercaseString] isEqualToString:@"LARGE"]) {
        size = LARGE;
    }
    else if ([[fontSize uppercaseString] isEqualToString:@"XLARGE"]) {
        size = XLARGE;
    }
    
    return size;
}

/*
 Method to Perform WaterMark Based on Offset (Position and Percentage Ratio)
 @pramas
 position   - Watermark Position on visible video rect
 size       - Percentage Ration for Watermark based on visible video rect
 offset     - Padding relative to the visible video rect
 angle      - Angle to rotate watermark on visible video rect. 
              Uages : To calculate the  roated width in visible video rect
 */

-(void)setWaterMarkViewPosition:(NSString *)position size:(CGFloat)size withOffset:(CGFloat)offset andAngle:(CGFloat)angle
{
    CGFloat xOffset = _videoRect.size.width * offset;
    CGFloat yOffset = _videoRect.size.height * offset;
    
    if(position.length == 0 || [position isEqualToString:@" "]) {
        position = CENTER;
    }
    
    CGFloat width = 0.0f, height = 0.0f;

    width  = [PlayerUtilities getWaterMarkWidth:angle withRect:_videoRect andWidthFactor:size * 100];
    height = _videoRect.size.height * WATERMARK_HEIGHT;

    //Get Font Size based on the Width and height and update to Watermark Label
    _attributes[NSFontAttributeName] = [self getWaterMarkFontWithName:self.waterMarkModel.fontFamily forLabelSize:CGSizeMake(width, height)];
    [_watermarkLabel setAttributedText:[self getWaterMarkAttributedText]];

    //Height Adjustment based on the Watermark Text
    CGFloat newHeight = [[_watermarkLabel text] sizeWithAttributes:_attributes].height;
    if (newHeight < height) {
        height = newHeight;
    }
    
    CGFloat xPos   =  xOffset;
    CGFloat yPos   =  yOffset;
    
    if(_isTimeCodeEnabled) {
        offset = height * 0.5f;
    }
    else {
        offset = height;
    }
    
    offset = 0;
    
    if ([position isEqualToString:BOTTOM_RIGHT])
    {
        [_watermarkLabel setTextAlignment:NSTextAlignmentRight];
        
        xPos = ((_videoRect.origin.x + _videoRect.size.width)  - width)  - xOffset;
        yPos = ((_videoRect.origin.y + _videoRect.size.height) - height) - yOffset - offset;
    }
    else if ([position isEqualToString:BOTTOM_LEFT])
    {
        [_watermarkLabel setTextAlignment:NSTextAlignmentLeft];
        
        xPos = _videoRect.origin.x + xOffset;
        yPos = ((_videoRect.origin.y + _videoRect.size.height) - height) - yOffset - offset;
    }
    else if ([position isEqualToString:TOP_RIGHT])
    {
        [_watermarkLabel setTextAlignment:NSTextAlignmentRight];
        
        xPos = ((_videoRect.origin.x + _videoRect.size.width) - width) - xOffset;
        yPos = _videoRect.origin.y + yOffset + offset;
    }
    else if ([position isEqualToString:TOP_LEFT])
    {
        [_watermarkLabel setTextAlignment:NSTextAlignmentLeft];
        
        xPos = _videoRect.origin.x + xOffset;
        yPos = _videoRect.origin.y + yOffset;
    }
    else if ([position isEqualToString:CENTER])
    {
        [_watermarkLabel setTextAlignment:NSTextAlignmentCenter];
        
        xPos = ((_videoRect.origin.x + (_videoRect.size.width  * 0.5f)) - (width * 0.5f));
        yPos = ((_videoRect.origin.y + (_videoRect.size.height * 0.5f)) - (height * 0.5f)) + offset;
    }
    else if ([position isEqualToString:CENTER_TOP])
    {
        [_watermarkLabel setTextAlignment:NSTextAlignmentCenter];
        
        xPos = ((_videoRect.origin.x + (_videoRect.size.width * 0.5f)) - (width * 0.5f));
        yPos = _videoRect.origin.y + yOffset + offset;
    }
    else if ([position isEqualToString:CENTER_BOTTOM])
    {
        [_watermarkLabel setTextAlignment:NSTextAlignmentCenter];
        
        xPos = (_videoRect.origin.x + (_videoRect.size.width * 0.5f) - (width * 0.5f));
        yPos = ((_videoRect.origin.y + _videoRect.size.height) - (height)) - yOffset - offset;
    }
    else if ([position isEqualToString:CENTER_LEFT])
    {
        [_watermarkLabel setTextAlignment:NSTextAlignmentLeft];
        
        xPos = _videoRect.origin.x + xOffset;
        yPos = ((_videoRect.origin.y + (_videoRect.size.height * 0.5f)) - (height * 0.5f)) + offset;
    }
    else if ([position isEqualToString:CENTER_RIGHT])
    {
        [_watermarkLabel setTextAlignment:NSTextAlignmentRight];
        
        xPos = ((_videoRect.origin.x + _videoRect.size.width)  - width) - xOffset;
        yPos = ((_videoRect.origin.y + (_videoRect.size.height * 0.5f)) - (height * 0.5f)) + offset;
    }

    if (angle !=0)
    {
        if ([[self delegate] respondsToSelector:@selector(updateWatermarkWithRect:andAngle:)])
        {
            CGRect sourceRect = CGRectMake(xPos, yPos, width, height);
            [[self delegate] updateWatermarkWithRect:sourceRect andAngle:angle];
        }
    }
    else
    {
        if([[self delegate] respondsToSelector:@selector(updateWatermarkRect:)]) {
            [[self delegate] updateWatermarkRect:CGRectMake(xPos, yPos, width, height)];
        }
    }
    
    [_containerView updateConstraintsIfNeeded];
    [_containerView setNeedsLayout];
    
    [self watermarkTimeCode];
}


/*
    Method to Perform WaterMark Based on Offset (i.e., xAxis and yAxis)
    @pramas
    size    - Percentage Ration for Watermark based on visible video rect
    offx    - X Axis relative to the visible video rect
    offy    - Y Axis relative to the visible video rect
    offset  - Padding relative to the visible video rect
*/

-(void)setWaterMarkViewPositionVideo:(CGFloat)size withOffset:(CGFloat)offset andxoffset:(CGFloat)offx andyoffset:(CGFloat)offy
{
    //watermark width and height should be ratio of video rect 20 %
    CGFloat width = 0.0f, height = 0.0f;
    
    width  = [PlayerUtilities getWaterMarkWidth:0 withRect:_videoRect andWidthFactor:size * 100];
    height = _videoRect.size.height * WATERMARK_HEIGHT;

    _attributes[NSFontAttributeName] = [self getWaterMarkFontWithName:self.waterMarkModel.fontFamily forLabelSize:CGSizeMake(width, height)];
    [_watermarkLabel setAttributedText:[self getWaterMarkAttributedText]];
    
    CGFloat nHeight = [[_watermarkLabel text] sizeWithAttributes:_attributes].height;
    if (nHeight < height) {
        height = nHeight;
    }

    CGFloat x = (_videoRect.size.width * offx * 0.01f) + _videoRect.origin.x;
    CGFloat y = (_videoRect.size.height * offy * 0.01f) + _videoRect.origin.y;
  
    
    BOOL isOutOfView = false;
    if((x+width) > (_videoRect.size.width + _videoRect.origin.x))
    {
        x = x - ((x + width) - _videoRect.size.width);
        isOutOfView = YES;
    }
    
    if ((y + height) > (_videoRect.size.height + _videoRect.origin.y)) {
        y = y - ((y + height) - _videoRect.size.height);
    }
    
    if((x+width) > _videoRect.size.width) {
        x = x - ((x + width) - _videoRect.size.width) - offset;
    }
    
    if ((y + height) > _videoRect.size.height)
    {
        y = y - ((y + height) - _videoRect.size.height) - offset;
        isOutOfView = YES;
    }
    
    if (isOutOfView) {
        [_watermarkLabel setTextAlignment:NSTextAlignmentRight];
    }
    else if ((x + (width * 0.5f)) > (_videoRect.size.width * 0.7f)) {
        [_watermarkLabel setTextAlignment:NSTextAlignmentRight];
    }
    else if ((x + (width * 0.5f)) < (_videoRect.size.width * 0.3f)){
        [_watermarkLabel setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [_watermarkLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    if([[self delegate] respondsToSelector:@selector(updateWatermarkRect:)]) {
        [[self delegate] updateWatermarkRect:CGRectMake(x, y, width, height)];
    }
    
    [_containerView updateConstraintsIfNeeded];
    [_containerView setNeedsLayout];
    
    [self watermarkTimeCode];
}

/*
 Method to Fetch the Watermark Rotation Angle Value
 Output    -  Returns the roatation angle Value based the visbale Video Rect
 */
-(CGFloat)getRotationAngle
{
    if (_videoRect.size.height > _videoRect.size.width) {
        return self.waterMarkModel.potraitRotation;
    }
    else{
        return self.waterMarkModel.landscapeRotation;
    }
}

@end

