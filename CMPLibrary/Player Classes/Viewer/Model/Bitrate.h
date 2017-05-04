//
//  Bitrate.h
//  CM Library
//
//  Created by Dipak on 5/3/16.
//  Copyright © 2016 Prime Focus Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bitrate : NSObject

@property (nonatomic, strong) NSString  *URL;
@property (nonatomic, strong) NSString  *birtateTitle;
@property (nonatomic, assign) double    bitrate;
@property (nonatomic, assign) BOOL      isSelection;

@end
