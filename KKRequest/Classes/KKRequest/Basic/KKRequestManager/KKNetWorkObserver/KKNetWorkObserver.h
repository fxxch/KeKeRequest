//
//  KKNetWorkObserver.h
//  ProjectK
//
//  Created by liubo on 14-1-7.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSNotificationName const _Nonnull KKNotificationName_NetWorkStatusWillChange;
UIKIT_EXTERN NSNotificationName const _Nonnull KKNotificationName_NetWorkStatusDidChanged;

UIKIT_EXTERN NSAttributedStringKey const _Nonnull KKNetWorkObserverNotificationKeyOldValue;
UIKIT_EXTERN NSAttributedStringKey const _Nonnull KKNetWorkObserverNotificationKeyNewValue;

typedef enum : NSInteger {
    KKNotReachable = 0,
    KKReachableViaWiFi,
    KKReachableViaWWAN
} KKNetworkStatus;

@interface KKNetWorkObserver : NSObject

@property(nonatomic,assign)KKNetworkStatus    status;

+ (KKNetWorkObserver *_Nonnull)sharedInstance;

- (BOOL)isReachable;

@end
