//
//  HomeViewController.m
//  KKRequestDemo
//
//  Created by edward lannister on 2022/08/15.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "HomeViewController.h"
#import "KKRequestSender_Demo.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KKRequestDemo";
    
    KKRequestParam *requestParam = [KKRequestSender_Demo.defaultManager getUserList];
    //方式一 （Block回调，下面的方法不会回调）
    [KKRequestSender_Demo.defaultManager kk_SendRequestWithParam:requestParam target:self finished:^(KKFormRequest * _Nonnull aFormRequest, NSDictionary * _Nullable aRequestResult, NSDictionary * _Nullable aHttpInfomation, NSString * _Nullable aRequestIdentifier) {
        
    }];
    
    //方式二 (回调在下面的方法里)
    [KKRequestSender_Demo.defaultManager kk_SendRequestWithParam:requestParam target:self];
}

#pragma mark ==================================================
#pragma mark == Network: Request Result
#pragma mark ==================================================
- (void)KKRequestDidFinished:(KKFormRequest *)aFormRequest
               requestResult:(NSDictionary *)aRequestResult
              httpInfomation:(NSDictionary *)aHttpInfomation
           requestIdentifier:(NSString *)aRequestIdentifier{
    
    if ([aRequestIdentifier isEqualToString:kCMD_User_GetUserList]) {
        

    }

}

@end
