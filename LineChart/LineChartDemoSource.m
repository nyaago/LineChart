//
//  LineChartDemoSource.m
//  LineChart
//
//  Created by nyaago on 2013/10/24.
//  Copyright (c) 2013年 nyaago. All rights reserved.
//

#import "LineChartDemoSource.h"

@implementation LineChartDemoSource

- (NSInteger) xScaleCount {
  return 10;
}
- (NSInteger) yScaleCount {
  return 6;
}


- (CGFloat) xWithIndex:(NSInteger)index {
  return index * 20;
}

- (CGFloat) yWithIndex:(NSInteger)index {
  return index * 20;
}
/*!
 *
 * @param x X軸インデックス
 * @return 値
 */
-(CGFloat) yWithXIndex:(NSInteger)index {
  return index * 106 % 87;
}

/**
 * @param x X軸インデックス
 * @return X軸名
 */
-(NSString *) xScaleTitle:(NSInteger)index {
  return [NSString stringWithFormat:@"%0.0f", [self xWithIndex:index]];
}

/**
 * @param y Y軸インデックス
 * @return Y軸名
 */
-(NSString *) yScaleTitle:(NSInteger)index {
  return [NSString stringWithFormat:@"%0.0f", [self yWithIndex:index]];

}

-(NSString *) xAxisNote {
  return @"X-Axis";
}
-(NSString *) yAxisNote {
  return @"Y-Axis";
}


@end
