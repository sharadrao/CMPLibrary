//
//  SubtitleItemView.m
//  ClearBC
//
//  Created by Damodar Namala on 13/01/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//

#import "SubtitleItemView.h"
#import "SubtitleModel.h"
#import "SubtitleFormatingTextModel.h"
#import "SubtitleTimedTextEntitlementsModel.h"
#import "PlayerCache.h"
#import "PlayerProductConstants.h"
#import "PlayerUtilities.h"
#import "NSString+MD5.h"
@interface SubtitleItemView() {

}
@property(nonatomic,strong) NSDictionary *attrsDictionary;


@end
@implementation SubtitleItemView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        if ([self.delegate respondsToSelector:@selector(subtitleDidEndFetching)]) {
            [self.delegate subtitleDidStartFetching];
        }
        
        [[self layer]setCornerRadius:4];
        [self setBackgroundColor: [[UIColor blackColor] colorWithAlphaComponent:0.35]];
    }
    return self;
}

-(void)initHUD:(CGRect)rect
{
    self.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    _videoRect = rect;
    CGFloat fontSize = ((_videoRect.origin.y + _videoRect.size.height) / 25);
    _attrsDictionary = @{
                         NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                         NSForegroundColorAttributeName : [UIColor whiteColor]
                        };

    
}
-(void)loadSubtitleWithData:(NSData *)data
{
    if (data) {
        _arraySubtitles  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    if ([self.delegate respondsToSelector:@selector(subtitleDidEndFetching)]) {
        [self.delegate subtitleDidEndFetching];
    }
}

- (void)parseSubtitleFile:(NSData *)data withFileName:(NSString *)fileName
{
    if (data)
    {
        NSError *error = nil;
        NSInputStream *inputStream = [[NSInputStream alloc] initWithData:data];
        [inputStream open];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithStream: inputStream
                                                                     options:kNilOptions
                                                                       error:&error];
        [inputStream close];
        if (error)
        {
            // ... do something ...
        }
        else
        {
            if ([PlayerUtilities isNotNil:[jsonObject objectForKey:@"TimedTextLineInfoElements"] ])
            {
                NSArray *jsonArray = [jsonObject objectForKey:@"TimedTextLineInfoElements"];
                _arraySubtitles = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dictTextEntitlements in jsonArray)
                {
                    
                    SubtitleModel *subtitleMdl   =       [[SubtitleModel alloc] init];
                    subtitleMdl.duration            =       [dictTextEntitlements objectForKey:@"Duration"];
                    subtitleMdl.index               =       [dictTextEntitlements objectForKey:@"Index"];
                    subtitleMdl.sccOriginalTcIn     =       [dictTextEntitlements objectForKey:@"SccOriginalTcIn"];
                    subtitleMdl.sccOriginalTcOut    =       [dictTextEntitlements objectForKey:@"SccOriginalTcOut"];
                    subtitleMdl.tcIn                =       [dictTextEntitlements objectForKey:@"TcIn"];
                    subtitleMdl.tcOut               =       [dictTextEntitlements objectForKey:@"TcOut"];
                    
                    NSMutableString *subtitleString = [[NSMutableString alloc] init];
                    
                    for (NSDictionary *dictTimeTextDict in [dictTextEntitlements objectForKey:@"TimedTextLineElements"])
                    {
                        
                        SubtitleTimedTextEntitlementsModel *textEntitleModel      =          [[SubtitleTimedTextEntitlementsModel alloc] init];
                        textEntitleModel.lineNumber                                  =          [dictTimeTextDict objectForKey:@"LineNumber"];
                        textEntitleModel.text                                        =          [dictTimeTextDict objectForKey:@"Text"];
                        [subtitleString appendFormat:@"%@",textEntitleModel.text];
                        
                        NSMutableString *textStering    = [[textEntitleModel.text stringByAppendingFormat:@"\n%@",textEntitleModel.text] mutableCopy];
                        textEntitleModel.text           = textStering;
                        
                        for (NSDictionary * dictTimedLineEntitle in [dictTextEntitlements objectForKey:@"TimedTextLineElements"]) {
                            
                            SubtitleFormatingTextModel *formatingText    = [[SubtitleFormatingTextModel alloc] init];
                            formatingText.formatingTextRGB                  = [dictTimedLineEntitle objectForKey:@"ARGB"];
                            formatingText.formatingTextColor                = [dictTimedLineEntitle objectForKey:@"Color"];
                            formatingText.formatingTextFontStyle            = [dictTimedLineEntitle objectForKey:@"FontStyle"];
                            formatingText.formatingTextXpos                 = [dictTimedLineEntitle objectForKey:@"XPos"];
                            formatingText.formatingTextYpos                 = [dictTimedLineEntitle objectForKey:@"YPos"];
                            
                            [textEntitleModel.formatingTextEntitlements addObject:formatingText];
                        }
                        [subtitleMdl.textEntitlements addObject:textEntitleModel];
                    }
                    
                    subtitleMdl.textSubtitle = subtitleString;
                    [_arraySubtitles addObject:subtitleMdl];
                }
              
                NSData *subtitleData = [NSKeyedArchiver archivedDataWithRootObject:_arraySubtitles];
                //[PlayerCache setObject:subtitleData forKey:fileName  withNewPath:SUBTITLE_LOCATION];
            }
        }

        if ([self.delegate respondsToSelector:@selector(subtitleDidEndFetching)]) {
            [self.delegate subtitleDidEndFetching];
        }
    }
  
}
- (void)playerTimeUpdateWithtime:(CGFloat)seconds
{
    
    // [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    CGSize sizeLabel;
    
    NSMutableArray *candidates = [NSMutableArray new];
    
    for(SubtitleModel *subtitle in self.arraySubtitles)
    {
        
        CGFloat playerSecondsTimeCodeIn = [PlayerUtilities getSecondsFromTimeCode:subtitle.tcIn isDF:NO];
        CGFloat playerSecondsTimeCodeOut = [PlayerUtilities getSecondsFromTimeCode:subtitle.tcOut isDF:NO];
        
        if ((playerSecondsTimeCodeIn <  seconds )  && (seconds <=  playerSecondsTimeCodeOut) )
        {
            [candidates addObject:subtitle.textSubtitle];
            self.alpha = 1;
           }

        else if(seconds >= playerSecondsTimeCodeOut){
            self.alpha = 0;
            //self.text = @"";
        }
    }
  
    if ([[candidates lastObject] length])
    {
        
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:[candidates lastObject] attributes:_attrsDictionary];
       //self.translatesAutoresizingMaskIntoConstraints = NO;
         sizeLabel    = [PlayerUtilities getSizeOfString:[attributedTitle string] withFont:self.font];
        CGFloat yAxis   = (_videoRect.origin.y + _videoRect.size.height)  - (_videoRect.origin.y + sizeLabel.height + 5 ) * 0.80 ;
    
        CGFloat xAxis   = ((_videoRect.origin.x + _videoRect.size.width)  * 0.5 ) - ((_videoRect.origin.x + sizeLabel.width) * 0.5) ;
        [self setAttributedText:attributedTitle];
      
            self.frame      = CGRectMake(xAxis, yAxis, sizeLabel.width, sizeLabel.height);
            self.center = CGPointMake(CGRectGetMidX(self.videoRect),yAxis);
        
       
    }
    
}


@end
