//
//  KKFormRequest.m
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKFormRequest.h"
#import "KKRequestParam.h"
#import "KKRequestManager.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager+KKExtention.h"

@implementation KKFormRequest

#pragma mark ==================================================
#pragma mark == Inherface
#pragma mark ==================================================
- (void)startRequestWithParam:(KKRequestParam *)param
                requestTarget:(KKRequestTarget *)aRequestTarget
                requestSender:(KKRequestSender*)aRequestSender{

    [self setRequestWithParam:param requestTarget:aRequestTarget requestSender:aRequestSender];

    [self startAFNRequestWithParam:param requestTarget:aRequestTarget];
}

- (void)setRequestWithParam:(KKRequestParam *)param
              requestTarget:(KKRequestTarget*)aRequestTarget
               requestSender:(KKRequestSender*)aRequestSender{
    self.requestTarget = aRequestTarget;
    self.requestParam = param;
    self.requestSender = aRequestSender;
}

- (void)clearDelegatesAndCancel{
    
}

#pragma mark ==================================================
#pragma mark == Request
#pragma mark ==================================================
- (void)startAFNRequestWithParam:(KKRequestParam *)param
                   requestTarget:(KKRequestTarget *)aRequestTarget{

#ifdef DEBUG
    if (KKFormRequest_IsOpenLog) {
        NSLog(@"🚩🚩🚩Request API【%@】: %@",[self.requestParam method],self.requestParam.urlString);
    }
    
    if (self.requestParam.postParamDic) {
        if (KKFormRequest_IsOpenLog) {
            NSLog(@"🚩🚩🚩POST Params: %@",self.requestParam.postParamDic);
        }
    }
    if (self.requestParam.postFilesPathDic) {
        if (KKFormRequest_IsOpenLog) {
            NSLog(@"🚩🚩🚩POST File: %@",self.requestParam.postFilesPathDic);
        }
    }
    if (self.requestParam.requestHeaderDic) {
        if (KKFormRequest_IsOpenLog) {
            NSLog(@"🚩🚩🚩requestHeader: %@",self.requestParam.requestHeaderDic);
        }
    }
#endif

    //POST
    if ([[self.requestParam.method uppercaseString] isEqualToString:@"POST"]) {
        
        [self startAFNRequest_POST_Param:param requestTarget:aRequestTarget];
        
    }
    //GET
    else if ([[self.requestParam.method uppercaseString] isEqualToString:@"GET"]){

        [self startAFNRequest_GET_Param:param requestTarget:aRequestTarget];

    }
    //PUT
    else if ([[self.requestParam.method uppercaseString] isEqualToString:@"PUT"]){
        
        [self startAFNRequest_PUT_Param:param requestTarget:aRequestTarget];
        
    }
    //DELETE
    else if ([[self.requestParam.method uppercaseString] isEqualToString:@"DELETE"]){
        
        [self startAFNRequest_DELETE_Param:param requestTarget:aRequestTarget];
        
    }
    else{
        
    }
}

- (void)startAFNRequest_POST_Param:(KKRequestParam *)param
                     requestTarget:(KKRequestTarget *)aRequestTarget{
    
    AFHTTPSessionManager *manager = [self AFHTTPSessionManager_DefaultManager];
    manager.requestSerializer.timeoutInterval = param.timeout;

    NSMutableDictionary *postParamDic = [NSMutableDictionary dictionary];
    NSDictionary *dictionary = [self.requestParam paramOfPost];
    [postParamDic setValuesForKeysWithDictionary:dictionary];

    __weak typeof(self) weakself = self;
    [manager KK_POST_URLString:self.requestParam.urlString kkParameters:self.requestParam parameters:postParamDic headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nullable formData) {
        
        if (weakself.requestParam.postFilesPathDic &&
            [weakself.requestParam.postFilesPathDic isKindOfClass:[NSDictionary class]] &&
            [weakself.requestParam.postFilesPathDic count]>0) {

            NSArray *allKeys = [weakself.requestParam.postFilesPathDic allKeys];
            for (NSInteger i=0; i<[allKeys count]; i++) {
                NSString *key = [allKeys objectAtIndex:i];
                NSString *filePath = [weakself.requestParam.postFilesPathDic objectForKey:key];

                NSData *data = [NSData dataWithContentsOfFile:filePath];
                [formData appendPartWithFileData:data name:key fileName:[filePath lastPathComponent] mimeType:@"image/jpg"];

            }
        }
        
        if (weakself.requestParam.postDataDic &&
            [weakself.requestParam.postDataDic isKindOfClass:[NSDictionary class]] &&
            [weakself.requestParam.postDataDic count]>0) {

            NSArray *allKeys = [weakself.requestParam.postDataDic allKeys];
            for (NSInteger i=0; i<[allKeys count]; i++) {
                NSString *key = [allKeys objectAtIndex:i];
                NSData *data = [weakself.requestParam.postDataDic objectForKey:key];
                [formData appendPartWithFormData:data name:key];
            }
        }

        
    } progress:^(NSProgress * _Nullable progress) {
        
        
    } success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [weakself requestSuccessWithTask:task responseObject:responseObject responce:response error:error];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [weakself requestFailedWithTask:task responseObject:responseObject responce:response error:error];
        
    }];

}

- (void)startAFNRequest_GET_Param:(KKRequestParam *)param
                    requestTarget:(KKRequestTarget *)aRequestTarget{
    
    AFHTTPSessionManager *manager = [self AFHTTPSessionManager_DefaultManager];
    manager.requestSerializer.timeoutInterval = param.timeout;

    NSString *urlString_origin = _requestParam.urlString;
    if (KKFormRequest_IsOpenLog) {
        NSLog(@"🚩🚩🚩GET origin URL: %@",urlString_origin);
    }
    NSString *urlString_KKURLEncodedString = [NSString stringWithFormat:@"%@%@", urlString_origin, [self.requestParam paramStringOfGet]];
    NSString *urlString = [urlString_KKURLEncodedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
#ifdef DEBUG
    if (KKFormRequest_IsOpenLog) {
        NSLog(@"🚩🚩🚩GET URL: %@",urlString);
    }
#endif
    
    NSMutableDictionary *postParamDic = [NSMutableDictionary dictionary];
    NSDictionary *dictionary = [self.requestParam paramOfPost];
    [postParamDic setValuesForKeysWithDictionary:dictionary];

    __weak typeof(self) weakself = self;
    [manager KK_GET_URLString:urlString kkParameters:self.requestParam parameters:postParamDic headers:nil uploadProgress:^(NSProgress * _Nullable uploadProgress) {
        
        
    } downloadProgress:^(NSProgress * _Nullable downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [weakself requestSuccessWithTask:task responseObject:responseObject responce:response error:error];

    } failure:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [weakself requestFailedWithTask:task responseObject:responseObject responce:response error:error];
    }];
}

- (void)startAFNRequest_PUT_Param:(KKRequestParam *)param
                    requestTarget:(KKRequestTarget *)aRequestTarget{
    
    AFHTTPSessionManager *manager = [self AFHTTPSessionManager_DefaultManager];
    manager.requestSerializer.timeoutInterval = param.timeout;

    NSMutableDictionary *postParamDic = [NSMutableDictionary dictionary];
    NSDictionary *dictionary = [self.requestParam paramOfPost];
    [postParamDic setValuesForKeysWithDictionary:dictionary];

    __weak typeof(self) weakself = self;
    [manager KK_PUT_URLString:param.urlString kkParameters:self.requestParam parameters:postParamDic headers:nil uploadProgress:^(NSProgress * _Nullable uploadProgress) {
        
        
    } downloadProgress:^(NSProgress * _Nullable downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [weakself requestSuccessWithTask:task responseObject:responseObject responce:response error:error];

    } failure:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [weakself requestFailedWithTask:task responseObject:responseObject responce:response error:error];
    }];
}

- (void)startAFNRequest_DELETE_Param:(KKRequestParam *)param
                       requestTarget:(KKRequestTarget *)aRequestTarget{

    AFHTTPSessionManager *manager = [self AFHTTPSessionManager_DefaultManager];
    manager.requestSerializer.timeoutInterval = param.timeout;

    NSString *urlString_origin = _requestParam.urlString;
    if (KKFormRequest_IsOpenLog) {
        NSLog(@"🚩🚩🚩DELETE Origin URL: %@",urlString_origin);
    }

    NSString *urlString_KKURLEncodedString = [NSString stringWithFormat:@"%@%@", urlString_origin, [self.requestParam paramStringOfGet]];
    NSString *urlString = [urlString_KKURLEncodedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
#ifdef DEBUG
    if (KKFormRequest_IsOpenLog) {
        NSLog(@"🚩🚩🚩DELETE URL: %@",urlString);
    }
#endif
    
    NSMutableDictionary *postParamDic = [NSMutableDictionary dictionary];
    NSDictionary *dictionary = [self.requestParam paramOfPost];
    [postParamDic setValuesForKeysWithDictionary:dictionary];

    
    __weak typeof(self) weakself = self;
    [manager KK_PUT_URLString:urlString kkParameters:self.requestParam parameters:postParamDic headers:nil uploadProgress:^(NSProgress * _Nullable uploadProgress) {
        
        
    } downloadProgress:^(NSProgress * _Nullable downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [weakself requestSuccessWithTask:task responseObject:responseObject responce:response error:error];

    } failure:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [weakself requestFailedWithTask:task responseObject:responseObject responce:response error:error];
    }];
}

- (AFHTTPSessionManager*)AFHTTPSessionManager_DefaultManager{

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
//    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    [manager.requestSerializer setValue:@"application/json"
//                     forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
//                     forHTTPHeaderField:@"Content-Type"];

//    NSSet *Content_Type = [[NSSet alloc] initWithObjects:
//                           @"application/xml",
//                           @"text/xml",
//                           @"text/html",
//                           @"application/json",
//                           @"text/plain",
//                           @"text/json",
//                           @"text/javascript",
//                           @"multipart/form-data",
//                           nil];
//    manager.responseSerializer.acceptableContentTypes = Content_Type;

    //_requestHeader
    if (self.requestParam.requestHeaderDic &&
        [self.requestParam.requestHeaderDic isKindOfClass:[NSDictionary class]] &&
        [self.requestParam.requestHeaderDic count]>0) {

        NSArray *allKeys = [self.requestParam.requestHeaderDic allKeys];
        for (NSInteger i=0; i<[allKeys count]; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [self.requestParam.requestHeaderDic objectForKey:key];
            
            [manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }

    return manager;
}

- (void)requestSuccessWithTask:(NSURLSessionDataTask * _Nonnull) task
                responseObject:(id  _Nullable )responseObject
                      responce:(NSURLResponse*)responce
                         error:(NSError*)error{
    
    __weak typeof(self) weakself = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (weakself.delegate &&
            [weakself.delegate respondsToSelector:@selector(requestFinished:result:httpResponse:error:)]) {
            [weakself.delegate requestFinished:self result:responseObject httpResponse:responce error:error];
        }
        
    });
}

- (void)requestFailedWithTask:(NSURLSessionDataTask * _Nonnull) task
               responseObject:(id  _Nullable )responseObject
                     responce:(NSURLResponse*)responce
                        error:(NSError* _Nonnull)error{
    
    __weak typeof(self) weakself = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (weakself.delegate &&
            [weakself.delegate respondsToSelector:@selector(requestFailed:result:httpResponse:error:)]) {
            [weakself.delegate requestFailed:self result:responseObject httpResponse:responce error:error];
        }
        
    });
}


@end
