//
//  AnimationTestVC.m
//  AnimationAPI
//
//  Created by 冯攀 on 2020/1/19.
//  Copyright © 2020 fengpan. All rights reserved.
//

#import "AnimationTestVC.h"
#import "FQCustomAlert.h"
#import "FQCustomModel.h"

@interface AnimationTestVC ()<FQCustomAlertDelegate>

@property (nonatomic, strong) NSMutableArray <FQCustomModel *> *souseArray;

@property (nonatomic, assign) int index;

@end

@implementation AnimationTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 0;
    
}

-(NSMutableArray<FQCustomModel *> *)souseArray{
    if (!_souseArray) {
        _souseArray = [[NSMutableArray alloc]init];
        
        for (int a = 0; a < 20; a++) {
            FQCustomModel *model = [[FQCustomModel alloc] init];
            model.titles = [NSString stringWithFormat:@"请选择标题---%d",a];
            [_souseArray addObject:model];
        }
    }
    return _souseArray;
}

- (IBAction)show:(UIButton *)sender {
    self.index++;
    
    if (self.index%4 == 0) {
        FQCustomAlert *alertView = [[FQCustomAlert alloc]initWithTitle:@"选择" WithContentString:self.souseArray WithSureBlock:^(FQCustomModel * _Nonnull model) {
            NSLog(@"点击了------------%@",model.titles);
        } WithCancelBlock:^(NSString * _Nonnull title) {
            
        }];
        [alertView show];
        
    }else if (self.index%4 == 1){
        FQCustomAlert *alertView = [[FQCustomAlert alloc]initWithTitle:@"规则说明" WithContent:@"系统将随机从题库中抽取一套题，其中有单选、多选类型题目，请您认真审题后选出您认为正确的选项，系统将随机从题库中抽取一套题，其中有单选、多选类型题目，请您认真审题后选出您认为正确的选项" delegate:self WithHorizontalItemTitle:@[@"取消",@"确定"]];
        [alertView show];
        
        
    }else if (self.index%4 == 2){
        FQCustomAlert *alertView = [[FQCustomAlert alloc]initWithTitle:@"规则说明" WithContent:@"系统将随机从题库中抽取一套题，其中有单选、多选类型题目，请您认真审题后选出您认为正确的选项，系统将随机从题库中抽取一套题，其中有单选、多选类型题目，请您认真审题后选出您认为正确的选项" delegate:self WithVerticalItemTitle:@[@"取消",@"确定",@"提交"]];
        [alertView show];
        
        
    }else if (self.index%4 == 3){
        FQCustomAlert *alertView = [[FQCustomAlert alloc]initWithTitle:@"规则说明" WithContent:@"系统将随机从题库中抽取一套题，其中有单选、多选类型题目，请您认真审题后选出您认为正确的选项，系统将随机从题库中抽取一套题，其中有单选、多选类型题目，请您认真审题后选出您认为正确的选项" WithImageName:@"activity_cloud" WithSureBtnTitle:@"AAA"];
        [alertView show];
        
    }
    
}


- (void)alert:(FQCustomAlert *)alert withIndexButton:(UIButton *)button{
    NSLog(@"已经点击----%ld",button.tag);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
