//
//  LineChartView.h
//  LineChart
//
//  Created by nyaago on 2013/10/24.
//  Copyright (c) 2013年 nyaago. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LineChartSource <NSObject>

/*! 
 * @return Xスケール数
 */
- (NSInteger) xScaleCount;
/*!
 * @return Yスケール数
 */
- (NSInteger) yScaleCount;


/*!
 * X軸のIndexからX軸の値を得る
 * @param x Y軸Index
 * @return X値
 */
- (CGFloat) xWithIndex:(NSInteger)index;

/*!
 * インデックス対応するYのスケール値を得る
 * @param y
 * @return インデックス対応するYのスケール値
 */
- (CGFloat) yWithIndex:(NSInteger)index;
/*!
 *
 * @param x X軸インデックス
 * @return 値
 */
-(CGFloat) yWithXIndex:(NSInteger)index;

/**
 * @param x X軸インデックス
 * @return X軸名
 */
-(NSString *) xScaleTitle:(NSInteger)index;

/**
 * @param y Y軸インデックス
 * @return Y軸名
 */
-(NSString *) yScaleTitle:(NSInteger)index;

/*!
 @return x軸の凡例
 */
-(NSString *) xAxisNote;
/*!
 @return y軸の凡例
 */
-(NSString *) yAxisNote;


@end

@interface LineChartView : UIView

@property (nonatomic, strong) UIColor *frameColor;
@property (nonatomic, strong) UIColor *chartLineColor;
@property (nonatomic, strong) UIColor *scaleLineColor;
@property (nonatomic, strong) UIColor *scaleTextColor;
@property (nonatomic, strong) UIColor *noteTextColor;


@property (nonatomic) NSInteger scaleTextSize;
@property (nonatomic) NSInteger noteTextSize;
/*!
 * 値の点の半径
 */
@property (nonatomic) CGFloat pointRedius;

@property (nonatomic, strong) NSObject <LineChartSource> *source;

@end
