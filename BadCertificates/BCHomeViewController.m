//
//  BCHomeViewController.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/10/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCHomeViewController.h"
#import "BCCertificate.h"
#import "BCCertificateViewController.h"

@interface BCHomeViewController ()

@end

@implementation BCHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - Helpers

- (void)createNewCertificateWithAwarder:(NSString *)awarder awardee:(NSString *)awardee
{
    BCCertificate *newCert = [BCCertificate randomCertificate];
    newCert.awarder = awarder;
    newCert.awardee = awardee;
    
    BCCertificateViewController *cvc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"certificate"];
    cvc.style = [self getDefaultStyle];
    cvc.certificate = newCert;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (BCStyle *)getDefaultStyle
{
    // get styles json data
    NSData *stylesData = [self getJsonFileWithName:@"styles"];
    if (stylesData) {
        // convert to array
        NSError *err;
        id styles = [NSJSONSerialization JSONObjectWithData:stylesData options:NSJSONReadingAllowFragments error:&err];
        if (!err) {
            return [BCStyle styleWithDictionary:styles[@"styles"][0]];
        }
    }
    return nil;
}

- (NSData *)getJsonFileWithName:(NSString *)name
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    return [NSData dataWithContentsOfFile:filePath];
}

#pragma mark - Actions

- (IBAction)pressedGo:(id)sender
{
    if (self.awardeeTextField.text.length && self.awarderTextField.text.length) {
        [self createNewCertificateWithAwarder:self.awarderTextField.text awardee:self.awardeeTextField.text];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill in all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)pressedDismissButton:(id)sender
{
    [self.awarderTextField resignFirstResponder];
    [self.awardeeTextField resignFirstResponder];
}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0) {
        [self.awarderTextField becomeFirstResponder];
    }
    else {
        [self pressedGo:nil];
    }
    return NO;
}

@end
