//
//  BCCertificate.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCCertificate.h"

@implementation BCCertificate


+ (instancetype)certificateWithDictionary:(NSDictionary *)dictionary
{
    return [[BCCertificate alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.headerText = dictionary[@"header_text"];
        self.award = dictionary[@"award"];
        self.awardee = dictionary[@"awardee"];
        self.modeText = dictionary[@"mode_text"];
        self.awarderText = dictionary[@"awarder_text"];
        self.date = [NSDate date];
        
        self.backgroundImageName = dictionary[@"background_image"];
    }
    return self;
}

@end
