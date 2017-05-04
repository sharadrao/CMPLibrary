//
//  ScreenerPopUpController.h
//  CM Library
//
//  Created by Girish G on 29/12/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupDelegate.h"

@interface ScreenerPopUpController : UIViewController

@property (nonatomic, weak) id <PopupDelegate>   delegate;

@property (nonatomic, weak)  NSString  *publishLabel;
@property (nonatomic, weak) id              info;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView   *smallLoadingView;

-(void)showError:(NSString*)errorInfo;
-(void)setPublishLabelinFilter:(NSString *)publishLabel;
-(void)getInfoForPopups:(id)info;
-(IBAction)cancelActionHandler:(id)sender;
 
@end
