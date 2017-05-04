//
//  CBCSubtitleStatusDelegate.h
//  ClearBC
//
//  Created by Damodar Namala on 13/01/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//

#ifndef CBCSubtitleStatusDelegate_h
#define CBCSubtitleStatusDelegate_h
#endif /* CBCSubtitleStatusDelegate_h */

@protocol SubtitleStatusDelegate <NSObject>

-(void)subtitleDidStartFetching;
-(void)subtitleDidEndFetching;

@end
