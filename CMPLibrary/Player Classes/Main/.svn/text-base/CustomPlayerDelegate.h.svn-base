#import <UIKit/UIKit.h>
#import "PlayerProductConstants.h"


@protocol CustomPlayerDelegate <NSObject>

@optional
//Fired when player is on pause
-(void)didPause;

//Fired when player did play and did resume
-(void)didPlay;

//Fired when the player is playbacked frame by frame (Example - 00:00:20:22  to 00:00:20:23)
-(void)didStepFrame;

//Fired when the player is playbacked second by second (Example - 00:00:20:22  to 00:00:21:22)
-(void)didStepSecond;

//Fired when annotation mark out or point annotation is pressed
-(void)didAnnotationMarkIn:(NSString*)tcIn  markOut:(NSString*)tcout;

//Fired when the playlist index changes to a new playlist item.
-(void)didSwitchToPlayerItem:(NSInteger)index playlistType:(CMPItemType)playlistType;

//Fired when an item completes playback.
-(void)didCompletePlayback:(CMPItemType)playlistType;

//Fired when Toggle between Compact/Fullscreen 
-(void)didSwitchToFullScreen:(BOOL)isFullScreen;

@end
