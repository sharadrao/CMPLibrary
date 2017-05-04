//
//  PlayerProductConstants.h
//  ClearBCProduct
//
//  Created by Bishwajit on 7/25/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef void (^CompletionHandler)(id receivedObj, NSUInteger errorCode);
typedef void (^ProgressHandler)(CGFloat progressValue);
typedef void (^downloadedData)(NSData* data);

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define M3U8                                                @"m3u8"
#define MP4                                                 @"MP4"

#define SUBTITLE_CACHE_FILENAME @"SubtitleFile"


#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define STREAM_KEY                                                      @"54G91A8?s7^F97C]Fyj*8&kR2eU+HNg!"
#define HELVETICA_NEUE                                                  @"HelveticaNeue"
#define CMP_EXTERNAL_PAUSE                                              @"cmp_external_pause"

#pragma mark - Player Essence Macros
//Player Essences Macros  ==========================================================================================
#define AUDIO_TRACK_NAME_TRACK                                          @"Track"
#define AUDIO_TRACK_NAME_UNKNOWN_LANGUAGE                               @"Unknown Language"

#pragma mark - Player Storyboard Macros
//Player Controller  ===============================================================================================
#define STORYBOARD_ID_PLAYER_CONTROLLER                                 @"custom_player_controller"

//Player Storyboard
#define IPHONE_STORYBOARD_NAME                                          @"Player_iPhone"
#define IPAD_STORYBOARD_NAME                                            @"Player_iPad"

//Player Controls Controllers
#define PLAYER_CONTROLS_CONTAINER_SEGUE                                 @"viewer_player_controls"
#define STORYBOARD_ID_SCREENER_PREVIEW_CONTROLS                         @"preview_player_controls"
#define STORYBOARD_ID_EXECUTIVE_PLAYER_CONTROLS                         @"executive_player_controls"
#define STORYBOARD_ID_REVIEW_CONTROLS                                   @"review_player_controls"

//Player Setting Controllers
#define STORYBOARD_ID_PLAYER_SETTINGS_POPUP_CONTROLLER                  @"player_settings_popup_controller"
#define STORYBOARD_ID_SCREENER_ANNOTATION_CONTROLS                      @"player_annotations_controls"
#define STORYBOARD_ID_PLAYER_SETTINGS_AUDIO_TRACK_CONTROLLER            @"player_audio_controller"
#define STORYBOARD_ID_PLAYER_SETTINGS_BITRATE_CONTROLLER                @"player_bitrate_controller"
#define STORYBOARD_ID_PLAYER_SETTINGS_SUBTITLES_CONTROLLER              @"player_subtitle_controller"
#define STORYBOARD_ID_PLAYER_SETTINGS_ANNOTATION_CONTROLLER             @"player_annotation_controller"

//PLayer Controls Controllers
#define STORYBOARD_ID_STANDARD_CONTROLS                                 @"standard_player_controls_ss1"
#define STORYBOARD_ID_SCREENER_RANGE_ANNOTATION_CONTROLS                @"screener_player_range_annotations_controls_ss0"
#define STORYBOARD_ID_SCREENER_PUBLISH_CONTROLS                         @"screener_publish_player_controls_ss1"

//Watermark Related Macros ===============================================================================================
#pragma mark - Watermark Macros

#define TOP_LEFT                                                        @"TOP_LEFT"
#define TOP_RIGHT                                                       @"TOP_RIGHT"
#define CENTER                                                          @"CENTER"
#define BOTTOM_LEFT                                                     @"BOTTOM_LEFT"
#define BOTTOM_RIGHT                                                    @"BOTTOM_RIGHT"
#define CENTER_LEFT                                                     @"LEFT"
#define CENTER_RIGHT                                                    @"RIGHT"
#define CENTER_BOTTOM                                                   @"BOTTOM_CENTER"
#define CENTER_TOP                                                      @"TOP_CENTER"

#define XSMALL                                                          0.15
#define SMALL                                                           0.2
#define MEDIUM                                                          0.3
#define LARGE                                                           0.4
#define XLARGE                                                          0.5

#define WATERMARK_HEIGHT                                                0.25

#define TIME24                                                          @"HH:mm:ss"
#define TIME12                                                          @"hh:mm:ss a"
#define DATEYYYYMMDD                                                    @"yyyy:MM:dd"
#define DATEDDMMYYYY                                                    @"dd:MM:yyyy"
#define DATEMMDDYYYY                                                    @"MM:dd:yyyy"

//Rotation Calulation - Degree to Radian and Radian to Degree
#define DegreeToRadian(angle)                                           (angle)  * M_PI/180.0
#define RadianToDegree(radian)                                          (radian) * 180/M_PI

//Date formaters
#define DATE_FORMAT                                         @"MMM dd, yyyy HH:mm"
#define DATE_FORMAT_WITH_SECONDS                            @"MMM dd, yyyy HH:mm:ss"


typedef  enum playerStates {
    IDLE,
    PLAYING,
    PAUSED,
    BUFFERING
    
} PlayerState;

typedef enum PlayerControlTypes
{
    CONTROL_TYPE_PREVIEW,
    CONTROL_TYPE_PUBLISH,
    CONTROL_TYPE_FULLFILLMENT,
    CONTROL_TYPE_ADVANCED,
    CONTROL_TYPE_REVIEW,
    CONTROL_TYPE_INFORMATION,
    CONTROL_TYPE_ANNOTATION,
    CONTROL_TYPE_RANGE_COMMENT,
    CONTROL_TYPE_EXECUTIVE
} PlayerControlType;


typedef  enum CMPItemType {
    Reel,
    Playlist,
    Video,
    Audio,
} CMPItemType;

typedef enum PlayerType {
    Advanced,
    Review,
    Information,
    Editor,
    DashboardReview
}PlayerType;

enum TRACE_CODES
{
    TRACE_CODE_SUCCESS,
    TRACE_CODE_NETWORK_NOT_AVAILABLE,
    TRACE_CODE_NETWORK_ERROR,
    TRACE_CODE_AUTH_TOKEN_EXPIRED,
    TRACE_CODE_REQ_JSON_PARSE_FAILED,
    TRACE_CODE_RES_JSON_PARSE_FAILED,
    TRACE_CODE_TASK_SESSION_RESUME_SUCCESS,
    TRACE_CODE_TASK_SESSION_RESUME_FAILED,
    TRACE_CODE_TASK_SESSION_PAUSE_SUCCESS,
    TRACE_CODE_TASK_SESSION_PAUSE_FAILED,
    TRACE_CODE_TASK_SESSION_CANCEL_FAILED,
    TRACE_CODE_TASK_SESSION_CANCEL_SUCCCESS,
    TRACE_CODE_FILE_SYSTEM_ERROR,
    TRACE_CODE_DATA_INIT_FAILED,
    TRACE_CODE_CUSTOM_ERROR,
    TRACE_CODE_URL_ERROR
};

enum PLAYER_SLIDER_TYPES
{
    PLAYER_SLIDER_ROUGH_CUT,
    PLAYER_SLIDER_SALES_PREVIEW_PROGRESS,
    PLAYER_SLIDER_SALES_PREVIEW_SPEED,
    PLAYER_SLIDER_PUBLISH_SEGMENT,
    PLAYER_SLIDER_CUSTOM_COLOR
};

/*
enum PLAYER_SCREENER_TYPE
{
    PLAYER_SCREENER_TYPE_PREVIEW,
    PLAYER_SCREENER_TYPE_PUBLISH,
    PLAYER_SCREENER_TYPE_FULLFILLMENT,
    PLAYER_SCREENER_TYPE_ADVANCED,
    PLAYER_SCREENER_TYPE_REVIEW,
    PLAYER_SCREENER_TYPE_INFORMATION,
    PLAYER_SCREENER_TYPE_ANNOTATION,
    PLAYER_SCREENER_TYPE_RANGE_COMMENT,
    PLAYER_SCREENER_TYPE_EXECUTIVE
};*/




/*
enum
{
    PLAYER_CBC_POPUP_SCREENER_EXPIRE_NOW,
    PLAYER_CBC_POPUP_SCREENER_EXPIRY_DETAILS,
    PLAYER_CBC_POPUP_SCREENER_REQUEST_NEW_LINK,
    PLAYER_CBC_POPUP_SCREENER_REQUEST_EXTENSION,
    PLAYER_CBC_POPUP_SCREENER_PUBLISH_TO,
    PLAYER_CBC_POPUP_SCREENER_EXTEND_EXPIRY,
    PLAYER_CBC_POPUP_SCREENER_EXTENSION_REQUESTED,
    PLAYER_CBC_POPUP_SCREENER_FILTER_POPUP,
    PLAYER_CBC_POPUP_SCREENER_SHARE_POPUP,
    PLAYER_CBC_POPUP_SCREENER_SHARED_DETAILS_POPUP,
    PLAYER_CL_POPUP_LOGIN_HELP,
    PLAYER_CL_POPUP_LOGIN_TERMS_OF_USE,
    PLAYER_CL_POPUP_LOGIN_PRIVACY_POLICY,
    PLAYER_CL_POPUP_SEND_FOR_REVIEW,
    PLAYER_CL_REVIEW_POPUP,
    PLAYER_CL_USER_STATUS_DESCRIPTION_NOTICE,
    PLAYER_CL_POPUP_CONFIRM_EDIT_TIME_CODE,
    PLAYER_CL_POPUP_ADD_COMMENT,
    PLAYER_CL_POPUP_TEST,
    PLAYER_CBC_ICAROUSEL,
    PLAYER_CBC_POPUP_SCREENER_DOWNLOAD,
    PLAYER_CBC_MAIL_IDS,
};
*/






