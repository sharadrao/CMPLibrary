//
//  ClearFont.m
//  ClearFontApp
//
//  Created by Nishant Kumar on 10/17/16.
//  Copyright © 2016 NISHANT. All rights reserved.
//

#import "ClearFont.h"

int fa_constraintLabelToSize(UILabel *label, CGSize size, int maxFontSize, int minFontSize)
{
    // Set the frame of the label to the targeted rectangle
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    label.frame = rect;
    
    // Try all font sizes from largest to smallest font size
    int fontSize = maxFontSize;
    
    // Fit label width wize
    CGSize constraintSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    
    do {
        // Set current font size
        label.font = [UIFont fontWithName:label.font.fontName size:fontSize];
        
        // Find label size for current font size
        CGRect textRect = [[label text] boundingRectWithSize:constraintSize
                                                     options:NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName:label.font}
                                                     context:nil];
        // Done, if created label is within target size
        if( textRect.size.height <= label.frame.size.height )
            break;
        
        // Decrease the font size and try again
        fontSize -= 2;
        
    } while (fontSize > minFontSize);
    
    return fontSize;
}

@implementation ClearFont

@end

@implementation UIFont (ExtendedClearFont)

@end

@implementation NSString (ExtendedClearString)
//2
+ (ClearIcon)fontClearEnumForIconIdentifier:(NSString*)string {
    NSDictionary *enums = [self enumDictionary];
    return [enums[string] integerValue];
}

//4
+ (NSString*)fontClearIconStringForEnum:(ClearIcon)value {
    return [NSString fontClearUnicodeStrings][value];
}

//1
+ (NSString*)fontClearIconStringForIconIdentifier:(NSString*)identifier {
    return [self fontClearIconStringForEnum:[self fontClearEnumForIconIdentifier:identifier]];
}

//5
#pragma mark - Data Initialization
+(NSArray*)fontClearUnicodeStrings
{
    static NSArray *fontClearUnicodeString;
    
    static dispatch_once_t unicodeStringsOnceToken;
    dispatch_once(&unicodeStringsOnceToken, ^{
        fontClearUnicodeString = @[@"\ue903",@"\ue908",@"\ue9b5",@"\ue92b",@"\ueb52",@"\ueabd",@"\ue91f",@"\ue9be",@"\ue9bf",@"\uead4",@"\ue9ac",@"\ue914",@"\ue92c",@"\ue9c7",@"\ue9c8",@"\ue9da",@"\ue9d9",@"\ue9bb",@"\ue9bd",@"\ue9e5",@"\ue9e6",@"\ue9e4",@"\ueae8",@"\ueb66",@"\ueb67",@"\ue9cb",@"\ue9d4",@"\ue915",@"\ue92a",@"\uea19",@"\uea1d",@"\uead8",@"\ue9ea",@"\ue904",@"\ue905",@"\ue906",@"\ue907",@"\uea14",@"\ueac8",@"\ue970",@"\ueafb",@"\ueae9",@"\ue9ba",@"\ue944",@"\ueb48",@"\ueb49",@"\ueaa1",@"\ue94a",@"\ueaea",@"\ue902",@"\ue94e",@"\uea24",@"\uea58",@"\uea28",@"\ue93c",@"\uea59",@"\ueadc",@"\ueadb",@"\uead7",@"\uea93",@"\ue9b7",@"\ue92d",@"\ue961",@"\ue9e2",@"\ue9e1",@"\ue9d5",@"\ueaad",@"\ueab1",@"\uebc4",@"\uebc3",@"\ueadd",@"\uea6e",@"\ue981",@"\ue918",@"\uebc2",@"\ueb53",@"\ueb54",@"\ueadf",@"\ueade",@"\ueae7",@"\ue90d",@"\uec14",@"\uec10",@"\uec02",@"\uec01",@"\uec15",@"\uec16",@"\uec17",@"\ue9a1",@"\uec04",@"\uec03",@"\uec18",@"\ueaab",@"\uebda",@"\ue940",@"\ueaca",@"\uec05",@"\uec07",@"\uec08",@"\uec06",@"\ue9c3",@"\ue9c4",@"\ue9e9",@"\ue9c2",@"\uea00",@"\uec1a",@"\ue955",@"\uea8f",@"\uea95",@"\uead9",@"\ueada",@"\uea5d",@"\uea5d",@"\uebf2",@"\uea64",@"\ue9f2",@"\ue9f5",@"\ue9f6",@"\ue9f3",@"\uea23",@"\uebb8",@"\ueac9",@"\ueac8",@"\ueacb",@"\ueb0f",@"\uec2e",@"\uec2d",@"\uec35",@"\uec36",@"\uec3b",@"\uec26",@"\uec27",@"\uec2c",@"\uec2b",@"\uec30",@"\uec2f"];
    });
    return fontClearUnicodeString;
}

//3
+(NSDictionary*)enumDictionary
{
    static NSDictionary *enumDictionary;
    
    static dispatch_once_t enumDictionaryOnceToken;
    dispatch_once(&enumDictionaryOnceToken, ^{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
//        dict[@"cf-clear-logo"] = @(CLEARLOGO);
//        dict[@"cf-clear-logo1"] = @(CLEARPFTLOGO);
//        dict[@"cf-clear-logo2"] = @(CLEARADD);
//        dict[@"clear-ClearLogoL"]= @(CFClearMERP);
        
        dict[@"clear-ClearMERP"]          = @(Clear_ClearMERP);
        dict[@"clear-add"]                = @(Clear_add);
        dict[@"clear-airplay"]            = @(Clear_airplay);
        dict[@"clear-moveT"]              = @(Clear_moveT);
        dict[@"clear-document-file-mp3"]  = @(Clear_document_file_mp3);
        dict[@"clear-volume_up"]          = @(Clear_volume_up);
        dict[@"clear-leftArrow"]          = @(Clear_leftArrow);
        dict[@"clear-cross"]              = @(Clear_cross);
        dict[@"clear-closeB"]             = @(Clear_closeB);
        dict[@"clear-feed"]               = @(Clear_feed);
        dict[@"clear-calender"]           = @(Clear_calender);
        dict[@"clear-addC2"]              = @(Clear_addC2);
        dict[@"clear-moveR"]              = @(Clear_moveR);
        dict[@"clear-collection"]         = @(Clear_collection);
        dict[@"clear-collections"]        = @(Clear_collections);
        dict[@"clear-crop"]               = @(Clear_crop);
        dict[@"clear-cut"]                = @(Clear_cut);
        dict[@"clear-clock2"]             = @(Clear_clock2);
        dict[@"clear-cancelF"]            = @(Clear_cancelF);
        dict[@"clear-trash"]              = @(Clear_trash);
        dict[@"clear-trashAll"]           = @(Clear_trashAll);
        dict[@"clear-delete"]             = @(Clear_delete);
        dict[@"clear-menu"]               = @(Clear_menu);
        dict[@"clear-docPDF"]             = @(Clear_docPDF);
        dict[@"clear-document-file-pdf2"] = @(Clear_document_file_pdf2);
        dict[@"clear-downloadAsset"]      = @(Clear_downloadAsset);
        dict[@"clear-anotation"]          = @(Clear_anotation);
        dict[@"clear-expanded"]           = @(Clear_expanded);
        dict[@"clear-moveB"]              = @(Clear_moveB);
        dict[@"clear-wait"]               = @(Clear_wait);
        dict[@"clear-hourglass3"]         = @(Clear_hourglass3);
        dict[@"clear-fast_forward"]       = @(Clear_fast_forward);
        dict[@"clear-favoriteF"]          = @(Clear_favoriteF);
        dict[@"clear-moreF"]              = @(Clear_moreF);
        dict[@"clear-actionsF"]           = @(Clear_actionsF);
        dict[@"clear-actions"]            = @(Clear_actions);
        dict[@"clear-more"]               = @(Clear_more);
        dict[@"clear-folder"]             = @(Clear_folder);
        dict[@"clear-full-screen"]        = @(Clear_full_screen);
        dict[@"clear-comment"]            = @(Clear_comment);
        dict[@"clear-columnView"]         = @(Clear_columnView);
        dict[@"clear-menu2"]              = @(Clear_menu2);
        dict[@"clear-clock"]              = @(Clear_clock);
        dict[@"clear-homeF"]              = @(Clear_homeF);
        dict[@"clear-docJPG"]             = @(Clear_docJPG);
        dict[@"clear-document-file-jpg2"] = @(Clear_document_file_jpg2);
        dict[@"clear-password"]           = @(Clear_password);
        dict[@"clear-books"]              = @(Clear_books);
        dict[@"clear-list-view"]          = @(Clear_list_view);
        dict[@"clear-ClearLogoB"]         = @(Clear_ClearLogoB);
        dict[@"clear-logout"]             = @(Clear_logout);
        dict[@"clear-information"]        = @(Clear_information);
        dict[@"clear-not-viewed"]         = @(Clear_not_viewed);
        dict[@"clear-warning2"]           = @(Clear_warning2);
        dict[@"clear-tick"]               = @(Clear_tick);
        dict[@"clear-some-viewed"]        = @(Clear_some_viewed);
        dict[@"clear-pause"]              = @(Clear_pause);
        dict[@"clear-play"]               = @(Clear_play);
        dict[@"clear-fast_rewind"]        = @(Clear_fast_rewind);
        dict[@"loginusernameImage"]       = @(loginusernameImage);
        dict[@"clear-checkCircle"]        = @(Clear_checkCircle);
        dict[@"clear-moveL"]              = @(Clear_moveL);
        dict[@"clear-playSegment"]        = @(Clear_playSegment);
        dict[@"clear-save"]               = @(Clear_save);
        dict[@"clear-saveAs"]             = @(Clear_saveAs);
        dict[@"clear-edit"]               = @(Clear_edit);
        dict[@"clear-send"]               = @(Clear_send);
        dict[@"clear-cog"]                = @(Clear_cog);
        dict[@"clear-sort-ascending"]     = @(Clear_sort_ascending);
        dict[@"clear-sort-descending"]    = @(Clear_sort_descending);
        dict[@"clear-stop2"]              = @(Clear_stop2);
        dict[@"clear-email"]              = @(Clear_email);
        dict[@"clear-task"]               = @(Clear_task);
        dict[@"clear-arrowCT"]            = @(Clear_arrowCT);
        dict[@"clear-userSTB"]            = @(Clear_userSTB);
        dict[@"clear-docMP4"]             = @(Clear_docMP4);
        dict[@"clear-document-file-mp32"] = @(Clear_document_file_mp32);
        dict[@"clear-zoom-in"]            = @(Clear_zoom_in);
        dict[@"clear-zoom-out"]           = @(Clear_zoom_out);
        dict[@"clear-library2"]           = @(Clear_library2);
        dict[@"clear-addC"]               = @(Clear_addC);
        dict[@"clear-menuIcon"]           = @(Clear_menuIcon);
        dict[@"clear-triangleBottom"]     = @(Clear_triangleBottom);
        dict[@"clear-checkboxCheck"]      = @(Clear_checkboxCheck);
        dict[@"clear-checkboxUncheck"]    = @(Clear_checkboxUncheck);
        dict[@"clear-menuIcon2"]          = @(Clear_menuIcon2);
        dict[@"clear-show"]               = @(Clear_show);
        dict[@"clear-hide"]               = @(Clear_hide);
        dict[@"clear-activity"]           = @(Clear_activity);
        dict[@"clear-radioCheck"]         = @(Clear_radioCheck);
        dict[@"clear-radioUncheck"]       = @(Clear_radioUncheck);
        dict[@"clear-clear-ClearMERP-L"]  = @(Clear_clear_ClearMERP_L);
        dict[@"clear-reel"]               = @(Clear_reel);
        dict[@"clear-archiveTape"]        = @(clear_archiveTape);
        dict[@"clear-rotateRight"]        = @(clear_rotateRight);
        dict[@"clear-fullscreen_exit"]    = @(Clear_fullscreen_exit);
        dict[@"clear-reviewApprove"]      = @(Clear_reviewApprove);
        dict[@"clear-reviewReject"]       = @(Clear_reviewReject);
        dict[@"clear-reviewSave"]         = @(Clear_reviewSave);
        dict[@"clear-reviewPending"]      = @(Clear_reviewPending);
        dict[@"clear-cloudDownload"]      = @(Clear_add_to_offline);
        dict[@"clear-cloudOff"]           = @(Clear_remove_offline);
        dict[@"clear-favorite"]           = @(Clear_favorite);
        dict[@"clear-cloudDone"]          = @(Clear_cloudDone);
        dict[@"clear-filter"]             = @(Clear_filter);
        dict[@"clear-sortNew"]            = @(Clear_sortNew);
        dict[@"clear-equalizer"]          = @(Clear_equalizer);
        dict[@"clear-user-profile"]       = @(Clear_user_profile);
        dict[@"clear-user-pref"]          = @(Clear_user_pref);
        dict[@"clear-skip_previous"]      = @(Clear_skip_previous);
        dict[@"clear-skip_next"]          = @(Clear_skip_next);
        dict[@"clear-btnPlay"]            = @(Clear_btnPlay);
        dict[@"clear-play_arrow"]         = @(Clear_play_arrow);
        dict[@"clear-btnPause"]           = @(Clear_btnPause);
        dict[@"clear-pause3"]             = @(Clear_pause3);
        dict[@"clear-audioFile2"]         = @(Clear_audioFile2);
        dict[@"clear-videoFile"]          = @(Clear_videoFile);
        dict[@"clear-textFile"]           = @(Clear_textFile);
        dict[@"clear-pictureFile"]        = @(Clear_pictureFile);
        dict[@"clear-errorOutline"]       = @(Clear_errorOutline);
        dict[@"clear-help_outline"]       = @(Clear_help_outline);
        dict[@"clear-fullscreen"]         = @(Clear_fullscreen);
        dict[@"clear-full-screen"]        = @(Clear_full_screen_large);
        dict[@"clear-exit-screen"]        = @(Clear_exit_screen_large);
        dict[@"clear-phone"]              = @(Clear_phone);
        dict[@"clear-new_previousButton"] = @(Clear_new_previousButton);
        dict[@"clear-new_nextButton"]     = @(Clear_new_nextButton);
        dict[@"clear-new_fullScreen"]     = @(Clear_new_fullScreen);
        dict[@"clear-new_fullScreen_exit"] = @(Clear_new_fullScreen_exit);
        dict[@"clear-new_settings"]      = @(Clear_new_settings);
        dict[@"clear-new_playButton"]    = @(Clear_new_playButton);
        dict[@"clear-new_pauseButton"]   = @(Clear_new_pauseButton);
        dict[@"clear-new_rewindButton"]  = @(Clear_new_rewindButton);
        dict[@"clear-new_forwardButton"] = @(Clear_new_forwardButton);
        dict[@"clear-new_playSlower"]    = @(Clear_new_playSlower);
        dict[@"clear-new_playFaster"]    = @(Clear_new_playFaster);
        
        enumDictionary = dict;
    });
    return enumDictionary;
}

@end

@interface UIButton()

@property (nonatomic,assign) NSInteger buttonSize;
@property (nonatomic, strong) NSString *imageIconCode;

@end

@implementation UIButton (ExtendedClearButton)
@dynamic fontCode;

-(void)setFontCode:(NSString *)fontCode
{
    NSString  *textContent = [NSString fontClearIconStringForIconIdentifier:fontCode];
    UIImage *img = [UIImage imageWithIcon:textContent backgroundColor:nil iconColor:self.tintColor andSize:self.bounds.size];
    [self setBackgroundImage:img forState:UIControlStateNormal];
}

@end

@implementation UIImageView (ExtendedClearImageView)
@dynamic fontCode;

-(instancetype)initWithFontCode:(NSString *)fontCode
{
    self = [super init];
    if (self) {
       // [self setFontCode:fontCode];
    }
    return self;
}
-(void)setFontCode:(NSString *)fontCode
{
    NSString  *textContent = [NSString fontClearIconStringForIconIdentifier:fontCode];
    UIImage *img = [UIImage imageWithIcon:textContent backgroundColor:nil iconColor:self.tintColor andSize:self.bounds.size];
    self.image = img;
}
@end

@implementation UIImage (ExtendedClearImage)
+(UIImage*)imageWithIcon:(NSString*)identifier backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor andSize:(CGSize)size
{
    if (!bgColor) {
        bgColor = [UIColor clearColor];
    }
    if (!iconColor) {
        iconColor = [UIColor lightGrayColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    //// Abstracted Attributes
    NSString* textContent = identifier;
    if (identifier.length > 6 && [[identifier substringToIndex:6] isEqualToString:@"clear-"]) {
        textContent = [NSString fontClearIconStringForIconIdentifier:identifier];
    }
    
    CGRect textRect = CGRectZero;
    textRect.size = size;
    
    //// Retangle Drawing
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:textRect];
    [bgColor setFill];
    [path fill];
    
    //// Text Drawing
    int fontSize = size.width;
    UIFont *font = [UIFont fontWithName:kClearFontFamily size:fontSize];
    @autoreleasepool {
        UILabel *label = [UILabel new];
        label.font = font;
        label.text = textContent;
        fontSize = fa_constraintLabelToSize(label, size, 500, 5);
        font = label.font;
    }
    [iconColor setFill];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    [textContent drawInRect:textRect withAttributes:@{NSFontAttributeName : font,
                                                      NSForegroundColorAttributeName : iconColor,
                                                      NSBackgroundColorAttributeName : bgColor,
                                                      NSParagraphStyleAttributeName: style,
                                                      }];
    
    //Image returns
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage*)imageWithIcon:(NSString*)identifier backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor  fontSize:(int)fontSize
{
    if (!bgColor) {
        bgColor = [UIColor clearColor];
    }
    if (!iconColor) {
        iconColor = [UIColor blackColor];
    }
    
    //// Abstracted Attributes
    NSString* textContent = identifier;
    if (identifier.length > 6 && [[identifier substringToIndex:6] isEqualToString:@"clear-"]) {
        textContent = [NSString fontClearIconStringForIconIdentifier:identifier];
    }
    
    UIFont *font = [UIFont fontWithName:kClearFontFamily size:fontSize];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSForegroundColorAttributeName : iconColor,
                                 NSBackgroundColorAttributeName : bgColor,
                                 NSParagraphStyleAttributeName: style,
                                 };
    
    //// Content Edge Insets
    CGSize size = [textContent sizeWithAttributes:attributes];
    size = CGSizeMake(size.width * 1.1, size.height * 1.05);
    
    CGRect textRect = CGRectZero;
    textRect.size = size;
    
    CGPoint origin = CGPointMake(size.width * 0.05, size.height * 0.025);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    //// Rectangle Drawing
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:textRect];
    [bgColor setFill];
    [path fill];
    
    //// Text Drawing
    [textContent drawAtPoint:origin withAttributes:attributes];
    
    //Image returns
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
