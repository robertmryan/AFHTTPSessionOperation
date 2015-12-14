//
//  AFHTTPSessionOperation.m
//
//  Created by Robert Ryan on 8/6/15.
//  Copyright (c) 2015 Robert Ryan. All rights reserved.
//

#import "AFHTTPSessionOperation.h"
#import "AFNetworking.h"

@interface AFHTTPSessionManager (DataTask)

// this method is not publicly defined in @interface in .h, so we need to define our own interface for it

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end

@interface AFHTTPSessionOperation ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong, readwrite, nullable) NSURLSessionTask *task;

@end

@implementation AFHTTPSessionOperation

+ (instancetype)operationWithManager:(AFHTTPSessionManager *)manager
                          HTTPMethod:(NSString *)method
                           URLString:(NSString *)URLString
                          parameters:(id)parameters
                      uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress
                    downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgress
                             success:(void (^)(NSURLSessionDataTask *, id))success
                             failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {

    AFHTTPSessionOperation *operation = [[self alloc] init];
    
    NSURLSessionTask *task = [manager dataTaskWithHTTPMethod:method URLString:URLString parameters:parameters uploadProgress:uploadProgress downloadProgress:downloadProgress success:^(NSURLSessionDataTask *task, id responseObject){
        if (success) {
            success(task, responseObject);
        }
        [operation completeOperation];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
        [operation completeOperation];
    }];
    [task resume];
    operation.task = task;

    return operation;
}

- (void)main {
    [self.task resume];
}

- (void)completeOperation {
    self.task = nil;
    [super completeOperation];
}

- (void)cancel {
    [self.task cancel];
    [super cancel];
}

@end
