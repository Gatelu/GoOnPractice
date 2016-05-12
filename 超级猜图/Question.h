//
//  Question.h
//  超级猜图
//
//  Created by Gate on 15/12/23.
//  Copyright © 2015年 Gate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
@property (nonatomic ,copy) NSString *answer;
@property (nonatomic ,copy) NSString *icon;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,strong) NSArray *options;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)questionWithDict:(NSDictionary *)dict;


@end
