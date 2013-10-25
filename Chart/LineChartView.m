//
//  LineChartView.m
//  LineChart
//
//  Created by nyaago on 2013/10/24.
//  Copyright (c) 2013年 nyaago. All rights reserved.
//

#import "LineChartView.h"

@implementation LineChartView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setDefault];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect)rect {
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  UIGraphicsPushContext(ctx);
  [self drawFrame:rect context:ctx];
  [self drawScaleTitle:rect context:ctx];
  [self drawValue:rect context:ctx];
  [self drawNote:rect context:ctx];
}


/*!
 * 枠の描画
 * @param canvas
 */
- (void) drawFrame:(CGRect)rect context:(CGContextRef)context {
  CGContextSetRGBFillColor(context, 0.2f, 0.2f, 0.2f, 1.0f);
  
  CGContextSetStrokeColorWithColor(context, [self.frameColor CGColor]);
  CGContextSetLineWidth(context, 2.0f);
  
  CGContextStrokeRect(context, CGRectMake([self leftOfChart], [self topOfChart],
                                          [self rightOfChart] - [self leftOfChart],
                                          [self bottomOfChart] - [self topOfChart]));

  CGContextSetStrokeColorWithColor(context, [self.scaleLineColor CGColor]);
  CGContextSetLineWidth(context, 1.0f);

  for(int i = 1; i < [self.source xScaleCount] - 1; ++i ) {
    CGFloat x  = [self xFor:[self.source xWithIndex:i]];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, x, [self topOfChart]);
    CGContextAddLineToPoint(context, x, [self bottomOfChart]);
    CGContextStrokePath(context);
  }
  
  for(int i = 1; i < [self.source yScaleCount] - 1; ++i ) {
    CGFloat y = [self yFor:[self.source yWithIndex:i]];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, [self leftOfChart], y);
    CGContextAddLineToPoint(context, [self rightOfChart], y);
    CGContextStrokePath(context);
  }
}

- (void) drawScaleTitle:(CGRect)rect context:(CGContextRef)context {
  
  [self setTextAttrib:context
                color:self.scaleTextColor];
  UIFont *font = [UIFont systemFontOfSize:self.scaleTextSize];
  for(int i = 0; i < [self.source xScaleCount]; ++i ) {
    CGFloat x  = [self xFor:[self.source xWithIndex:i]];
    NSString *text = [self.source xScaleTitle:i];
    CGFloat width = [self getTextWidth:text font:[UIFont systemFontOfSize:self.scaleTextSize]];
    [self drawText:text font:font x:x - width / 2 y:[self yOfXAxitTitle]
             color:self.scaleTextColor context:context];
  }
  
  for(int i = 0; i < [self.source yScaleCount]; ++i ) {
    CGFloat y = [self yFor:[self.source yWithIndex:i]];
    NSString *text = [self.source yScaleTitle:i];
    [self drawText:text font:font x:0 y:y + self.scaleTextSize / 2
             color:self.scaleTextColor context:context];
  }
  
}

- (void) drawValue:(CGRect)rect context:(CGContextRef)context {

  CGContextSetStrokeColorWithColor(context, [self.chartLineColor CGColor]);
  CGContextSetFillColorWithColor(context, [self.chartLineColor CGColor]);
  CGContextSetLineWidth(context, 1.0f);

  for(int i = 0; i < [self.source xScaleCount] ; ++i) {
    CGFloat x1 = [self xFor:[self.source xWithIndex:i]];
    CGFloat y1 = [self yFor:[self.source yWithXIndex:i]];
    if(i < [self.source xScaleCount] - 1) {
      CGFloat x2 = [self xFor:[self.source xWithIndex:i + 1]];
      CGFloat y2 = [self yFor:[self.source yWithXIndex:i + 1]];
      CGContextBeginPath(context);
      CGContextMoveToPoint(context, x1, y1);
      CGContextAddLineToPoint(context, x2, y2);
      CGContextStrokePath(context);
    }
    CGRect rect = CGRectMake(x1 - self.pointRedius, y1 - self.pointRedius,
                             self.pointRedius * 2, self.pointRedius * 2);
    CGContextFillEllipseInRect(context, rect);
  }
}

- (void) drawNote:(CGRect)rect  context:(CGContextRef)context {
  [self setTextAttrib:context
                color:self.noteTextColor];
  UIFont *font = [UIFont systemFontOfSize:self.noteTextSize];
  [self drawText:[self.source xAxisNote] font:font x:[self xOfXAxisNote] y:[self yOfXAxitNote]
           color:self.noteTextColor context:context];
  [self drawText:[self.source yAxisNote] font:font x:[self xOfYAxisNote] y:[self yOfYAxitNote]
         color:self.noteTextColor context:context];
  
  
}

- (void) drawText:(NSString *)text font:(UIFont *)font x:(CGFloat)x y:(CGFloat)y
            color:(UIColor *)color
          context:(CGContextRef)context {
  if([self isIOS7]) {
    [self drawTextIOS7:text font:font x:x y:y color:color context:context];
  }
  else {
    [self drawTextLegacy:text font:font x:x y:y color:color context:context];
  }
}


// for IOS7
- (void) drawTextIOS7:(NSString *)text font:(UIFont *)font x:(CGFloat)x y:(CGFloat)y
                color:(UIColor *)color
              context:(CGContextRef)context {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                color, NSForegroundColorAttributeName,
                                nil];

  [text drawAtPoint:CGPointMake(x, y - font.lineHeight) withAttributes:attributes];
}


// for IOS6
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void) drawTextLegacy:(NSString *)text font:(UIFont *)font x:(CGFloat)x y:(CGFloat)y
                  color:(UIColor *)color
                context:(CGContextRef)context {
  CGAffineTransform affine = CGAffineTransformMake
  (1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
  CGContextSelectFont(context, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding],
                      font.pointSize, kCGEncodingMacRoman);

  CGContextSetTextMatrix(context, affine);
    CGContextShowTextAtPoint(context,
                             x, y, [text cStringUsingEncoding:NSUTF8StringEncoding], text.length);
}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"

- (void) setTextAttrib:(CGContextRef)context
                 color:(UIColor *)color {
  CGFloat red, blue, green, alpha;
  [color getRed:&red green:&green blue:&blue alpha:&alpha];
  CGContextSetRGBFillColor(context,
                           red, green, blue, alpha);
  CGContextSetRGBStrokeColor(context,
                             red, green, blue, alpha);
  if(![self isIOS7]) {
  }
  CGContextSetTextDrawingMode(context,
                              kCGTextFillStroke);
}


#pragma mark - Private

/**
 * X軸値に対するX位置
 * @param val X軸の値
 * @return x座標
 */
-(CGFloat) xFor:(CGFloat)val {
  CGFloat offset = [self leftOfChart];
  int size = [self.source xWithIndex:[self.source xScaleCount] - 1] - [self.source xWithIndex:0];
  int distance = val - [self.source xWithIndex:0];
  CGFloat result = offset + [self getChartWidth] * ((float)distance / (float)size);
  return result;
}

/**
 * Y軸値に対するY位置
 * @param val Y軸の値
 * @return y座標
 */
-(CGFloat) yFor:(CGFloat) val {
  CGFloat offset = [self topOfChart];
  int size = [self.source yWithIndex:[self.source yScaleCount] - 1] - [self.source yWithIndex:0];
  int distance = val - [self.source yWithIndex:0];
  CGFloat result =  offset + [self getChartHeight]
  - [self getChartHeight] * ((float)distance / (float)size);
  return  result;
}


-(CGFloat) topOfChart {
  return [self topMargin];
}

-(CGFloat) bottomOfChart {
  return [self topOfChart] + [self getChartHeight];
}

-(CGFloat) leftOfChart {
  return [self leftMargin];
}

-(CGFloat) rightOfChart {
  return [self leftMargin] + [self getChartWidth];
}

-(CGFloat) yOfXAxitTitle {
  return self.frame.size.height - 2.0f;
}

-(CGFloat) topMargin {
  return self.scaleTextSize * (2.0f / 3.0f);
}

-(CGFloat) bottomMargin {
  return self.scaleTextSize * (7.0f / 5.0f);
}

-(CGFloat) leftMargin {
  return [self getTextWidth:[self.source yScaleTitle:[self.source yScaleCount] - 1]
                       font:[UIFont systemFontOfSize:self.scaleTextSize]] * 1.1f;
}

-(CGFloat) rightMargin {
  return [self getTextWidth:[self.source yScaleTitle:[self.source yScaleCount] - 1]
                       font:[UIFont systemFontOfSize:self.scaleTextSize]];
}

/*!
 * @return Chart領域（目盛りタイトル部分を除外した部分）の高さ(px）
 */
-(CGFloat) getChartHeight {
  return self.frame.size.height - [self topOfChart] - [self bottomMargin];
}

/*!
 * @return Chart領域（目盛りタイトル部分を除外した部分）の幅(px）
 */
-(CGFloat) getChartWidth {
  return self.frame.size.width - [self leftMargin] - [self rightMargin];
}

-(CGFloat) yOfYAxitNote {
  return [self topOfChart] + self.noteTextSize * 1.5f;
}

-(CGFloat) xOfYAxisNote {
  return [self leftOfChart] + self.noteTextSize / 2;
}

-(CGFloat) yOfXAxitNote {
  return [self bottomOfChart] - self.noteTextSize / 2;
}

-(CGFloat) xOfXAxisNote {
  return [self rightOfChart] - [self getTextWidth:[self.source xAxisNote]
                                                   font:[UIFont systemFontOfSize:self.noteTextSize]]
                                - self.noteTextSize / 2;
}

- (CGFloat) getTextWidth:(NSString *)text font:(UIFont *)font {
  return [self getTextSize:text font:font].width;
  
  
}

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (CGSize) getTextSize:(NSString *)text font:(UIFont *)font {
  if ([text respondsToSelector:@selector(sizeWithAttributes:)])
  {
    NSDictionary* attribs = @{NSFontAttributeName:font};
    return ([text sizeWithAttributes:attribs]);
  }
  return ([text sizeWithFont:font]);
}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"

- (void) setDefault {

  self.backgroundColor = [UIColor whiteColor];
  self.frameColor = [UIColor blackColor];
  self.chartLineColor = [UIColor blueColor];
  self.scaleLineColor = [UIColor colorWithRed:204.0f/256.0f
                                        green:204.0f/256.0f
                                         blue:204.0f/256.0f
                                        alpha:1.0f];
  self.scaleTextColor = [UIColor colorWithRed:51.0f/256.0f
                                        green:51.0f/256.0f
                                         blue:51.0f/256.0f
                                        alpha:1.0f];
  self.noteTextColor = [UIColor colorWithRed:204.0f/256.0f
                                       green:204.0f/256.0f
                                        blue:204.0f/256.0f
                                       alpha:1.0f];
  self.scaleTextSize = [UIFont smallSystemFontSize];
  self.noteTextSize = [UIFont systemFontSize];
  self.pointRedius = 2.0f;
}


- (CGFloat)iOSVersion
{
  return ([[[UIDevice currentDevice] systemVersion] floatValue]);
}


// iOS7以降であるか
- (BOOL)isIOS7
{
  return [self iOSVersion] >= 7.0f;
}


@end
