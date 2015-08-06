## AFHTTPSessionOperation

### Introduction

This is a `NSOperation` subclass for requests added to `AFHTTPSessionManager`. 

When using `AFHTTPRequestOperationManager`, you enjoy `NSOperation` capabilities, but when using `AFHTTPSessionManager`, you don't. This is somewhat understandable (as `NSURLSession` introduces background requests, and that's incompatible with `NSOperation`-based approaches), but when performing requests in the foreground, it's useful to have `NSOperation`-style capabilities. This class makes that possible.

### Usage

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 4;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [queue addOperation:[AFHTTPSessionOperation operationWithManager:manager method:@"GET" URLString:@"http://www.example.com/path" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // use `responseObject` here
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        // handle `error` here
    }]];

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

