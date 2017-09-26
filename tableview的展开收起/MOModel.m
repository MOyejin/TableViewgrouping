//
//  MOModel.m
//  tableview的展开收起
//
//  Created by 莫莫 on 2017/9/25.
//  Copyright © 2017年 MO. All rights reserved.
//

#import "MOModel.h"
#import <MJExtension.h>

@implementation MOModel

- (void)setRow_array:(NSArray<MORowModel *> *)row_array{
    _row_array = [MORowModel mj_objectArrayWithKeyValuesArray:row_array];
    
}

@end

@implementation MORowModel


@end
