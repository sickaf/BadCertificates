//
//  BCCertificate.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCCertificate.h"

@implementation BCCertificate

+ (instancetype)randomCertificate
{
    return [[BCCertificate alloc] initWithRandomValues];
}

- (instancetype)initWithRandomValues
{
    self = [super init];
    if (self) {
        self.feeling = [self getRandomValueFromPlistWithName:@"feelings"];
        self.award = [self getRandomValueFromPlistWithName:@"awards"];
        self.date = [NSDate date];
    }
    return self;
}

- (NSString *)getRandomValueFromPlistWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *chosen;
    if (dict) {
        NSArray *data = dict[@"Data"];
        int rand = arc4random_uniform(data.count);
        chosen = data[rand];
    }
    return chosen;
}

@end
