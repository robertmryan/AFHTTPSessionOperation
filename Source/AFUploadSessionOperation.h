//
//  AFUploadSessionOperation.h
//  KaKa_iOS
//
//  Created by Calvin Sun on 15/11/30.
//  Copyright © 2015年 com.opentrans. All rights reserved.
//

#import "ConcurrentOperation.h"

@class AFHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface AFUploadSessionOperation : ConcurrentOperation

+ (nullable instancetype)operationWithManager:(AFHTTPSessionManager *)manager
                                      request:(NSURLRequest *)request
                                     fromData:(NSData *)bodyData
                               progressUpdate:(void (^)(NSProgress *progress))progressUpdate
                                      success:(nullable void (^)(NSURLResponse *response, id responseObject))success
                                      failure:(nullable void (^)(NSURLResponse *response, NSError * error))failure;

@end

NS_ASSUME_NONNULL_END
