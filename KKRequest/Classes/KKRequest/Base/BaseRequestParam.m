//
//  BaseRequestParam.m
//  PropertyManage
//
//  Created by liubo on 15/8/5.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "BaseRequestParam.h"

@implementation BaseRequestParam

- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}


//+ (NSString*)requestURLForInterface:(NSString*)interface{
//    if ([ServerAddress hasSuffix:@"/"] && [interface hasPrefix:@"/"]) {
//        NSString *tail = [interface substringFromIndex:1];
//        return [NSString stringWithFormat:@"%@%@",ServerAddress,tail];
//    }
//    else if ((![ServerAddress hasSuffix:@"/"]) && (![interface hasPrefix:@"/"])){
//        return [NSString stringWithFormat:@"%@/%@",ServerAddress,interface];
//    }
//    else{
//        return [NSString stringWithFormat:@"%@%@",ServerAddress,interface];
//    }
//}
//
//+ (NSString*)serverAddress{
//    return @"http://p2c-dev.msops.top";
//}

@end
