//
//  KKRequestParam.m
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKRequestParam.h"
#import <objc/runtime.h>

@implementation KKRequestParam

- (id)init {
    if (self = [super init]) {
        self.method = HTTPMethod_POST;
        self.timeout = 20.0f;
    }
    return self;
}

#pragma ==================================================
#pragma == 添加参数
#pragma ==================================================
- (void)addRequestHeader:(NSString *)key withValue:(id)value{
    if (self.requestHeaderDic == nil) {
        self.requestHeaderDic = [[NSMutableDictionary alloc] init];
    }
    
    if (value == nil) {
        value = @"";
    }
    
    if (value != nil && key != nil) {
        [self.requestHeaderDic setObject:value forKey:key];
    }
}

- (void)addFile:(NSString *)filePath forKey:(NSString *)fileKey{
    if (self.postFilesPathDic == nil) {
        self.postFilesPathDic = [[NSMutableDictionary alloc] init];
    }

    if (filePath && (![filePath isEqualToString:@""])) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            if (fileKey && (![fileKey isEqualToString:@""])) {
                [self.postFilesPathDic setObject:filePath forKey:fileKey];
            }
            else{
#ifdef DEBUG
                NSLog(@"❌❌❌upload file，Key error");
#endif
                return;
            }
        }
        else{
#ifdef DEBUG
            NSLog(@"❌❌❌upload file, file is not exist：%@",filePath);
#endif
            return;
        }
    }
}

- (void)addParam:(NSString *)key withValue:(id)value{
    if (self.postParamDic == nil) {
        self.postParamDic = [[NSMutableDictionary alloc] init];
    }
    
    if (value == nil) {
        return;
    }
    
    if (value != nil && key != nil) {
        [self.postParamDic setObject:value forKey:key];
    }
}

- (void)addParams:(NSDictionary *)aParamsDictionary{
    
    if (aParamsDictionary==nil || [aParamsDictionary isKindOfClass:[NSDictionary class]]==NO || aParamsDictionary.count==0){
        return;
    }
    
    if (self.postParamDic == nil) {
        self.postParamDic = [[NSMutableDictionary alloc] init];
    }
    
    [self.postParamDic setValuesForKeysWithDictionary:aParamsDictionary];
}

- (void)addPostData:(NSData *)data forKey:(NSString *)aKey{
    if (self.postDataDic == nil) {
        self.postDataDic = [[NSMutableDictionary alloc] init];
    }
    
    if (data && aKey) {
        [self.postDataDic setObject:data forKey:aKey];
    }
}

- (void)addPostData:(NSData *)data{
    if (self.postData == nil) {
        self.postData = [[NSMutableData alloc] init];
    }
    
    if (data) {
        [self.postData appendData:data];
    }
}


#pragma ==================================================
#pragma == 将self的所有property拼接成Get方式请求的字符串
#pragma ==================================================
- (NSString *)paramStringOfGet{
    
    NSDictionary *returnDictionary = [self paramOfPost];
    
    NSString *paramString = @"?";
    if (returnDictionary != nil) {
        NSInteger length = [[returnDictionary allKeys] count];
        
        NSString    *key;
        id          value;
        NSString    *separate = @"&";
        
        for (int i=0; i<length; i++) {
            key = [[returnDictionary allKeys] objectAtIndex:i];
            
            if ([key isEqualToString:@"requestHeaderDic"]
                || [key isEqualToString:@"postFilesPathDic"]
                || [key isEqualToString:@"postParamDic"]
                || [key isEqualToString:@"postDataDic"]
                || [key isEqualToString:@"postData"]
                || [key isEqualToString:@"urlString"]
                || [key isEqualToString:@"identifier"]
                || [key isEqualToString:@"method"]
                || [key isEqualToString:@"timeout"]
                ) {
                continue;
            }
            
            value = [returnDictionary valueForKey:key];
            if (i == length-1) {
                separate = @"";
            }
            
            if (paramString && key && [key length]>0 && separate) {
                if (value && [value isKindOfClass:[NSString class]] && [value length]>0) {
                    paramString = [NSString stringWithFormat:@"%@%@=%@%@", paramString, key, value, separate];
                }
                else if (value && [value isKindOfClass:[NSNumber class]]){
                    paramString = [NSString stringWithFormat:@"%@%@=%@%@", paramString, key, [(NSNumber*)value stringValue], separate];
                }
                else{
                    
                }
            }
        }
    }
    
    if ([paramString hasSuffix:@"&"]) {
        paramString = [paramString substringToIndex:[paramString length]-1];
    }
    
    if ([paramString isEqualToString:@"?"]) {
        return @"";
    }
    
    return paramString;
}

#pragma ==================================================
#pragma == Create Post Dictionary with propertyList
#pragma ==================================================
- (NSDictionary *)paramOfPost{
    
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    
    NSString *propertyName = nil;
    NSString *propertyValue = nil;
    
    NSArray *propertyList = [self attributeList];
    NSUInteger count = propertyList.count;
    
    for (int i=0; i<count; i++) {
        propertyName = [propertyList objectAtIndex:i];
        
        if ([propertyName isEqualToString:@"requestHeaderDic"]
            || [propertyName isEqualToString:@"postFilesPathDic"]
            || [propertyName isEqualToString:@"postParamDic"]
            || [propertyName isEqualToString:@"postDataDic"]
            || [propertyName isEqualToString:@"postData"]
            || [propertyName isEqualToString:@"urlString"]
            || [propertyName isEqualToString:@"identifier"]
            || [propertyName isEqualToString:@"method"]
            || [propertyName isEqualToString:@"timeout"]
            ) {
            continue;
        }

        propertyValue =[self valueForKey:propertyName];
        
        if (propertyValue == nil) {
            propertyValue = @"";
        }
        if (propertyName && propertyValue) {
            [returnDictionary setObject:propertyValue forKey:propertyName];
        }
    }
        
    [returnDictionary setValuesForKeysWithDictionary:self.postParamDic];
    
    return returnDictionary;
}


#pragma ==================================================
#pragma == Get Class PropertyList
#pragma ==================================================
- (NSMutableArray *)attributeList {
    static NSMutableDictionary *classDictionary = nil;
    if (classDictionary == nil) {
        classDictionary = [[NSMutableDictionary alloc] init];
    }
    
    NSString *className = NSStringFromClass(self.class);
    
    NSMutableArray *propertyList = [classDictionary objectForKey:className];
    
    if (propertyList != nil) {
        return propertyList;
    }
    
    propertyList = [[NSMutableArray alloc] init];
    
    id theClass = object_getClass(self);
    [self getPropertyList:theClass forList:&propertyList];
    
    [classDictionary setObject:propertyList forKey:className];
    
    return propertyList;
}

- (void)getPropertyList:(id)theClass forList:(NSMutableArray **)propertyList {
    id superClass = class_getSuperclass(theClass);
    unsigned int count, i;
    objc_property_t *properties = class_copyPropertyList(theClass, &count);
    for (i=0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        if (propertyName != nil) {
            [*propertyList addObject:propertyName];
            
            propertyName = nil;
        }
    }
    free(properties);
    
    if (superClass != [NSObject class]) {
        [self getPropertyList:superClass forList:propertyList];
    }
}

#pragma mark ==================================================
#pragma mark == header_application_json
#pragma mark ==================================================
- (void)kk_CheckHeader_application_json{

    if ([[self.method uppercaseString] isEqualToString:HTTPMethod_POST] ||
        [[self.method uppercaseString] isEqualToString:HTTPMethod_PUT]) {
        
        if ([self.postFilesPathDic count]>0 ) {
//            [param addRequestHeader:@"Accept" withValue:@""];
//            [param addRequestHeader:@"Content-Type" withValue:@"multipart/form-data"];
//            [param addRequestHeader:@"Content-Type" withValue:@""];
        }
        else{
            NSDictionary *dictionary = [self paramOfPost];
            if (dictionary && [dictionary isKindOfClass:[NSDictionary class]] && [dictionary count]>0) {
                NSString *jsonString = [self kkrequest_translateToJSONString:dictionary];
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                [self addPostData:jsonData];
            }
            [self addRequestHeader:@"Accept" withValue:@"application/json"];
            [self addRequestHeader:@"Content-Type" withValue:@"application/json"];
        }
    }
    else if ([[self.method uppercaseString] isEqualToString:HTTPMethod_DELETE]){
        NSDictionary *dictionary = [self paramOfPost];
        if (dictionary && [dictionary isKindOfClass:[NSDictionary class]] && [dictionary count]>0) {
            NSString *jsonString = [self kkrequest_translateToJSONString:dictionary];
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            [self addPostData:jsonData];
        }
        [self addRequestHeader:@"Accept" withValue:@"application/json"];
        [self addRequestHeader:@"Content-Type" withValue:@"application/json"];
    }
    else{
        
    }
}

/**
 将字典转换成Json字符串
 
 @return Json字符串
 */
- (nullable NSString*)kkrequest_translateToJSONString:(NSDictionary*)aDictionary{
    if ([NSJSONSerialization isValidJSONObject:aDictionary]) {
        //NSJSONWritingPrettyPrinted 方式，苹果会默认加上\n换行符，如果传0，就不会
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aDictionary
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        if (jsonData && [jsonData isKindOfClass:[NSData class]]) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            return jsonString;
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

@end
