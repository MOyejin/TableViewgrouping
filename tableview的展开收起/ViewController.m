//
//  ViewController.m
//  tableview的展开收起
//
//  Created by 莫莫 on 2017/9/25.
//  Copyright © 2017年 MO. All rights reserved.
//

#import "ViewController.h"
#import "MOTableViewCell.h"
#import "MOModel.h"
#import <MJExtension.h>

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define StatusBarHeight (IOS7==YES ? 0 : 20)
#define MOScreenW   [UIScreen mainScreen].bounds.size.width
#define MOScreenH  [UIScreen mainScreen].bounds.size.height-StatusBarHeight
//随机色
#define RGBRandom [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView   *tabelView_main;
@property(nonatomic, strong)NSMutableArray   *dataArr;

@end

@implementation ViewController

//本地json
- (void)initData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"motext" ofType:@"json"];
    NSString *jsonData = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (jsonData != nil) {
        NSData *dat = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableContainers error:&err];
        NSArray *tet = [dic objectForKey:@"data"];
        
        self.dataArr = [MOModel mj_objectArrayWithKeyValuesArray:tet];
        
        MOModel *model = self.dataArr[0];
        MORowModel *row = model.row_array[0];
        NSLog(@"%@",row.row_name);
        
        [self.tabelView_main reloadData];
        if(err){
            NSLog(@"json解析失败：%@",err);
        }
    }
}

//初始化tableView
- (void)addSubView
{
    self.tabelView_main = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,MOScreenW,MOScreenH) style:UITableViewStylePlain];
    self.tabelView_main.delegate = self;
    self.tabelView_main.dataSource = self;
    self.tabelView_main.rowHeight = 30;
    
    [self.view addSubview:self.tabelView_main];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self addSubView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    MOModel *model = self.dataArr[section];
    
    return model.isDisplay ? model.row_array.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *key_id = @"cell";
    
    MOTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:key_id];
    if (!cell) {
        cell = [[MOTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key_id];
    }
    
    cell.indexPath = indexPath;
    cell.model = self.dataArr[indexPath.section];
    
    cell.MOTableViewCellBlock = ^(NSIndexPath *indexPath) {
        
        //点击一个cell头部选中;
        UIButton *button = [self.view viewWithTag:indexPath.section + 88];
        MOModel *model = self.dataArr[indexPath.section];
        NSMutableArray *boolAry = [NSMutableArray array];
        for (MORowModel *rowModel in model.row_array) {
            [boolAry addObject:[NSString stringWithFormat:@"%d", rowModel.isSubDisplay]];
        }
        if ([boolAry containsObject:@"1"]) {
            button.selected = YES;
            model.isAllSel = YES;
            
        }else{
            button.selected = NO;
            model.isAllSel = NO;
        }

        
        
    };
    
    return cell;
    
}

//头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
//header视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *vie = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MOScreenW, 60)];
    vie.backgroundColor = RGBRandom;
    
    MOModel *model = self.dataArr[section];
    
    //全选button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 30, 30)];
    btn.tag = section + 88;
    [btn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.selected = model.isAllSel;
    [vie addSubview:btn];
    
    //展开button
    UIButton *openBtn = [[UIButton alloc] initWithFrame:CGRectMake(MOScreenW - 50, 15, 30, 30)];
    openBtn.tag = section + 888;
    [openBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [openBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [openBtn addTarget:self action:@selector(openBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    openBtn.selected = model.isDisplay;
    [vie addSubview:openBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 300, 40)];

    lab.text = model.section;
    [vie addSubview:lab];
    
    return vie;
}

//头视图button全选
-(void)btnAction:(UIButton *)btn{
    MOModel *model = self.dataArr[btn.tag - 88];
    btn.selected = !btn.selected;
    model.isAllSel = btn.selected;
    model.isDisplay = btn.selected;
    
    for (MORowModel *rowModel in model.row_array) {
        rowModel.isSubDisplay = model.isAllSel;
    }
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:btn.tag - 88];
    [self.tabelView_main reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

//头视图按钮事件展开
-(void)openBtnClicked:(UIButton *)btn{
    MOModel *model = self.dataArr[btn.tag - 888];
    btn.selected = !btn.selected;
    model.isDisplay = btn.selected;

    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:btn.tag - 888];
    [self.tabelView_main reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
