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

#### Progress and completion 

The progress of a series of requests can be accomplished by creating your own `NSProgress` object and then call `addChild` for the `NSProgress` objects of all of the tasks that are created. You can then add an observer to the `fractionCompleted` of your `NSProgress`.

To determine when the downloads are done, you can add an operation (e.g. a `NSBlockOperation`) and then make it dependent upon all of the other operations that were added to the queue.

To illustrate this, a Swift 2 implementation might look like so. The Objective-C implementation is equivalent.

    import UIKit

    private var observerContext = 0

    class ViewController: UIViewController {

        override func viewDidLoad() {
            super.viewDidLoad()

            progress = NSProgress()
            progress.addObserver(self, forKeyPath: "fractionCompleted", options: .New, context: &observerContext)

            downloadFiles()
        }

        private var progress: NSProgress!

        deinit {
            progress?.removeObserver(self, forKeyPath: "fractionCompleted")
        }

        private func downloadFiles() {
            let filenames = ["as17-134-20380.jpg", "as17-140-21497.jpg", "as17-148-22727.jpg"]

            let baseURL = NSURL(string: "http://example.com/path")!

            let queue = NSOperationQueue()
            queue.maxConcurrentOperationCount = 4

            progress.totalUnitCount = Int64(filenames.count)
            progress.completedUnitCount = 0

            let manager = AFHTTPSessionManager()
            manager.responseSerializer = AFImageResponseSerializer()

            let completionOperation = NSBlockOperation {
                print("done")
            }

            for filename in filenames {
                let url = baseURL.URLByAppendingPathComponent(filename)
                let operation = AFHTTPSessionOperation(manager: manager, HTTPMethod: "GET", URLString: url.absoluteString, parameters: nil, uploadProgress: nil, downloadProgress: nil, success:
                    { (task, responseObject) -> Void in
                        print("\(filename): \(NSStringFromCGSize((responseObject as! UIImage).size))")
                    }, failure: { task, error in
                        print("\(filename): \(error)")
                    })
                queue.addOperation(operation)
                completionOperation.addDependency(operation)
                progress.addChild(manager.downloadProgressForTask(operation.task!)!, withPendingUnitCount: 1)
            }

            queue.addOperation(completionOperation)
        }

        override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
            if context == &observerContext {
                if keyPath == "fractionCompleted" {
                    let percent = change![NSKeyValueChangeNewKey] as! Double
                    print("\(percent)")
                }
            } else {
                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            }
        }

    }

Note, this is a mix and match situation, where you can use either `NSProgress` or completion handler or both or neither. I just depends upon your needs.

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

