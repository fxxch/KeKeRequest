//
//  KKRequestParam.h
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSObject+KKRequest.h"

#define HTTPMethod_POST    @"POST"
#define HTTPMethod_GET     @"GET"
#define HTTPMethod_PUT     @"PUT"
#define HTTPMethod_DELETE  @"DELETE"

@interface KKRequestParam : NSObject

@property (nonatomic, strong) NSMutableDictionary   *requestHeaderDic;
@property (nonatomic, strong) NSMutableDictionary   *postFilesPathDic;
@property (nonatomic, strong) NSMutableDictionary   *postParamDic;
@property (nonatomic, strong) NSMutableDictionary   *postDataDic;
@property (nonatomic, strong) NSMutableData         *postData;

@property (nonatomic, copy)   NSString              *urlString;
@property (nonatomic, copy)   NSString              *identifier;
@property (nonatomic, copy)   NSString              *method;
@property (nonatomic, assign) NSTimeInterval        timeout;

- (NSString *)paramStringOfGet;
- (NSDictionary *)paramOfPost;

- (void)addRequestHeader:(NSString *)key withValue:(id)value;

- (void)addFile:(NSString *)filePath forKey:(NSString *)fileKey;

- (void)addParam:(NSString *)key withValue:(id)value;
- (void)addParams:(NSDictionary *)aParamsDictionary;

- (void)addPostData:(NSData *)data forKey:(NSString *)aKey;

- (void)addPostData:(NSData *)data;

#pragma mark ==================================================
#pragma mark == header_application_json
#pragma mark ==================================================
- (void)kk_CheckHeader_application_json;

@end
