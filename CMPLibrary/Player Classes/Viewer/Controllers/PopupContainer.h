//
//  PopupContainer.h
//  CM Library
//
//  Created by Saravana Kumar on 12/31/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupContainer : UIViewController

-(void)setDelegate:(id)delegate popup:(NSInteger)popupType;
-(void)filterUserLabel:(NSString*)lableText;
-(void)getInfoForPopup:(id)info;

@end
