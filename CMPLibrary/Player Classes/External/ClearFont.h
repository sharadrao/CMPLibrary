//
//  ClearFont.h
//  ClearFontApp
//
//  Created by Nishant Kumar on 10/17/16.
//  Copyright © 2016 NISHANT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
static NSString *const kClearFontFamily = @"Clear";

typedef NS_ENUM(NSInteger,ClearIcon)
{
    //CFClearMERP
    Clear_ClearMERP,
    Clear_add,
    Clear_airplay,
    Clear_moveT,
    Clear_document_file_mp3,
    Clear_volume_up,
    Clear_leftArrow,
    Clear_cross,
    Clear_closeB,
    Clear_feed,
    Clear_calender,
    Clear_addC2,
    Clear_moveR,
    Clear_collection,
    Clear_collections,
    Clear_crop,
    Clear_cut,
    Clear_clock2,
    Clear_cancelF,
    Clear_trash,
    Clear_trashAll,
    Clear_delete,
    Clear_menu,
    Clear_docPDF,
    Clear_document_file_pdf2,
    Clear_downloadAsset,
    Clear_anotation,
    Clear_expanded,
    Clear_moveB,
    Clear_wait,
    Clear_hourglass3,
    Clear_fast_forward,
    Clear_favoriteF,
    Clear_moreF,
    Clear_actionsF,
    Clear_actions,
    Clear_more,
    Clear_folder,
    Clear_full_screen,
    Clear_comment,
    Clear_columnView,
    Clear_menu2,
    Clear_clock,
    Clear_homeF,
    Clear_docJPG,
    Clear_document_file_jpg2,
    Clear_password,
    Clear_books,
    Clear_list_view,
    Clear_ClearLogoB,
    Clear_logout,
    Clear_information,
    Clear_not_viewed,
    Clear_warning2,
    Clear_tick,
    Clear_some_viewed,
    Clear_pause,
    Clear_play,
    Clear_fast_rewind,
    loginusernameImage,
    Clear_checkCircle,
    Clear_moveL,
    Clear_playSegment,
    Clear_save,
    Clear_saveAs,
    Clear_edit,
    Clear_send,
    Clear_cog,
    Clear_sort_ascending,
    Clear_sort_descending,
    Clear_stop2,
    Clear_email,
    Clear_task,
    Clear_arrowCT,
    Clear_userSTB,
    Clear_docMP4,
    Clear_document_file_mp32,
    Clear_zoom_in,
    Clear_zoom_out,
    Clear_library2,
    Clear_addC,
    Clear_menuIcon,
    Clear_triangleBottom,
    Clear_checkboxCheck,
    Clear_checkboxUncheck,
    Clear_menuIcon2,
    Clear_show,
    Clear_hide,
    Clear_activity,
    Clear_radioCheck,
    Clear_radioUncheck,
    Clear_clear_ClearMERP_L,
    Clear_reel,
    clear_archiveTape,
    clear_rotateRight,
    Clear_fullscreen_exit,
    Clear_reviewApprove,
    Clear_reviewReject,
    Clear_reviewSave,
    Clear_reviewPending,
    Clear_add_to_offline,
    Clear_remove_offline,
    Clear_favorite,
    Clear_cloudDone,
    Clear_filter,
    Clear_sortNew,
    Clear_equalizer,
    Clear_user_profile,
    Clear_user_pref,
    Clear_skip_previous,
    Clear_skip_next,
    Clear_btnPlay,
    Clear_play_arrow,
    Clear_btnPause,
    Clear_pause3,
    Clear_audioFile2,
    Clear_videoFile,
    Clear_textFile,
    Clear_pictureFile,
    Clear_errorOutline,
    Clear_help_outline,
    Clear_fullscreen,
    Clear_full_screen_large,
    Clear_exit_screen_large,
    Clear_phone,
    Clear_new_previousButton,
    Clear_new_nextButton,
    Clear_new_fullScreen,
    Clear_new_fullScreen_exit,
    Clear_new_settings,
    Clear_new_playButton,
    Clear_new_pauseButton,
    Clear_new_rewindButton,
    Clear_new_forwardButton,
    Clear_new_playSlower,
    Clear_new_playFaster
};

@interface ClearFont : NSObject

@end

@interface UIFont (ExtendedClearFont)
@end

@interface NSString (ExtendedClearString)
+ (ClearIcon)fontClearEnumForIconIdentifier:(NSString*)string;
+ (NSString*)fontClearIconStringForEnum:(ClearIcon)value;
+ (NSString*)fontClearIconStringForIconIdentifier:(NSString*)identifier;
@end

@interface UIImage (ExtendedClearImage)
+(UIImage*)imageWithIcon:(NSString*)identifier backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor andSize:(CGSize)size;
+(UIImage*)imageWithIcon:(NSString*)identifier backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor  fontSize:(int)fontSize;
@end

@interface UIButton (ExtendedClearButton)
@property (nonatomic, strong) IBInspectable NSString *fontCode;
@end

@interface UIImageView (ExtendedClearImageView)
@property (nonatomic, strong) IBInspectable NSString *fontCode;
-(instancetype)initWithFontCode:(NSString*)fontCode;
@end
