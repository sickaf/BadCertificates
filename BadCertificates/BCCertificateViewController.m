//
//  BCCertificateViewController.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCCertificateViewController.h"
#import "BCStyleViewController.h"

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
    self.headerLabel.text = [NSString stringWithFormat:@"With great %@, %@ presents the title of", self.certificate.feeling,self.certificate.awarder];
    self.awardLabel.text = [NSString stringWithFormat:@"%@ %@", self.certificate.adjective, self.certificate.noun];
    self.awarderLabel.text = self.certificate.awarder;
    self.recipientLabel.text = self.certificate.awardee;
    _dateFormatter.dateFormat = [NSString stringWithFormat:@"d'%@ %@' MMMM, YYYY", [self suffixForDayInDate:self.certificate.date], @"of"];
    self.dateLabel.text = [_dateFormatter stringFromDate:self.certificate.date];
}

#pragma mark - Actions

- (void)randomCertificate
{
    BCCertificate *newCert = [BCCertificate randomCertificate];
    newCert.awarder = self.certificate.awarder;
    newCert.awardee = self.certificate.awardee;
    self.certificate = newCert;
    [self setupCertificateValues];
}

- (IBAction)pressedRandom:(id)sender
{
    [self randomCertificate];
}

- (IBAction)pressedEdit:(id)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Random", @"Custom", nil];
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
}

#pragma mark - Style delegate

- (void)dismissedWithStyle:(BCStyle *)style
{
    self.style = style;
    [self setupCertificateAppearance];
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self randomCertificate];
            break;
        case 1:
            DLog(@"pressed edit");
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
