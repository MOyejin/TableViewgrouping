//
//  MOTableViewCell.h
//  tableview的展开收起
//
//  Created by 莫莫 on 2017/9/25.
//  Copyright © 2017年 MO. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOModel;
@interface MOTableViewCell : UITableViewCell

@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UILabel *lab;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)MOModel *model;

@property (nonatomic,copy) void (^MOTableViewCellBlock)(NSIndexPath *indexPath);

@end
