//
//  AFSessionOperation.h
//
//  Created by Robert Ryan on 8/6/15.
//  Copyright (c) 2015 Robert Ryan. All rights reserved.
//

#import "ConcurrentOperation.h"

@class AFHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface AFHTTPSessionOperation : ConcurrentOperation

+ (nullable instancetype)operationWithManager:(AFHTTPSessionManager *)manager
                                       method:(NSString *)method
                                    URLString:(NSString *)URLString
                                   parameters:(nullable id)parameters
                                      success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                      failure:(nullable void (^)(NSURLSessionDataTask *task, NSError * error))failure;

@end

NS_ASSUME_NONNULL_END