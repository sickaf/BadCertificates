//
//  BCStyleCell.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCStyle.h"

@interface BCStyleCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

- (void)configureWithStyle:(BCStyle *)style;

@end
