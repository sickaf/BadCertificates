//
//  BCHomeViewController.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/10/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCHomeViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *awardeeTextField;
@property (weak, nonatomic) IBOutlet UITextField *awarderTextField;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerBottomConstraint;

- (IBAction)pressedGo:(id)sender;
- (IBAction)pressedDismissButton:(id)sender;

@end
