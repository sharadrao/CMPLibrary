//
//  CBCScreenerPopUpContainer.m
//  CM Library
//
//  Created by Girish G on 29/12/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import "PopupContainer.h"
#import "PopupDelegate.h"
#import "PlayerProductConstants.h"
#import "PlayerUtilities.h"
#import "ScreenerPopUpController.h"

@interface PopupContainer ()

@property (nonatomic, weak)     id <PopupDelegate>   delegate;
@property (nonatomic, assign)   NSInteger               popupType;

@property (nonatomic, weak) NSString    *filterPublishUserLabel;

@property (nonatomic, strong)   UIViewController        *controller;

@property (nonatomic, weak) id  info;

@end

@implementation PopupContainer

#pragma mark - private methods
-(void)initHUD
{
    //_controller = [self getCurrentController];
    
    CGSize popupSize = [[_controller view] bounds].size;    
    if([_delegate respondsToSelector:@selector(setContentSize:)]) {
        [_delegate setContentSize:popupSize];
    }
    
    //[self.view addSubview:_controller.view];
    
    //[self.view.layer setCornerRadius:3.3f];
    //[self.view.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
}

/*
-(UIViewController*)getCurrentController
{
    UIViewController    *newController = nil;
    
    switch (_popupType)
    {
        case PLAYER_CBC_POPUP_SCREENER_EXPIRE_NOW:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_SCREENER_EXPIRE_NOW_POPUP];
            break;
        case PLAYER_CBC_POPUP_SCREENER_EXPIRY_DETAILS:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_EXPIRY_DETAILS_POPUP];
            break;
        case PLAYER_CBC_POPUP_SCREENER_PUBLISH_TO:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_PUBLISHED_TO_POPUP];
            break;
        case PLAYER_CBC_POPUP_SCREENER_REQUEST_NEW_LINK:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_REQUEST_NEW_LINK_POPUP];
            break;
        case PLAYER_CBC_POPUP_SCREENER_REQUEST_EXTENSION:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_REQUEST_EXTENSION_POPUP];
            break;
        case PLAYER_CBC_POPUP_SCREENER_EXTEND_EXPIRY:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_EXTENSION_EXPIRY];
            break;
        case PLAYER_CBC_POPUP_SCREENER_EXTENSION_REQUESTED:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_EXTENSION_REQUEST];
            break;
        case PLAYER_CBC_POPUP_SCREENER_FILTER_POPUP:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_SCREENER_FILTER_POPUP];
            break;
        case PLAYER_CBC_POPUP_SCREENER_SHARE_POPUP:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_SHARE_POPUP];
            break;
        case PLAYER_CBC_POPUP_SCREENER_SHARED_DETAILS_POPUP:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SCREENER_SHARED_DETAILS_POPUP];
            break;
        case PLAYER_CL_POPUP_LOGIN_HELP:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_LOGIN_HELP_POPUP];
            break;
        case PLAYER_CL_POPUP_LOGIN_TERMS_OF_USE:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_LOGIN_TERMS_OF_USER_POPUP];
            break;
        case PLAYER_CL_POPUP_LOGIN_PRIVACY_POLICY:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_LOGIN_PRIVACY_POLICY_POPUP];
            break;
        case PLAYER_CL_POPUP_SEND_FOR_REVIEW:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_SEND_FOR_REVIEW_POPUP];
            break;
        case PLAYER_CL_REVIEW_POPUP:
            newController = [PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_REVIEW_POPUP];
            break;
        case PLAYER_CL_USER_STATUS_DESCRIPTION_NOTICE:
            newController = [PlayerUtilities getControllerWithStoryBoardId:CL_USER_STATUS_DESCRIPTION_POPUP];
            break;
        case PLAYER_CL_POPUP_CONFIRM_EDIT_TIME_CODE:
            newController = [PlayerUtilities getControllerWithStoryBoardId:CL_CONFIRM_EDIT_TIMECODE_CONTROLLER_STORYBOARD_ID];
            break;
        case PLAYER_CL_POPUP_ADD_COMMENT:
            newController = [PlayerUtilities getControllerWithStoryBoardId:CL_ADDCOMMENT_IPHONE];
            break;
        case PLAYER_CBC_ICAROUSEL:
            newController = [PlayerUtilities getControllerWithStoryBoardId:CBC_ICAROUSEL_POPUP_STORYBOARD_ID];
            break;
        case PLAYER_CBC_POPUP_SCREENER_DOWNLOAD:
            newController = [PlayerUtilities getControllerWithStoryBoardId:CBC_POPUP_SCREENER_DOWNLOAD_STORYBOARD_ID];
            break;
        case PLAYER_CBC_MAIL_IDS:
            newController = [PlayerUtilities getControllerWithStoryBoardId:CBC_MAIL_IDS_POPUP_STORYBOARD_ID];
            break;
        default:
            break;
    }
    
    [(ScreenerPopUpController*) newController setDelegate:_delegate];
    [(ScreenerPopUpController*) newController setPublishLabelinFilter:_filterPublishUserLabel];
    [(ScreenerPopUpController*) newController getInfoForPopups:_info];
    
    return newController;
}
*/

#pragma mark - public methods
-(void)setDelegate:(id)delegate popup:(NSInteger)popupType
{
    _delegate   =   delegate;
    _popupType  =   popupType;
}

-(void)filterUserLabel:(NSString*)lableText {
    _filterPublishUserLabel = lableText;
}

-(void)getInfoForPopup:(id)info {
    _info = info;
}

#pragma mark - self methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view.layer setCornerRadius:3.3f];
    [self.view.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    
    [self initHUD];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    
}

@end
