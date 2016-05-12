//
//  ViewController.m
//  超级猜图
//
//  Created by Gate on 15/12/23.
//  Copyright © 2015年 Gate. All rights reserved.
//

#import "ViewController.h"
#import "Question.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIButton *imgBtn;
@property (strong, nonatomic) IBOutlet UIButton *coinBtn;
@property (strong, nonatomic) UIButton *cover;
@property (strong, nonatomic) IBOutlet UIView *answerView;
@property (strong, nonatomic) IBOutlet UIView *optionView;

/**
 *  当前题目的序号
 */
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic ,assign) int index;

/**
 *  所有的题目
 */
@property (strong, nonatomic) NSArray *questions;
@end

@implementation ViewController
-(NSArray *)questions{
    if (_questions == nil) {
        //1.加载plist
        NSArray *dictArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
        
        //2.字典转模型
        NSMutableArray *questionArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArr) {
            Question *question = [Question questionWithDict:dict];
            [questionArray addObject:question];
        }
        //3.赋值
        _questions = questionArray;
    }
    return _questions;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.index = -1;
    [self next:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (IBAction)tip:(id)sender {
        for (UIButton *answerbtn in self.answerView.subviews) {
        [self answerBtnClick:answerbtn];
    }
    Question *question = self.questions[self.index];
    
    NSString *firstStr = [question.answer substringToIndex:1];
    for (UIButton *optionbtn in self.optionView.subviews) {
        if ([optionbtn.currentTitle isEqualToString:firstStr]) {
            optionbtn.hidden = YES;
            [self optionBtnClick:optionbtn];
        }
    }
    
    //扣分
    int score =  [self.coinBtn.currentTitle intValue];
    score -= 200;
    [self.coinBtn setTitle:[NSString stringWithFormat:@"%d",score] forState:UIControlStateNormal];
}
- (IBAction)help:(id)sender {
}
- (IBAction)img:(id)sender {
    _cover.alpha = 0.0;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    _cover = [[UIButton alloc] initWithFrame:self.view.bounds];
    [_cover addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    _cover.backgroundColor = [UIColor blackColor];
    _cover.alpha = 0.5;
    [self.view addSubview:_cover];
    [self.view bringSubviewToFront:self.imgBtn];
    
    
    self.imgBtn.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.width);
    [UIView commitAnimations];
}
- (IBAction)next:(id)sender {
    if (self.index == self.questions.count - 1) {
        return;
    }

    self.optionView.userInteractionEnabled = YES;

    self.index ++;
    Question *question = self.questions[_index];
    self.numLabel.text = [NSString stringWithFormat:@"%d/%lu",_index + 1,(unsigned long)self.questions.count];
    self.tipLabel.text = question.title;
    [self.imgBtn setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    self.nextBtn.enabled = self.index != self.questions.count - 1;
    //删除之前的子视图
//    for (UIView *subView in self.answerView.subviews) {
//        [subView removeFromSuperview];
//    }
    //与上面for循环作用一致
    //让数组中所有元素都执行selector的方法
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int length = (int)question.answer.length;
    for (int i = 0; i < length; i ++) {
        CGFloat margin = 10;
        CGFloat viewW = self.view.frame.size.width;
        CGFloat leftMargin = (viewW - length*35 - margin *(length - 1) )*0.5;
        CGFloat buttonX = leftMargin + i*45;
        UIButton *answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 0, 35, 35)];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateNormal];
        [self.answerView addSubview:answerBtn];
        [answerBtn addTarget:self action:@selector(answerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //添加待选按钮
    for (UIView *subView in self.optionView.subviews) {
        [subView removeFromSuperview];
    }
    int count = (int)question.options.count;
    for (int i = 0; i < count; i ++) {
        //列号
        int col = i%7;
        int row = i/7;
        CGFloat margin = 10;
        CGFloat viewW = self.view.frame.size.width;
        CGFloat leftMargin = (viewW - 7 * 35 - margin * (7 - 1) )*0.5;
        CGFloat optionBtnX = leftMargin + col *45;
        CGFloat optionBtnY = row *45;

        UIButton *optionBtn = [[UIButton alloc] initWithFrame:CGRectMake(optionBtnX, optionBtnY, 35, 35)];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateNormal];
        [optionBtn setTitle:question.options[i] forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.optionView addSubview:optionBtn];
        [optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSLog(@"=============%d",1/7);
}
- (void)optionBtnClick:(UIButton *)optionBtn{
    optionBtn.hidden = YES;
    for (UIButton *answerBtn in self.answerView.subviews) {
        NSString *answerBtnTitle = [answerBtn titleForState:UIControlStateNormal];
        if (answerBtnTitle == 0) {//说明没有文字
            [answerBtn setTitle:[optionBtn titleForState:UIControlStateNormal] forState:UIControlStateNormal];
            break;
        }
    }
    //判断答案正确性
    BOOL full = YES;
    NSMutableString *tempStr = [NSMutableString string];
    for (UIButton *answerBtn in self.answerView.subviews) {
        NSString *answerBtnTitle = [answerBtn titleForState:UIControlStateNormal];
        if (answerBtnTitle == 0) {//说明没有文字
            full = NO;
            break;
        }
        [tempStr appendString:answerBtnTitle];
    }
    if (full == YES) {//答案满了
        self.optionView.userInteractionEnabled = NO;
        
        Question *question = self.questions[self.index];
        if ([tempStr isEqualToString:question.answer]) {
            //答对了
            NSLog(@"答对了");
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            int score =  [self.coinBtn.currentTitle intValue];
            score += 200;
            [self.coinBtn setTitle:[NSString stringWithFormat:@"%d",score] forState:UIControlStateNormal];
            [self performSelector:@selector(next:) withObject:nil afterDelay:0.5];
        }else{
            //打错了
            for (UIButton *answerBtn  in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
    
}
- (void)answerBtnClick:(UIButton *)answerBtn{
  self.optionView.userInteractionEnabled = YES;
    for (UIButton *optionBtn in self.optionView.subviews) {
        if ([[answerBtn titleForState:UIControlStateNormal] isEqualToString:[optionBtn titleForState:UIControlStateNormal]] && optionBtn.hidden == YES) {
            optionBtn.hidden = NO;
            break;
        }
    }
    //在比较文字之后  才能设置answerBtn的文字nil
    [answerBtn setTitle:nil forState:UIControlStateNormal];
    
    
    for (UIButton *answerBtn in self.answerView.subviews) {
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
- (IBAction)imgBtn:(id)sender {
    
    if (self.cover == nil) {
        
        [self img:nil];
    }else{
        [self cancel];
    }

    
}
- (void)cancel{
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1];
//    self.imgBtn.frame = CGRectMake(85, 86, 150, 150);
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(removeCover)];
//    self.cover.alpha = 0.0;
//    [UIView commitAnimations];
    [UIView animateWithDuration:1.0 animations:^{
        self.imgBtn.frame = CGRectMake(85, 86, 150, 150);
        self.cover.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_cover removeFromSuperview];
        self.cover = nil;
    }];
    
}
//- (void)removeCover{
//    [_cover removeFromSuperview];
//    self.cover = nil;
//}
@end
