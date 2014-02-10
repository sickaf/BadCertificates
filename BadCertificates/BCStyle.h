//
//  BCStyle.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCStyle : NSObject

@property (nonatomic, strong) NSNumber *styleNumber;
@property (nonatomic, strong) NSString *awardFontName;
@property (nonatomic, strong) NSString *detailFontName;
@property (nonatomic, strong) NSString *backgroundImageName;
@property (nonatomic, strong) NSString *thumbnailImageName;

+ (instancetype)styleWithDictionary:(NSDictionary *)dictionary;

@end
