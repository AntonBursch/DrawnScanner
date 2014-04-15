//
//  ScannerView.m
//  DrawnScanner
//
//  Created by Michael Boczek on 4/3/14.
//  Copyright (c) 2014 Descartes Biometrics, Inc. All rights reserved.
//

#import "ScannerView.h"

@interface ScannerView() {
    NSMutableArray* touchPoints;
}
@end

@implementation ScannerView

-(id)init {
    CGRect frame = [[UIScreen mainScreen] bounds];
    // create 20 unit margin for top iOS bar (time, battery, etc)
    frame.size.height -= 20;
    frame.origin.y += 20;
    self = [super initWithFrame:frame];
    if (self) {
        // do not let view capture touch events
        self.userInteractionEnabled = NO;
        
        // view background color default
        self.backgroundColor = [UIColor whiteColor];
        
        // grid defaults
        self.gridDotRadius = 2.5;
        self.gridDotColumns = 6;
        self.gridDotRows = 12;
        self.gridDotColor = [UIColor grayColor];
        
        // target defaults
        self.targetBottomImage = [UIImage imageNamed:@"bottom"];
        self.targetMiddleImage = [UIImage imageNamed:@"middle"];
        self.targetTopImage = [UIImage imageNamed:@"top"];
        
        // touches defaults
        self.touchImage = [UIImage imageNamed:@"green-dot"];
        self.touchRadius = 25;
        self.touchRadiusRandomVariance = 0.5;
        self->touchPoints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // draw background grid
    float dotWidth = self.gridDotRadius * 2;
    float dotHeight = self.gridDotRadius * 2;
    float dotColumnSpacing = self.bounds.size.width/self.gridDotColumns;
    float dotRowSpacing = self.bounds.size.height/self.gridDotRows;
    float dotLeftMargin = dotColumnSpacing/2;
    float dotTopMargin = dotRowSpacing/2;
    
    for (int c=0; c<self.gridDotColumns; c++) {
        for (int r=0; r<self.gridDotRows; r++) {
            float x = dotLeftMargin + (c * dotColumnSpacing) - (self.gridDotRadius);
            float y = dotTopMargin + (r * dotRowSpacing) - (self.gridDotRadius);
            UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y, dotWidth, dotHeight)];
            [self.gridDotColor setFill];
            [p fill];
        }
    }
    
    // draw target
    [self.targetBottomImage drawInRect:CGRectMake(20, 500, 280, 28)];
    [self.targetMiddleImage drawInRect:CGRectMake(146, 270-14, 28, 28)];
    [self.targetTopImage drawInRect:CGRectMake(20, 20, 280, 28)];

    
    // draw touches
    for (NSValue* touchPoint in self->touchPoints) {
        float touchOffset = [self randomizeRadius:self.touchRadius];
        float touchWidth = touchOffset * 2;
        float touchHeight = touchOffset * 2;
        
        float x = touchPoint.CGPointValue.x - touchOffset;
        float y = touchPoint.CGPointValue.y - touchOffset;
        [self.touchImage drawInRect:CGRectMake(x, y, touchWidth, touchHeight)];
    }
}

-(void)addTouchPoint: (CGPoint) point {
    [self->touchPoints addObject:[NSValue valueWithCGPoint:point]];
}

-(float)randomizeRadius:(float)radius {
    float min = radius * (1 - self.touchRadiusRandomVariance);
    float max = radius * (1 + self.touchRadiusRandomVariance);
    
    return arc4random_uniform(max - min + 1) + min;
}

@end
