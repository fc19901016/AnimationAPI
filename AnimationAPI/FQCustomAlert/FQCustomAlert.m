//
//  FQCustomAlert.m
//  AnimationAPI
//
//  Created by fengpan on 2018/10/10.
//  Copyright © 2018年 fengpan. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGBCOLOR(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define APPScreen_Width_Scale(s) s*(SCREEN_WIDTH/375)
#define APPScreen_Height_Scale(s) s*(SCREEN_HEIGHT/667)

#import "FQCustomAlert.h"

@interface FQCustomAlert ()<UITableViewDataSource,UITableViewDelegate>{
    UIView *_bgView;
    UIView *_alertView;
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray <FQCustomModel *> *dataSouseArray;

@property (nonatomic, strong) FQCustomModel *selectModel;

@end

@implementation FQCustomAlert

#pragma -mark 默认提示框、水平按钮
- (instancetype)initWithTitle:(NSString *)title
                  WithContent:(NSString *)content
                     delegate:(id<FQCustomAlertDelegate>)delegate
      WithHorizontalItemTitle:(NSArray <NSString *>*)itemTitle{
    self = [super init];
    if (self) {
        _delegate = delegate;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        /** 半透明背景*/
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = RGBCOLOR(0, 0, 0, 0.3);
        [self addSubview:_bgView];
        
        /** 父控件view*/
        UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0.1*SCREEN_WIDTH, 0.1*SCREEN_HEIGHT, 0.8*SCREEN_WIDTH, 0.8*SCREEN_HEIGHT)];

        alertView.center = _bgView.center;
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 8.0;
        alertView.layer.masksToBounds = YES;
        [_bgView addSubview:alertView];
        _alertView = alertView;
        
        //config...
        /** 红色view*/
        UIView *redView = [[UIView alloc]init];
        redView.frame = CGRectMake(APPScreen_Width_Scale(15), APPScreen_Height_Scale(15), alertView.frame.size.width - 2*APPScreen_Width_Scale(15), alertView.frame.size.height - APPScreen_Height_Scale(15)-APPScreen_Width_Scale(45));
        //redView.backgroundColor = RGBCOLOR(218, 2, 2, 1);
        [_alertView addSubview:redView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, redView.frame.size.width, APPScreen_Width_Scale(35))];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:APPScreen_Width_Scale(16)];
        [redView addSubview:label];
        
        /** 选择背景View*/
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, _alertView.frame.size.height - APPScreen_Width_Scale(45), _alertView.frame.size.width, APPScreen_Width_Scale(45))];
        selectView.backgroundColor = [UIColor brownColor];
        [_alertView addSubview:selectView];
        /** 选择按钮*/
        CGFloat T = 0.5;    //间隙
        CGFloat Y = 0.5;
        CGFloat W = (selectView.frame.size.width-T*(itemTitle.count-1))/itemTitle.count;
        CGFloat H = selectView.frame.size.height-Y;

        for (int a = 0; a<itemTitle.count; a++) {
            CGFloat X = a*(W+T);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor whiteColor];
            button.frame = CGRectMake(X, Y, W, H);
            button.tag = a;
            [button setTitle:itemTitle[a] forState:UIControlStateNormal];
            [button setTitleColor:RGBCOLOR(50, 50, 50, 1) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            [selectView addSubview:button];
        }

        /** 计算文字*/
        CGSize size = [self labelAutoCalculateRectWith:content FontSize:APPScreen_Width_Scale(14) MaxSize:CGSizeMake(redView.frame.size.width, CGFLOAT_MAX)];
        /** textView的最大高度*/
        CGFloat height = MIN(size.height+25, 0.8*SCREEN_HEIGHT - CGRectGetMaxY(label.frame)-APPScreen_Height_Scale(35)-selectView.frame.size.height - 5);
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+5, redView.frame.size.width, height)];
        textView.font = [UIFont systemFontOfSize:APPScreen_Width_Scale(14)];
        textView.text = content;
        [redView addSubview:textView];
        NSLog(@"%f----%f----%f",CGRectGetMaxY(label.frame),height,selectView.frame.size.height);
        /** alertView最大高度 = 标题最大Y值+内容高度+确定按钮高度+2倍的边距*/
        CGFloat alertViewHeight = CGRectGetMaxY(label.frame)+5+height+selectView.frame.size.height+APPScreen_Height_Scale(15);
        _alertView.frame = CGRectMake(0, 0, 0.8*SCREEN_WIDTH, alertViewHeight);
        _alertView.center = _bgView.center;
        selectView.frame = CGRectMake(0, _alertView.frame.size.height - APPScreen_Width_Scale(45), _alertView.frame.size.width, APPScreen_Width_Scale(45));

    }
    return self;
}
#pragma -mark 默认提示框、垂直按钮
- (instancetype)initWithTitle:(NSString *)title
                  WithContent:(NSString *)content
                     delegate:(id<FQCustomAlertDelegate>)delegate
        WithVerticalItemTitle:(NSArray <NSString *>*)itemTitle{
    self = [super init];
    if (self) {
        _delegate = delegate;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        /** 半透明背景*/
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = RGBCOLOR(0, 0, 0, 0.3);
        [self addSubview:_bgView];
        
        /** 父控件view*/
        UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0.1*SCREEN_WIDTH, 0.1*SCREEN_HEIGHT, 0.8*SCREEN_WIDTH, 0.8*SCREEN_HEIGHT)];
        
        alertView.center = _bgView.center;
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 8.0;
        alertView.layer.masksToBounds = YES;
        [_bgView addSubview:alertView];
        _alertView = alertView;
        
        //config...
        /** 红色view*/
        UIView *redView = [[UIView alloc]init];
        redView.frame = CGRectMake(APPScreen_Width_Scale(15), APPScreen_Height_Scale(15), alertView.frame.size.width - 2*APPScreen_Width_Scale(15), alertView.frame.size.height - APPScreen_Height_Scale(15)-APPScreen_Width_Scale(45));
        //_redView.backgroundColor = RGBCOLOR(218, 2, 2, 1);
        [_alertView addSubview:redView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, redView.frame.size.width, APPScreen_Width_Scale(35))];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:APPScreen_Width_Scale(16)];
        [redView addSubview:label];
        
        CGFloat T = 0.5;    //间隙
        CGFloat selectViewHeight = itemTitle.count*(APPScreen_Width_Scale(45)+T);
        /** 选择背景View*/
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, _alertView.frame.size.height - selectViewHeight, _alertView.frame.size.width, selectViewHeight)];
        selectView.backgroundColor = [UIColor brownColor];
        [_alertView addSubview:selectView];
        /** 选择按钮*/
        CGFloat X = 0.0;
        CGFloat W = _alertView.frame.size.width;
        CGFloat H = APPScreen_Width_Scale(45);
        
        for (int a = 0; a<itemTitle.count; a++) {
            CGFloat Y = a*(H+T) + T;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor whiteColor];
            button.frame = CGRectMake(X, Y, W, H);
            button.tag = a;
            [button setTitle:itemTitle[a] forState:UIControlStateNormal];
            [button setTitleColor:RGBCOLOR(50, 50, 50, 1) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            [selectView addSubview:button];
        }
        
        /** 计算文字*/
        CGSize size = [self labelAutoCalculateRectWith:content FontSize:APPScreen_Width_Scale(14) MaxSize:CGSizeMake(alertView.frame.size.width - 2*APPScreen_Width_Scale(30), CGFLOAT_MAX)];
        /** 最大高度*/
        CGFloat height = MIN(size.height+25, 0.8*SCREEN_HEIGHT - CGRectGetMaxY(label.frame)-APPScreen_Height_Scale(35)-selectView.frame.size.height - 5);
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+5, redView.frame.size.width, height)];
        textView.font = [UIFont systemFontOfSize:APPScreen_Width_Scale(14)];
        textView.text = content;
        [redView addSubview:textView];
        NSLog(@"%f----%f----%f",CGRectGetMaxY(label.frame),height,selectView.frame.size.height);
        /** alertView最大高度 = 标题最大Y值+内容高度+确定按钮高度+2倍的边距*/
        CGFloat alertViewHeight = CGRectGetMaxY(label.frame)+5+height+selectView.frame.size.height+APPScreen_Height_Scale(15);
        _alertView.frame = CGRectMake(0, 0, 0.8*SCREEN_WIDTH, alertViewHeight);
        _alertView.center = _bgView.center;
        selectView.frame = CGRectMake(0, _alertView.frame.size.height - selectViewHeight, _alertView.frame.size.width, selectViewHeight);

    }
    return self;
}
#pragma -mark 带背景提示框
-(instancetype)initWithTitle:(NSString *)title
                 WithContent:(NSString *)content
               WithImageName:(NSString *)imageName
            WithSureBtnTitle:(NSString *)sureTitle{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        /** 半透明背景*/
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = RGBCOLOR(0, 0, 0, 0.3);
        [self addSubview:_bgView];
        
        /** 父控件view*/
        UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0.1*SCREEN_WIDTH, 0.1*SCREEN_HEIGHT, 0.8*SCREEN_WIDTH, 0.8*SCREEN_HEIGHT)];
        alertView.center = _bgView.center;
        //alertView.backgroundColor = [UIColor cyanColor];
        [_bgView addSubview:alertView];
        _alertView = alertView;
        
        //config...
        /** 红色view*/
        UIView *redView = [[UIView alloc]init];
        redView.frame = CGRectMake(APPScreen_Width_Scale(15), APPScreen_Height_Scale(15), alertView.frame.size.width - 2*APPScreen_Width_Scale(15), alertView.frame.size.height - 2*APPScreen_Height_Scale(15));
        redView.backgroundColor = RGBCOLOR(218, 2, 2, 1);
        redView.layer.cornerRadius = 6.0;
        redView.layer.masksToBounds = YES;
        [_alertView addSubview:redView];
        /** 背景图*/
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, redView.frame.origin.x+18, alertView.frame.size.width, alertView.frame.size.width/2.6)];
        imageV.image = [UIImage imageNamed:imageName];
        [alertView addSubview:imageV];
        /** 关闭按钮*/
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(alertView.frame.size.width- 30, 10, 30, 30);
        button.center = CGPointMake(CGRectGetMaxX(redView.frame), redView.frame.origin.y);
        button.tag = 0;
        [button setTitle:@"✖️" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:button];
        button.backgroundColor = RGBCOLOR(218, 2, 2, 1);
        button.layer.cornerRadius = 30/2;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [[UIColor whiteColor] CGColor];
        /** 计算文字*/
        CGSize size = [self labelAutoCalculateRectWith:content FontSize:APPScreen_Width_Scale(14) MaxSize:CGSizeMake(alertView.frame.size.width - 2*APPScreen_Width_Scale(30), CGFLOAT_MAX)];
        /** 最大高度*/
        CGFloat height = MIN(size.height+APPScreen_Height_Scale(15), 0.8*SCREEN_HEIGHT - CGRectGetMaxY(imageV.frame)-APPScreen_Height_Scale(35));
        /** 加载文字*/
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+5, redView.frame.size.width, height)];
        textView.font = [UIFont systemFontOfSize:APPScreen_Width_Scale(14)];
        textView.text = content;
        [redView addSubview:textView];
        
        NSLog(@"%f----%f",CGRectGetMaxY(imageV.frame),height);
        /** alertView最大高度 = 标题最大Y值+内容高度+确定按钮高度+2倍的边距*/
        CGFloat alertViewHeight = CGRectGetMaxY(imageV.frame)+5+height+2*APPScreen_Height_Scale(15);
        _alertView.frame = CGRectMake(0, 0, 0.8*SCREEN_WIDTH, alertViewHeight);
        _alertView.center = _bgView.center;
        redView.frame = CGRectMake(APPScreen_Width_Scale(15), APPScreen_Height_Scale(15), alertView.frame.size.width - 2*APPScreen_Width_Scale(15), alertView.frame.size.height - 2*APPScreen_Height_Scale(15));
    }
    return self;
}

#pragma -mark 列表选择弹框
-(FQCustomAlert * )initWithTitle:(NSString *)title
               WithContentString:(NSMutableArray <FQCustomModel *>*)contentArray
                   WithSureBlock:(SureActionBlock)sureBlock
                 WithCancelBlock:(CancelActionBlock)cancelBlock{
    self = [super init];
    if (self) {
        _dataSouseArray = contentArray;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        /** 半透明背景*/
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = RGBCOLOR(0, 0, 0, 0.3);
        [self addSubview:_bgView];
        
        /** 父控件view*/
        UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0.15*SCREEN_WIDTH, 0.15*SCREEN_HEIGHT, 0.7*SCREEN_WIDTH, 0.7*SCREEN_HEIGHT)];
        
        alertView.center = _bgView.center;
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 8.0;
        alertView.layer.masksToBounds = YES;
        [_bgView addSubview:alertView];
        _alertView = alertView;
        
        //config...
        /** 红色view*/
        UIView *redView = [[UIView alloc]init];
        redView.frame = CGRectMake(APPScreen_Width_Scale(15), APPScreen_Height_Scale(15), alertView.frame.size.width - 2*APPScreen_Width_Scale(15), alertView.frame.size.height - APPScreen_Height_Scale(15)-APPScreen_Width_Scale(45));
        //redView.backgroundColor = RGBCOLOR(218, 2, 2, 1);
        [_alertView addSubview:redView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, redView.frame.size.width, APPScreen_Width_Scale(35))];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:APPScreen_Width_Scale(16)];
        [redView addSubview:label];
        
        /** 选择背景View*/
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, _alertView.frame.size.height - APPScreen_Width_Scale(45), _alertView.frame.size.width, APPScreen_Width_Scale(45))];
        selectView.backgroundColor = [UIColor brownColor];
        [_alertView addSubview:selectView];
        /** 选择按钮*/
        CGFloat T = 0.5;    //间隙
        CGFloat Y = 0.5;
        CGFloat W = (selectView.frame.size.width-T*(2-1))/2;
        CGFloat H = selectView.frame.size.height-Y;
        
        for (int a = 0; a<2; a++) {
            CGFloat X = a*(W+T);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor whiteColor];
            button.frame = CGRectMake(X, Y, W, H);
            button.tag = a;
            if (a == 0) {
                [button setTitle:@"取消" forState:UIControlStateNormal];
            }else{
                [button setTitle:@"确定" forState:UIControlStateNormal];
            }
            [button setTitleColor:RGBCOLOR(50, 50, 50, 1) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectIndexButton:) forControlEvents:UIControlEventTouchUpInside];
            [selectView addSubview:button];
        }
        
        CGFloat maxHeight = MAX(contentArray.count*APPScreen_Height_Scale(35), 3*APPScreen_Height_Scale(35));
        
        CGFloat height = MIN(maxHeight, 6*APPScreen_Height_Scale(35));
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+5, redView.frame.size.width, height) style:UITableViewStylePlain];
        [redView addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//隐藏多余分割线
        _tableView.layer.cornerRadius = 3.0;// 设置圆角半径
        _tableView.layer.masksToBounds = YES;//设置圆角
        _tableView.layer.borderWidth = 0.8;
        _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        NSLog(@"%f----%f----%f",CGRectGetMaxY(label.frame),height,selectView.frame.size.height);
        /** alertView最大高度 = 标题最大Y值+内容高度+确定按钮高度+2倍的边距*/
        CGFloat alertViewHeight = CGRectGetMaxY(label.frame)+5+height+selectView.frame.size.height+APPScreen_Height_Scale(15);
        _alertView.frame = CGRectMake(0, 0, _alertView.frame.size.width, alertViewHeight+10);
        _alertView.center = _bgView.center;
        selectView.frame = CGRectMake(0, _alertView.frame.size.height - APPScreen_Width_Scale(45), _alertView.frame.size.width, APPScreen_Width_Scale(45));
        
        
        _sureActionBlock = sureBlock;
        _cancelActionBlock = cancelBlock;
    }
    return self;
}
#pragma mark - UITableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSouseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 定义cell标识
    NSString *CellIdentifier = @"FQCustomAlert";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化,当拉动页面显示超过主页面内容的时候就会重用之前的cell
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    FQCustomModel *model = self.dataSouseArray[indexPath.row];
    cell.textLabel.text = model.titles;
    if (model.isSelect) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;

}

#pragma mark - UITableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return APPScreen_Height_Scale(35);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击首页cell");
    [_dataSouseArray enumerateObjectsUsingBlock:^(FQCustomModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelect = NO;
    }];
    
    FQCustomModel *model = _dataSouseArray[indexPath.row];
    model.isSelect = !model.isSelect;
    self.selectModel = model;

    [_tableView reloadData];
}




- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[self class] animationAlert:_alertView];
}
- (void)dismiss{
    [self removeFromSuperview];
}

- (void)selectAction:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alert:withIndexButton:)]) {
        [self.delegate alert:self withIndexButton:btn];
    }
    [self dismiss];
}

-(void)selectIndexButton:(UIButton *)indexButton{
    if (indexButton.tag == 0) {
        [self dismiss];
    }else{
        self.sureActionBlock(self.selectModel);
        [self dismiss];
    }
}


+(void) animationAlert:(UIView *)view
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.6;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
    
}

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize{
    
    //    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //
    //    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    
    //    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine:attributes context:nil].size;
    CGSize labelSize = [text boundingRectWithSize:maxSize options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size;
    //    [paragraphStyle release];
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
