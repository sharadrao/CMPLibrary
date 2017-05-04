//
//  PlayerSettingsPopupAnnotationController.m
//  CM Library
//
//  Created by Paridhi Malviya on 5/21/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import "PlayerSettingsPopupAnnotationController.h"
#import "PlayerSettingsCategoryCellmodel.h"
#import "PlayerSettingsCollectionViewCell.h"

#define COMMENT_POSITION_MAX_COUNT       7
#define COMMENT_POSITION_MIN_COUNT       0
#define COMMENT_FONTSIZE_MAX_COUNT       4
#define COMMENT_FONTSIZE_MIN_COUNT       0
#define COLOR_COUNT                      5

@interface PlayerSettingsPopupAnnotationController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray                    *colorModelArray;

@property (nonatomic, assign) NSInteger                         commentPositionCount;
@property (nonatomic, assign) NSInteger                         commentFontSizeCount;

@property (nonatomic, strong) IBOutlet UICollectionView         *colorButtonCollectionView;
@property (nonatomic, weak)   IBOutlet UIButton                 *moveCommentUpButton;
@property (nonatomic, weak)   IBOutlet UIButton                 *moveCommentDownButton;
@property (nonatomic, weak)   IBOutlet UIButton                 *increaseCommentFontSizeButton;
@property (nonatomic, weak)   IBOutlet UIButton                 *decreaseCommentFontSizeButton;
@property (nonatomic, weak)   IBOutlet UIButton                 *moveCommentLeftButton;
@property (nonatomic, weak)   IBOutlet UIButton                 *moveCommentRightButton;

@end

@implementation PlayerSettingsPopupAnnotationController

- (IBAction)moveCommentLeftButtonAction:(id)sender
{
    if([[self delegate] respondsToSelector:@selector(moveCommentLeft)]) {
        [[self delegate] moveCommentLeft];
    }
}

- (IBAction)moveCommentUpButtonAction:(id)sender
{
    if([[self delegate] respondsToSelector:@selector(moveCommentUp)]) {
        [[self delegate] moveCommentUp];
    }
    
    ++_commentPositionCount;
    
    [self handleEnablingDisablingOfPositionButtons];
}

- (IBAction)moveCommentRightButtonAction:(id)sender
{
    if([[self delegate] respondsToSelector:@selector(moveCommentRight)]) {
        [[self delegate] moveCommentRight];
    }
}

- (IBAction)moveCommentDownButtonAction:(id)sender
{
    if(_commentPositionCount)
    {
        if([[self delegate] respondsToSelector:@selector(moveCommentDown)]) {
            [[self delegate] moveCommentDown];
        }
    }

    --_commentPositionCount;
    
    [self handleEnablingDisablingOfPositionButtons];
}

- (IBAction)increaseFontSizeButtonAction:(id)sender
{
    if([[self delegate] respondsToSelector:@selector(increaseCommentTextFontSize)]) {
        [[self delegate] increaseCommentTextFontSize];
    }
    
    ++_commentFontSizeCount;
    [self handleEnablingDisablingOfFontSizeButtons];
}

- (IBAction)decreaseFontSizeButtonAction:(id)sender
{
    if([[self delegate] respondsToSelector:@selector(decreaseCommentTextFontSize)]) {
        [[self delegate] decreaseCommentTextFontSize];
    }
    
    --_commentFontSizeCount;
    [self handleEnablingDisablingOfFontSizeButtons];
}

#pragma mark - private methods
-(void)initHUD
{
    _colorModelArray                = [[NSMutableArray alloc]init];
    _commentPositionCount           = 1; //we can make its position down once
    _commentFontSizeCount           = 2; // we can make font size less 2 times
    
    [_moveCommentLeftButton setEnabled:NO];
    [_moveCommentRightButton setEnabled:NO];
    
    for(int i = 0 ; i < COLOR_COUNT ; i++)
    {
        PlayerSettingsCategoryCellmodel *colorModel = [[PlayerSettingsCategoryCellmodel alloc]init];
        
        if(i == 0)
        {
            [colorModel setIsSelected:YES];
            [_colorModelArray addObject:colorModel];
            continue;
        }
        [colorModel setIsSelected:NO];
        [_colorModelArray addObject:colorModel];
    }
    
    [_colorButtonCollectionView reloadData];
}

-(void)handleEnablingDisablingOfPositionButtons
{
    if(_commentPositionCount == COMMENT_POSITION_MAX_COUNT)
    {
        [_moveCommentUpButton setEnabled:NO];
        [_moveCommentDownButton setEnabled:YES];
    }
    else if(_commentPositionCount < COMMENT_POSITION_MAX_COUNT && _commentPositionCount > COMMENT_POSITION_MIN_COUNT)
    {
        [_moveCommentUpButton setEnabled:YES];
        [_moveCommentDownButton setEnabled:YES];
    }
    else if (_commentPositionCount == COMMENT_POSITION_MIN_COUNT)
    {
        [_moveCommentUpButton setEnabled:YES];
        [_moveCommentDownButton setEnabled:NO];
    }
}

-(void)handleEnablingDisablingOfFontSizeButtons
{
    if(_commentFontSizeCount == COMMENT_FONTSIZE_MAX_COUNT)
    {
        [_increaseCommentFontSizeButton setEnabled:NO];
        [_decreaseCommentFontSizeButton setEnabled:YES];
    }
    else if (_commentFontSizeCount < COMMENT_FONTSIZE_MAX_COUNT && _commentFontSizeCount > COMMENT_FONTSIZE_MIN_COUNT)
    {
        [_increaseCommentFontSizeButton setEnabled:YES];
        [_decreaseCommentFontSizeButton setEnabled:YES];
    }
    else if (_commentFontSizeCount == COMMENT_FONTSIZE_MIN_COUNT)
    {
        [_increaseCommentFontSizeButton setEnabled:YES];
        [_decreaseCommentFontSizeButton setEnabled:NO];
    }
}

#pragma mark - self methods

-(void)viewDidLoad
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

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    _colorModelArray            = nil;
}


#pragma  mark - collection view delegates methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return COLOR_COUNT;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(32, 32);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedColorImageArray     = [[NSArray alloc]initWithObjects:@"whiteActive",@"greyActive",@"yellowActive",@"blueActive",@"blackActive",nil];
    NSArray *deSelectedColorImageArray   = [[NSArray alloc] initWithObjects:@"white",@"grey",@"yellow",@"blue",@"black",nil];
    
    PlayerSettingsCollectionViewCell  *cell = (PlayerSettingsCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    PlayerSettingsCategoryCellmodel *categoryModel = [_colorModelArray objectAtIndex:[indexPath row]];
    
    if([categoryModel isSelected]) {
        [[cell categoryImageView] setImage:[UIImage imageNamed:[selectedColorImageArray objectAtIndex:[indexPath row]]]];
    }
    else {
        [[cell categoryImageView] setImage:[UIImage imageNamed:[deSelectedColorImageArray objectAtIndex:[indexPath row]]]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSUInteger index = [_colorModelArray indexOfObjectPassingTest:^BOOL(PlayerSettingsCategoryCellmodel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return ([obj isSelected] == YES);
    }];
    
    if(index != NSNotFound)
    {
        PlayerSettingsCategoryCellmodel *model = [_colorModelArray objectAtIndex:index];
        [model setIsSelected:NO];
    }
    
    PlayerSettingsCategoryCellmodel *model = [_colorModelArray objectAtIndex:[indexPath row]];
    [model setIsSelected:YES];

    UIColor *color = [[UIColor alloc]initWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];

    switch ([indexPath row])
    {
        case 0:
            color = [UIColor whiteColor];
            break;
        case 1:
            color = [UIColor grayColor];
            break;
        case 2:
            color = [UIColor yellowColor];
            break;
        case 3:
            color = [UIColor colorWithRed:62.0f/255.0f green:212.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
            break;
        case 4:
            color = [UIColor blackColor];
            break;
        default:
            break;
    }
    
    if([[self delegate] respondsToSelector:@selector(setCommentTextColor:)]) {
        [[self delegate] setCommentTextColor:color];
    }

    [_colorButtonCollectionView reloadData];
}


@end


