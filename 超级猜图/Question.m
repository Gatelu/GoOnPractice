//
//  Question.m
//  超级猜图
//
//  Created by Gate on 15/12/23.
//  Copyright © 2015年 Gate. All rights reserved.
//

#import "Question.h"

@implementation Question
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self == [super init]) {
        self.icon = dict[@"icon"];
        self.answer = dict[@"answer"];
        self.title = dict[@"title"];
        self.options = dict[@"options"];
    }
    return self;
}
+ (instancetype)questionWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
