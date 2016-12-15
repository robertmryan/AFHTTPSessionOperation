//
//  AFURLSessionOperation.m
//
//  Created by Robert Ryan on 12/13/15.
//  Copyright © 2015 Robert Ryan. All rights reserved.
//

#import "AFURLSessionOperation.h"
#import "AFURLSessionManager.h"

@interface AFURLSessionOperation ()

@property (nonatomic, strong, readwrite, nullable) NSURLSessionTask *task;

@end

@implementation AFURLSessionOperation

+ (instancetype)dataOperationWithManager:(AFURLSessionManager *)manager
                                 request:(NSURLRequest *)request
                       completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {
    AFURLSessionOperation *operation = [[AFURLSessionOperation alloc] init];
    
    operation.task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler) completionHandler(response, responseObject, error);
        [operation completeOperation];
    }];
    
    return operation;
}

+ (instancetype)dataOperationWithManager:(AFURLSessionManager *)manager
                                 request:(NSURLRequest *)request
                          uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                        downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                       completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {
    AFURLSessionOperation *operation = [[AFURLSessionOperation alloc] init];
    
    operation.task = [manager dataTaskWithRequest:request uploadProgress:uploadProgress downloadProgress:downloadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler) completionHandler(response, responseObject, error);
        [operation completeOperation];
    }];
    
    return operation;
}

- (instancetype)uploadOperationWithManager:(AFURLSessionManager *)manager
                                   request:(NSURLRequest *)request
                                  fromFile:(NSURL *)fileURL
                                  progress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                         completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError  * _Nullable error))completionHandler {
    AFURLSessionOperation *operation = [[AFURLSessionOperation alloc] init];
    
    operation.task = [manager uploadTaskWithRequest:request fromFile:fileURL progress:uploadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler) completionHandler(response, responseObject, error);
        [operation completeOperation];
    }];
    
    return operation;
}

+ (instancetype)uploadOperationWithManager:(AFURLSessionManager *)manager
                                   request:(NSURLRequest *)request
                                  fromData:(nullable NSData *)bodyData
                                  progress:(nullable void (^)(NSProgress *uploadProgress)) progress
                         completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler {
    AFURLSessionOperation *operation = [[AFURLSessionOperation alloc] init];
    
    operation.task = [manager uploadTaskWithRequest:request fromData:bodyData progress:progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler) completionHandler(response, responseObject, error);
        [operation completeOperation];
    }];
    
    return operation;
}

+ (instancetype)uploadOperationWithManager:(AFURLSessionManager *)manager
                           streamedRequest:(NSURLRequest *)request
                                  progress:(nullable void (^)(NSProgress *uploadProgress)) progress
                         completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler {
    AFURLSessionOperation *operation = [[AFURLSessionOperation alloc] init];
    
    operation.task = [manager uploadTaskWithStreamedRequest:request progress:progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler) completionHandler(response, responseObject, error);
        [operation completeOperation];
    }];
    
    return operation;
}

+ (instancetype)downloadOperationWithManager:(AFURLSessionManager *)manager
                                     request:(NSURLRequest *)request
                                    progress:(nullable void (^)(NSProgress *downloadProgress)) progress
                                 destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                           completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler {
    AFURLSessionOperation *operation = [[AFURLSessionOperation alloc] init];
    
    operation.task = [manager downloadTaskWithRequest:request progress:progress destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) completionHandler(response, filePath, error);
        [operation completeOperation];
    }];
    
    return operation;
}

+ (instancetype)downloadOperationWithManager:(AFURLSessionManager *)manager
                                  resumeData:(NSData *)resumeData
                                    progress:(nullable void (^)(NSProgress *downloadProgress)) progress
                                 destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                           completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler {
    AFURLSessionOperation *operation = [[AFURLSessionOperation alloc] init];
    
    operation.task = [manager downloadTaskWithResumeData:resumeData progress:progress destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) completionHandler(response, filePath, error);
        [operation completeOperation];
    }];
    
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
