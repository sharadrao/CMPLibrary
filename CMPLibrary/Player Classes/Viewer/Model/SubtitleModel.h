//
//  SubtitleModel.h
//  ClearBC
//
//  Created by Damodar Namala on 13/01/17.
//  Copyright © 2017 Prime Focus Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubtitleModel : NSObject {

}
@property (nonatomic, strong) NSString *tcIn;
@property (nonatomic, strong) NSString *tcOut;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) NSString *sccOriginalTcIn;
@property (nonatomic, strong) NSString *sccOriginalTcOut;
@property (nonatomic, strong) NSString *textSubtitle;

@property (nonatomic, strong) NSMutableArray *textEntitlements;

@end
