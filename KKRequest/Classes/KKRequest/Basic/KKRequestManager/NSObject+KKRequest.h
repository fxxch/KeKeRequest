//
//  NSObject+KKRequest.h
//  P2CSumauhon
//
//  Created by liubo on 2022/4/9.
//  Copyright © 2022 ts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKFormRequest.h"
#import "KKRequestTarget.h"
#import "KKRequestParam.h"

@interface NSObject (KKRequest)

#pragma mark ==================================================
#pragma mark == KKRequest Notification
#pragma mark ==================================================
- (void)observeKKRequestNotification:(NSString *_Nonnull)notificationName;

- (void)unobserveKKRequestNotification:(NSString *_Nonnull)notificationName;

- (void)KKRequestDidFinished:(KKFormRequest*_Nonnull)aFormRequest
               requestResult:(NSDictionary*_Nullable)aRequestResult
              httpInfomation:(NSDictionary*_Nullable)aHttpInfomation
           requestIdentifier:(NSString*_Nullable)aRequestIdentifier;

@end
