//
//  PAPI.h
//  Player
//
//  Created by Deep Arora on 2/23/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerProductConstants.h"
//#import "PlayerServicesConstants.h"


@interface PlayerAPI : NSObject

+(PlayerAPI*)sharedInstance;
+(void)startAsyncDownload:(NSString*)urlString progress:(ProgressHandler)progHandler finished:(CompletionHandler)compHandler;
+(void)asyncDataDownload:(NSString*)urlString withProgressHandler:(void (^)(CGFloat progress))progressHandler andCompletionHandler:(void (^)(id response, NSUInteger errorCode))completionHandler;


@end
