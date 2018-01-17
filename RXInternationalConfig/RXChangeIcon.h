//
//  RXChangeIcon.h
//  RXInternationalConfig
//
//  Created by srxboys on 2018/1/16.
//  Copyright © 2018年 srxboys. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RXChangeIcon : NSObject
+ (NSArray *)getPrimaryArray; //PRIMARY_ARRAY
+ (NSArray *)getNewsstandArray; //NEWSSTAND_ARRAY

//设置
+ (void)setIcon:(NSString *)imageName complete:(void(^)(NSError * _Nullable error))complete;

//还原
+ (void)restoreIconImgComplete:(void (^)(NSError * _Nullable error))complete;
@end
