//
//  MOModel.h
//  tableview的展开收起
//
//  Created by 莫莫 on 2017/9/25.
//  Copyright © 2017年 MO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MORowModel : NSObject

@property (nonatomic,copy) NSString *row_ID;
@property (nonatomic,copy) NSString *row_name;
@property (nonatomic,assign)BOOL isSubDisplay;


@end

@interface MOModel : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *section;
@property (nonatomic,strong)NSArray<MORowModel *> *row_array;
@property (nonatomic,assign)BOOL isDisplay; //判断是否展开
@property (nonatomic,assign)BOOL isAllSel;//全屏是否全选


@end
