//
//  BCCertificate.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCCertificate : NSObject

@property (nonatomic, strong) NSString *headerText;
@property (nonatomic, strong) NSString *award;
@property (nonatomic, strong) NSString *awardee;
@property (nonatomic, strong) NSString *modeText;
@property (nonatomic, strong) NSString *awarderText;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSString *backgroundImageName;
@property (nonatomic, strong) UIImage *signatureImage;

+ (instancetype)certificateWithDictionary:(NSDictionary *)dictionary;

@end
