//
//  NeteaseGridViewCell.h
//  FMGridViewDemo
//
//  Created by CyonLeu on 14-8-7.
//  Copyright (c) 2014年 CyonLeuInc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    NeteaseGridViewCellStyleDefault = 0,  //默认网格中就只有图片
    NeteaseGridViewCellStyleTitle         //图片之外，还有图片说明标题
    
} NeteaseGridViewCellStyle;

#define kCellTitleAndImageGap 4
#define kCellTitleHeightDefault 12
#define kCellWidthDefault 80
#define kCellHeightDefault 80

/**
 *  @brief  iconHeight = cellHeight - titleHeight
 */


@interface NeteaseGridViewIndex : NSObject
{
    
}
@property (nonatomic, assign) NSInteger     rowIndex;
@property (nonatomic, assign) NSInteger     columnIndex;

+ (id)gridViewIndexWithRow:(NSInteger)row column:(NSInteger)column;
- (id)initWithRow:(NSInteger)row column:(NSInteger)column;
- (BOOL)isEqualIndex:(NeteaseGridViewIndex *)otherObject;


@end

@protocol NeteaseGridViewCellDelegate;


/**
 *  gridCell
 */
@interface NeteaseGridViewCell : UIView

{
    NeteaseGridViewCellStyle _gridViewCellStyle;
}

@property (nonatomic, assign) id<NeteaseGridViewCellDelegate> delegate;

@property (nonatomic, retain) NeteaseGridViewIndex *gridIndex;
@property (nonatomic, assign) CGFloat        titleHeight;
@property (nonatomic, assign) BOOL		     bSelected;

@property (nonatomic, retain) UIButton      *touchBtn;
@property (nonatomic, retain) UIImageView   *iconImageView; //缩略图
@property (nonatomic, retain) UILabel       *label;     //说明标题

@property (nonatomic, retain) UIView        *backgroundView;//背景视图
@property (nonatomic, retain) UIView        *selectedBackgroundView;//选中时的背景

@property (nonatomic, retain) UIImage       *normalImage;
@property (nonatomic, retain) UIImage       *highlightImage;

- (id)initWithCellStyle:(NeteaseGridViewCellStyle)cellStyle;
- (void)onPressedTouchBtn:(id)sender;

@end

@protocol NeteaseGridViewCellDelegate <NSObject>

@optional
- (void)cellSelected:(NeteaseGridViewCell *)cell;


@end
