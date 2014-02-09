//
//  BCStyleViewController.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCStyleViewController.h"
#import "BCStyleCell.h"

@interface BCStyleViewController ()

@end

@implementation BCStyleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BCStyleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"style_cell" forIndexPath:indexPath];
    cell.mainLabel.text = [NSString stringWithFormat:@"Style %li",(long)indexPath.row];
    
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
