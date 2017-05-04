//
//  ScreenerPopUpController.m
//  CM Library
//
//  Created by Girish G on 29/12/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import "ScreenerPopUpController.h"
//#import "CBCAlertView.h"
#import "PlayerProductConstants.h"

@interface ScreenerPopUpController ()

//@property (nonatomic, strong)           CBCAlertView    *alertView;

@end

@implementation ScreenerPopUpController

#pragma mark - private methods
-(IBAction)cancelActionHandler:(id)sender
{
    if([[self delegate] respondsToSelector:@selector(dismissPopover:)]) {
        [[self delegate] dismissPopover:YES];
    }
}


-(void)getInfoForPopups:(id)info {
    _info = info;
}

-(void)setPublishLabelinFilter:(NSString *)publishLabel {
    _publishLabel = publishLabel;
}

-(void)keyboardWillShow:(NSNotification*)notification {
    
}

-(void)keyboardWillHide:(NSNotification*)notification {
    
}

#pragma mark - public methods
-(void)showError:(NSString*)errorInfo
{
//    if(_alertView) {
//        [_alertView removeFromSuperview];
//    }
//    _alertView = nil;
//        
//    _alertView = [[CBCAlertView alloc] initWithAlert:ALERT_KIND_ERROR andInfo:errorInfo];
//    [self.view addSubview:_alertView];
//    [_alertView show];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:errorInfo,@"key", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_ERROR_ALERT" object:nil userInfo:dict];
}

#pragma mark - self methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    /*
    if(_alertView) {
        [_alertView removeFromSuperview];
    }
    */
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
   // _alertView = nil;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    DLog(@"i called...");
    return (textView.text.length + (text.length - range.length)) <= 140;
}

@end
