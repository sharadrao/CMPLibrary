//
//  CMPPlayerTrackCell.m
//  PlayerTest
//
//  Created by sharad.rao on 27/04/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import "CMPPlayerTrackCell.h"

@implementation CMPPlayerTrackCell

#pragma mark - Public Methods
-(void)setPlayerTrackSelection:(BOOL)isSelection
{
    UIColor * buttonTitleColor  = [UIColor whiteColor];
    NSString *imageName         = @"normalButton";
    
    if (isSelection)
    {
        buttonTitleColor       = [UIColor colorWithRed:41.0f/255.0f green:185.0f/255.0f blue:248.0f/255.0f alpha:1.0f];
        imageName              = @"selectedButton";
    }
    [self.trackButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.trackButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
}

-(void)setPlayerTrackTitle:(NSString*)title {
    [self.trackButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - self methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[self.trackButton layer] setCornerRadius:5.0f];
    [[self.trackButton layer] masksToBounds];
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    
    return self;
}

-(void)dealloc {    
}


@end
