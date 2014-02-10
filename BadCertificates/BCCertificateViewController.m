//
//  BCCertificateViewController.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCCertificateViewController.h"

@interface BCCertificateViewController () {
    BOOL _shouldStatusBarHide;
}

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
    
    _shouldStatusBarHide = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return _shouldStatusBarHide;
}

#pragma mark - Actions

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    _shouldStatusBarHide = !_shouldStatusBarHide;
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
}

@end
