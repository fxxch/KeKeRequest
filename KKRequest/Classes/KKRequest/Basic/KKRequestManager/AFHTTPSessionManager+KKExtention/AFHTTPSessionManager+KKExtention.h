//
//  AFHTTPSessionManager+KKExtention.h
//  KKLibray
//
//  Created by liubo on 2018/4/26.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class KKRequestParam;

typedef void(^AFRequestSuccessBlock)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error);

typedef void(^AFRequestFailureBlock)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error);


@interface AFHTTPSessionManager (KKExtention)

- (NSURLSessionDataTask *_Nullable)KK_POST_URLString:(nullable NSString*)aURLString
                                        kkParameters:(nullable KKRequestParam*)aKKParameters
                                          parameters:(nullable id )parameters
                                             headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                           constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nullable formData))block
                                            progress:(nullable void (^)(NSProgress * _Nullable progress))uploadProgress
                                             success:(nullable AFRequestSuccessBlock)success
                                             failure:(nullable AFRequestFailureBlock)failure;

- (NSURLSessionDataTask *_Nullable)KK_GET_URLString:(nullable NSString*)aURLString
                                       kkParameters:(nullable KKRequestParam*)aKKParameters
                                         parameters:(nullable id)parameters
                                            headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                                     uploadProgress:(nullable void (^)(NSProgress * _Nullable uploadProgress)) uploadProgress
                                   downloadProgress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgress
                                            success:(nullable AFRequestSuccessBlock)success
                                            failure:(nullable AFRequestFailureBlock)failure;

- (NSURLSessionDataTask *_Nullable)KK_PUT_URLString:(nullable NSString*)aURLString
                                       kkParameters:(nullable KKRequestParam*)aKKParameters
                                         parameters:(nullable id)parameters
                                            headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                                     uploadProgress:(nullable void (^)(NSProgress * _Nullable uploadProgress)) uploadProgress
                                   downloadProgress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgress
                                            success:(nullable AFRequestSuccessBlock)success
                                            failure:(nullable AFRequestFailureBlock)failure;

- (NSURLSessionDataTask *_Nullable)KK_DELETE_URLString:(nullable NSString*)aURLString
                                          kkParameters:(nullable KKRequestParam*)aKKParameters
                                            parameters:(nullable id)parameters
                                               headers:(nullable NSDictionary<NSString *,NSString *> *)headers
                                        uploadProgress:(nullable void (^)(NSProgress * _Nullable uploadProgress)) uploadProgress
                                      downloadProgress:(nullable void (^)(NSProgress * _Nullable downloadProgress)) downloadProgress
                                               success:(nullable AFRequestSuccessBlock)success
                                               failure:(nullable AFRequestFailureBlock)failure;

@end
