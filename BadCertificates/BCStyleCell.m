//
//  BCStyleCell.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/9/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCStyleCell.h"

@implementation BCStyleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.bgImageView.alpha = highlighted ? 0.5 : 1;
}

- (void)configureWithStyle:(BCStyle *)style
{
    self.mainLabel.text = [NSString stringWithFormat:@"Style %li",[style.styleNumber integerValue]];
    self.mainLabel.font = [UIFont fontWithName:style.awardFontName size:[self.mainLabel.font pointSize]];
    self.bgImageView.image = [UIImage imageNamed:style.thumbnailImageName];
}

@end
