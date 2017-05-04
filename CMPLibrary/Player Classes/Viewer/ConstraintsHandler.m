//
//  ConstraintsHandler.m
//  PlayerTest
//
//  Created by Deep Arora on 3/27/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import "ConstraintsHandler.h"

@implementation ConstraintsHandler



-(void)updatePlayerContainerConstraints
{
    NSDictionary *viewsDictionary = @{@"controllerView":_playerContainerView};
    
    [_playerContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    for(NSLayoutConstraint *c in _playerContainerSuperView.constraints)
    {
        if(c.firstItem == _playerContainerView || c.secondItem == _playerContainerView) {
            [_playerContainerSuperView removeConstraint:c];
        }
    }
    
    [_playerContainerSuperView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[controllerView]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:NSDictionaryOfVariableBindings(_playerContainerView) views:viewsDictionary]];
    [_playerContainerSuperView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[controllerView]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:NSDictionaryOfVariableBindings(_playerContainerView) views:viewsDictionary]];
    
    [_playerContainerSuperView setNeedsLayout];
}


-(void)updateSettingsPopupConstraints
{
    NSDictionary *viewsDictionary = @{@"settingsController":_playerSettingscontroller.view};
    
    [_playerSettingscontroller.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    for(NSLayoutConstraint *c in [_settingsHolderView constraints])
    {
        if(c.firstItem == _playerSettingscontroller.view || c.secondItem == _playerSettingscontroller.view) {
            [_settingsHolderView removeConstraint:c];
        }
    }
    
    [_settingsHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[settingsController]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:NSDictionaryOfVariableBindings(_playerSettingscontroller.view) views:viewsDictionary]];
    [_settingsHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[settingsController]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:NSDictionaryOfVariableBindings(_playerSettingscontroller.view) views:viewsDictionary]];
    
    [_settingsHolderView layoutSubviews];
}


-(void)updateWatermarkConstraints
{
    NSDictionary *viewsDictionary = @{@"watermarkView":self.waterMarkView};
    [self.waterMarkView setTranslatesAutoresizingMaskIntoConstraints:NO];
    for(NSLayoutConstraint *c in [self.waterMarkHolderView constraints])
    {
        if(c.firstItem == self.waterMarkView || c.secondItem == self.waterMarkView) {
            [_waterMarkHolderView removeConstraint:c];
        }
    }
    
    [self.waterMarkHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[watermarkView]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:NSDictionaryOfVariableBindings(self.waterMarkView) views:viewsDictionary]];
    [self.waterMarkHolderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[watermarkView]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:NSDictionaryOfVariableBindings(self.waterMarkView) views:viewsDictionary]];
    
    [self.waterMarkHolderView setNeedsLayout];
    
    [self.waterMarkView updateConstraintsIfNeeded];
    [self.waterMarkView setNeedsLayout];
}

-(void)updateSubtitleConstraintsInRect:(CGRect)rect
{
    [self.subtitleView setAlpha:0];
    [self.subtitleView initHUD:rect];
}
@end
