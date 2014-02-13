//
//  BCStyleViewController.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCStyleViewController.h"
#import "BCCertificateViewController.h"
#import "BCStyleCell.h"
#import "BCStyle.h"
#import "BCCertificate.h"

@interface BCStyleViewController ()

@property (nonatomic, strong) NSMutableArray *styles;

@end

@implementation BCStyleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // always bounce the collection view
    [self.collectionView setAlwaysBounceVertical:YES];
    
    // setup right bar button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pressedDone:)];
    
    // fetch style data
    [self fetchData];
}

#pragma mark - Helpers

- (void)fetchData
{
    // get styles json data
    NSData *stylesData = [self getJsonFileWithName:@"styles"];
    if (stylesData) {
        // convert to array
        NSError *err;
        id styles = [NSJSONSerialization JSONObjectWithData:stylesData options:NSJSONReadingAllowFragments error:&err];
        if (!err) {
            // create style objects from each element
            for (NSDictionary *dict in styles[@"styles"]) {
                BCStyle *style = [BCStyle styleWithDictionary:dict];
                [self.styles addObject:style];
            }
            // refresh collection view data
            [self.collectionView reloadData];
        }
    }
}

- (NSData *)getJsonFileWithName:(NSString *)name
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    return [NSData dataWithContentsOfFile:filePath];
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _styles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BCStyle *style = [self.styles objectAtIndex:indexPath.row];
    BCStyleCell *cell = (BCStyleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"style_cell" forIndexPath:indexPath];
    [cell configureWithStyle:style];
    
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    // get the proper style
    BCStyle *style = [self.styles objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(dismissedWithStyle:)]) {
        [self.delegate dismissedWithStyle:style];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Getters

- (NSMutableArray *)styles
{
	if (!_styles) {
		_styles = [NSMutableArray new];
	}
	
	return _styles;
}

#pragma mark - Actions

- (void)pressedDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
