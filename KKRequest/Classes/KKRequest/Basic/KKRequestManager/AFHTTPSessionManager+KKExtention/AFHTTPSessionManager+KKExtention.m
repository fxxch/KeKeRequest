//
//  AFHTTPSessionManager+KKExtention.m
//  KKLibray
//
//  Created by liubo on 2018/4/26.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "AFHTTPSessionManager+KKExtention.h"
#import "KKRequestParam.h"

@implementation AFHTTPSessionManager (KKExtention)


- (NSURLSessionDataTask *_Nullable)KK_POST_URLString:(nullable NSString*)aURLString
                                        kkParameters:(nullable KKRequestParam*)aKKParameters
                                          parameters:(nullable id )parameters
                                             headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                           constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nullable formData))block
                                            progress:(nullable void (^)(NSProgress * _Nullable progress))uploadProgress
                                             success:(nullable AFRequestSuccessBlock)success
                                             failure:(nullable AFRequestFailureBlock)failure{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:aURLString?aURLString:aKKParameters.urlString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, nil, nil, serializationError);
            });
        }
        
        return nil;
    }

    for (NSString *headerField in headers.keyEnumerator) {
        [request setValue:headers[headerField] forHTTPHeaderField:headerField];
    }
    //kk_requestHeader
    if (aKKParameters.requestHeaderDic && [aKKParameters.requestHeaderDic isKindOfClass:[NSDictionary class]] && [aKKParameters.requestHeaderDic count]>0) {
        NSArray *allKeys = [aKKParameters.requestHeaderDic allKeys];
        for (NSInteger i=0; i<[allKeys count]; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [aKKParameters.requestHeaderDic objectForKey:key];
            [request setValue:value forHTTPHeaderField:key];
        }
    }
    //kk_postData
    if (aKKParameters.postData) {
        NSMutableData *data = [NSMutableData data];
        [data appendData:request.HTTPBody];
        [data appendData:aKKParameters.postData];
        request.HTTPBody = data;
        
        unsigned long long lenth = [[request valueForHTTPHeaderField:@"Content-Length"] longLongValue];
        lenth = lenth + [aKKParameters.postData length];
        [request setValue:[NSString stringWithFormat:@"%llu", lenth] forHTTPHeaderField:@"Content-Length"];
    }

    
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, responseObject, response, error);
            }
        } else {
            if (success) {
                success(task, responseObject, response, error);
            }
        }
    }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *_Nullable)KK_GET_URLString:(nullable NSString*)aURLString
                                       kkParameters:(nullable KKRequestParam*)aKKParameters
                                         parameters:(nullable id)parameters
                                            headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                                     uploadProgress:(nullable void (^)(NSProgress * _Nullable uploadProgress)) uploadProgress
                                   downloadProgress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgress
                                            success:(nullable AFRequestSuccessBlock)success
                                            failure:(nullable AFRequestFailureBlock)failure{
    
    NSURLSessionDataTask *task = [self kk_dataTask_WithURLString:aURLString
                                                      httpMethod:@"GET"
                                                  kkRequestParam:aKKParameters
                                                      parameters:parameters
                                                         headers:headers
                                                  uploadProgress:uploadProgress
                                                downloadProgress:downloadProgress
                                                         success:success
                                                         failure:failure];
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *_Nullable)KK_PUT_URLString:(nullable NSString*)aURLString
                                       kkParameters:(nullable KKRequestParam*)aKKParameters
                                         parameters:(nullable id)parameters
                                            headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                                     uploadProgress:(nullable void (^)(NSProgress * _Nullable uploadProgress)) uploadProgress
                                   downloadProgress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgress
                                            success:(nullable AFRequestSuccessBlock)success
                                            failure:(nullable AFRequestFailureBlock)failure{
    
    NSURLSessionDataTask *task = [self kk_dataTask_WithURLString:aURLString
                                                      httpMethod:@"PUT"
                                                  kkRequestParam:aKKParameters
                                                      parameters:parameters
                                                         headers:headers
                                                  uploadProgress:uploadProgress
                                                downloadProgress:downloadProgress
                                                         success:success
                                                         failure:failure];
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *_Nullable)KK_DELETE_URLString:(nullable NSString*)aURLString
                                          kkParameters:(nullable KKRequestParam*)aKKParameters
                                            parameters:(nullable id)parameters
                                               headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                                        uploadProgress:(nullable void (^)(NSProgress * _Nullable uploadProgress)) uploadProgress
                                      downloadProgress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgress
                                               success:(nullable AFRequestSuccessBlock)success
                                               failure:(nullable AFRequestFailureBlock)failure{
    
    NSURLSessionDataTask *task = [self kk_dataTask_WithURLString:aURLString
                                                      httpMethod:@"DELETE"
                                                  kkRequestParam:aKKParameters
                                                      parameters:parameters
                                                         headers:headers
                                                  uploadProgress:uploadProgress
                                                downloadProgress:downloadProgress
                                                         success:success
                                                         failure:failure];
    [task resume];
    
    return task;
}


- (NSURLSessionDataTask *_Nullable)kk_dataTask_WithURLString:(nullable NSString*)aURLString
                                                  httpMethod:(nullable NSString *)method
                                              kkRequestParam:(nullable KKRequestParam*)aKKParameters
                                                  parameters:(nullable id)parameters
                                                     headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                                              uploadProgress:(nullable void (^)(NSProgress * _Nullable uploadProgress)) uploadProgress
                                            downloadProgress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgress
                                                     success:(nullable AFRequestSuccessBlock)success
                                                     failure:(nullable AFRequestFailureBlock)failure{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:aURLString?aURLString:aKKParameters.urlString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    for (NSString *headerField in headers.keyEnumerator) {
        [request setValue:headers[headerField] forHTTPHeaderField:headerField];
    }
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, nil, nil, serializationError);
            });
        }
        
        return nil;
    }

    //kk_requestHeader
    if (aKKParameters.requestHeaderDic && [aKKParameters.requestHeaderDic isKindOfClass:[NSDictionary class]] && [aKKParameters.requestHeaderDic count]>0) {
        NSArray *allKeys = [aKKParameters.requestHeaderDic allKeys];
        for (NSInteger i=0; i<[allKeys count]; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [aKKParameters.requestHeaderDic objectForKey:key];
            
            [request setValue:value forHTTPHeaderField:key];
        }
    }
    
    //kk_postData
    if (aKKParameters.postData) {
        
        NSMutableData *data = [NSMutableData data];
        [data appendData:request.HTTPBody];
        [data appendData:aKKParameters.postData];
        request.HTTPBody = data;
        
        unsigned long long lenth = [[request valueForHTTPHeaderField:@"Content-Length"] longLongValue];
        lenth = lenth + [aKKParameters.postData length];
        [request setValue:[NSString stringWithFormat:@"%llu", lenth] forHTTPHeaderField:@"Content-Length"];
    }
    
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(dataTask, responseObject, response, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject, response, error);
            }
        }
    }];
    
    return dataTask;
}

@end
