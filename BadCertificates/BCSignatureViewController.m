//
//  BCPaintViewController.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/12/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCSignatureViewController.h"

@interface BCSignatureViewController ()

@end

@implementation BCSignatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(pressedDone:)];
}

#pragma mark - Actions

- (void)pressedDone:(id)sender
{
    UIGraphicsBeginImageContextWithOptions(self.paintView.frame.size, YES, 0.0);
	[self.paintView drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.paintView.frame), CGRectGetHeight(self.paintView.frame)) afterScreenUpdates:NO];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

    if ([self.delegate respondsToSelector:@selector(finishedWithSignature:)]) {
        [self.delegate finishedWithSignature:screenshot];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
