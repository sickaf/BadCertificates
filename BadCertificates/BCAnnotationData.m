//
//  BCAnnotationData.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/12/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCAnnotationData.h"

@implementation BCAnnotationData

- (id)initWithLocation:(CGPoint)location andColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.location = location;
        self.color = color;
    }
	
    return self;
}

@end
