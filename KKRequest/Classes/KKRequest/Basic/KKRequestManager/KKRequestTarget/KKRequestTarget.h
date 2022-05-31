//
//  KKRequestSender.h
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KKRequestDefine.h"

@class KKFormRequest;

@interface KKRequestTarget : NSObject

@property (nonatomic , copy) NSString *_Nullable target_name;
@property (nonatomic , copy) NSString *_Nullable target_address;
@property (nonatomic , copy) NSString *_Nullable kkRequestIdentifier;
@property (nonatomic , copy) KKRequestFinishedBlock _Nullable kkRequestFinishedBlock;
@property (nonatomic , weak) id _Nullable kkTarget;

@end
