//
//  BCCertificate.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCCertificate.h"
#import "BCDatabaseManager.h"

@implementation BCCertificate

+ (instancetype)randomCertificate
{
    return [[BCCertificate alloc] initWithRandomValues];
}

- (instancetype)initWithRandomValues
{
    self = [super init];
    if (self) {
        self.feeling = [[BCDatabaseManager sharedInstance] getEmotion];
        self.adjective = [[BCDatabaseManager sharedInstance] getAdjective];
        self.noun = [[BCDatabaseManager sharedInstance] getNoun];
        self.date = [NSDate date];
    }
    return self;
}

@end
