//
//  SubtitleItemView.h
//  ClearBC
//
//  Created by Damodar Namala on 13/01/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubtitleStatusDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerUtilities.h"
//#import "PLayerView.h"

@interface SubtitleItemView : UILabel

@property (nonatomic,weak) id <SubtitleStatusDelegate>                  delegate;
@property(nonatomic) CGRect                                             videoRect;
@property(nonatomic,strong) NSMutableArray                              *arraySubtitles;

-(void)parseSubtitleFile:(NSData *)data withFileName:(NSString *)fileName;
-(void)loadSubtitleWithData:(NSData *)data;

-(void)playerTimeUpdateWithtime:(CGFloat)seconds ;
-(void)initHUD:(CGRect)rect;

@end
