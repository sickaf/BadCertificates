//
//  BCStyle.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCStyle.h"

@implementation BCStyle

+ (instancetype)styleWithDictionary:(NSDictionary *)dictionary
{
    return [[BCStyle alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.styleNumber = [NSNumber numberWithInt:[dictionary[@"style_number"] intValue]];
        self.awardFontName = dictionary[@"award_font"];
        self.detailFontName = dictionary[@"detail_font"];
        self.backgroundImageName = dictionary[@"background_image"];
        self.thumbnailImageName = [self.backgroundImageName stringByAppendingString:@"_thumb"];
    }
    return self;
}

@end
