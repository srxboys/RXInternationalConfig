//
//  RXIconTableViewController.m
//  RXInternationalConfig
//
//  Created by srxboys on 2018/1/17.
//  Copyright © 2018年 srxboys. All rights reserved.
//

#import "RXIconTableViewController.h"
#import "RXChangeIcon.h"

static NSString * const CELL_ID_0 = @"cell_0";
static NSString * const CELL_ID_1 = @"cell_1";

@interface RXIconTableViewController ()
@property (nonatomic, copy) NSArray * primaryArray;
@property (nonatomic, copy) NSArray * newsstandArray;
@property (nonatomic, copy) NSString * loc_icon;
@end

@implementation RXIconTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"点击更改 icon";
//     self.clearsSelectionOnViewWillAppear = NO;
    [self configUI];
}

- (void)configUI {
    self.primaryArray = @[@"icon_0"];
    self.newsstandArray = [RXChangeIcon getNewsstandArray];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_ID_0];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_ID_1];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 50;
    self.tableView.sectionHeaderHeight = 30;

    NOTI_ADD_OBNAME(@selector(refresh), @"update_icon");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)loc_icon {
    if(!_loc_icon) {
        _loc_icon = UserGetSetting(@"icon_name_srx");
        if(_loc_icon.length == 0) {
            _loc_icon = @"icon_0";
        }
    }
    return _loc_icon;
}

- (void)refresh {
    self.loc_icon = nil;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return self.primaryArray.count;
    return self.newsstandArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = CELL_ID_0;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(section == 1) {
        cellID = CELL_ID_1;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString * title = @"";
    if(section == 0) {
        title = row < self.primaryArray.count ?  self.primaryArray[row] : @"";
    }
    else {
        title = row < self.newsstandArray.count ?  self.newsstandArray[row] : @"";
    }
    UIImage * img = [UIImage imageNamed:title];
    cell.imageView.image = img;
    cell.textLabel.text = title;
    if([title isEqualToString:self.loc_icon]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) return @"primary";
    return @"newsstand";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STATUS_BAR_START();
    self.view.userInteractionEnabled = NO;
    NSString * iconName = nil;
    NSInteger row = indexPath.row;
    if(indexPath.section == 0) {
        [RXChangeIcon restoreIconImgComplete:^(NSError * _Nullable error) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            STATUS_BAR_STOP();
            self.view.userInteractionEnabled = YES;
            
            if(error) {
                //NSLog(@"还原设置失败 error=%@", error.description);
            }
            else {
                NSLog(@"还原设置成功");
            }
        }];
    }
    else {
        iconName = row < self.newsstandArray.count ? self.newsstandArray[row] : @"";
        NSLog(@"\n\niconName=%@\n\n", iconName);
        [RXChangeIcon setIcon:iconName complete:^(NSError * _Nullable error) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            STATUS_BAR_STOP();
            self.view.userInteractionEnabled = YES;
            if(error) {
    //            NSLog(@"设置失败 error=%@", error.description);
            }
            else {
                NSLog(@"设置成功");
            }
        }];
    }
    
    UserSaveSetting(@"Title_preference",iconName);
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
