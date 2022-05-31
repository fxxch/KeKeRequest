//
//  KKRequestManager.m
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKRequestManager.h"
#import "KKNetWorkObserver.h"
#import "KKFormRequest.h"
#import "KKRequestParam.h"
#import "KKRequestTarget.h"
#import "AFNetworking.h"
#import "KKRequestSender.h"

#ifdef DEBUG
#define NSLog(format,...) printf("%s",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#endif

@interface KKRequestManager ()<KKFormRequestDelegate>

@property(nonatomic,strong)NSMutableArray *requestList;

@end

@implementation KKRequestManager

+ (KKRequestManager *)defaultManager{
    static KKRequestManager *defaultManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

- (id)init{
    self = [super init];
    if (self) {
        self.requestList = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == add Request
#pragma mark ==================================================
+ (void)addRequestWithParam:(KKRequestParam *)param requestTarget:(KKRequestTarget *)requestTarget requestSender:(KKRequestSender*)aRequestSender{
    [[KKRequestManager defaultManager] sendRequestWithParam:param requestTarget:requestTarget requestSender:aRequestSender];
}

- (void)sendRequestWithParam:(KKRequestParam *)param requestTarget:(KKRequestTarget *)requestTarget requestSender:(KKRequestSender*)aRequestSender{
    if ([KKNetWorkObserver sharedInstance].status != KKNotReachable) {
        if (!(param && requestTarget)) {
            return ;
        }
        
        [self clearRequestWithIdentifier:param.identifier];

        [param kk_CheckHeader_application_json];
        KKFormRequest *newFormRequest = [[KKFormRequest alloc] init];
        [newFormRequest setDelegate:self];
        [newFormRequest startRequestWithParam:param
                                requestTarget:requestTarget
                                requestSender:aRequestSender];
        [self.requestList addObject:newFormRequest];
    }
    else{
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        if (param && [param isKindOfClass:[KKRequestParam class]]) {
            [dictionary setObject:param forKey:@"KKRequestParam"];
        }
        if (requestTarget && [requestTarget isKindOfClass:[KKRequestTarget class]]) {
            [dictionary setObject:requestTarget forKey:@"KKRequestTarget"];
        }
        if (aRequestSender && [aRequestSender isKindOfClass:[KKRequestSender class]]) {
            [dictionary setObject:aRequestSender forKey:@"KKRequestSender"];
        }

        [self performSelector:@selector(requestCannotSendWhenNotHaveNetwork:) withObject:dictionary afterDelay:0.5];
    }
}

- (void)cancelRequest:(NSString*)indentifier{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:self.requestList];
    [self.requestList removeAllObjects];
    for (NSInteger i=0; i<[tempArray count]; i++) {
        KKFormRequest *tmpRequest = [tempArray objectAtIndex:i];
        if ([tmpRequest.requestParam.identifier isEqualToString:indentifier]) {
            [tmpRequest clearDelegatesAndCancel];
            continue;
        }
        else{
            [self.requestList addObject:tmpRequest];
        }
    }
}

- (void)requestCannotSendWhenNotHaveNetwork:(NSDictionary*)aInformation{
    KKRequestParam *param = [aInformation objectForKey:@"KKRequestParam"];
    KKRequestTarget *requestTarget = [aInformation objectForKey:@"KKRequestTarget"];
    KKRequestSender *requestSender = [aInformation objectForKey:@"KKRequestSender"];

    [param kk_CheckHeader_application_json];
    KKFormRequest *newFormRequest = [[KKFormRequest alloc] init];
    [newFormRequest setDelegate:self];
    [newFormRequest setRequestWithParam:param
                          requestTarget:requestTarget
                          requestSender:requestSender];
    
    [self processRequestFinished:newFormRequest result:nil httpResponse:nil error:nil isNetworkOK:NO];
}

#pragma mark ==================================================
#pragma mark == KKFormRequestDelegate
#pragma mark ==================================================
- (void)requestFinished:(KKFormRequest *)request result:(id)responseObject httpResponse:(NSURLResponse*)response error:(NSError*)aError{
    
    [self processRequestFinished:request result:responseObject httpResponse:response error:aError isNetworkOK:YES];
}

- (void)requestFailed:(KKFormRequest *)request result:(id)responseObject httpResponse:(NSURLResponse*)response error:(NSError*)aError{

    [self processRequestFinished:request result:responseObject httpResponse:response error:aError isNetworkOK:YES];
}

- (void)processRequestFinished:(KKFormRequest*)formRequest
                        result:(id)responseObject
                  httpResponse:(NSURLResponse*)response
                         error:(NSError*)aError
                   isNetworkOK:(BOOL)networkOK
{
    if (networkOK) {
        NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
        if ([responseObject isKindOfClass:[NSString class]]) {
            NSDictionary *dic= [self kkrequest_dictionaryFromJSONString:(NSString*)responseObject];
            if (dic && [dic isKindOfClass:[NSDictionary class]] && [dic count]>0) {
                [resultDictionary setValuesForKeysWithDictionary:dic];
            }
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]]){
            [resultDictionary setValuesForKeysWithDictionary:(NSDictionary*)responseObject];
        }
        else if ([responseObject isKindOfClass:[NSData class]]) {
            NSDictionary *dic= [self kkrequest_dictionaryFromJSONData:(NSData*)responseObject];
            if (dic && [dic isKindOfClass:[NSDictionary class]] && [dic count]>0) {
                [resultDictionary setValuesForKeysWithDictionary:dic];
            }
        }
        else{
            
        }

        if (aError) {
            #ifdef DEBUG
            if (KKFormRequest_IsOpenLog) {
                KKRequestTarget *requestTarget = (KKRequestTarget*)formRequest.requestTarget;
                NSString *notificationName = [NSString stringWithFormat:@"%@_%@_%@",requestTarget.target_name,requestTarget.target_address,requestTarget.kkRequestIdentifier];
                NSLog(@"❌❌❌★★★★★★★★★★Request Finished <Failed>: %@ \n %@ \n",notificationName,aError.localizedDescription);
            }
            #endif
            
            // httpInfomation
            NSHTTPURLResponse * mResponse = (NSHTTPURLResponse *)response;
            NSString *statusCode = [NSString stringWithFormat:@"%ld", (long)[mResponse statusCode]];
            NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
            [httpInfomation setObject:formRequest.requestParam.urlString forKey:httpResultURLKey];
            [httpInfomation setObject:[NSString stringWithFormat:@"%ld",(long)aError.code] forKey:httpErrorCodeKey];
            [httpInfomation setObject:[NSString stringWithFormat:@"%@",aError.localizedDescription] forKey:httpErrorMessageKey];
            [httpInfomation setObject:statusCode forKey:httpResultCodeKey];
            [httpInfomation setObject:@"failed" forKey:httpResultMessageKey];
            
            [formRequest.requestSender kk_SenderProcessResultFinished:formRequest requestResult:resultDictionary httpInfomation:httpInfomation requestIdentifier:formRequest.requestParam.identifier];
        }
        else{
            #ifdef DEBUG
            if (KKFormRequest_IsOpenLog) {
                KKRequestTarget *requestTarget = (KKRequestTarget*)formRequest.requestTarget;
                NSString *notificationName = [NSString stringWithFormat:@"%@_%@_%@",requestTarget.target_name,requestTarget.target_address,requestTarget.kkRequestIdentifier];
                NSLog(@"🚩🚩🚩★★★★★★★★★★Request Finished <Success>: %@ \n %@ \n",notificationName,resultDictionary);
            }
            #endif

            // httpInfomation
            NSHTTPURLResponse * mResponse = (NSHTTPURLResponse *)response;
            NSString *statusCode = [NSString stringWithFormat:@"%ld", (long)[mResponse statusCode]];
            NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
            [httpInfomation setObject:formRequest.requestParam.urlString forKey:httpResultURLKey];
            [httpInfomation setObject:[NSString stringWithFormat:@"%ld",(long)aError.code] forKey:httpErrorCodeKey];
            [httpInfomation setObject:[NSString stringWithFormat:@"%@",aError.localizedDescription] forKey:httpErrorMessageKey];
            [httpInfomation setObject:statusCode forKey:httpResultCodeKey];
            [httpInfomation setObject:@"success" forKey:httpResultMessageKey];

            [formRequest.requestSender kk_SenderProcessResultFinished:formRequest requestResult:resultDictionary httpInfomation:httpInfomation requestIdentifier:formRequest.requestParam.identifier];
        }
    }
    else{
        #ifdef DEBUG
        if (KKFormRequest_IsOpenLog) {
            KKRequestTarget *requestTarget = (KKRequestTarget*)formRequest.requestTarget;
            NSString *notificationName = [NSString stringWithFormat:@"%@_%@_%@",requestTarget.target_name,requestTarget.target_address,requestTarget.kkRequestIdentifier];
            NSLog(@"❌❌❌★★★★★★★★★★Request Finished <Failed>: %@ \n Network Not Reachable ! \n",notificationName);
        }
        #endif
        
        // httpInfomation
        NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
        [httpInfomation setObject:[NSString stringWithFormat:@"%@",formRequest.requestParam.urlString] forKey:httpResultURLKey];
        [httpInfomation setObject:httpErrorCode forKey:httpErrorCodeKey];
        [httpInfomation setObject:@"Network Not Reachable" forKey:httpErrorMessageKey];
        [httpInfomation setObject:@"" forKey:httpResultCodeKey];
        [httpInfomation setObject:@"" forKey:httpResultMessageKey];

        [formRequest.requestSender kk_SenderProcessResultFinished:formRequest requestResult:nil httpInfomation:httpInfomation requestIdentifier:formRequest.requestParam.identifier];
    }

    [self clearRequestWithIdentifier:formRequest.requestParam.identifier];
}

- (void)clearRequestWithIdentifier:(NSString*)aIdentifier{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:self.requestList];
    [self.requestList removeAllObjects];
    for (NSInteger i=0; i<[tempArray count]; i++) {
        KKFormRequest *tmpRequest = [tempArray objectAtIndex:i];
        if ([tmpRequest.requestParam.identifier isEqualToString:aIdentifier]) {
            [tmpRequest clearDelegatesAndCancel];
            continue;
        }
        else{
            [self.requestList addObject:tmpRequest];
        }
    }
}


- (nullable NSDictionary*)kkrequest_dictionaryFromJSONString:(nullable NSString*)aJsonString{
    
    if (aJsonString && [aJsonString isKindOfClass:[NSString class]]) {
        
        NSData *aJsonData = [aJsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:aJsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
        if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSDictionary class]]){
            return jsonObject;
        }else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

- (nullable NSDictionary*)kkrequest_dictionaryFromJSONData:(nullable NSData*)aJsonData{
    if (aJsonData && [aJsonData isKindOfClass:[NSData class]]) {
        
        NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:aJsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
        if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSDictionary class]]){
            return jsonObject;
        }else{
            return nil;
        }
    }
    else{
        return nil;
    }
}


@end



