//
//  NeteaseShareView.m
//  NeteaseShareSDKDemo
//
//  Created by Liuyong on 14-8-8.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

#import "NeteaseShareView.h"
#import "NeteaseGridView.h"

#define kMAX_CONTENT_HEIGHT 350
#define kEdgeMarginSpace 1
#define kMinimumInteritemSpacing 5
#define kUIViewAnimationTimeInterval 0.3
#define kCancelShare -1


@interface NeteaseShareView () <UIGestureRecognizerDelegate, NeteaseGridViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *upSeparatorView;

@property (nonatomic, strong) NeteaseGridView *gridView;
@property (nonatomic, strong) UIView *cancelSeparatorView;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation NeteaseShareView

+ (UIColor *)colorWithHex:(int)hex withAlpha:(CGFloat)alpha{
    
    CGFloat r = ((hex & 0xFF0000) >> 16) / 255.0;
    CGFloat g = ((hex & 0x00FF00) >> 8 ) / 255.0;
    CGFloat b = ((hex & 0x0000FF)      ) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hex{
    return [NeteaseShareView colorWithHex:hex withAlpha:1.0];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _itemSize = CGSizeMake(80, 80);
        _titleHeight = 12;
        _numOfColumns = 4;
        _titleFont = [UIFont systemFontOfSize:12];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0f];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBackgroundView:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
//        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self         action:@selector(onPanHandler:)];
//        [self addGestureRecognizer:panGesture];
        
        _itemTitles = [NSMutableArray array];
        _itemImages = [NSMutableArray array];
        _highlightItemImages = [NSMutableArray array];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 200)];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 2)];
        _topLineView.backgroundColor = [NeteaseShareView colorWithHex:0xc91e30];
        [_contentView addSubview:_topLineView];
        _topLineView.hidden = YES;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        [_contentView addSubview:_titleLabel];
        
        _upSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
        _upSeparatorView.backgroundColor = [NeteaseShareView colorWithHex:0xd1d1d1];
        [_contentView addSubview:_upSeparatorView];
        
        _gridView = [[NeteaseGridView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, 200)];
        _gridView.gridViewDelegate = self;
        _gridView.numOfColumns = self.numOfColumns;
        _gridView.backgroundColor = [UIColor whiteColor];
        
        [_contentView addSubview:_gridView];
        
        //取消按钮与视图之间的分割线
        _cancelSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 5)];
        _cancelSeparatorView.backgroundColor = [NeteaseShareView colorWithHex:0xe7e7e7];
        
        UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
        topSeparator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        topSeparator.backgroundColor = [NeteaseShareView colorWithHex:0xd1d1d1];
        [_cancelSeparatorView addSubview:topSeparator];
        
        UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, _cancelSeparatorView.frame.size.height - 0.5, 320, 0.5)];
        bottomSeparator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        bottomSeparator.backgroundColor = [NeteaseShareView colorWithHex:0xd1d1d1];
        [_cancelSeparatorView addSubview:bottomSeparator];
        
        [_contentView addSubview:_cancelSeparatorView];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.clipsToBounds = YES;
        _cancelButton.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, 44);
        
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_cancelButton setTitleColor:[NeteaseShareView colorWithHex:0x3a3a3a] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [_cancelButton setBackgroundImage:[NeteaseShareView imageWithColor:[NeteaseShareView colorWithHex:0xf3f5f5] size:_cancelButton.bounds.size] forState:UIControlStateHighlighted];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        
        [_cancelButton addTarget:self
                          action:@selector(onCancelButton:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:_cancelButton];
        
        [self addSubview:_contentView];
    }
    return self;
}


- (id)initWithTitle:(NSString *)title
         itemTitles:(NSArray *)itemTitles
             images:(NSArray *)images
    selectedHandler:(MenuActionHandler)handler
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        
        [self setupWithTitle:title itemTitles:itemTitles images:images selectedHandler:handler];
    }
    return self;
}

+ (instancetype)defaultShareViewWithGroup:(BOOL)hasGroup selectedHandler:(MenuActionHandler)handler {
    NeteaseShareView *shareView = nil;

    if (hasGroup) {
        shareView = [[NeteaseShareView alloc] initWithTitle:@"分享至" itemTitles:@[@"微信好友", @"微信朋友圈", @"新浪微博", @"QQ好友", @"QQ空间", @"高手秀场", @"分享到小组"] images:@[[UIImage imageNamed:@"share_btn_wechat"], [UIImage imageNamed:@"share_btn_moments"], [UIImage imageNamed:@"share_btn_weibo"], [UIImage imageNamed:@"share_btn_qq"], [UIImage imageNamed:@"share_btn_qzone"], [UIImage imageNamed:@"share_btn_topShow"], [UIImage imageNamed:@"share_group"]] selectedHandler:handler];
    } else {
        shareView = [[NeteaseShareView alloc] initWithTitle:@"分享至" itemTitles:@[@"微信好友", @"微信朋友圈", @"新浪微博", @"QQ好友", @"QQ空间"] images:@[[UIImage imageNamed:@"share_btn_wechat"], [UIImage imageNamed:@"share_btn_moments"], [UIImage imageNamed:@"share_btn_weibo"], [UIImage imageNamed:@"share_btn_qq"], [UIImage imageNamed:@"share_btn_qzone"]] selectedHandler:handler];
    }
    
    shareView.itemSize = CGSizeMake(70, 70);
    shareView.titleHeight = 12;
    shareView.itemCount = 4;
    
    return shareView;
}


#pragma mark - Public Method

- (void)setupItemTitles:(NSArray *)itemTitles
                images:(NSArray *)images
{
    NSInteger count = MIN(itemTitles.count, images.count);
    _itemTitles = !itemTitles ? [@[] mutableCopy ]: [[itemTitles subarrayWithRange:NSMakeRange(0, count)] mutableCopy];
    _itemImages = !images ? [@[] mutableCopy] : [[images subarrayWithRange:NSMakeRange(0, count)] mutableCopy];
    _itemCount = count;
}

- (void)setupWithTitle:(NSString *)title
            itemTitles:(NSArray *)itemTitles
                images:(NSArray *)images
       selectedHandler:(MenuActionHandler)handler
{
    NSInteger count = MIN(itemTitles.count, images.count);
    _titleLabel.text = title;
    _itemTitles = !itemTitles ? [@[] mutableCopy ]: [[itemTitles subarrayWithRange:NSMakeRange(0, count)] mutableCopy];
    _itemImages = !images ? [@[] mutableCopy] : [[images subarrayWithRange:NSMakeRange(0, count)] mutableCopy];
    _itemCount = count;
    self.actionHandle = handler;
}

- (BOOL)addItemTitles:(NSArray *)itemTitles images:(NSArray *)images
{
    NSInteger count = MIN(itemTitles.count, images.count);
    if (count <= 0) {
        return NO;
    }
    
    if (!self.itemTitles) {
        self.itemTitles = [NSMutableArray arrayWithArray:[itemTitles subarrayWithRange:NSMakeRange(0, count)]];
    }
    else {
        [self.itemTitles addObjectsFromArray:[itemTitles subarrayWithRange:NSMakeRange(0, count)]];
    }
    
    if (!self.itemImages) {
        self.itemImages = [NSMutableArray arrayWithArray:[images subarrayWithRange:NSMakeRange(0, count)]];
    }
    else {
        [self.itemImages addObjectsFromArray:[images subarrayWithRange:NSMakeRange(0, count)]];
    }
    
    return YES;
}

- (BOOL)addItemTitle:(NSString *)itemTitle image:(UIImage *)image highlightImage:(UIImage *)highlightImage
{
    if (!itemTitle || !image) {
        return NO;
    }
    
    [self.itemTitles addObject:itemTitle];
    [self.itemImages addObject:image];
    [self.highlightItemImages addObject:highlightImage];
    return YES;
}

- (void)setNumOfColumns:(NSUInteger)numOfColumns
{
    _numOfColumns = numOfColumns;
    self.gridView.numOfColumns = numOfColumns;
    [self.gridView reloadData];
}

- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    [self.gridView reloadData];
}

- (void)setTitleHeight:(NSInteger)titleHeight
{
    _titleHeight = titleHeight;
    [self.gridView reloadData];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.contentView.frame = (CGRect){CGPointMake(0, self.bounds.size.height - self.contentView.bounds.size.height), self.contentView.bounds.size};
    [self.contentView layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topLineView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, 1);
    self.titleLabel.frame = (CGRect){CGPointMake(20, self.topLineView.frame.origin.y + self.topLineView.frame.size.height), CGSizeMake(self.contentView.bounds.size.width - 40, 40)};
    self.upSeparatorView.frame = CGRectMake(kEdgeMarginSpace, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, self.contentView.bounds.size.width - kEdgeMarginSpace*2, 0.5);
    self.gridView.frame = CGRectMake(0, self.upSeparatorView.frame.origin.y + self.upSeparatorView.frame.size.height + kEdgeMarginSpace , self.contentView.bounds.size.width, 200);
    [self layoutGridView];
    self.gridView.frame = CGRectMake(0, self.upSeparatorView.frame.origin.y + self.upSeparatorView.frame.size.height + kEdgeMarginSpace , self.contentView.bounds.size.width, self.gridView.bounds.size.height);
    
    self.cancelSeparatorView.frame = CGRectMake(0, self.gridView.frame.origin.y + self.gridView.frame.size.height + kEdgeMarginSpace, self.contentView.bounds.size.width, 3 /*self.cancelSeparatorView.frame.size.height*/);
    
    self.cancelButton.frame = CGRectMake(0, self.cancelSeparatorView.frame.origin.y + self.cancelSeparatorView.bounds.size.height,self.contentView.bounds.size.width, 44);
    
    self.contentView.bounds = (CGRect){CGPointZero, CGSizeMake(self.contentView.bounds.size.width, self.titleLabel.bounds.size.height + self.gridView.bounds.size.height + self.cancelSeparatorView.bounds.size.height + self.cancelButton.bounds.size.height + kEdgeMarginSpace * 2 + 3)};
    self.contentView.frame = (CGRect){CGPointMake(0, self.bounds.size.height - self.contentView.bounds.size.height), self.contentView.bounds.size};
}

- (void)layoutGridView
{
    CGFloat rowHeight = self.itemSize.height + [self gridView:self.gridView spaceForRowAt:0];
    NSInteger rows = [self.gridView numberOfRowsInSection:0];
    CGFloat gridViewHeight = rowHeight * rows + 10;
    if (gridViewHeight > kMAX_CONTENT_HEIGHT) {
        self.gridView.bounds = CGRectMake(0, 0, self.contentView.bounds.size.width, kMAX_CONTENT_HEIGHT);
        self.gridView.scrollEnabled = YES;
    }
    else {
        self.gridView.bounds = CGRectMake(0, 0, self.contentView.bounds.size.width, gridViewHeight);
        self.gridView.scrollEnabled = NO;
    }
    
}
- (UIView *)topView{
    UIView *topView = nil;
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        if (window.windowLevel == UIWindowLevelNormal) {
            topView = window;
            break;
        }
    }
    return topView;
}

- (void)showInview:(UIView *)parentView
{
    if (![self superview]) {
        
        if (parentView){
            [parentView addSubview:self];
        }
        else{
            [self.topView addSubview:self];
        }
    }
    [self.gridView reloadData];
    self.frame = (CGRect){CGPointMake(0, 0), self.superview.bounds.size};
    CGRect contentFrame = self.contentView.frame;
    contentFrame.size.width = CGRectGetWidth(self.bounds);
    
    self.contentView.frame = (CGRect){CGPointMake(0, contentFrame.origin.y + contentFrame.size.height), contentFrame.size};
    [UIView animateWithDuration:kUIViewAnimationTimeInterval animations:^{
        self.contentView.frame = contentFrame;
        [self setNeedsLayout];
        [self.gridView reloadData];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss
{
    [self dismissShareViewWithIndex:kCancelShare];
}

#pragma  mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.contentView.frame, touchPoint)) {
        return NO;
    }
    
    return YES;
}

#pragma mark - HandleEvent

- (void)onCancelButton:(id)sender
{
    [self dismissShareViewWithIndex:kCancelShare];
}

- (void)onTapBackgroundView:(UITapGestureRecognizer *)tapGesture
{
    [self dismissShareViewWithIndex:kCancelShare];
}

- (void)onPanHandler:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        [self dismissShareViewWithIndex:kCancelShare];
    }
    
}

- (void)dismissShareViewWithIndex:(NSInteger)index
{
    CGRect contentFrame = self.contentView.frame;
    contentFrame = (CGRect){CGPointMake(0, contentFrame.origin.y + contentFrame.size.height), contentFrame.size};
    
    [UIView animateWithDuration:kUIViewAnimationTimeInterval animations:^{
        self.contentView.frame = contentFrame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.actionHandle)
        {
            self.actionHandle(index);
        }
    }];
}

#pragma mark - NeteaseGridViewDelegate

- (NSInteger) numberOfCellsOfGridView:(NeteaseGridView *) grid
{
    return self.itemTitles.count;
}

- (NeteaseGridViewCell *) gridView:(NeteaseGridView *)grid cellForGridIndex:(NeteaseGridViewIndex *)gridIndex
{
    NeteaseGridViewCell *cell = [grid dequeueReusableCell];
    
    if (!cell) {
        cell = [[NeteaseGridViewCell alloc] initWithCellStyle:NeteaseGridViewCellStyleTitle];
    }
    
    NSInteger index = gridIndex.rowIndex * grid.numOfColumns + gridIndex.columnIndex;
    cell.iconImageView.image = self.itemImages[index];
    if (self.highlightItemImages && self.highlightItemImages.count > index) {
        cell.iconImageView.highlightedImage = self.highlightItemImages[index];
        cell.highlightImage = self.highlightItemImages[index];
    }
    
    cell.normalImage = self.itemImages[index];
    cell.label.text = [NSString stringWithFormat:@"%@", self.itemTitles[index]];
    cell.label.font = self.titleFont;
//    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
//    [cell.touchBtn setBackgroundImage:[NeteaseShareView imageWithColor:[UIColor colorWithWhite:1 alpha:0.9] size:self.itemSize] forState:UIControlStateHighlighted];
    return cell;
}

- (CGFloat) gridView:(NeteaseGridView *)grid widthForColumnAt:(NSInteger)columnIndex
{
    return self.itemSize.width;
}

- (CGFloat) gridView:(NeteaseGridView *)grid heightForRowAt:(NSInteger)rowIndex
{
    return self.itemSize.height;
}

- (CGFloat) gridView:(NeteaseGridView *)grid spaceForRowAt:(NSInteger)rowIndex
{
    return 10;
}
/*
 *列间距，每个网格cell之间的间距：横向间距 default:0
 */
- (CGFloat) gridView:(NeteaseGridView *)grid spaceForCellGridIndex:(NeteaseGridViewIndex *)gridIndex
{
    return 10;
}

- (CGFloat) gridView:(NeteaseGridView *)grid titleHeightForCellGridIndex:(NeteaseGridViewIndex *)gridIndex
{
    return self.titleHeight;
}

- (void) gridView:(NeteaseGridView *)grid didSelectCell:(NeteaseGridViewCell *)cell
{
//    NSLog(@"didSelect cell row:%ld, column:%ld", cell.gridIndex.rowIndex, cell.gridIndex.columnIndex);
    cell.bSelected = NO;
    NSInteger index = cell.gridIndex.rowIndex * grid.numOfColumns + cell.gridIndex.columnIndex;
    [self dismissShareViewWithIndex:index];
}
@end