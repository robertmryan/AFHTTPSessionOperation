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
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, copy) id parameters;
@property (nonatomic, copy) void (^uploadProgress)(NSProgress *uploadProgress);
@property (nonatomic, copy) void (^downloadProgress)(NSProgress *downloadProgress);
@property (nonatomic, copy) void (^success)(NSURLSessionDataTask *task, id responseObject);
@property (nonatomic, copy) void (^failure)(NSURLSessionDataTask *task, NSError * error);

@property (nonatomic, weak) NSURLSessionTask *task;

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
    
    operation.manager = manager;
    operation.method = method;
    operation.URLString = URLString;
    operation.parameters = parameters;
    operation.uploadProgress = uploadProgress;
    operation.downloadProgress = downloadProgress;
    operation.success = success;
    operation.failure = failure;
    
    return operation;
}

- (void)main {
    NSURLSessionTask *task = [self.manager dataTaskWithHTTPMethod:self.method URLString:self.URLString parameters:self.parameters uploadProgress:self.uploadProgress downloadProgress:self.downloadProgress success:^(NSURLSessionDataTask *task, id responseObject){
        if (self.success) {
            self.success(task, responseObject);
        }
        [self completeOperation];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.failure) {
            self.failure(task, error);
        }
        [self completeOperation];
    }];
    [task resume];
    self.task = task;
}

- (void)completeOperation {
    self.failure = nil;
    self.success = nil;
    self.downloadProgress = nil;
    self.uploadProgress = nil;
    
    [super completeOperation];
}

- (void)cancel {
    [self.task cancel];
    [super cancel];
}

@end
