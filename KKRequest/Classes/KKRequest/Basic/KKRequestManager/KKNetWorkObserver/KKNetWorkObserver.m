//
//  KKNetWorkObserver.m
//  ProjectK
//
//  Created by liubo on 14-1-7.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import "KKNetWorkObserver.h"
#import "AFNetworkReachabilityManager.h"

NSNotificationName const KKNotificationName_NetWorkStatusWillChange = @"KKNotificationName_NetWorkStatusWillChange";
NSNotificationName const KKNotificationName_NetWorkStatusDidChanged = @"KKNotificationName_NetWorkStatusDidChanged";

NSAttributedStringKey const KKNetWorkObserverNotificationKeyOldValue = @"oldValue";
NSAttributedStringKey const KKNetWorkObserverNotificationKeyNewValue = @"newValue";

@interface KKNetWorkObserver()


@end


@implementation KKNetWorkObserver

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (KKNetWorkObserver *_Nonnull)sharedInstance {
    static KKNetWorkObserver *KKNETWORK_OBSERVER = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKNETWORK_OBSERVER = [[self alloc] init];
    });
    return KKNETWORK_OBSERVER;
}

- (id)init {
    self = [super init];
    if (self) {
        self.status = KKReachableViaWiFi;

        __weak typeof(self) weakself = self;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            KKNetworkStatus status_old = weakself.status;
            
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    weakself.status = KKNotReachable;
                    break;

                case AFNetworkReachabilityStatusNotReachable:
                    weakself.status = KKNotReachable;
                    break;

                case AFNetworkReachabilityStatusReachableViaWWAN:
                    weakself.status = KKReachableViaWWAN;
                    break;

                case AFNetworkReachabilityStatusReachableViaWiFi:
                    weakself.status = KKReachableViaWiFi;
                    break;
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)status_old] forKey:KKNetWorkObserverNotificationKeyOldValue];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)weakself.status] forKey:KKNetWorkObserverNotificationKeyNewValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:KKNotificationName_NetWorkStatusWillChange
                                                                object:nil
                                                              userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:KKNotificationName_NetWorkStatusDidChanged object:[NSNumber numberWithInteger:weakself.status]];
        }];
    }
    return self ;
}

#pragma mark ==================================================
#pragma mark == Notification
#pragma mark ==================================================
- (BOOL)isReachable{
    if (self.status==KKNotReachable) {
        return NO;
    }
    else{
        return YES;
    }
}

@end
