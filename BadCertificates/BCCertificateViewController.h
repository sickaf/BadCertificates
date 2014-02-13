//
//  BCCertificateViewController.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCStyle.h"
#import "BCCertificate.h"
#import "BCStyleViewController.h"

@interface BCCertificateViewController : UIViewController <UIActionSheetDelegate, BCStyleDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) BCStyle *style;
@property (nonatomic, strong) BCCertificate *certificate;

@property (weak, nonatomic) IBOutlet UIImageView *certificateBackground;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *awarderLabel;
@property (weak, nonatomic) IBOutlet UILabel *functionalityLabel;
@property (weak, nonatomic) IBOutlet UILabel *hereOnThisLabel;

@property (weak, nonatomic) IBOutlet UILabel *awardLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipientLabel;

@end
