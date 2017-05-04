//
//  PlayerSettingsAudioTrackController.m
//  CM Library
//
//  Created by Paridhi Malviya on 5/23/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import "PlayerSettingsAudioTrackController.h"
//#import "PlayerDownloadManager.h"
#import "Bitrate.h"
#import "CMPPlayerTrackCell.h"
//#import "PlayerServicesConstants.h"
#import "PlayerTrack.h"

#define CELL        @"Cell"

@interface PlayerSettingsAudioTrackController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak)   IBOutlet UICollectionView               *audioTrackCollectionView;
@property (nonatomic, weak)   IBOutlet UIActivityIndicatorView        *activityIndicatorView;
@property (nonatomic, assign) BOOL                                    isBitRateChecking;
@property (nonatomic, weak) IBOutlet UILabel *noAudiotrackLabel;

@property (nonatomic, strong) NSArray                                 *audioTrackDatasource;
@property (nonatomic, strong) NSMutableArray                          *audioTrackArray;
@property (nonatomic, strong) NSIndexPath                             *lastSelectedIndexPath;

@end

@implementation PlayerSettingsAudioTrackController

#pragma mark - private methods
-(void)initHUD
{
    [_noAudiotrackLabel setHidden:YES];
    [self loadAudioTrack];
}

-(void)loadAudioTrack
{
    _lastSelectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [_activityIndicatorView startAnimating];
    
    if([self delegate]) {
        _audioTrackDatasource  = [[self delegate]getAudioTracks];
    }
    
     NSString *selectedTrack = @"";
    
    if([[self delegate] respondsToSelector:@selector(getCurrentAudioTrackName)]) {
        selectedTrack  = [self.delegate getCurrentAudioTrackName];
    }
    
    if (![_audioTrackDatasource count])
    {
        [_noAudiotrackLabel setHidden:NO];
        [_activityIndicatorView stopAnimating];
        return;
    }
    
    NSIndexSet *set = [_audioTrackDatasource indexesOfObjectsPassingTest:^BOOL(PlayerTrack *track, NSUInteger idx, BOOL * _Nonnull stop) {
           return ([selectedTrack isEqualToString:track.trackName]);
       }];
    
    if(set.count > 1) {
        PlayerTrack *track = [_audioTrackDatasource firstObject];
        [track setEnabled:YES];
    }
    else {
        PlayerTrack *track = [_audioTrackDatasource objectAtIndex:set.firstIndex];
        [track setEnabled:YES];
    }
    
    [_audioTrackCollectionView reloadData];
    [_activityIndicatorView stopAnimating];
}

#pragma mark - self methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHUD];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)dealloc
{
    _audioTrackDatasource   = nil;
    _audioTrackArray        = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - collection view delegates methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_audioTrackDatasource count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMPPlayerTrackCell  *cell      = (CMPPlayerTrackCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CELL forIndexPath:indexPath];
    PlayerTrack *track                              = [_audioTrackDatasource objectAtIndex:[indexPath row]];
    
    if (_audioTrackDatasource.count < 2) {
        [cell setUserInteractionEnabled:NO];
    }

    [cell setPlayerTrackTitle:[track trackName]];
    [cell setPlayerTrackSelection:track.enabled];
     
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerTrack *track = [_audioTrackDatasource objectAtIndex:[indexPath row]];
    
    if([[self delegate] respondsToSelector:@selector(switchAudioTrack:)]) {
        [[self delegate] switchAudioTrack:track];
    }
    
    NSUInteger index = [_audioTrackDatasource indexOfObjectPassingTest:^BOOL(PlayerTrack *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return ([obj isEnabled]);
    }];
    
    NSMutableArray *indexPaths  = [NSMutableArray arrayWithCapacity:1];
    
    if(index != NSNotFound)
    {
        PlayerTrack *track = [_audioTrackDatasource objectAtIndex:index];
        [track setEnabled:NO];
        [indexPaths addObject:[NSIndexPath indexPathForItem:index inSection:0]];
    }
   
    [track setEnabled:YES];
    if (![indexPaths containsObject:indexPath]) {
        [indexPaths addObject:indexPath];
    }
    
    [self.audioTrackCollectionView performBatchUpdates:^{
        [self.audioTrackCollectionView reloadItemsAtIndexPaths:indexPaths];
    } completion:nil];
    
    _lastSelectedIndexPath = indexPath;
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
