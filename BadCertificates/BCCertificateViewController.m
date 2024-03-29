//
//  BCCertificateViewController.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCCertificateViewController.h"
#import "SVProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface BCCertificateViewController () {
    BOOL _shouldStatusBarHide;
    NSDateFormatter *_dateFormatter;
}

@end

@implementation BCCertificateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup date formatter
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    // setup the style of the certificate
    [self updateCertificateAppearance];
    
    // setup the proper values for the randomly selected certificate
    [self updateCertificateValues];
    
    // setup tap gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.certificateView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    _shouldStatusBarHide = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self resignFirstResponder];
}

- (BOOL)prefersStatusBarHidden
{
    return _shouldStatusBarHide;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Helpers

- (void)updateCertificateAppearance
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

- (void)updateCertificateValues
{
    self.headerLabel.text = [NSString stringWithFormat:@"With great %@, %@ presents the title of", self.certificate.feeling,self.certificate.awarder];
    self.awardLabel.text = [NSString stringWithFormat:@"%@%@%@", self.certificate.adjective, self.certificate.noun.length > 0 ? @" " : @"", self.certificate.noun];
    self.awarderLabel.text = self.certificate.awarder;
    self.recipientLabel.text = self.certificate.awardee;
    _dateFormatter.dateFormat = [NSString stringWithFormat:@"d'%@ %@' MMMM, YYYY", [self suffixForDayInDate:self.certificate.date], @"of"];
    self.dateLabel.text = [_dateFormatter stringFromDate:self.certificate.date];
}

#pragma mark - Actions

- (void)handleTap:(id)sender
{
    [self pressedEdit:nil];
}

- (void)randomCertificate
{
    BCCertificate *newCert = [BCCertificate randomCertificate];
    newCert.awarder = self.certificate.awarder;
    newCert.awardee = self.certificate.awardee;
    self.certificate = newCert;
    [self updateCertificateValues];
}

- (IBAction)pressedRandom:(id)sender
{
    [self randomCertificate];
}

- (IBAction)pressedEdit:(id)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Emotion",@"Award",@"Awarder",@"Awardee",@"Signature", nil];
    [as showInView:self.view];
}

- (IBAction)pressedStyle:(id)sender
{
    BCStyleViewController *style = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Styles"];
    style.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:style];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)pressedShare:(id)sender
{
    UIGraphicsBeginImageContextWithOptions(self.certificateView.frame.size, YES, 0.0);
	[self.certificateView drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.certificateView.frame), CGRectGetHeight(self.certificateView.frame)) afterScreenUpdates:NO];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [SVProgressHUD showWithStatus:@"Saving..."];
    [library writeImageToSavedPhotosAlbum:screenshot.CGImage
                              orientation:(ALAssetOrientation)[screenshot imageOrientation]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (!error) {
                                      [SVProgressHUD showSuccessWithStatus:@"Saved!"];
                                  }
                                  else {
                                      [SVProgressHUD dismiss];
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                                      message:NSLocalizedString(@"There was an error saving photo to library. Try again later.", nil)
                                                                                     delegate:nil
                                                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                            otherButtonTitles:nil];
                                      [alert show];
                                  }
                              });
                          }];
}

#pragma mark - Style delegate

- (void)dismissedWithStyle:(BCStyle *)style
{
    self.style = style;
    [self updateCertificateAppearance];
}

#pragma mark - Signature Delegate

- (void)finishedWithSignature:(UIImage *)signature
{
    self.signatureImageView.image = signature;
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self showAlertWithTitle:@"Emotion" text:self.certificate.feeling tag:0];
            break;
        case 1:
            [self showAlertWithTitle:@"Award" text:self.awardLabel.text tag:1];
            break;
        case 2:
            [self showAlertWithTitle:@"Awarder" text:self.certificate.awarder tag:2];
            break;
        case 3:
            [self showAlertWithTitle:@"Awardee" text:self.certificate.awardee tag:3];
            break;
        case 4:
            [self showPaintViewController];
            break;
        default:
        break;
    }
}

- (void)showPaintViewController
{
    BCSignatureViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Paint"];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title text:(NSString *)text tag:(NSUInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = tag;
    [[alert textFieldAtIndex:0] setText:text];
    [alert show];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *text = [[alertView textFieldAtIndex:0] text];
    switch (alertView.tag) {
        case 0:
            if (buttonIndex == 1) {
                self.certificate.feeling = text;
                [self updateCertificateValues];
            }
            break;
        case 1:
            if (buttonIndex == 1) {
                self.certificate.noun = @"";
                self.certificate.adjective = text;
                [self updateCertificateValues];
            }
            break;
        case 2:
            if (buttonIndex == 1) {
                self.certificate.awarder = text;
                [self updateCertificateValues];
            }
            break;
        case 3:
            if (buttonIndex == 1) {
                self.certificate.awardee = text;
                [self updateCertificateValues];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Utilities

- (NSString *)suffixForDayInDate:(NSDate *)date{
    NSInteger day = [[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:NSDayCalendarUnit fromDate:date] day];
    if (day >= 11 && day <= 13) {
        return @"th";
    } else if (day % 10 == 1) {
        return @"st";
    } else if (day % 10 == 2) {
        return @"nd";
    } else if (day % 10 == 3) {
        return @"rd";
    } else {
        return @"th";
    }
}

#pragma mark - Motion

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self randomCertificate];
    }
}

@end
