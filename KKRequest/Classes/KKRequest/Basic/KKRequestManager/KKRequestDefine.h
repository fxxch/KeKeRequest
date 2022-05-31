//
//  KKRequestDefine.h
//  P2CSumauhon
//
//  Created by liubo on 2022/4/9.
//  Copyright © 2022 ts. All rights reserved.
//

#ifndef KKRequestDefine_h
#define KKRequestDefine_h

@class KKFormRequest;

typedef void(^KKRequestFinishedBlock)(KKFormRequest * _Nonnull aFormRequest,
                                      NSDictionary* _Nullable aRequestResult,
                                      NSDictionary* _Nullable aHttpInfomation,
                                      NSString* _Nullable aRequestIdentifier);


#endif /* KKRequestDefine_h */
