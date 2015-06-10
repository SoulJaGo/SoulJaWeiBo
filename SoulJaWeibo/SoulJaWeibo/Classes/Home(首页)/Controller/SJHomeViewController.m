//
//  SJHomeViewController.m
//  SoulJaWeibo
//
//  Created by SoulJa on 15/6/5.
//  Copyright (c) 2015年 SoulJa. All rights reserved.
//

#import "SJHomeViewController.h"
#import "UIBarButtonItem+SJ.h"
#import "SJTitleButton.h"
#import "AFNetworking.h"
#import "SJAccountTool.h"
#import "UIImageView+WebCache.h"
#import "SJStatus.h"
#import "SJUser.h"
#import "MJExtension.h"

@interface SJHomeViewController ()
@property (nonatomic,strong) NSArray *statuses;
@end

@implementation SJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.设置导航栏
    [self setupNavBar];
    //2.加载微博数据
    [self setupStatusData];
}

/**
 *  加载微博数据
 */
- (void)setupStatusData
{
    //1.发起请求
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //2.请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [SJAccountTool account].access_token;
    
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //取出所有的微博数据
        NSArray *dictArray = responseObject[@"statuses"];
        
        //将字典数据转换为模型数据
//        NSMutableArray *statusArray = [NSMutableArray array];
//        for (NSDictionary *dict in dictArray) {
//            //创建模型
//            SJStatus *status = [SJStatus objectWithKeyValues:dict];
//            
//            //添加模型
//            [statusArray addObject:status];
//        }
    
        self.statuses = [SJStatus objectArrayWithKeyValuesArray:dictArray];
        
        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
/**
 *  设置导航栏
 */
- (void)setupNavBar
{
    //左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_friendsearch" highIcon:@"navigationbar_friendsearch_highlighted" target:self action:@selector(findFriend)];
    //右边的按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_pop" highIcon:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    //设置中间的按钮
    SJTitleButton *titleButton = [SJTitleButton titleButton];
    [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [titleButton setTitle:@"哈哈哈哈" forState:UIControlStateNormal];
    titleButton.frame = CGRectMake(0, 0, 100, 30);
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
}

- (void)titleClick:(SJTitleButton *)titleButton
{
    if (titleButton.selected) {
        [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    } else {
        [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    }
    titleButton.selected = !titleButton.selected;
}

- (void)pop
{
    SJLog(@"pop");
}

- (void)findFriend
{
    SJLog(@"findFriend");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    SJStatus *status = self.statuses[indexPath.row];
    cell.textLabel.text = status.text;
    SJUser *user = status.user;
    cell.detailTextLabel.text = user.name;
    
    //微博作者的头像
    NSString *iconUrl = user.profile_image_url;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:iconUrl]
                      placeholderImage:[UIImage imageWithName:@"icon"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
