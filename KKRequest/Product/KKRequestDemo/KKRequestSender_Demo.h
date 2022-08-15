//
//  KKRequestSender_Demo.h
//  KKRequestDemo
//
//  Created by edward lannister on 2022/08/15.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKRequestParam_Demo.h"

#define kCMD_User_GetUserList @"CMD_User_GetUserList"

@interface KKRequestSender_Demo : KKRequestSender

+ (KKRequestSender_Demo*)defaultManager;

- (KKRequestParam*)getUserList;

@end
