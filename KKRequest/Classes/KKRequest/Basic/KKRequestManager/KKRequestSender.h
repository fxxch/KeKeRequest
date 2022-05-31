//
//  KKRequestSender.h
//  Lib_Base
//
//  Created by edward lannister on 2022/04/13.
//  Copyright © 2022 ts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKRequestParam.h"

@interface KKRequestSender : NSObject

#pragma mark ==================================================
#pragma mark == SendRequest
#pragma mark ==================================================
- (void)kk_SendRequestWithParam:(KKRequestParam*_Nullable)aRequestParam
                         target:(id _Nullable)aTarget;

- (void)kk_SendRequestWithParam:(KKRequestParam*_Nullable)aRequestParam
                         target:(id _Nullable)aTarget
                       finished:(KKRequestFinishedBlock _Nullable )finished;

#pragma mark ==================================================
#pragma mark == Process Request Response
#pragma mark ==================================================
- (void)kk_SenderProcessResultFinished:(KKFormRequest*_Nullable)aFormRequest
                         requestResult:(NSDictionary*_Nullable)aRequestResult
                        httpInfomation:(NSDictionary*_Nullable)aHttpInfomation
                     requestIdentifier:(NSString*_Nullable)aRequestIdentifier;

@end
