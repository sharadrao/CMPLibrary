//
//  PlayerSettingsPopupViewController.m
//  CM Library
//
//  Created by Paridhi Malviya on 5/20/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import "PlayerSettingsPopupViewController.h"
#import "PlayerUtilities.h"
#import "PlayerProductConstants.h"
#import "PlayerSettingsCollectionViewCell.h"
#import "PlayerSettingsPopupContainer.h"
#import "PlayerSettingsCategoryCellmodel.h"

#define SETTINGS_POPUP_SEGUE    @"settings_popup_segue"
#define CELL                    @"Cell"


@interface PlayerSettingsPopupViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)        PlayerSettingsPopupInterface *interface;
@property (nonatomic, strong)        PlayerSettingsPopupContainer *playerSettingsPopupController;

@property (nonatomic, strong)        NSArray                         *categoryNameArray;
@property (nonatomic, strong)        NSMutableArray                  *categoryModelArray;

@property (nonatomic, assign)        NSInteger                       selectedIndex;

@end


@implementation PlayerSettingsPopupViewController

#pragma mark - private methods
-(void)reloadData {
    [_categoriesCollectionView reloadData];
}

-(void)initHUD
{
    _categoryNameArray = [[NSArray alloc]initWithArray:_interface.categoryArray];
    
    _categoryModelArray = [[NSMutableArray alloc]init];
    [self setPlayerSettingsCategoryModel];
    
    [_categoriesCollectionView reloadData];

    [_playerSettingsPopupController switchToSelectedOption:0];
}

-(void)setPlayerSettingsCategoryModel
{
    for(int i = 0; i < [_categoryNameArray count]; i++)
    {
        PlayerSettingsCategoryCellmodel *categoryModel = [[PlayerSettingsCategoryCellmodel alloc] init];
        
        [categoryModel setCategoryName:[_categoryNameArray objectAtIndex:i]];
        
        if(i == 0)
        {
            [categoryModel setIsSelected:YES];
            [_categoryModelArray addObject:categoryModel];
            
            continue;
        }
        
        [categoryModel setIsSelected:NO];
        
        [_categoryModelArray addObject:categoryModel];
    }
}

#pragma mark - public methods
+(UIViewController*)initWithInterface:(PlayerSettingsPopupInterface*)interface withDelegate:(id)delegate;
{
    PlayerSettingsPopupViewController *controller = (PlayerSettingsPopupViewController*)[PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_PLAYER_SETTINGS_POPUP_CONTROLLER];
    [controller setInterface:interface];
    [controller setDelegate:delegate];
    
    NSAssert(interface, @"Interface must be set to initialise player settings pop up controller...");

    return  controller;
}

#pragma mark - self methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:BIT_RATE_CHANGE_NOTIFICATION object:nil];
    
    [self initHUD];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}

-(void)dealloc
{
    _playerSettingsPopupController  = nil;
    _categoryNameArray              = nil;
    _categoryModelArray             = nil;
    _interface                      = nil;
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:BIT_RATE_CHANGE_NOTIFICATION object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - collection view delegates methods

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right;
    CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width + ((UICollectionViewFlowLayout*)collectionViewLayout).minimumLineSpacing;
    
    NSInteger totalCellWidth    =  cellWidth * ([_categoryNameArray count]);
    CGFloat emptySpace          =  contentWidth - (CGFloat)totalCellWidth;
    CGFloat interItemSpace      =  emptySpace / ([_categoryNameArray count] + 1);
    return interItemSpace;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_categoryNameArray count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *categoryName = [_categoryNameArray objectAtIndex:[indexPath row]];
    
    categoryName                =  [categoryName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    categoryName                =  [categoryName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *selectedImage     =  [[categoryName lowercaseString] stringByAppendingString:@"On"];
    NSString *deselectedImage   =  [[categoryName lowercaseString] stringByAppendingString:@"Off"];

    PlayerSettingsCollectionViewCell  *cell = (PlayerSettingsCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CELL forIndexPath:indexPath];
    PlayerSettingsCategoryCellmodel *categoryModel = [_categoryModelArray objectAtIndex:[indexPath row]];
    
    if([categoryModel isSelected])
    {
        [[cell categoryImageView] setImage:[UIImage imageNamed:selectedImage]];
        cell.categoryNameLabel.textColor = [UIColor colorWithRed:41.0f/255.0f green:185.0f/255.0f blue:248.0f/255.0f alpha:1.0f];

    }
    else
    {
        [[cell categoryImageView] setImage:[UIImage imageNamed:deselectedImage]];
        cell.categoryNameLabel.textColor = [UIColor colorWithRed:198.0f/255.0f green:198.0f/255.0f blue:198.0f/255.0f alpha:.85f];
    }
    
    if(![categoryName caseInsensitiveCompare:@"quality"])
    {
//        NSArray *bitRateOption = [[[self delegate] getCurrentBitRate] componentsSeparatedByString:@":"];
//        NSString    *mode = [bitRateOption firstObject];
//        double      value = [[bitRateOption lastObject] doubleValue];
//        
//        if(value > 0)
//        {
//            if(![mode caseInsensitiveCompare:@"auto"]) {
//                mode = [NSString stringWithFormat:@"Auto (%@)",[PlayerUtilities getBitrateName:value]];
//            }
//            else {
//                mode = [NSString stringWithFormat:@"%@",[PlayerUtilities getBitrateName:value]];
//            }
//        }
//        else {
//            mode = @"Auto";
//        }
        
//        categoryName = [NSString stringWithFormat:@"%@", mode];
    }
    else if(![categoryName caseInsensitiveCompare:@"audio"])
    {
//        if ([[self delegate] getCurrentAudioTrackName]) {
//            categoryName = [[self delegate] getCurrentAudioTrackName];
//        }
    }
    else if (![categoryName caseInsensitiveCompare:@"Subtitles"])
    {
//        if ([[self delegate] getCurrentSubtitleName]) {
//            categoryName = [[self delegate] getCurrentSubtitleName];
//        }
    }
    
    [[cell categoryNameLabel] setText:categoryName];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = [indexPath row];
    
    NSUInteger index = [_categoryModelArray indexOfObjectPassingTest:^BOOL(PlayerSettingsCategoryCellmodel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return ([obj isSelected] == YES);
    }];
    
    if(index != NSNotFound)
    {
        PlayerSettingsCategoryCellmodel *model = [_categoryModelArray objectAtIndex:index];
        [model setIsSelected:NO];
    }
    
    PlayerSettingsCategoryCellmodel *model = [_categoryModelArray objectAtIndex:[indexPath row]];
    [model setIsSelected:YES];
    
    [_categoriesCollectionView reloadData];
    
    [_playerSettingsPopupController switchToSelectedOption:[indexPath item]];
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    
    if(cellCount)
    {
        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width + ((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellWidth * cellCount;
        CGFloat contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right;
        
        CGFloat cellHeight = ((UICollectionViewFlowLayout*) collectionViewLayout).itemSize.height + ((UICollectionViewFlowLayout*)collectionViewLayout).minimumLineSpacing;
        CGFloat contentHeight = collectionView.frame.size.height - collectionView.contentInset.top - collectionView.contentInset.bottom;
        
        CGFloat verticalPadding =20.0f;
        CGFloat horizontalPadding = 20.0f;
        
        if (IS_IPHONE) {
            //For Alligning Subtitles in Settings popup
            horizontalPadding = -15.0f;
        }
        
        
        
        if( totalCellWidth < contentWidth) {
            horizontalPadding = (contentWidth - totalCellWidth) / ([_categoryNameArray count]+1);
        }
        
        if (IS_IPAD) {
            if(cellHeight < contentHeight) {
                verticalPadding = (contentHeight - cellHeight) / 2.0f;
            }
        } else {
            verticalPadding = 0;
        }
        return UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding); //top, left, bottom, right
    }
    
    return UIEdgeInsetsZero;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueId = segue.identifier;
    if([segueId caseInsensitiveCompare:SETTINGS_POPUP_SEGUE] == NSOrderedSame)
    {
        _playerSettingsPopupController = (PlayerSettingsPopupContainer*)[segue destinationViewController];
        [_playerSettingsPopupController setDelegate:[self delegate]];
        
        [_playerSettingsPopupController getCategories:_interface.categoryArray];
        [_playerSettingsPopupController setSwitchOptionDelegate:(id)self];
    }
}

#pragma mark - player settings switch option delegate method
-(void)switchCategoryOption:(NSInteger)index
{
    if(_selectedIndex == index) {
        return;
    }
    
    NSUInteger currentIndex = [_categoryModelArray indexOfObjectPassingTest:^BOOL(PlayerSettingsCategoryCellmodel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return ([obj isSelected] == YES);
    }];
    
    if(currentIndex != NSNotFound)
    {
        PlayerSettingsCategoryCellmodel *model = [_categoryModelArray objectAtIndex:currentIndex];
        [model setIsSelected:NO];
    }
    
    PlayerSettingsCategoryCellmodel *selectedModel = [_categoryModelArray objectAtIndex:index];
    [selectedModel setIsSelected:YES];
    
    [_categoriesCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index  inSection:0],[NSIndexPath indexPathForItem:_selectedIndex inSection:0]]];
    _selectedIndex = index ;
    [_categoriesCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index  inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

@end
