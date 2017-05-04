//
//  TouchManager.m
//  PlayerTest
//
//  Created by Deep Arora on 3/27/17.
//  Copyright © 2017 Deep Arora. All rights reserved.
//

#import "GestureHandler.h"

#define ANIMATION_DURATION 0.0f
#define MAX_SCALE          6.0f
#define MIN_SCALE          1.0f

@interface GestureHandler()
    @property(nonatomic) CGFloat scale, previousScale;
@end

@implementation GestureHandler

-(instancetype)initWithController:(CustomPlayerController *)controller
{
    if (self = [super init])
    {
        _previousScale = _scale = 1.0f;
        _playerController = controller;
    }
    
    return self;
}

#pragma mark - public methods
-(void)addPlayerGesture
{
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [pinchGesture setDelegate:self];
    [self.playerContainerSuperView addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.playerContainerSuperView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerSingleTapGesture:)];
    singleTap.numberOfTapsRequired = 1;
    [singleTap setDelegate:self];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [doubleTap setDelegate:self];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipeGesture.delegate = self;
    
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipeGesture.delegate = self;
    
    
    /* if(IS_IPHONE)
     {
     UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(fullscreenPinch:)];
     pinchGesture.delegate = self;
     [self.view addGestureRecognizer:pinchGesture];
     } */
    
    [self.playerController.view  addGestureRecognizer:singleTap];
    [self.playerController.view  addGestureRecognizer:doubleTap];
    [self.playerController.view  addGestureRecognizer:rightSwipeGesture];
    [self.playerController.view  addGestureRecognizer:leftSwipeGesture];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

#pragma mark - Gesture delegates

- (void)SwipeRecognizer:(UISwipeGestureRecognizer *)sender
{
    NSArray *itemArray = self.playerController.config.itemArray;
    
    if (self.playerController.selectedItemIndex >= [itemArray count]) {
        [self.playerController stopPlayers];
        return;
    }
    
    //Play Next Segment Clip of Playlist
}

-(void)playerDoubleTapGesture:(UIGestureRecognizer*)sender
{
    if(CGRectContainsPoint(self.playerControlsView.frame, [sender locationInView:self.playerContainerView]))
    {
        if(self.playerControlsView.alpha >= 0.3f) {
            return;
        }
    }
    
    if(IS_IPHONE)
    {
        if(self.playerController.isFullscreen) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        }
        else {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];
        }
        
        //Force Changes of Device Orientation when performed fullscreen playbacks
        [self.playerController setIsFullScreen:self.playerController.isFullscreen];
    }
    else
    {
        self.playerController.isFullscreen = !self.playerController.isFullscreen;
        [self.playerController setIsFullScreen:self.playerController.isFullscreen];
    }
}

-(void)pinchGesture:(UIPinchGestureRecognizer*)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        _previousScale = _scale;
    }
    
    CGFloat currentScale = MAX(MIN([gesture scale] * _scale, MAX_SCALE), MIN_SCALE);
    CGFloat scaleStep = currentScale / _previousScale;
    [gesture.view setTransform: CGAffineTransformScale(gesture.view.transform, scaleStep, scaleStep)];
    
    _previousScale = currentScale;
    
    CGFloat controlsHeight = [self.playerControlsView frame].size.height;
    
    if(self.playerController.isFullscreen) {
        controlsHeight = 0.0f;
    }
    
    CGRect recognizerFrame = gesture.view.frame;
    if (recognizerFrame.origin.x > self.playerController.view.bounds.origin.x)
    {
        recognizerFrame.origin.x = 0;
        gesture.view.frame = recognizerFrame;
    }
    else if ((recognizerFrame.origin.x + recognizerFrame.size.width) < self.playerController.view.bounds.size.width)
    {
        recognizerFrame.origin.x = self.playerController.view.bounds.size.width - recognizerFrame.size.width;
        gesture.view.frame = recognizerFrame;
    }
    
    if (recognizerFrame.origin.y >= self.playerController.view.bounds.origin.y)
    {
        recognizerFrame.origin.y = 0;
        gesture.view.frame = recognizerFrame;
    }
    else if ((recognizerFrame.origin.y + recognizerFrame.size.height) <= (self.playerController.view.bounds.size.height - controlsHeight))
    {
        recognizerFrame.origin.y = (self.playerController.view.bounds.size.height - controlsHeight) - recognizerFrame.size.height;
        gesture.view.frame = recognizerFrame;
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled || [gesture state] == UIGestureRecognizerStateFailed) {
        _scale = currentScale;
    }
}


-(void)panGesture:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translation = [recognizer translationInView:self.playerController.view];
    CGRect recognizerFrame = recognizer.view.frame;
    
    recognizerFrame.origin.x += translation.x;
    recognizerFrame.origin.y += translation.y;
    
    CGFloat controlsHeight = [self.playerControlsView bounds].size.height;
    
    if(self.playerController.isFullscreen) {
        controlsHeight = 0.0f;
    }
    
    if (recognizerFrame.origin.x > self.playerController.view.bounds.origin.x) {
        recognizerFrame.origin.x = 0;
    }
    else if ((recognizerFrame.origin.x + recognizerFrame.size.width) < self.playerController.view.bounds.size.width) {
        recognizerFrame.origin.x = self.playerController.view.bounds.size.width - recognizerFrame.size.width;
    }
    
    if (recognizerFrame.origin.y >= self.playerController.view.frame.origin.y) {
        recognizerFrame.origin.y = 0;
    }
    else if ((recognizerFrame.origin.y + recognizerFrame.size.height) <= (self.playerController.view.bounds.size.height - controlsHeight)) {
        recognizerFrame.origin.y = (self.playerController.view.bounds.size.height - controlsHeight) - recognizerFrame.size.height;
    }
    
    if (_scale > 1 || _previousScale > 1)
    {
        recognizer.view.frame = recognizerFrame;
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.playerController.view];
    }
}


-(void)playerSingleTapGesture:(UIGestureRecognizer*)sender
{
    if(CGRectContainsPoint(self.playerControlsView.frame, [sender locationInView:self.playerContainerView]))
    {
        if(self.playerControlsView.alpha >= 0.3f) {
            return;
        }
    }
    
    if(self.playerController.isFullscreen)
    {
      
        if(self.playerHeaderView.isHidden){
            [self.playerController showHeaderAndControlsView];
        }
        else {
            [self.playerController hideHeaderAndControlsView];
        }
    }
}

- (void)fullscreenPinch:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (recognizer.scale > 1.0f)
        {
            if(IS_IPHONE) {
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];
            }
            else {
                [self.playerController setIsFullScreen:YES];
            }
        }
        else
        {
            if(IS_IPHONE) {
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIInterfaceOrientationPortrait] forKey:@"orientation"];
            }
            else {
                [self.playerController setIsFullScreen:NO];
            }
        }
        
        recognizer.scale = 0.0f;
    }
}


@end
