//
//  KKRequestSender_Demo.m
//  KKRequestDemo
//
//  Created by edward lannister on 2022/08/15.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "KKRequestSender_Demo.h"

@implementation KKRequestSender_Demo

+ (KKRequestSender_Demo *)defaultManager{
    static KKRequestSender_Demo *KKRequestSender_Demo_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKRequestSender_Demo_default = [[self alloc] init];
    });
    return KKRequestSender_Demo_default;
}

- (KKRequestParam*)getUserList{
    KKRequestParam_Demo *requestParam = [[KKRequestParam_Demo alloc] init];
    NSString *urlStr = @"/app/userList";
    requestParam.urlString = [KKRequestParam_Demo requestURLForInterface:urlStr];
    requestParam.identifier = kCMD_User_GetUserList;
    
    [requestParam addParam:@"req" withValue:@"xxx"];
    
    return requestParam;
}

@end
