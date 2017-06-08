//
//  QuestionModel.h
//  猜题游戏
//
//  Created by jiangwei18 on 17/6/8.
//  Copyright © 2017年 jiangwei18. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject
@property(nonatomic, copy)NSString* answer;
@property(nonatomic, copy)NSString* icon;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, strong)NSArray* options;
- (instancetype)initWithDict:(NSDictionary*)dict;

+ (instancetype)modelWith:(NSDictionary*)dict;

@end
