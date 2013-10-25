//
//  ViewController.m
//  LineChart
//
//  Created by nyaago on 2013/10/24.
//  Copyright (c) 2013年 nyaago. All rights reserved.
//

#import "ViewController.h"
#import "LineChartView.h"
#import "LineChartDemoSource.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
  LineChartView *chartView = [[LineChartView alloc] initWithFrame:CGRectMake(0.0f,
                                                                             applicationFrame.origin.y,
                                                                             320.0f,
                                                                             200.0f)];
  chartView.source = [[LineChartDemoSource alloc] init];
  [self.view addSubview:chartView];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
