//
//  BCPaintView.m
//  BadCertificates
//
//  Created by Cody Kolodziejzyk on 2/12/14.
//  Copyright (c) 2014 Cody Kolodziejzyk. All rights reserved.
//

#import "BCPaintView.h"
#import "BCAnnotationData.h"

@implementation BCPaintView {
    CGContextRef cacheContext;
    
    CGPoint point0;
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    
    NSMutableArray *_paths;
    NSMutableArray *_points;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetup];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialSetup];
    }
	
    return self;
}

- (void)initialSetup
{
    if (![self initContext:self.bounds.size]) {
        DLog(@"error setting up context");
    };
    
    _paths = [[NSMutableArray alloc] init];
}

- (BOOL)initContext:(CGSize)size
{
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
    float scaleFactor = [[UIScreen mainScreen] scale];
    int	bitmapBytesPerRow = (size.width * scaleFactor * 4);
	
	cacheContext = CGBitmapContextCreate(NULL, size.width * scaleFactor, size.height * scaleFactor, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(cacheContext, scaleFactor, scaleFactor);
    
    CGContextSetRGBFillColor(cacheContext, 1.0, 1.0, 1.0, 0);
    CGContextFillRect(cacheContext, self.bounds);
	
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    point0 = CGPointMake(-1, -1);
    point1 = CGPointMake(-1, -1); // previous previous point
    point2 = CGPointMake(-1, -1); // previous touch point
    point3 = [touch locationInView:self]; // current touch point
    
    BCAnnotationData *point = [[BCAnnotationData alloc] initWithLocation:point3 andColor:self.selectedColor];
    _points = [[NSMutableArray alloc] init];
    [_points addObject:point];
    [_paths addObject:_points];
    
    [self drawToCache];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    point0 = point1;
    point1 = point2;
    point2 = point3;
    point3 = [touch locationInView:self];
    
    BCAnnotationData *new = [[BCAnnotationData alloc] initWithLocation:point3 andColor:self.selectedColor];
    [_points addObject:new];
    
    [self drawToCache];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //need to nil out this reference can't just remove all its entries cause the object its pointing to is inside the touchPoints array
    _points = nil;
    if (_paths.count > 0) {
        if ([self.delegate respondsToSelector:@selector(paintViewDrawingBegan:)]) {
            [self.delegate paintViewDrawingBegan:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _points = nil;
    if (_paths.count > 0) {
        if ([self.delegate respondsToSelector:@selector(paintViewDrawingBegan:)]) {
            [self.delegate paintViewDrawingBegan:self];
        }
    }
}

- (void)undo
{
    // Pop the last path off the stack
    [_paths removeLastObject];
    
    // Clear the context first
    CGContextClearRect(cacheContext, self.bounds);
    [self setNeedsDisplay];
    
    // Return if there are no paths to draw
    if (_paths.count <= 0) {
        if ([self.delegate respondsToSelector:@selector(paintViewCleared:)]) {
            [self.delegate paintViewCleared:self];
        }
        return;
    }
    
    // ave the color so that we can go back to it after undo
    UIColor *currentlySelectedColor = self.selectedColor;
    for (NSMutableArray *aPath in _paths) {
        
        // set the initial point for the path
        BCAnnotationData *first = aPath[0];
        
        point0 = CGPointMake(-1, -1);
        point1 = CGPointMake(-1, -1);
        point2 = CGPointMake(-1, -1);
        point3 = first.location;
        
        // Set the correct color for the path
        self.selectedColor = first.color;
        
        [self drawToCache];
        for (BCAnnotationData *aPoint in aPath) {
            //Draw the rest of the points
            point0 = point1;
            point1 = point2;
            point2 = point3;
            point3 = aPoint.location;
            [self drawToCache];
        }
    }
    
    // Go back to original selected color
    self.selectedColor = currentlySelectedColor;
}

- (void)drawToCache
{
    UIColor *color = self.selectedColor;
    
    CGContextSetStrokeColorWithColor(cacheContext, [color CGColor]);
    CGContextSetLineCap(cacheContext, kCGLineCapRound);
    CGContextSetLineJoin(cacheContext, kCGLineJoinBevel);
    CGContextSetLineWidth(cacheContext, 6);
    CGContextSetBlendMode(cacheContext, kCGBlendModeNormal);
    if (point1.x > -1) {
        double x0 = (point0.x > -1) ? point0.x : point1.x; //after 4 touches we should have a back anchor point, if not, use the current anchor point
        double y0 = (point0.y > -1) ? point0.y : point1.y; //after 4 touches we should have a back anchor point, if not, use the current anchor point
        double x1 = point1.x;
        double y1 = point1.y;
        double x2 = point2.x;
        double y2 = point2.y;
        double x3 = point3.x;
        double y3 = point3.y;
        // Assume we need to calculate the control
        // points between (x1,y1) and (x2,y2).
        // Then x0,y0 - the previous vertex,
        //      x3,y3 - the next one.
        
        double xc1 = (x0 + x1) / 2.0;
        double yc1 = (y0 + y1) / 2.0;
        double xc2 = (x1 + x2) / 2.0;
        double yc2 = (y1 + y2) / 2.0;
        double xc3 = (x2 + x3) / 2.0;
        double yc3 = (y2 + y3) / 2.0;
        
        double len1 = sqrt((x1 - x0) * (x1 - x0) + (y1 - y0) * (y1 - y0));
        double len2 = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
        double len3 = sqrt((x3 - x2) * (x3 - x2) + (y3 - y2) * (y3 - y2));
        
        double k1 = len1 / (len1 + len2);
        double k2 = len2 / (len2 + len3);
        
        double xm1 = xc1 + (xc2 - xc1) * k1;
        double ym1 = yc1 + (yc2 - yc1) * k1;
        
        double xm2 = xc2 + (xc3 - xc2) * k2;
        double ym2 = yc2 + (yc3 - yc2) * k2;
        double smooth_value = 0.8;
        // Resulting control points. Here smooth_value is mentioned
        // above coefficient K whose value should be in range [0...1].
        float ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
        float ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
        
        float ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
        float ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
        
        CGContextMoveToPoint(cacheContext, point1.x, point1.y);
        CGContextAddCurveToPoint(cacheContext, ctrl1_x, ctrl1_y, ctrl2_x, ctrl2_y, point2.x, point2.y);
        CGContextStrokePath(cacheContext);
        
        CGRect dirtyPoint1 = CGRectMake(point1.x - 10, point1.y - 10, 20, 20);
        CGRect dirtyPoint2 = CGRectMake(point2.x - 10, point2.y - 10, 20, 20);
        [self setNeedsDisplayInRect:CGRectUnion(dirtyPoint1, dirtyPoint2)];
    }
    else {
        CGContextMoveToPoint(cacheContext, point3.x, point3.y);
        CGContextAddLineToPoint(cacheContext, point3.x, point3.y);
        CGContextStrokePath(cacheContext);
        CGRect dirtyPoint1 = CGRectMake(point3.x - 10, point3.y - 10, 20, 20);
        CGRect dirtyPoint2 = CGRectMake(point3.x - 10, point3.y - 10, 20, 20);
        [self setNeedsDisplayInRect:CGRectUnion(dirtyPoint1, dirtyPoint2)];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef cacheImage = CGBitmapContextCreateImage(cacheContext);
    CGContextDrawImage(context, self.bounds, cacheImage);
    CGImageRelease(cacheImage);
}

@end
