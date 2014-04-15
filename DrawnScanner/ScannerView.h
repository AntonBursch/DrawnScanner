//
//  ScannerView.h
//  DrawnScanner
//
//  Created by Michael Boczek on 4/3/14.
//  Copyright (c) 2014 Descartes Biometrics, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScannerView : UIView

-(void)addTouchPoint: (CGPoint)point;

@property float gridDotRadius;
@property int gridDotColumns;
@property int gridDotRows;
@property UIColor* gridDotColor;

@property UIImage* targetBottomImage;
@property CGRect targetBottomRect;
@property UIImage* targetMiddleImage;
@property CGRect targetMiddleRect;
@property UIImage* targetTopImage;
@property CGRect targetTopRect;

@property UIImage* touchImage;
@property float touchRadius;
@property float touchRadiusRandomVariance;

@end

typedef NS_ENUM(NSInteger, ScannerStateType) {
    ScannerStateInitial,
    ScannerStateScanning,
    ScannerStateComplete
};