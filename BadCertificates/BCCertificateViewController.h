//
//  BCCertificateViewController.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCStyle.h"

@interface BCCertificateViewController : UIViewController

@property (nonatomic, strong) BCStyle *style;

@property (weak, nonatomic) IBOutlet UIImageView *certificateBackground;

@end
