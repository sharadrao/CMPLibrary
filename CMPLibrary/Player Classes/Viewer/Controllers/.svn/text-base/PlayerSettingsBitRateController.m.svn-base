//
//  PlayerSettingsBitRateController.m
//  CM Library
//
//  Created by Paridhi Malviya on 5/21/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import "PlayerSettingsBitRateController.h"
#import "CMPPlayerTrackCell.h"

#import "PlayerUtilities.h"
#import "PlayerProductConstants.h"

#import "Bitrate.h"
#import "NSString+MD5.h"
#import "PlayerCache.h"


#define CELL                    @"Cell"
#define CUSTOM_SCHEME           @"cspum3u8"

@interface PlayerSettingsBitRateController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView               *bitrateCollectionView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView        *activityIndicatorView;
@property (nonatomic, strong)        NSMutableArray                 *datasource;

@property (nonatomic, weak) IBOutlet UILabel                        *noBitrateLabel;

@end

@implementation PlayerSettingsBitRateController

#pragma mark - private methods
-(void)initHUD
{
    [_noBitrateLabel setHidden:YES];
    [_activityIndicatorView setTintColor:[UIColor colorWithRed:15.0f/255.0f green:167.0f/255.0f blue:230.0f/255.0 alpha:1.0]];
    [self loadBitrate];
}

-(void)loadBitrate
{
    [_activityIndicatorView startAnimating];
   
    NSString *urlString = @"";
    if ([self delegate]) {
        urlString = [[self delegate] getCurrentURLFromPlayer];
    }
    
    if((![urlString.pathExtension length]) || ([urlString.pathExtension caseInsensitiveCompare:M3U8]))
    {
        [_activityIndicatorView stopAnimating];
        [_noBitrateLabel setHidden:NO];
        return;
    }
    
    if([urlString rangeOfString:CUSTOM_SCHEME].location != NSNotFound) {
        urlString = [urlString stringByReplacingOccurrencesOfString:CUSTOM_SCHEME withString:@"http"];
    }
    
    NSString *m3u8String = [[[NSString alloc] initWithData:[PlayerCache objectForKey:[urlString MD5] withPath:@"cache_m3u8"] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
    DLog(@"url string %@", urlString);
        
    if(m3u8String)
    {
        _datasource = [[PlayerUtilities getBitratesFromM3u8:m3u8String withURL:urlString] mutableCopy];
        [_activityIndicatorView stopAnimating];
        
        if (![_datasource count])
        {
            [_noBitrateLabel setHidden:NO];
            return;
        }
        
        if ([_datasource count] == 1)
        {
            Bitrate *bitrate = [self.datasource firstObject];
            [bitrate setURL:urlString];
            [bitrate setBirtateTitle:@"Auto"];
            [bitrate setIsSelection:YES];
            [_datasource replaceObjectAtIndex:0 withObject:bitrate];
        }
        else if([_datasource count] > 1)
        {
            Bitrate *bitrate = [[Bitrate alloc] init];
            [bitrate setURL:urlString];
            [bitrate setBirtateTitle:@"Auto"];
            [bitrate setIsSelection:YES];
            [_datasource insertObject:bitrate atIndex:0];
        }
        
        [_bitrateCollectionView reloadData];
    }
    else
    {
        [PlayerUtilities downloadM3u8AndParseBandwidth:urlString completionHandler:^(NSArray *bandWidths, NSUInteger errorCode)
         {
             _datasource = [ NSMutableArray arrayWithArray:bandWidths];
             [_activityIndicatorView stopAnimating];
             
             if (![_datasource count])
             {
                 [_noBitrateLabel setHidden:NO];
                 return;
             }
             
             if(errorCode == TRACE_CODE_SUCCESS)
             {
                 if ([_datasource count] == 1)
                 {
                     Bitrate *bitrate = [self.datasource firstObject];
                     [bitrate setURL:urlString];
                     [bitrate setBirtateTitle:@"Auto"];
                     [bitrate setIsSelection:YES];
                     [_datasource replaceObjectAtIndex:0 withObject:bitrate];
                 }
                 else if([_datasource count] > 1)
                 {
                     Bitrate *bitrate = [[Bitrate alloc] init];
                     [bitrate setURL:urlString];
                     [bitrate setBirtateTitle:@"Auto"];
                     [bitrate setIsSelection:YES];
                     [_datasource insertObject:bitrate atIndex:0];
                 }
             }
             else {
                 [_noBitrateLabel setHidden:NO];
             }
             
             [_bitrateCollectionView reloadData];
         }];
    }
}

#pragma mark - self methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHUD];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectAutoByDefault) name:PLAYER_STOPPED_NOTIFICATION object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

-(void)dealloc {
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:PLAYER_STOPPED_NOTIFICATION object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - collection view delegates methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_datasource count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMPPlayerTrackCell *cell   = (CMPPlayerTrackCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CELL forIndexPath:indexPath];
    Bitrate *bitrateModel                         = [_datasource objectAtIndex:[indexPath row]];
    
    [cell setPlayerTrackSelection:bitrateModel.isSelection];
    [cell setPlayerTrackTitle:bitrateModel.birtateTitle];
        
    if (_datasource.count < 2) {
        [cell setUserInteractionEnabled:NO];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Bitrate *bitRate = (Bitrate*)[_datasource objectAtIndex:[indexPath item]];

    if([[self delegate] respondsToSelector:@selector(switchBitrate:)]) {
        [[self delegate] switchBitrate:bitRate];
    }
    
    NSUInteger index = [_datasource indexOfObjectPassingTest:^BOOL(Bitrate *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return ([obj isSelection]);
    }];
    
    NSMutableArray *indexPaths  = [NSMutableArray arrayWithCapacity:1];
    
    if(index != NSNotFound)
    {
        Bitrate *bitRateTrack = [_datasource objectAtIndex:index];
        [bitRateTrack setIsSelection:NO];
        [indexPaths addObject:[NSIndexPath indexPathForItem:index inSection:0]];
    }
    
    [bitRate setIsSelection:YES];

    [indexPaths addObject:indexPath];

    [self.bitrateCollectionView performBatchUpdates:^{
        [self.bitrateCollectionView reloadItemsAtIndexPaths:indexPaths];
    } completion:nil];
    
}
-(void)setSelectAutoByDefault
{
    NSMutableArray *indexPaths  = [NSMutableArray arrayWithCapacity:1];

    for (NSUInteger x= 0; x<_datasource.count; x++)
    {
        Bitrate *bitRateTrack = (Bitrate *) [_datasource objectAtIndex:x];
        if (x == 0) {
            [bitRateTrack setIsSelection:YES];
        }else{
            [bitRateTrack setIsSelection:NO];
        }
        [indexPaths addObject:[NSIndexPath indexPathForItem:x inSection:0]];
    }
    
    [self.bitrateCollectionView performBatchUpdates:^{
        [self.bitrateCollectionView reloadItemsAtIndexPaths:indexPaths];
    } completion:nil];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    if(cellCount)
    {
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellWidth*cellCount;
        CGFloat contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right;
        
        CGFloat cellHeight = ((UICollectionViewFlowLayout*) collectionViewLayout).itemSize.height + ((UICollectionViewFlowLayout*)collectionViewLayout).minimumLineSpacing;
        CGFloat contentHeight = collectionView.frame.size.height - collectionView.contentInset.top - collectionView.contentInset.bottom;
        
        CGFloat verticalPadding = 20.0f;
        CGFloat horizontalPadding = 20.0f;
        
        if( totalCellWidth < contentWidth) {
            horizontalPadding = (contentWidth - totalCellWidth) / 2.0;
        }
        
        if(cellHeight < contentHeight) {
            verticalPadding = (contentHeight - cellHeight) / 2.0;
        }
        
        return UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding);
        
    }
    return UIEdgeInsetsZero;
}


@end
