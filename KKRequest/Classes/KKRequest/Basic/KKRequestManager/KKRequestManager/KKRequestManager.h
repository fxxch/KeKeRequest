//
//  KKRequestManager.h
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define httpResultURLKey     @"result_URL"
#define httpResultCodeKey    @"result_code"
#define httpResultMessageKey @"result_message"
#define httpErrorCodeKey     @"error_code"
#define httpErrorMessageKey  @"error_message"

#define httpErrorCode        @"999999"

#define KKFormRequest_IsOpenLog 1

@class KKRequestParam;
@class KKRequestTarget;
@class KKRequestSender;

@interface KKRequestManager : NSObject

+ (KKRequestManager*)defaultManager;

+ (void)addRequestWithParam:(KKRequestParam *)param
             requestTarget:(KKRequestTarget *)requestTarget
              requestSender:(KKRequestSender*)aRequestSender;

- (void)clearRequestWithIdentifier:(NSString*)aIdentifier;

@end



