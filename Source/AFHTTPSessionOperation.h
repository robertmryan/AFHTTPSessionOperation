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

/** The NSURLSessionTask associated with this operation
 */
@property (nonatomic, strong, readonly, nullable) NSURLSessionTask *task;

/**
 Creates an `AFHTTPSessionOperation` with the specified request.
 
 @param manager            The AFURLSessionManager for the operation.
 @param request            The HTTP request for the request.
 @param method             The HTTP method (e.g. GET, POST, etc.).
 @param parameter          A dictionary of parameters to be added to the request. The nature of the encoding is dictated by the manager's requestSerializer setting.
 @param uploadProgress     A block that is called as the upload of the request body progresses.
 @param downloadProgress   A block that is called as the download of the server response progresses.
 @param success            A block object to be executed if and when the task successfully finishes.
 @param failure            A block object to be executed if and when the task fails.
 
 @returns AFURLSessionOperation that can be added to a NSOperationQueue.
 */
+ (instancetype)operationWithManager:(AFHTTPSessionManager *)manager
                          HTTPMethod:(NSString *)method
                           URLString:(NSString *)URLString
                          parameters:(nullable id)parameters
                      uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                    downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                             success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END