//
//  QuestionModel.m
//  猜题游戏
//
//  Created by jiangwei18 on 17/6/8.
//  Copyright © 2017年 jiangwei18. All rights reserved.
//

#import "QuestionModel.h"

@interface QuestionModel()

@end

@implementation QuestionModel
- (instancetype)initWithDict:(NSDictionary*)dict{
    if ([super init]) {
        self.answer = dict[@"answer"];
        self.icon = dict[@"icon"];
        self.title = dict[@"title"];
        self.options = dict[@"options"];
    }
    return self;
}

+ (instancetype)modelWith:(NSDictionary*)dict{
    return [[QuestionModel alloc]initWithDict:dict];
}
@end
