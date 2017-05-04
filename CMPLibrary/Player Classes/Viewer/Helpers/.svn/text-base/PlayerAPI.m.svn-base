//
//  PAPI.m
//  Player
//
//  Created by Deep Arora on 2/23/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import "PlayerAPI.h"



#define TIME_OUT_INTERVAL_REQUEST       300.0f
#define TIME_OUT_INTERVAL_RESOURCE      60.0f
@implementation PlayerAPI

+(PlayerAPI*)sharedInstance
{
    static dispatch_once_t onceToken;
    static PlayerAPI* instance = nil;
    
    dispatch_once(&onceToken, ^{instance = [[self alloc] init]; });
    
    return instance;
}

-(id)init
{
    self = [super init];
    
    if(self)
    {
        
    }
    
    return self;
}

+(void)asyncDataDownload:(NSString*)urlString withProgressHandler:(void (^)(CGFloat progress))progressHandler andCompletionHandler:(void (^)(id response, NSUInteger errorCode))completionHandler
{
    [PlayerAPI startAsyncDownload:urlString progress:^(CGFloat progressValue)
     {
         progressHandler(progressValue);
     } finished:^(id receivedObj, NSUInteger errorCode)
     {
         if(errorCode == TRACE_CODE_SUCCESS) {
             completionHandler(receivedObj, TRACE_CODE_SUCCESS);
         }
         else {
             completionHandler(receivedObj, errorCode);
         }
     }];
}

// Module , session handling should be done from main project
+(void)startAsyncDownload:(NSString*)urlString progress:(ProgressHandler)progHandler finished:(CompletionHandler)compHandler
{
    //    if ([urlString rangeOfString:@"127.0.0.1:8080"].location == NSNotFound)
    //    {
    //        if(![Reachability isReachable])
    //        {
    //            compHandler(nil, TRACE_CODE_NETWORK_NOT_AVAILABLE);
    //            return;
    //        }
    //    }
    //
    //_progressHandler = progHandler;
    
    NSURLSessionConfiguration *sessionConfig    = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest     = TIME_OUT_INTERVAL_REQUEST;
    sessionConfig.timeoutIntervalForResource    = TIME_OUT_INTERVAL_RESOURCE;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT_INTERVAL_REQUEST];
    [request setValue:@"iPad" forHTTPHeaderField:@"User-Agent"];
    
    NSURLSessionTask   *sessionTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
                                       {
                                           if(error) {
                                               compHandler(error, TRACE_CODE_NETWORK_ERROR);
                                           }
                                           else
                                           {
                                               NSData *data = [NSData dataWithContentsOfURL:location];
                                               compHandler(data, TRACE_CODE_SUCCESS);
                                           }
                                           
                                           // [[CMSessionManager sharedInstance] doLockLockTime:NO];
                                       }];
    
    
    [sessionTask resume];
    
    //[[PlayerDownloadManager sharedInstance] doLockLockTime:YES];
    
    
    
}

@end
