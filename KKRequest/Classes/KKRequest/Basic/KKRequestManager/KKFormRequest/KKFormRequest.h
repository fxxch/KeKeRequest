//
//  KKFormRequest.h
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KKFormRequestDelegate;

@class KKRequestTarget;
@class KKRequestParam;
@class KKRequestSender;

@interface KKFormRequest : NSObject

@property (nonatomic, strong) KKRequestParam  *requestParam;
@property (nonatomic, strong) KKRequestTarget *requestTarget;
@property (nonatomic, weak) KKRequestSender *requestSender;
@property (nonatomic, weak) id<KKFormRequestDelegate> delegate;


- (void)startRequestWithParam:(KKRequestParam *)param
                requestTarget:(KKRequestTarget *)aRequestTarget
                requestSender:(KKRequestSender*)aRequestSender;

- (void)setRequestWithParam:(KKRequestParam *)param
              requestTarget:(KKRequestTarget*)aRequestTarget
              requestSender:(KKRequestSender*)aRequestSender;

- (void)clearDelegatesAndCancel;

@end

@protocol KKFormRequestDelegate <NSObject>
@optional

- (void)requestFinished:(KKFormRequest *)request result:(id)responseObject httpResponse:(NSURLResponse*)response error:(NSError*)aError;

- (void)requestFailed:(KKFormRequest *)request result:(id)responseObject httpResponse:(NSURLResponse*)response error:(NSError*)aError;

@end

