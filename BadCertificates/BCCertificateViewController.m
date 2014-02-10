//
//  BCCertificateViewController.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCCertificateViewController.h"

@interface BCCertificateViewController ()

@end

@implementation BCCertificateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.certificateBackground.image = [UIImage imageNamed:self.style.backgroundImageName];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.certificateBackground addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - Actions

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

@end
