//
//  Emotion.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/11/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "Emotion.h"


@implementation Emotion

@dynamic emotion;

- (BOOL)validateEmotion:(NSString *)ioValue error:(NSError **)outError
{
    NSString *emotion = ioValue;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entity.name];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"emotion == %@", emotion];
    [request setPredicate:predicate];
    
    NSError *err = nil;
    NSUInteger num = [self.managedObjectContext countForFetchRequest:request error:&err];
    if (!err && num == 0) {
        return YES;
    }
    
    if (outError != NULL) {
        *outError = err;
    }
    return NO;
}

@end
