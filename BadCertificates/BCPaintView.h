//
//  BCPaintView.h
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/12/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCPaintViewDelegate;

@interface BCPaintView : UIView
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) NSInteger strokeSize;
@property (nonatomic, assign) id<BCPaintViewDelegate> delegate;

- (void)undo;

@end

@protocol BCPaintViewDelegate <NSObject>
- (void)paintViewCleared:(BCPaintView *)paintView;
- (void)paintViewDrawingBegan:(BCPaintView *)paintView;

@end
