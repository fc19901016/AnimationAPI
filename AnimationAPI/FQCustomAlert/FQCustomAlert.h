//
//  FQCustomAlert.h
//  AnimationAPI
//
//  Created by fengpan on 2018/10/10.
//  Copyright © 2018年 fengpan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FQCustomModel.h"

NS_ASSUME_NONNULL_BEGIN
@class FQCustomAlert;

typedef NS_ENUM(NSInteger, UIAlertTypes) {
    UIAlertTypeHorizontal,      //从0开始,水平按钮
    UIAlertTypeVertical,        //竖直按钮
    UIAlertTypeBackgroundImage, //带背景提示框
    UIAlertTypeTableView,       //列表选择弹框
    UIAlertTypeTextView,        //输入框弹框
};
    

typedef void(^SureActionBlock)(FQCustomModel *model);
typedef void(^CancelActionBlock)(NSString *title);
typedef UITableViewCell * _Nullable (^IndexPathBlock)(UITableView*tableView,NSIndexPath *indexPath);


@protocol FQCustomAlertDelegate <NSObject>

-(void)alert:(FQCustomAlert *)alert withIndexButton:(UIButton *)button;

@end


@interface FQCustomAlert : UIView

@property (nonatomic, copy)SureActionBlock sureActionBlock;
@property (nonatomic, copy)CancelActionBlock cancelActionBlock;
@property (nonatomic, weak) id<FQCustomAlertDelegate>delegate;


/**
 水平按钮

 @param title 标题
 @param content 内容
 @param itemTitle 按钮文字
 @return FQCustomAlert
 */
- (instancetype)initWithTitle:(NSString *)title
                  WithContent:(NSString *)content
                     delegate:(id<FQCustomAlertDelegate>)delegate
      WithHorizontalItemTitle:(NSArray <NSString *>*)itemTitle;

/**
 竖直按钮

 @param title 标题
 @param content 内容
 @param itemTitle 按钮文字
 @return FQCustomAlert
 */
- (instancetype)initWithTitle:(NSString *)title
                  WithContent:(NSString *)content
                     delegate:(id<FQCustomAlertDelegate>)delegate
        WithVerticalItemTitle:(NSArray <NSString *>*)itemTitle;

/**
 带背景的弹框

 @param title 标题
 @param content 内容
 @param imageName 图片名称
 @param sureTitle 确定文字
 @return FQCustomAlert
 */
-(instancetype)initWithTitle:(NSString *)title
                  WithContent:(NSString *)content
                WithImageName:(NSString *)imageName
             WithSureBtnTitle:(NSString *)sureTitle;
/**
 确定取消按钮的弹框

 @param title 标题
 @param contentArray 列表内容
 @param sureBlock 确定回调
 @param cancelBlock 取消回调
 @return FQCustomAlert
 */
-(FQCustomAlert * )initWithTitle:(NSString *)title
               WithContentString:(NSMutableArray <FQCustomModel *>*)contentArray
                   WithSureBlock:(SureActionBlock)sureBlock
                 WithCancelBlock:(CancelActionBlock)cancelBlock;

- (void)show;

@end

NS_ASSUME_NONNULL_END
