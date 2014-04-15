//
//  ViewController.m
//  DrawnScanner
//
//  Created by Michael Boczek on 4/3/14.
//  Copyright (c) 2014 Descartes Biometrics, Inc. All rights reserved.
//

#import "ViewController.h"
#import "ScannerView.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
{
    ScannerStateType scannerState;
    CMMotionManager* motionManager;
    NSTimer* gravityTimer;
    NSTimer* scannerTimer;
}

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // create new motion manager and start updates
        self->motionManager = [[CMMotionManager alloc] init];
        [self->motionManager startDeviceMotionUpdates];
        
        // create new scanner and add as child to view
        self.scannerView = [[ScannerView alloc] init];
        [[self view] addSubview:self.scannerView];
        
        // set scanner state to initial
        self->scannerState = ScannerStateInitial;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // if scanner state is complete, return
    if (self->scannerState == ScannerStateComplete) {
        return;
    }
    
    // if scanner state is initial, change scanner state to scanning and start gravity and scanner timers
    if(self->scannerState == ScannerStateInitial) {
        self->scannerState = ScannerStateScanning;
        self->gravityTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(captureGravity:) userInfo:nil repeats:NO];
        self->scannerTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(captureScan:) userInfo:nil repeats:NO];
    }
    
    // capture touches and send them to the scanner view to draw
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self.view];
        [self.scannerView addTouchPoint:location];
        [self.scannerView setNeedsDisplay];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)captureGravity:(NSTimer*)timer {
    // get the gravity data and stop the device motion updates
    CMAcceleration grav = self->motionManager.deviceMotion.gravity;
    [self->motionManager stopDeviceMotionUpdates];
    
    // for now, just log the gravity data
    NSLog([NSString stringWithFormat:@"(%f-%f-%f)", grav.x, grav.y, grav.z]);
}

-(void)captureScan:(NSTimer*)timer {
    // for now, just set the scanner state to complete
    self->scannerState = ScannerStateComplete;
}

@end
