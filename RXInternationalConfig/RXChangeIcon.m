//
//  RXChangeIcon.m
//  RXInternationalConfig
//
//  Created by srxboys on 2018/1/16.
//  Copyright © 2018年 srxboys. All rights reserved.
//

/*
 https://developer.apple.com/documentation/uikit/uiapplication/2806818-setalternateiconname?language=objc
 
 
 info.plist
 新加 键值对（New additive key value pair）  ` icon files(iOS5) `
 Primary Icon  = 主
    Icon already includes gloss effects =  是否高亮效果
 Newsstand Icon = 辅
     bingdng type = Magazine | newspaper
     bingding edge = Left | right | bottom
 
 */

#import "RXChangeIcon.h"



#define ICON_INFO_PLIST_KEY @"CFBundleIcons"
#define ICON_PRIMARY_KEY    @"CFBundlePrimaryIcon"
#define ICON_NEWSSTAND_KEY  @"UINewsstandIcon"
#define ICON_KEY            @"CFBundleIconFiles"


//这里需要判断的 / It needs to be judged here
//#define ICON_DICT [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIcons"]
//主 / main
//#define PRIMARY_ARRAY [[ICON_DICT objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"]
//辅 / sub
//#define NEWSSTAND_ARRAY [[ICON_DICT objectForKey:@"UINewsstandIcon"] objectForKey:@"CFBundleIconFiles"]


//也可以制作数据模型处理 / You can also make data model processing

bool isDict(id objc) {
    if(!objc) return NO;
    if([objc isKindOfClass:[NSNull class]]) return NO;
    if(![objc isKindOfClass:[NSDictionary class]]) return NO;
    if(((NSDictionary *)objc).allKeys.count == 0) return NO;
    return YES;
}

@interface NSDictionary(values)
- (id)objectForNilKey:(NSString *)key;
@end

@implementation NSDictionary(values)
- (id)objectForNilKey:(NSString *)key {
    if(!isDict(self)) return nil;
    if(![self.allKeys containsObject:key]) return nil;
    return [self objectForKey:key];
}
@end

@interface RXChangeIcon()
//数据操作安全
@property (nonatomic, strong, nullable) dispatch_queue_t ioQueue;
@end

@implementation RXChangeIcon

+ (RXChangeIcon *)shareRXChangeIcon {
    static dispatch_once_t onceToken;
    static RXChangeIcon * __icon = nil;
    dispatch_once(&onceToken, ^{
        __icon = [RXChangeIcon new];
        __icon.ioQueue = dispatch_queue_create("com.SCMAPICACHE.srxboys", DISPATCH_QUEUE_SERIAL);
    });
    return __icon;
}

+ (NSArray *)getPrimaryArray {
    [self shareRXChangeIcon];
    return [self getIconArrayWithKey:ICON_PRIMARY_KEY];
}

+ (NSArray *)getNewsstandArray {
    [self shareRXChangeIcon];
    return [self getIconArrayWithKey:ICON_NEWSSTAND_KEY];
}

+ (NSDictionary *)getInfoPlistIconDict {
    [self shareRXChangeIcon];
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
    if(!isDict(infoDict)) return nil;
    return [infoDict objectForNilKey:ICON_INFO_PLIST_KEY];
}

+ (NSArray *)getIconArrayWithKey:(NSString *)key {
    [self shareRXChangeIcon];
    NSDictionary * iconDict = [self getInfoPlistIconDict];
    if(!isDict(iconDict)) return nil;
    NSDictionary * primaryDict = [iconDict objectForNilKey:key];
    if(!isDict(primaryDict)) return nil;
    return [primaryDict objectForNilKey:ICON_KEY];
}


+ (void)setIcon:(NSString *)imageName complete:(void (^)(NSError * _Nullable error))complete{
    //根据上面的地址做处理
    
    UIApplication * application = [UIApplication sharedApplication];
    if (@available(iOS 10.3, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([application supportsAlternateIcons]) {
                [application setAlternateIconName:imageName completionHandler:^(NSError * _Nullable error) {
                    if(complete) complete(error);
                }];
            }
            else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
                [application setNewsstandIconImage:[UIImage imageNamed:imageName]];
#endif
            }
        });
    }


    
}
+ (void)restoreIconImgComplete:(void (^)(NSError * _Nullable error))complete {
        if(@available(iOS 10.3, *)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([UIApplication sharedApplication].alternateIconName != nil) {//已经被替换掉了图标
                    [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
                        if(complete)  complete(error);
                    }];
                }
            });
        }
        else {
            // Fallback on earlier versions
        }
}

@end


/*
 info.plist 新增 Icon files (iOS 5)【 code=CFBundleIcons】
 Primary Icon为默认的app icon，只需要将Icon files目录下面的Item0设置成实际项目中icon名称。
 Newsstand Icon为默认的icon(这个比较老了 支持 iOS<=9)
 
 
 CFBundleAlternateIcons设置 (如果没有就手动添加) 支持 iOS>10.3
 注意：有2处要设置一样的，
 <key>CFBundleAlternateIcons</key>
 <dict>
     <key>icon_1</key> //1️⃣这里
     <dict>
         <key>UIPrerenderedIcon</key>
             <false/>
         <key>CFBundleIconFiles</key>
         <array>
             <string>icon_1</string>       //2️⃣这里
         </array>
     </dict>
 
 ...
 ...
 ...
 
 </dict>
 
 
 所有设置后，记得clean Xcode 在 编译+运行
 */
