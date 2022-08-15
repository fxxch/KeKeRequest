//
//  KKRequestParam_Demo.h
//  KKRequestDemo
//
//  Created by edward lannister on 2022/08/15.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ServerAddress                ([KKRequestParam_Demo serverAddress])

@interface KKRequestParam_Demo : KKRequestParam

+ (NSString*)requestURLForInterface:(NSString*)interface;

+ (NSString*)serverAddress;

@end

