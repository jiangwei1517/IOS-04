//
//  ViewController.m
//  猜题游戏
//
//  Created by jiangwei18 on 17/6/8.
//  Copyright © 2017年 jiangwei18. All rights reserved.
//

#import "ViewController.h"
#import "QuestionModel.h"

@interface ViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *iv;
@property (weak, nonatomic) IBOutlet UILabel *titlej;
@property (weak, nonatomic) IBOutlet UILabel *mIndex;
- (IBAction)mNextImg:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *mBtnNext;
@property(nonatomic, assign)int index;
@property (weak, nonatomic) IBOutlet UIView *mAnswerView;
@property (weak, nonatomic) IBOutlet UIView *mOptionView;
- (IBAction)mBigImage:(UIButton *)sender;
- (IBAction)ivClick:(UIButton *)sender;

@property(nonatomic, strong)NSArray* questions;
@property(nonatomic, weak)UIButton* mBackBtn;
@property(nonatomic, assign)CGRect mFrame;
@property(nonatomic, assign)BOOL isBigImage;

@property(nonatomic, copy)NSString* curAnswer;
@end

@implementation ViewController

- (IBAction)mNextImg:(UIButton *)sender {
    [self goToNextImg];
}

- (void)goToNextImg {
    self.index++;
    QuestionModel* model = self.questions[self.index];
    [self.iv setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    self.mIndex.text = [NSString stringWithFormat:@"%d/%lu", self.index+1, self.questions.count];
    self.titlej.text = model.title;
    if (self.index == self.questions.count - 1) {
        self.mBtnNext.enabled = NO;
    }
    [self.mAnswerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self generateAnswerBtn:model];
    [self generateOptionView:model];
    self.curAnswer = model.answer;
    [self.mOptionView setUserInteractionEnabled:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"cancel");
    }
}

- (IBAction)mBigImage:(UIButton *)sender {
    [self bigImage];
}

- (IBAction)ivClick:(UIButton *)sender {
    if (self.isBigImage) {
        [self smallImg];
    } else {
        [self bigImage];
    }
}

- (void)bigImage {
    self.isBigImage = YES;
    // 1 设置阴影
    UIButton *coverView = [UIButton new];
    self.mBackBtn = coverView;
    coverView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [coverView setBackgroundColor:[UIColor blackColor]];
    coverView.alpha = 0.0;
    [self.view addSubview:coverView];
    // 2大图提前
    [UIView animateWithDuration:1 animations:^{
        coverView.alpha = 0.5;
        self.iv.frame = CGRectMake(0, (self.view.frame.size.height-300)/2, 375, 300);
        [self.view bringSubviewToFront:self.iv];
    }];
    [coverView addTarget:self action:@selector(smallImg) forControlEvents:UIControlEventTouchUpInside];
}

- (void)smallImg {
    self.isBigImage = NO;
    if (self.mBackBtn != nil) {
        [UIView animateWithDuration:1 animations:^{
            self.mBackBtn.alpha = 0;
             self.iv.frame = self.mFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.mBackBtn removeFromSuperview];
            }
        }];
    }
}

- (NSArray *)questions {
    if (_questions == nil) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@".plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray* newQuestions = [NSMutableArray new];
        for (NSDictionary* dict in array) {
            QuestionModel* model = [QuestionModel modelWith:dict];
            [newQuestions addObject:model];
        }
        _questions = newQuestions;
    }
    return _questions;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    QuestionModel* model = self.questions[0];
    [self.iv setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    [self.titlej setText:model.title];
    self.mIndex.text = [NSString stringWithFormat:@"%d/%lu", self.index+1, self.questions.count];
    self.mFrame = self.iv.frame;
    [self generateAnswerBtn:model];
    [self generateOptionView:model];
    self.curAnswer = model.answer;
}

- (void)generateAnswerBtn:(QuestionModel*)model {
    NSUInteger len = model.answer.length;
    for (int i = 0;i < len;i++) {
        int margin = 10;
        int width = 35;
        int height = 35;
        UIButton* btnAnswer = [UIButton new];
        [btnAnswer setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [btnAnswer setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:
         UIControlStateHighlighted];
        [btnAnswer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnAnswer setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        int marginLeft = (self.view.frame.size.width - len*width-(len - 1)*margin)/2;
        int marginTop = (self.mAnswerView.frame.size.height-height)/2;
        btnAnswer.frame = CGRectMake(marginLeft+i*(width+margin), marginTop, width, height);
        [btnAnswer addTarget:self action:@selector(resume:) forControlEvents:UIControlEventTouchUpInside];
        [self.mAnswerView addSubview:btnAnswer];
    }
}

- (void)resume:(UIButton*)sender {
    if (sender.currentTitle != nil) {
        [sender setTitle:nil forState:UIControlStateNormal];
        [self.mOptionView setUserInteractionEnabled:YES];
    }
    for (UIButton* btn in self.mOptionView.subviews) {
        if (btn.tag == sender.tag) {
            btn.hidden = NO;
        }
    }
}

- (void)generateOptionView:(QuestionModel*)model {
    NSArray* optionArray = model.options;
    int rowNums = 7;
    for (int i = 0;i<optionArray.count;i++) {
        NSString* s = optionArray[i];
        int margin = 10;
        int width = 35;
        int height = 35;
        UIButton* optionBtn = [UIButton new];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        int marginLeft = (self.view.frame.size.width - rowNums*width-(rowNums - 1)*margin)/2;
        int marginTop = 10;
        optionBtn.frame = CGRectMake(marginLeft+(i%7)*(width+margin), marginTop+(i/7)*(height+margin), width, height);
        [optionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [optionBtn setTitle:s forState:UIControlStateNormal];
        [optionBtn setTitle:s forState:UIControlStateHighlighted];
        optionBtn.tag = i;
        [optionBtn addTarget:self action:@selector(clickOptionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mOptionView addSubview:optionBtn];
    }
}

- (void)clickOptionBtn:(UIButton*)sender {
    BOOL isFull = NO;
    for (UIButton* btn in self.mAnswerView.subviews) {
        if (btn.currentTitle == nil) {
            [btn setTitle:sender.currentTitle forState:UIControlStateNormal];
            btn.tag = sender.tag;
            isFull = NO;
            break;
        } else {
            isFull = YES;
        }
    }
    if (isFull) {
        sender.hidden = NO;
        [self.mOptionView setUserInteractionEnabled:NO];
        NSMutableString* answer = [NSMutableString new];
        for (UIButton* btn in self.mAnswerView.subviews) {
            [answer appendString:btn.currentTitle];
        }
        if ([answer isEqualToString:self.curAnswer]) {
            for (UIButton* btn in self.mAnswerView.subviews) {
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            if (self.index == self.questions.count-1) {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"成功了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"再接再厉", nil];
                [alertView show];
            }else{
               [self performSelector:@selector(goToNextImg) withObject:nil afterDelay:1.5];
            }
        } else {
            for (UIButton* btn in self.mAnswerView.subviews) {
                [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
        }
    }else{
        sender.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
