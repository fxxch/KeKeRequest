//
//  KKRequestParam_Demo.m
//  KKRequestDemo
//
//  Created by edward lannister on 2022/08/15.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "KKRequestParam_Demo.h"

@implementation KKRequestParam_Demo

+ (NSString*)requestURLForInterface:(NSString*)interface{
    if ([ServerAddress hasSuffix:@"/"] && [interface hasPrefix:@"/"]) {
        NSString *tail = [interface substringFromIndex:1];
        return [NSString stringWithFormat:@"%@%@",ServerAddress,tail];
    }
    else if ((![ServerAddress hasSuffix:@"/"]) && (![interface hasPrefix:@"/"])){
        return [NSString stringWithFormat:@"%@/%@",ServerAddress,interface];
    }
    else{
        return [NSString stringWithFormat:@"%@%@",ServerAddress,interface];
    }
}

+ (NSString*)serverAddress{
    return @"http://p2c-dev.msops.top";
}

@end
