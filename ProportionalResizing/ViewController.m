//
//  ViewController.m
//  ProportionalResizing
//
//  Created by Nikolaos Tsiolas on 09/01/2018.
//  Copyright © 2018 AFSE. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ProportionalResizing.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self adaptForAllDevices];
}

@end
