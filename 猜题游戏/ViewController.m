//
//  ViewController.m
//  猜题游戏
//
//  Created by jiangwei18 on 17/6/8.
//  Copyright © 2017年 jiangwei18. All rights reserved.
//

#import "ViewController.h"
#import "QuestionModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *iv;
@property (weak, nonatomic) IBOutlet UILabel *titlej;
@property (weak, nonatomic) IBOutlet UILabel *mIndex;
- (IBAction)mNextImg:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *mBtnNext;
@property(nonatomic, assign)int index;
- (IBAction)mBigImage:(UIButton *)sender;

@property(nonatomic, strong)NSArray* questions;
@property(nonatomic, weak)UIButton* mBackBtn;
@property(nonatomic, assign)CGRect mFrame;
@end

@implementation ViewController

- (IBAction)mNextImg:(UIButton *)sender {
    self.index++;
    QuestionModel* model = self.questions[self.index];
    [self.iv setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    self.mIndex.text = [NSString stringWithFormat:@"%d/%lu", self.index+1, self.questions.count];
    self.titlej.text = model.title;
    if (self.index == self.questions.count - 1) {
        self.mBtnNext.enabled = NO;
    }
}

- (IBAction)mBigImage:(UIButton *)sender {
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
