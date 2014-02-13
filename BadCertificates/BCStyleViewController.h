//
//  BCStyleViewController.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCStyle.h"

@protocol BCStyleDelegate;

@interface BCStyleViewController : UICollectionViewController

@property (nonatomic, assign) id<BCStyleDelegate> delegate;

@end

@protocol BCStyleDelegate <NSObject>

- (void)dismissedWithStyle:(BCStyle *)style;

@end
