//
//  AFSessionOperation.h
//
//  Created by Robert Ryan on 8/6/15.
//  Copyright (c) 2015 Robert Ryan. All rights reserved.
//

#import "AsynchronousOperation.h"

@class AFHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface AFHTTPSessionOperation : AsynchronousOperation

+ (nullable instancetype)operationWithManager:(AFHTTPSessionManager *)manager
                                   HTTPMethod:(NSString *)method
                                    URLString:(NSString *)URLString
                                   parameters:(nullable id)parameters
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                      success:(void (^)(NSURLSessionDataTask *, id))success
                                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

NS_ASSUME_NONNULL_END