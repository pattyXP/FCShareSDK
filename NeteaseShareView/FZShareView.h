//
//  NIEShareView.h
//  CustomShareView
//
//  Created by Liuyong on 14-6-24.
//  Copyright (c) 2014年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZShareView : UIView

@property (assign, nonatomic) BOOL cancelButtonHidden; //default is NO
@property (copy, nonatomic) void(^shareViewDidClickItemBlock)(FZShareView *shareView, NSInteger index);

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles images:(NSArray *)images;
- (void)showInview:(UIView *)parentView;

@end
