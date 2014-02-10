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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editPressed:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    // setup the style of the certificate
    [self setupCertificateAppearance];
    
    // setup the proper values for the randomly selected certificate
    [self setupCertificateValues];
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

#pragma mark - Helpers

- (void)setupCertificateAppearance
{
    // certificate background
    self.certificateBackground.image = [UIImage imageNamed:self.style.backgroundImageName];
    
    // main Labels
    self.awardLabel.font = [UIFont fontWithName:self.style.awardFontName size:[self.awardLabel.font pointSize]];
    self.recipientLabel.font = [UIFont fontWithName:self.style.awardFontName size:[self.recipientLabel.font pointSize]];
    
    // detail labels
    self.headerLabel.font = [UIFont fontWithName:self.style.detailFontName size:[self.headerLabel.font pointSize]];
    self.dateLabel.font = [UIFont fontWithName:self.style.detailFontName size:[self.dateLabel.font pointSize]];
    self.awarderLabel.font = [UIFont fontWithName:self.style.detailFontName size:[self.awarderLabel.font pointSize]];
    self.functionalityLabel.font = [UIFont fontWithName:self.style.detailFontName size:[self.functionalityLabel.font pointSize]];
    self.hereOnThisLabel.font = [UIFont fontWithName:self.style.detailFontName size:[self.hereOnThisLabel.font pointSize]];
    
}

- (void)setupCertificateValues
{
    self.headerLabel.text = [NSString stringWithFormat:@"With great %@, we present the title of", self.certificate.feeling];
    self.awardLabel.text = self.certificate.award;
}

#pragma mark - Actions

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    _shouldStatusBarHide = !_shouldStatusBarHide;
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
}

- (void)editPressed:(id)sender
{
    
}

@end
