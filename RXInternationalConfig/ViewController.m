//
//  ViewController.m
//  RXInternationalConfig
//
//  Created by srxboys on 2018/1/16.
//  Copyright © 2018年 srxboys. All rights reserved.
//

#import "ViewController.h"

#import "TableViewCell.h"

#import "RXIconTableViewController.h"
#import "RXChangeIcon.h"

@interface ViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
@property (nonatomic, copy) NSMutableArray * sourceArray;
@property (nonatomic, copy) UITableView * tableView;
@end

@implementation ViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGRect frame = self.tableView.frame;
    if(@available( iOS 11.0 , *)) {
        frame.origin.x = self.view.safeAreaInsets.left;
        frame.size.width = self.view.bounds.size.width - self.view.safeAreaInsets.right - self.view.safeAreaInsets.left;
    }
    else {
        frame = self.view.bounds;
    }
    self.tableView.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    NSString * title = Localized(LOC_HOME_TITLE);
    title = [title stringByAppendingString:@"(在[设置]里看)"];
    self.title = title;

    NOTI_ADD_OBNAME(@selector(appDidBecomeActive:), UIApplicationDidBecomeActiveNotification);
    
    [self configUI];
}

- (void)configUI {
    _sourceArray = [NSMutableArray new];
    
    //built settings
    //编译模式 == 可以直接全局使用
    //Distribution : app是否是生产包
    //Interface_Distribution=1  : 接口是否是生产接口
    //DEBUG
    NSString * SETServer = nil;
#if DEBUG && Interface_Distribution == 0
    SETServer = @"真机 debug";
#elif Distribution == 0 && Interface_Distribution == 1
    SETServer = @"真机 release";
#elif Distribution == 0 && Interface_Distribution == 1
    SETServer = @"企业 ADHoc";
#elif Distribution == 1 && Interface_Distribution == 1
    SETServer = @"生产 appStore";
#endif
    
    NAV_VIEW_ADD_BAR_BUTTON(self, SETServer, @selector(barButtonItemLeftClick), YES);
    NAV_VIEW_ADD_BAR_BUTTON(self, @"改 icon", @selector(barButtonItemRightClick), NO);
   
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:HomeCellIdentifier];
    [self.view addSubview:self.tableView];
    [self getSettingBundle];
}

- (void)barButtonItemLeftClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)barButtonItemRightClick {
    RXIconTableViewController * iconVC = [RXIconTableViewController new];
    [self.navigationController pushViewController:iconVC animated:YES];
}

- (void)getSettingBundle {
    
    NSArray * prefSpecifierArray = nil;
    SETTING_BUNDLE(prefSpecifierArray);
 
    if(prefSpecifierArray.count > 0) {
        [_sourceArray removeAllObjects];
    }
    
    NSDictionary *prefItem;
    for (prefItem in prefSpecifierArray) {
        NSString *keyValueStr = prefItem[@"Key"];  //key
        id defaultValue = prefItem[@"DefaultValue"]; //value
        NSLog(@"key=%@ value=%@", keyValueStr, defaultValue);
        
        if(keyValueStr == nil) {
            //分组的都是 nil ,防止崩溃（也可以在宏定义里面添加）
            keyValueStr = @"group";
            defaultValue = @"";
        }
        
        
//下面的判断 只是为了看效果，不建议项目中使用
if([keyValueStr isEqualToString:@"Title_preference"]) {
    if(![UserGetSetting(@"icon_name") isEqualToString:defaultValue]) {
        UserSaveSetting(@"icon_name", defaultValue);
        if(((NSString *)defaultValue).length > 0) {
            [RXChangeIcon setIcon:defaultValue complete:nil];
        }
        else {
            [RXChangeIcon restoreIconImgComplete:nil];
        }
    }
}
 
/*
 版本号的判断
 修改沙盒+此数据内容  就好，
 
 迭代版本 就修改root.plist就好
 如果有使用，热更新，就需要代码修改版本号等操作
*/
        
        [_sourceArray addObject:@{keyValueStr : defaultValue}];
    }

    if(_sourceArray.count > 0) {
        [self.tableView reloadData];
    }
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        _tableView.tableFooterView = [UIView new];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}


- (void)appDidBecomeActive:(NSNotification *)notif {
    [self getSettingBundle];
}


#pragma mark ----- tableView --------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HomeCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(row < _sourceArray.count) {
        NSDictionary * dict = [_sourceArray objectAtIndex:row];
        NSString * key = [dict.allKeys firstObject];
        NSString * value = [NSString stringWithFormat:@"%@", dict[key]];
        [cell setCellWithKey:key value:value];
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
