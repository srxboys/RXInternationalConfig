//
//  TableViewCell.h
//  RXInternationalConfig
//
//  Created by srxboys on 2018/1/17.
//  Copyright © 2018年 srxboys. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString * const HomeCellIdentifier;

@interface TableViewCell : UITableViewCell
- (void)setCellWithKey:(NSString *)key value:(NSString *)value;
@end
