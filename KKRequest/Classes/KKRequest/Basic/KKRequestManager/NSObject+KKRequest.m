//
//  NSObject+KKRequest.m
//  P2CSumauhon
//
//  Created by liubo on 2022/4/9.
//  Copyright © 2022 ts. All rights reserved.
//

#import "NSObject+KKRequest.h"
#import <objc/runtime.h>

@implementation NSObject (KKRequest)

#pragma mark ==================================================
#pragma mark == KKRequest Notification
#pragma mark ==================================================
- (void)observeKKRequestNotification:(NSString *)notificationName {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kkRequestFinishedPrivateNotification:)
                                                 name:notificationName
                                               object:nil];
}

- (void)unobserveKKRequestNotification:(NSString *)notificationName {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];
}

- (void)kkRequestFinishedPrivateNotification:(NSNotification*)notice{
    
    NSDictionary *dictionaryPost = notice.object;
    KKFormRequest *formRequest = [dictionaryPost objectForKey:@"formRequest"];
    NSDictionary *aRequestResult = [dictionaryPost objectForKey:@"requestResult"];
    NSDictionary *aHttpInfomation = [dictionaryPost objectForKey:@"httpInfomation"];
    NSString *requestIdentifier = [dictionaryPost objectForKey:@"requestIdentifier"];
    
    KKRequestTarget *requestTarget = (KKRequestTarget*)formRequest.requestTarget;
    NSString *notificationName = [NSString stringWithFormat:@"%@_%@_%@",requestTarget.target_name,requestTarget.target_address,requestTarget.kkRequestIdentifier];
    [self unobserveKKRequestNotification:notificationName];

    [self KKRequestDidFinished:formRequest requestResult:aRequestResult httpInfomation:aHttpInfomation requestIdentifier:requestIdentifier];
}


- (void)KKRequestDidFinished:(KKFormRequest*_Nonnull)aFormRequest
               requestResult:(NSDictionary*_Nullable)aRequestResult
              httpInfomation:(NSDictionary*_Nullable)aHttpInfomation
           requestIdentifier:(NSString*_Nullable)aRequestIdentifier{
    
}


@end

