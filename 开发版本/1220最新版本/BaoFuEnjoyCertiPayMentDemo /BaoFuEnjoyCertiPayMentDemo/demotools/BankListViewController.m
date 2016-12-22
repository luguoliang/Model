//
//  BankListViewController.m
//  BaofooWallet
//
//  Created by mac on 15/5/27.
//  Copyright (c) 2015年 宝付网络（上海）有限公司. All rights reserved.
//

#import "BankListViewController.h"

@interface BankListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_index;
}
@property(nonatomic,strong)UITableView *bankListTabel;//列表
@property(nonatomic,strong)NSArray *listArr;//列表数据
@end

@implementation BankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = @"NO";
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.title = self.selectStyle==1?@"选择银行":@"支持银行";
    self.view.backgroundColor = UIColorFromRGB(BACKGROUND_COLOR);
    [self.view addSubview:self.bankListTabel];
}
- (UITableView *)bankListTabel
{
    if (!_bankListTabel) {
        _bankListTabel = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SCREEN_WIDTH, SCREEN_HEIGHT-64.0f) style:UITableViewStyleGrouped];
        _bankListTabel.delegate = self;
        _bankListTabel.dataSource = self;
        _bankListTabel.rowHeight = 53.0f;
    }
    return _bankListTabel;
}
- (NSArray *)listArr
{
    if (!_listArr) {

        _listArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bankList" ofType:@"plist"]];
        [_listArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            if (*stop==NO) {
                if ([obj[@"bankId"] isEqualToString:_bankId]) {
                    _index = [NSString stringWithFormat:@"%ld",idx];
                }
            }
        }];
    }
    return _listArr;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listCell"];
        UIImageView *listIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 33.0f, 33.0f)];
        listIcon.tag = 100;
        [cell.contentView addSubview:listIcon];
        
        UILabel *bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(listIcon.frame.origin.x+listIcon.frame.size.width+10.0f, 0.0f, 200.0f, 53.0f)];
        bankNameLabel.textColor = UIColorFromRGB(BLACK_COLOR);
        bankNameLabel.font = FONT(14.0f);
        bankNameLabel.tag = 200;
        [cell.contentView addSubview:bankNameLabel];
    }
    UIImageView *listIcon = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *bankNameLabel = (UILabel *)[cell.contentView viewWithTag:200];
    
    NSDictionary *dataDict = self.listArr[indexPath.row];
    NSString *mainPath = [[NSBundle mainBundle] pathForResource:@"bankImage" ofType:@"bundle"];
    NSString *imagePath = [mainPath stringByAppendingPathComponent:[NSString stringWithFormat:@"logo/%@.png",dataDict[@"bankId"]]];
    listIcon.image = [UIImage imageWithContentsOfFile:imagePath];
    bankNameLabel.text = dataDict[@"bankName"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.selectStyle == 1) {
        if (![_index isEqualToString:@"NO"]) {
            if ([_index intValue] == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
    }
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectStyle == 1)
    {
        // 选中操作
        UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // 保存选中的
        _index = [NSString stringWithFormat:@"%ld",indexPath.row];
        [self.bankListTabel reloadData];
        [self.navigationController popViewControllerAnimated:YES];
        self.addBankVC.bankDict = self.listArr[indexPath.row];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
