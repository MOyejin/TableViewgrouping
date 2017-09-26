//
//  MOTableViewCell.m
//  tableview的展开收起
//
//  Created by 莫莫 on 2017/9/25.
//  Copyright © 2017年 MO. All rights reserved.
//

#import "MOTableViewCell.h"
#import "MOModel.h"

@interface MOTableViewCell()

@property (nonatomic,strong)MORowModel *rowModel;
@property (nonatomic,strong)NSIndexPath *path;



@end

@implementation MOTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(55, 0, 30, 30)];
        [_btn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [_btn addTarget:self action:@selector(ben_selected) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn];
        
        
        
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(205, 0, 205, 30)];
        [self.contentView addSubview:_lab];
    }
    return self;
}

- (void)ben_selected{
    _btn.selected = !_btn.selected;
    self.rowModel.isSubDisplay = _btn.selected;
    if (self.MOTableViewCellBlock) {
        self.MOTableViewCellBlock(self.path);
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _path = indexPath;
}

- (void)setModel:(MOModel *)model{
    _model = model;
    
    MORowModel *rowModel = model.row_array[_path.row];
    self.rowModel = rowModel;
    self.btn.selected = rowModel.isSubDisplay;
    self.lab.text = rowModel.row_name;
}

@end
