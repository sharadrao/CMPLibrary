//
//  PlayerSettingsSubtitlesController.m
//  CM Library
//
//  Created by Sudhanshu Saraswat on 16/08/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import "PlayerTrack.h"
#import "PlayerUtilities.h"
#import "CMPPlayerTrackCell.h"
#import "PlayerProductConstants.h"
#import "PlayerSettingsSubtitlesController.h"


#define SUBTITLE_CELL_IDENTIFIER       @"subtitleCell"



@interface PlayerSettingsSubtitlesController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView                *subtitlesCollectionView;
@property (nonatomic, weak) IBOutlet UILabel                         *noSubtileFound;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView         *subtitleActivityIndicator;
@property (nonatomic, strong) NSMutableArray                         *subtitlesArray;
@property (nonatomic, strong) NSString                               *selectedSubtitle;
@property (nonatomic, strong) UIFont                                 *cellFont;
@property (nonatomic, assign) BOOL                                   isSubtitleSelected;

@end

@implementation PlayerSettingsSubtitlesController

-(void)initHUD
{
    [_noSubtileFound setHidden:YES];
    _cellFont = [UIFont fontWithName:HELVETICA_NEUE size:14.0];
    [self loadSubtitle];
}

-(void)loadSubtitle
{
    if([[self delegate] respondsToSelector:@selector(getSubTitles)]) {
        _subtitlesArray = [[[self delegate] getSubTitles] mutableCopy];
    }
    
    if([[self delegate] respondsToSelector:@selector(getCurrentSubtitleName)]) {
        _selectedSubtitle  = [self.delegate getCurrentSubtitleName];
    }
    
    if (![_subtitlesArray count])
    {
        [_noSubtileFound setHidden:NO];
        return;
    }
    
    PlayerTrack *offTrack = [PlayerTrack trackWithName:@"Off" URL:nil];
    [_subtitlesArray insertObject:offTrack atIndex:0];
    
    NSUInteger index = [_subtitlesArray indexOfObjectPassingTest:^BOOL(PlayerTrack *track, NSUInteger idx, BOOL * _Nonnull stop) {
        return ([_selectedSubtitle isEqualToString:track.trackName]);
    }];
    
    if(index != NSNotFound)
    {
        PlayerTrack *track              = [_subtitlesArray objectAtIndex:index];
        track.enabled                   = YES;
    }
    else
    {
        PlayerTrack *track              = [_subtitlesArray firstObject];
        track.enabled                   = YES;
    }
    
    [_subtitlesCollectionView reloadData];
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

#pragma  mark - collection view delegates methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _subtitlesArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMPPlayerTrackCell *cell            = (CMPPlayerTrackCell*)[collectionView dequeueReusableCellWithReuseIdentifier:SUBTITLE_CELL_IDENTIFIER forIndexPath:indexPath];
    
    PlayerTrack *track                           = [_subtitlesArray objectAtIndex:[indexPath row]];
   
    [cell setPlayerTrackTitle:track.trackName];
    [cell setPlayerTrackSelection:track.enabled];
    
    _cellFont = [UIFont fontWithName:HELVETICA_NEUE size:14.0];
    [[cell.trackButton titleLabel] setFont:_cellFont];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerTrack *selectedTrack = [_subtitlesArray objectAtIndex:[indexPath item]];
    
    if([[self delegate] respondsToSelector:@selector(switchSubtitle:)]) {
        if (indexPath.item > 0) {
            selectedTrack.enabled = YES;
        }else{
            // 0 the index for stop the displaying subtitle so we are desabling here
            selectedTrack.enabled = NO;
        }
        [[self delegate] switchSubtitle:selectedTrack];
    }
    NSUInteger index = [_subtitlesArray indexOfObjectPassingTest:^BOOL(PlayerTrack *track, NSUInteger idx, BOOL * _Nonnull stop) {
        return track.enabled;
    }];
    
    NSMutableArray *indexPaths  = [NSMutableArray arrayWithCapacity:1];
    
    if(index != NSNotFound)
    {
        PlayerTrack *track = [_subtitlesArray objectAtIndex:index];
        [track setEnabled:NO];
        [indexPaths addObject:[NSIndexPath indexPathForItem:index inSection:0]];
    }
    
    [selectedTrack setEnabled:YES];
    
    if (![indexPaths containsObject:indexPath]) {
        [indexPaths addObject:indexPath];
    }
    [self.subtitlesCollectionView performBatchUpdates:^{
        [self.subtitlesCollectionView reloadItemsAtIndexPaths:indexPaths];
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
        
        CGFloat verticalPadding   = 40.0f;
        CGFloat horizontalPadding = 40.0f;
        
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
           CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;

    PlayerTrack *track = _subtitlesArray[indexPath.row];
    CGFloat cellPadding  = 40;
    CGFloat width  = [track.trackName boundingRectWithSize:CGSizeMake(cellWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width + cellPadding;
    CGFloat height =   ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.height;

    return CGSizeMake(width , height);
}

-(void)dealloc {
    _subtitlesArray  = nil;
    _selectedSubtitle = nil;
}

@end
