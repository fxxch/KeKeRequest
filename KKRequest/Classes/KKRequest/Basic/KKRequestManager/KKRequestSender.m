//
//  KKRequestSender.m
//  Lib_Base
//
//  Created by edward lannister on 2022/04/13.
//  Copyright © 2022 ts. All rights reserved.
//

#import "KKRequestSender.h"
#import "KKRequestManager.h"
#import "KKFormRequest.h"
#import "KKRequestTarget.h"
#import "KKRequestParam.h"
#import "NSObject+KKRequest.h"

@implementation KKRequestSender

#pragma mark ==================================================
#pragma mark == SendRequest
#pragma mark ==================================================
- (void)kk_SendRequestWithParam:(KKRequestParam*_Nullable)aRequestParam
                         target:(id _Nullable)aTarget{
    [self kk_SendRequestWithParam:aRequestParam target:(id)aTarget finished:nil];
}

- (void)kk_SendRequestWithParam:(KKRequestParam*_Nullable)aRequestParam
                         target:(id _Nullable)aTarget
                       finished:(KKRequestFinishedBlock _Nullable )finished{
    if (aRequestParam==nil) {
        return;
    }

    NSString *class_Name = NSStringFromClass([aTarget class]);
    if (class_Name==nil) {
        class_Name = @"classNull";
    }
    NSString *object_address = [NSString stringWithFormat:@"%p",aTarget];
    if (object_address==nil) {
        object_address = @"addressNull";
    }

    KKRequestTarget *requestTarget = [[KKRequestTarget alloc] init];
    requestTarget.target_name = class_Name;
    requestTarget.target_address = object_address;
    requestTarget.kkRequestIdentifier = aRequestParam.identifier;
    requestTarget.kkRequestFinishedBlock = finished;
    requestTarget.kkTarget = aTarget;
    
    NSString *notificationName = [NSString stringWithFormat:@"%@_%@_%@",requestTarget.target_name,requestTarget.target_address,requestTarget.kkRequestIdentifier];
    [aTarget observeKKRequestNotification:notificationName];

    [KKRequestManager addRequestWithParam:aRequestParam requestTarget:requestTarget requestSender:self];
}

#pragma mark ==================================================
#pragma mark == Received Request Response
#pragma mark ==================================================
- (void)kk_SenderProcessResultFinished:(KKFormRequest*)aFormRequest
                         requestResult:(NSDictionary*)aRequestResult
                        httpInfomation:(NSDictionary*)aHttpInfomation
                     requestIdentifier:(NSString*)aRequestIdentifier{
    
    KKRequestTarget *requestTarget = (KKRequestTarget*)aFormRequest.requestTarget;
    if (requestTarget.kkRequestFinishedBlock) {
        requestTarget.kkRequestFinishedBlock(aFormRequest,
                                              aRequestResult,
                                              aHttpInfomation,
                                              aRequestIdentifier);
    }
    else{
        KKRequestTarget *requestTarget = (KKRequestTarget*)aFormRequest.requestTarget;
        NSString *notificationName = [NSString stringWithFormat:@"%@_%@_%@",requestTarget.target_name,requestTarget.target_address,requestTarget.kkRequestIdentifier];
        
        NSMutableDictionary *dictionaryPost = [NSMutableDictionary dictionary];
        if (aFormRequest) {
            [dictionaryPost setObject:aFormRequest forKey:@"formRequest"];
        }
        if (aRequestResult) {
            [dictionaryPost setObject:aRequestResult forKey:@"requestResult"];
        }
        if (aHttpInfomation) {
            [dictionaryPost setObject:aHttpInfomation forKey:@"httpInfomation"];
        }
        if (aRequestIdentifier) {
            [dictionaryPost setObject:aRequestIdentifier forKey:@"requestIdentifier"];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:dictionaryPost];
    }
    
    
}

@end
