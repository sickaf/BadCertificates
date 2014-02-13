//
//  BCPaintViewController.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/12/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCPaintView.h"

@protocol BCSignatureDelegate;

@interface BCSignatureViewController : UIViewController

@property (weak, nonatomic) IBOutlet BCPaintView *paintView;
@property (nonatomic, assign) id<BCSignatureDelegate> delegate;

@end

@protocol BCSignatureDelegate <NSObject>

- (void)finishedWithSignature:(UIImage *)signature;

@end