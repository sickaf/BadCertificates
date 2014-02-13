//
//  BCAnnotationData.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/12/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCAnnotationData : NSObject

@property (nonatomic, assign) CGPoint location;
@property (nonatomic, strong) UIColor *color;

- (id)initWithLocation:(CGPoint)location andColor:(UIColor *)color;

@end
