//
//  BCStyleViewController.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCStyleViewController.h"
#import "BCStyleCell.h"
#import "BCStyle.h"

@interface BCStyleViewController ()

@property (nonatomic, strong) NSMutableArray *styles;

@end

@implementation BCStyleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
}

#pragma mark - Getters

- (NSMutableArray *)styles
{
	if (!_styles) {
		_styles = [NSMutableArray new];
	}
	
	return _styles;
}

@end
