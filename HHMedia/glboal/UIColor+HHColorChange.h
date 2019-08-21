//
//  UIColor+SRColorChange.h
//  BlueSeaRent
//
//  Created by llbt on 2019/4/19.
//  Copyright © 2019 yhb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HHColorChange)
// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
