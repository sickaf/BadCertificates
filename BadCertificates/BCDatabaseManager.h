//
//  BCDatabaseManager.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/11/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCDatabaseManager : NSObject

+ (instancetype)sharedInstance;

- (NSString *)getAdjective;
- (NSString *)getNoun;
- (NSString *)getEmotion;

@end
