//
//  CBCCache.m
//  ClearBCProduct
//
//  Created by Saravana Kumar on 7/30/14.
//  Copyright (c) 2014 Prime Focus Technology. All rights reserved.
//

#import "PlayerCache.h"
#import "PlayerProductConstants.h"

#define CACHE_DIR                   @"CacheDir"
//#define CBC_CACHE_APPLICATION_SUPPORT   @"Application Support"
//#define CBC_CACHE_OFFLINE               @"OffLine"

//static NSTimeInterval cacheTime =  (double)604800;  // 1 week

@implementation PlayerCache




//+ (void) resetCache {
//	[[NSFileManager defaultManager] removeItemAtPath:[PlayerCache cacheDirectory] error:nil];
//}

+ (NSString*) cacheDirectory
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = paths[0];
	cacheDirectory = [cacheDirectory stringByAppendingPathComponent:CACHE_DIR];
    
	return cacheDirectory;
}

+ (NSString*) createCacheSubDirectory:(NSString*)dirName
{
    NSString *cacheDir = [[self cacheDirectory] stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheDir]) {
		[fileManager createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
	}
    
    return cacheDir;
}

//+(NSString*) createDirectoryInDocument:(NSString*)dirName
//{
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *cacheDirectory = paths[0];
//    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:dirName];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:cacheDirectory])
//    {
//        if(![fileManager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil]) {
//            return nil;
//        }
//    }
//    
//    return cacheDirectory;
//}

//+ (NSString*) createDirectory:(NSString*)dirName
//{
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//	NSString *cacheDirectory = paths[0];
//	cacheDirectory = [cacheDirectory stringByAppendingPathComponent:dirName];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:cacheDirectory])
//    {
//		if(![fileManager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil]) {
//            return nil;
//        }
//	}
//    
//	return cacheDirectory;
//}

//
//+ (BOOL) removeDirectory:(NSString*)dirName
//{
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//	NSString *cacheDirectory = paths[0];
//    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:dirName];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error = nil;
//    if ([fileManager fileExistsAtPath:cacheDirectory]) {
//        [fileManager removeItemAtPath:cacheDirectory error:&error];
//    }
//    
//    if(error) {
//        return NO;
//    }
//    
//    return YES;
//}

+ (BOOL) removeCacheSubDirectory:(NSString*)dirName
{
    NSString *cacheDir = [[self cacheDirectory] stringByAppendingPathComponent:dirName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:cacheDir]) {
        [fileManager removeItemAtPath:cacheDir error:&error];
    }
    
    if(error) {
        return NO;
    }
    
    return YES;
}

//+ (BOOL) removeCacheDataInCacheSubDirectory:(NSString*)path andData:(NSString*)key
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *filename = [[PlayerCache createCacheSubDirectory:path] stringByAppendingPathComponent:key];
//
//    NSError *error = nil;
//    if ([fileManager fileExistsAtPath:filename]){
//        [fileManager removeItemAtPath:filename error:&error];
//    }
//    
//    if(error) {
//        return NO;
//    }
//    
//    return YES;
//}


+ (void) setObject:(NSData *)data forKey:(NSString *)key withNewPath:(NSString*)pathName
{
    NSString *fileName = [[PlayerCache createCacheSubDirectory:pathName] stringByAppendingPathComponent:key];
	NSError *error;
    
//    NSLog(@"file name %@", fileName);
    
	@try {
		[data writeToFile:fileName options:NSDataWritingAtomic error:&error];
	}
	@catch (NSException * e) {
		//TODO: error handling maybe
	}
}

+ (NSData*) objectForKey:(NSString*)key withPath:(NSString*)path
{
    NSData *data = nil;
   	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [[PlayerCache createCacheSubDirectory:path] stringByAppendingPathComponent:key];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        data = [NSData dataWithContentsOfFile:filename];
        return data;
    }
    
    return nil;
}

+ (NSData*) objectForKey:(NSString*)key
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [[PlayerCache cacheDirectory] stringByAppendingPathComponent:key];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        NSData *data = [NSData dataWithContentsOfFile:filename];
        return data;
    }
    
    return nil;
}

+ (void) setObject:(NSData*)data forKey:(NSString*)key
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
	BOOL isDir = YES;
    
	if (![fileManager fileExistsAtPath:[PlayerCache cacheDirectory] isDirectory:&isDir]) {
		[fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
	}
	
	NSError *error;
	@try {
		[data writeToFile:filename options:NSDataWritingAtomic error:&error];
	}
	@catch (NSException * e) {
		//TODO: error handling maybe
	}
}

//+(void) removeObject:(NSString*)key
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *fileName = [[PlayerCache cacheDirectory] stringByAppendingPathComponent:key];
//	if ([fileManager fileExistsAtPath:fileName]) {
//        [fileManager removeItemAtPath:fileName error:nil];
//    }
//}

//+(void)clearOldFiles
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//	NSArray *dirContents = [fileManager contentsOfDirectoryAtPath:self.cacheDirectory error:nil];
//    
//    for (NSString *fileName in dirContents)
//    {
//        if([fileManager fileExistsAtPath:fileName])
//        {
//            NSDate *modificationDate = [[fileManager attributesOfItemAtPath:fileName error:nil] objectForKey:NSFileModificationDate];
//            if ([modificationDate timeIntervalSinceNow] > cacheTime){
//                [fileManager removeItemAtPath:fileName error:nil];
//            }
//        }
//    }
//}

#pragma mark - offline screener items

//+(NSString*)applicationFolder
//{
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *applicationFolder = [paths firstObject];
//    applicationFolder = [applicationFolder stringByAppendingPathComponent:CBC_CACHE_APPLICATION_SUPPORT];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    if (![fileManager fileExistsAtPath:applicationFolder])
//    {
//        if(![fileManager createDirectoryAtPath:applicationFolder withIntermediateDirectories:YES attributes:nil error:nil]) {
//            return nil;
//        }
//    }
//    
//    return applicationFolder;
//}

//+(NSString*)offlineFolder
//{
//    NSString *appFolder = [self applicationFolder];
//    
//    NSString *offlineFolder = [appFolder stringByAppendingPathComponent:CBC_CACHE_OFFLINE];
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:offlineFolder])
//    {
//        if(![fileManager createDirectoryAtPath:offlineFolder withIntermediateDirectories:YES attributes:nil error:nil]) {
//            return nil;
//        }
//    }
//    
//    return offlineFolder;
//}

//+(BOOL)removeOfflineDirectory
//{
//    NSString *offlineFolder     = [self offlineFolder];
//    
//    NSFileManager *fileManager  = [NSFileManager defaultManager];
//    NSError *error;
//    if ([fileManager fileExistsAtPath:offlineFolder]) {
//        [fileManager removeItemAtPath:offlineFolder error:&error];
//    }
//    
//    if(error) {
//        return FALSE;
//    }
//    
//    return TRUE;
//
//}

//+(NSString*)createDirectoryInOffLine:(NSString*)userId screenerFolder:(NSString*)screenerName
//{
//    NSString *offlineFolder = [self offlineFolder];
//    
//    NSString *userFolder = [offlineFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"user_%@", userId]];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:userFolder])
//    {
//        if(![fileManager createDirectoryAtPath:userFolder withIntermediateDirectories:YES attributes:nil error:nil]) {
//            return nil;
//        }
//        else
//        {
//            NSString *screenerFolder = [userFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"screener_%@", screenerName]];
//            return [self createScreenerDirectory:screenerFolder];
//        }
//    }
//    else
//    {
//        NSString *screenerFolder = [userFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"screener_%@", screenerName]];
//        return [self createScreenerDirectory:screenerFolder];
//    }
//}

//+(BOOL)saveScreenerItem:(NSString*)screenerName forUser:(NSString*)userId withData:(NSData*)data andFileName:(NSString*)fileName
//{
//    NSString *screenerFolder = [PlayerCache createDirectoryInOffLine:userId screenerFolder:screenerName];
//    
//    if(!screenerFolder) {
//        return NO;
//    }
//    
//    NSString *fileLocation = [screenerFolder stringByAppendingPathComponent:fileName];
//    if ([data isKindOfClass:[NSData class]]) {
//        return [data writeToFile:fileLocation atomically:YES];
//    }
//    return NO;
//}

//+(BOOL)moveToScreenerItem:(NSString*)screenerName forUser:(NSString*)userId srcLocation:(NSURL*)srcLocation destFileName:(NSString*)fileName
//{
//    NSString *screenerFolder = [PlayerCache createDirectoryInOffLine:userId screenerFolder:screenerName];
//    if(!screenerFolder) {
//        return NO;
//    }
//    
//    NSString *fileLocation = [screenerFolder stringByAppendingPathComponent:fileName];
//    
//    NSURL *destLocation = [NSURL fileURLWithPath:fileLocation];
//    
//    return [[NSFileManager defaultManager] moveItemAtURL:srcLocation toURL:destLocation error:NULL];
//}

//+(BOOL)isItemFoundInOfflineForUser:(NSString*)userId andScreenerName:(NSString*)screener andFileName:(NSString*)fileName
//{
//    NSString *screenerFolder = [PlayerCache createDirectoryInOffLine:userId screenerFolder:screener];
//    if(!screenerFolder) {
//        return NO;
//    }
//    
//    NSString *fileLocation = [screenerFolder stringByAppendingPathComponent:fileName];
//    return [[NSFileManager defaultManager] fileExistsAtPath:fileLocation];
//}

//+(BOOL)saveScreenerItemForM3u8:(NSString*)downloadId forUser:(NSString*)userId withData:(NSData*)data andFileName:(NSString*)fileName
//{
//    NSArray *ids = [downloadId componentsSeparatedByString:@":"];
//    NSString *screenerFolder = [PlayerCache createDirectoryInOffLine:userId screenerFolder:[ids firstObject]];
//    
//    if(!screenerFolder) {
//        return NO;
//    }
//    NSString *m3u8Folder        = [screenerFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",[ids lastObject],M3U8]];
//    NSString *fileLocation      = [m3u8Folder stringByAppendingPathComponent:fileName];
//    
//    NSFileManager *fileManager  = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:m3u8Folder])
//    {
//        if(![fileManager createDirectoryAtPath:m3u8Folder withIntermediateDirectories:YES attributes:nil error:nil]) {
//            return NO;
//        }
//    }
//    if ([data isKindOfClass:[NSData class]]) {
//        BOOL save = [data writeToFile:fileLocation atomically:YES];
//        return save;
//    }
//    return NO;
//}

//+(NSString*)getOfflineItemPath:(NSString*)userId folderId:(NSString*)folderId
//{
//    NSString *folderPath = [PlayerCache createDirectoryInOffLine:userId screenerFolder:folderId];
//    return folderPath;
//}

//+(NSData*)getOfflineItemForUser:(NSString*)userId andScreenerName:(NSString*)screener andFileName:(NSString*)fileName
//{
//    NSString *screenerFolder = [PlayerCache createDirectoryInOffLine:userId screenerFolder:screener];
//    if(!screenerFolder) {
//        return nil;
//    }
//
//    NSString *fileLocation = [screenerFolder stringByAppendingPathComponent:fileName];
//    
//    DLog(@"getOfflineItemForUser %@", fileLocation);
//    
//    if(![[NSFileManager defaultManager] fileExistsAtPath:fileLocation]) {
//        return nil;
//    }
//    
//    return [NSData dataWithContentsOfFile:fileLocation];
//}

+(NSString*)createScreenerDirectory:(NSString*)screenerFolder
{
    NSString *screenerDirectory = screenerFolder;
    NSFileManager *fileManager  = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:screenerDirectory])
    {
        if(![fileManager createDirectoryAtPath:screenerDirectory withIntermediateDirectories:YES attributes:nil error:nil]) {
            return nil;
        }
    }
    return screenerDirectory;
}
//+(BOOL)removeScreenerClip:(NSString*)userID andScreener:(NSString*)screener andClip:(NSString*)clipId
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *cacheDirectory = [PlayerCache createDirectoryInOffLine:userID screenerFolder:screener];
//    NSError *error = nil;
//    
//    NSArray *dirContents = [fileManager contentsOfDirectoryAtPath:cacheDirectory error:nil];
//    for (NSString *fileName in dirContents)
//    {
//        NSString *reqFileName = [NSString stringWithFormat:@"%@.request", screener];
//        if(![fileName caseInsensitiveCompare:reqFileName]) {
//            DLog(@"skipping request...");
//        }
//        else
//        {
//            NSString *thumbFileName = [NSString stringWithFormat:@"%@_thumb.png",clipId];
//            if(![fileName caseInsensitiveCompare:thumbFileName]) {
//                DLog(@"skipping request...");
//            }
//            else
//            {
//                if ([fileName rangeOfString:clipId].location !=NSNotFound)
//                {
//                    NSString *fileLocation = [cacheDirectory stringByAppendingPathComponent:fileName];
//                    if([fileManager fileExistsAtPath:fileLocation]) {
//                        [fileManager removeItemAtPath:fileLocation error:&error];
//                    }
//                }
//            }
//        }
//    }
//    
//    return YES;
//}
//+(BOOL)removeScreener:(NSString*)userId andScreenerName:(NSString*)screener
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *cacheDirectory = [PlayerCache createDirectoryInOffLine:userId screenerFolder:screener];
//    NSError *error = nil;
//    
//    NSArray *dirContents = [fileManager contentsOfDirectoryAtPath:cacheDirectory error:nil];
//    for (NSString *fileName in dirContents)
//    {
//        NSString *reqFileName = [NSString stringWithFormat:@"%@.request", screener];
//        if(![fileName caseInsensitiveCompare:reqFileName]) {
//            DLog(@"skipping request...");
//        }
//        else
//        {
//            NSString *fileLocation = [cacheDirectory stringByAppendingPathComponent:fileName];
//            if([fileManager fileExistsAtPath:fileLocation]) {
//                [fileManager removeItemAtPath:fileLocation error:&error];
//            }
//        }
//    }
//
//    return TRUE;
//}

//+(BOOL)IsItemFoundInM3U8Location:(NSString*)downloadId forUser:(NSString*)userId destFileName:(NSString*)fileName
//{
//    if (!downloadId) {
//        return NO;
//    }
//    
//    NSArray  *ids               = [downloadId componentsSeparatedByString:@":"];
//    NSString *m3u8FilePath      = [NSString stringWithFormat:@"%@_%@",[ids lastObject], M3U8];
//    NSString * screenerFolder   = [PlayerCache createDirectoryInOffLine:userId screenerFolder:[ids firstObject]];
//    
//    if(!screenerFolder) {
//        return YES;
//    }
//    
//    NSString *m3u8Folder        =  [screenerFolder stringByAppendingPathComponent:m3u8FilePath];
//    NSString *fileLocation        = [m3u8Folder stringByAppendingPathComponent:fileName];
//    
//    DLog(@"file location %@", fileLocation);
//    
//    return [[NSFileManager defaultManager] fileExistsAtPath:fileLocation];
//}


//+(BOOL)moveTOM3u8ScreenerItem:(NSString*)downloadId forUser:(NSString*)userId srcLocation:(NSURL*)srcLocation destFileName:(NSString*)fileName
//{
//    if (!downloadId) {
//        return NO;
//    }
//    NSArray  *ids               = [downloadId componentsSeparatedByString:@":"];
//    NSString *m3u8FilePath      = [NSString stringWithFormat:@"%@_%@",[ids lastObject],M3U8];
//    NSString * screenerFolder   = [PlayerCache createDirectoryInOffLine:userId screenerFolder:[ids firstObject]];
//    if(!screenerFolder) {
//        return NO;
//    }
//    
//    NSString *m3u8Folder        =  [screenerFolder stringByAppendingPathComponent:m3u8FilePath];
//    NSFileManager *fileManager  = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:m3u8Folder])
//    {
//        if(![fileManager createDirectoryAtPath:m3u8Folder withIntermediateDirectories:YES attributes:nil error:nil]) {
//            return NO;
//        }
//    }
//    
//    NSString *fileLocation        = [m3u8Folder stringByAppendingPathComponent:fileName];
//    NSURL *destLocation = [NSURL fileURLWithPath:fileLocation];
//    NSData *data        = [NSData dataWithContentsOfFile:fileLocation];
//    if (data) {
//        [[NSFileManager defaultManager]removeItemAtPath:fileLocation error:nil];
//    }
//    return [[NSFileManager defaultManager] moveItemAtURL:srcLocation toURL:destLocation error:NULL];
//    
//    return YES;
//}

//+(BOOL)removeScreenerItem:(NSString*)screenerName forUser:(NSString*)userId andItem:(NSString*)item
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    NSString *screenerFolder = [PlayerCache createDirectoryInOffLine:userId screenerFolder:screenerName];
//    
//    NSString *fileLocation = [screenerFolder stringByAppendingPathComponent:item];
//    
//    if(![fileManager fileExistsAtPath:fileLocation]) {
//        return YES;
//    }
//    
//    return [fileManager removeItemAtPath:fileLocation error:nil];
//}

//+(NSString*)locateFileUrl:(NSString*)userId screenerName:(NSString*)screenerName isM3u8:(BOOL)m3u8 {
//    return [NSString  stringWithFormat:@"Library/%@/%@/user_%@/screener_%@",CBC_CACHE_APPLICATION_SUPPORT,CBC_CACHE_OFFLINE,userId,screenerName];
//}


@end
