//
//  PopupDelegate.h
//  CM Library
//
//  Created by Saravana Kumar on 12/30/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PopupDelegate <NSObject>

@optional
-(void)setContentSize:(CGSize)size;
-(id)getAdditionalInfo;
-(void)offsetPopupWithAnimation:(BOOL)animated withOffset:(CGFloat)offset;
-(void)showAlert:(NSString*)message;
-(void)popOverWillDismiss:(BOOL)animated withInfo:(id)info;
-(void)dismissPopover:(BOOL)animated;
-(void)dismissPopoverWithAlert:(NSString*)alertInfo andInfo:(id)info;
-(void)saveAndCancelComment:(id)commentInfo;
-(void)dismissPopupWithType:(id)popupInfo withType:(NSInteger)type;
-(void)launchEmailIdPopup;

@end
