//
//  TableViewCell.m
//  RXInternationalConfig
//
//  Created by srxboys on 2018/1/17.
//  Copyright © 2018年 srxboys. All rights reserved.
//

#import "TableViewCell.h"

NSString * const HomeCellIdentifier = @"TableViewCell";

@implementation TableViewCell {
    UILabel * _txtLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.contentView.bounds;
    CGFloat width = frame.size.width;
    CGFloat width_fix = width/ 2 - 10;
    frame.origin.x += 10;
    frame.size.width = width_fix;
    self.textLabel.frame = frame;
    frame.origin.x = width_fix;
    _txtLabel.frame = frame;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        _txtLabel = [UILabel new];
        _txtLabel.font = [UIFont systemFontOfSize:14];
        _txtLabel.textAlignment = NSTextAlignmentRight;
        _txtLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_txtLabel];
    }
    return self;
}

- (void)setCellWithKey:(NSString *)key value:(NSString *)value {
    if([key rangeOfString:@"group"].location == NSNotFound) {
        self.textLabel.text = key;
        _txtLabel.text = value;
    }
    else {
        self.textLabel.text = @"";
        _txtLabel.text = @"";
    }
}

@end
