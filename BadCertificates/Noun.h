//
//  Noun.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/11/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Noun : NSManagedObject

@property (nonatomic, retain) NSString * noun;
@property (nonatomic, retain) NSNumber * dirty;

@end
