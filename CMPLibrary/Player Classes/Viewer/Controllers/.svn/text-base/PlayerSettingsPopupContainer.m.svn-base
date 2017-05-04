//
//  PlayerSettingsPopupContainer.m
//  CM Library
//
//  Created by Paridhi Malviya on 5/20/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import "PlayerUtilities.h"
#import "PlayerProductConstants.h"

#import "PlayerSettingsPopupContainer.h"
#import "PlayerSettingsPopupAnnotationController.h"
#import "PlayerSettingsBitRateController.h"
#import "PlayerSettingsAudioTrackController.h"
#import "PlayerSettingsSubtitlesController.h"

@interface PlayerSettingsPopupContainer ()

@property (nonatomic, strong) UIPageViewController                          *pageViewController;
@property (nonatomic, strong) NSMutableArray                                *viewControllers;
@property (nonatomic, strong) NSArray                                       *categoryArray;
@property (nonatomic, assign) NSInteger                                      pageIndex;

@property (nonatomic, strong) UIViewController                              *controller;
@property (nonatomic, strong) PlayerSettingsPopupAnnotationController    *annotationController;
@property (nonatomic, strong) PlayerSettingsBitRateController            *bitrateController;
@property (nonatomic, strong) PlayerSettingsAudioTrackController         *audioTrackController;
@property (nonatomic,strong)  PlayerSettingsSubtitlesController          *subtitlesController;
@end


@implementation PlayerSettingsPopupContainer

#pragma mark - private methods
-(void)initialize
{
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [_pageViewController setDelegate:self];
    [_pageViewController setDataSource:self];
}

-(void)initHUD
{
    _pageIndex = 0;
    [self showSelectedOptionController];
}

-(void)showSelectedOptionController
{
    
    _viewControllers = [[NSMutableArray alloc]initWithCapacity:[_categoryArray count]];
    
    for(NSString *category in _categoryArray)
    {
        if(![category caseInsensitiveCompare:@"Audio"])
        {
            _audioTrackController    = (PlayerSettingsAudioTrackController*)[PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_PLAYER_SETTINGS_AUDIO_TRACK_CONTROLLER];
            [_audioTrackController setDelegate:[self delegate]];
            [_viewControllers addObject:_audioTrackController];
        }
        else if(![category caseInsensitiveCompare:@"Quality"])
        {
            _bitrateController    = (PlayerSettingsBitRateController*)[PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_PLAYER_SETTINGS_BITRATE_CONTROLLER];
            [_bitrateController setDelegate:[self delegate]];
            [_viewControllers addObject:_bitrateController];
        }
        else if (![category caseInsensitiveCompare:@"Annotation"])
        {
            _annotationController = (PlayerSettingsPopupAnnotationController*)[PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_PLAYER_SETTINGS_ANNOTATION_CONTROLLER];
            [_annotationController setDelegate:[self delegate]];
            [_viewControllers addObject:_annotationController];
        }
        else if (![category caseInsensitiveCompare:@"Subtitles"])
        {
            _subtitlesController = (PlayerSettingsSubtitlesController*)[PlayerUtilities getControllerWithStoryBoardId:STORYBOARD_ID_PLAYER_SETTINGS_SUBTITLES_CONTROLLER];
            [_subtitlesController setDelegate:[self delegate]];
            [_viewControllers addObject:_subtitlesController];
        }
        
    }
    
    [_pageViewController setViewControllers:@[[self getController]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    _pageViewController.view.frame = self.view.frame;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
}

#pragma mark - public methods
-(void)switchToSelectedOption:(NSInteger)item
{
    if(_pageIndex == item) {
        return;
    }
    _pageIndex = item;
    UIViewController *selectedOption = _viewControllers[item];
    [_pageViewController setViewControllers:@[selectedOption] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

-(void)getCategories:(NSArray *)categoryArray {
    _categoryArray = categoryArray;
}

-(UIViewController*)getController
{
    _controller = _viewControllers[_pageIndex];
    return _controller;
}


#pragma mark - self methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];
    [self initHUD];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    _viewControllers        =   nil;
    _controller             =   nil;
    _pageViewController     =   nil;
    _annotationController   =   nil;
    _categoryArray          =   nil;
    _bitrateController      =   nil;
    _audioTrackController   =   nil;
}


#pragma mark - page view controller data source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [_viewControllers indexOfObject:viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;

    return _viewControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [_viewControllers indexOfObject:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [_viewControllers count]) {
        return nil;
    }
    
    return _viewControllers[index];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSUInteger index = [self.viewControllers indexOfObject: [pageViewController.viewControllers lastObject]];
    _pageIndex = index;

    if([[self switchOptionDelegate] respondsToSelector:@selector(switchCategoryOption:)]) {
        [[self switchOptionDelegate] switchCategoryOption:_pageIndex];
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [_viewControllers count];
}

@end
