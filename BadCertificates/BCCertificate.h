//
//  BCCertificate.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCCertificate : NSObject

@property (nonatomic, strong) NSString *feeling;
@property (nonatomic, strong) NSString *award;
@property (nonatomic, strong) NSString *awardee;
@property (nonatomic, strong) NSString *awarder;
@property (nonatomic, strong) NSDate *date;

+ (instancetype)randomCertificate;

@end
