//
//  NeteaseGridView.h
//  FMGridViewDemo
//
//  Created by CyonLeu on 14-8-7.
//  Copyright (c) 2014年 CyonLeuInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeteaseGridViewCell.h"

@protocol NeteaseGridViewDelegate;

@interface NeteaseGridView : UITableView <UITableViewDelegate, UITableViewDataSource, NeteaseGridViewCellDelegate>
{
    NeteaseGridViewCell *_reusableCell;
}

@property (nonatomic, assign) id<NeteaseGridViewDelegate> gridViewDelegate;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NeteaseGridViewIndex *selectedIndex;
@property (nonatomic) NSInteger numOfColumns;//default is 4
@property (nonatomic, readonly) NSInteger numOfRows;


/**
 *  /外部可用方法
 *
 **/

//获取可重用的cell
- (NeteaseGridViewCell *) dequeueReusableCell;

//根据行列索引获取Cell

- (NeteaseGridViewCell *) getGridViewCellWithGridIndex:(NeteaseGridViewIndex *)gridIndex;
- (void)selectGridViewCellAtGridIndex:(NeteaseGridViewIndex *)gridIndex;//选中cell
- (void)deselectGridViewCellAtGridIndex:(NeteaseGridViewIndex *)gridIndex;//取消选中状态

@end


@protocol NeteaseGridViewDelegate  <NSObject>

@required
- (NSInteger) numberOfCellsOfGridView:(NeteaseGridView *) grid;

- (NeteaseGridViewCell *) gridView:(NeteaseGridView *)grid cellForGridIndex:(NeteaseGridViewIndex *)gridIndex;

@optional
/*
 *default: 80
 */
- (CGFloat) gridView:(NeteaseGridView *)grid widthForColumnAt:(NSInteger)columnIndex;

/*
 *default: 80
 */
- (CGFloat) gridView:(NeteaseGridView *)grid heightForRowAt:(NSInteger)rowIndex;

- (void) gridView:(NeteaseGridView *)grid didSelectCell:(NeteaseGridViewCell *)cell;

/*
 *default: 4
 */

- (NSInteger) numberOfColumnsOfGridView:(NeteaseGridView *) grid;
/*
 *行间距，获取当前行与上一行的间距：竖向间距 default:0
 */
- (CGFloat) gridView:(NeteaseGridView *)grid spaceForRowAt:(NSInteger)rowIndex;
/*
 *列间距，每个网格cell之间的间距：横向间距 default:0
 */
- (CGFloat) gridView:(NeteaseGridView *)grid spaceForCellGridIndex:(NeteaseGridViewIndex *)gridIndex;

//每个cell的标题高度，若cellStyle为NeteaseGridViewCellStyleTitle时，需要设置该值，default:20
- (CGFloat) gridView:(NeteaseGridView *)grid titleHeightForCellGridIndex:(NeteaseGridViewIndex *)gridIndex;


@end
