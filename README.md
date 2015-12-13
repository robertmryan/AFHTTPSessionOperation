## AFHTTPSessionOperation

### Introduction

`AFHTTPSessionOperation` is a `NSOperation` subclass for HTTP requests added to `AFHTTPSessionManager`. `AFURLSessionOperation` is a `NSOperation` subclass for data, upload, and download requests implemented in `AFURLSessionManager`. 

This has been updated for AFNetworking 3.0. See [`2.x` branch](https://github.com/robertmryan/AFHTTPSessionOperation/tree/2.x) of this repo if you're using AFNetworking 2.x.

When using `AFHTTPRequestOperationManager` (now retired), you enjoy `NSOperation` capabilities, but when using `AFHTTPSessionManager`, you don't. This is somewhat understandable (as `NSURLSession` introduces background requests, and that's incompatible with `NSOperation`-based approaches), but when performing requests in the foreground, it's useful to have `NSOperation`-style capabilities. This class makes that possible.

### Usage

#### AFHTTPSessionOperation

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 3;

    NSArray *filenames = @[@"file1.jpg", @"file2.jpg", @"file3.jpg", @"file4.jpg", @"file5.jpg", @"file6.jpg"];

    for (NSString *filename in filenames)  {
        NSString *urlString = [@"http://example.com" stringByAppendingPathComponent:filename];
        NSOperation *operation = [AFHTTPSessionOperation operationWithManager:manager HTTPMethod:@"GET" URLString:urlString parameters:nil uploadProgress:nil downloadProgress:^(NSProgress *downloadProgress) {
            NSLog(@"%@: %.1f", filename, downloadProgress.fractionCompleted * 100.0);
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@: %@", filename, NSStringFromCGSize([responseObject size]));
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@: %@", filename, error.localizedDescription);
        }];
        [queue addOperation:operation];
    }

#### AFURLSessionOperation

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] init];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 3;

    NSArray *filenames = @[@"file1.jpg", @"file2.jpg", @"file3.jpg", @"file4.jpg", @"file5.jpg", @"file6.jpg"];

    for (NSString *filename in filenames)  {
        NSString *urlString = [@"http://example.com" stringByAppendingPathComponent:filename];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

        NSOperation *operation = [AFURLSessionOperation downloadOperationWithManager:manager request:request progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"%@: %.1f", filename, downloadProgress.fractionCompleted * 100.0);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSError *error;
            NSURL *documentsURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:false error:&error];
            return [documentsURL URLByAppendingPathComponent:filename];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSLog(@"%@ done %@", filename, (error.localizedDescription ?: @""));
        }];
        [queue addOperation:operation];
    }

### Reference

As contemplated in AFNetworking issue [#1504](https://github.com/AFNetworking/AFNetworking/issues/1504).

### License

The MIT License (MIT)

Copyright (c) 2015 Rob Ryan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

