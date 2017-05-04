//
//  SubtitleTimedTextEntitlementsModel.h
//  ClearBC
//
//  Created by Damodar Namala on 13/01/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubtitleTimedTextEntitlementsModel : NSObject
{

}
@property (nonatomic, strong) NSString                      *text;
@property (nonatomic, strong) NSString                      *lineNumber;
@property (nonatomic,strong)  NSMutableArray *formatingTextEntitlements;

@end
