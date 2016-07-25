//
//  ViewController.m
//  09-掌握-AFN
//
//  Created by xiaomage on 15/7/15.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import <AFNetworking.h>


@interface ViewController ()<NSXMLParserDelegate>
/** 监控网络 */
@property (nonatomic, strong) Reachability *reachability;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self appleMonitoring];
    
    //从web服务器加载数据
    NSString *str = @"http://api.ithome.com/xml/newscontent/170/955.xml";  //这里是乱写的
    //1简历NSURL
    NSURL *url = [NSURL URLWithString:str];
    //2建立NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
    //3建立NSURLConnect的同步方法加载数据
    NSURLResponse *response = nil;
    NSError *error = nil;
    //同步加载数据
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //1实例化解析器,传入要解析的数据
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    //2 设置代理
    [parser setDelegate:self];
    //3解析器解析,这个方法会调用代理里面的方法。
    [parser parse];
    

    
    NSLog(@"%@",data);
    
}

- (void)appleMonitoring
{
    // 监听通知 。下面的Nil表示无论是谁发出的该条通知我都监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNetworkStatus) name:kReachabilityChangedNotification object:nil];
    
    // 开始监控网络
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.reachability stopNotifier];
    self.reachability = nil;
}


//获取现在的网络状态
- (void)getNetworkStatus
{
    if ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus != NotReachable) {
        NSLog(@"是wifi");
    } else if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus != NotReachable) {
        NSLog(@"是手机自带网络");
    } else {
        NSLog(@"网络有问题");
    }
}

- (void)afnMonitoring
{
    // 开始网络监控
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];

    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"-----当前的网络状态---%zd", status);
    }];
    
    [mgr startMonitoring];
    

    
    // 拿到当前网络状态
//    mgr.networkReachabilityStatus;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 直接使用“服务器本来返回的数据”，不做任何解析
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    [AFJSONResponseSerializer serializer]; // 解析服务器返回的JSON数据
//    [AFXMLParserResponseSerializer serializer]; // 解析服务器返回的XML数据

    
    [mgr GET:@"http://120.25.226.186:32812/resources/images/minion_02.png" parameters:nil success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        NSLog(@"请求成功---%zd", responseObject.length);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败---%@", error);
    }];
}

- (void)xml
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // responseSerializer 用来解析服务器返回的数据
    
    // 告诉AFN，以XML形式解析服务器返回的数据
    mgr.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it",
                             @"type" : @"XML"
                             };
    
    [mgr GET:@"http://120.25.226.186:32812/login" parameters:params success:^(NSURLSessionDataTask *task, NSXMLParser *parser) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败---%@", error);
    }];
}

- (void)upload2
{
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    [mgr uploadTaskWithRequest:<#(NSURLRequest *)#> fromData:<#(NSData *)#> progress:<#(NSProgress *__autoreleasing *)#> completionHandler:<#^(NSURLResponse *response, id responseObject, NSError *error)completionHandler#>];
}

- (void)upload
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr POST:@"http://120.25.226.186:32812/upload" parameters:@{@"username" : @"123"}
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 在这个block中设置需要上传的文件
//            NSData *data = [NSData dataWithContentsOfFile:@"/Users/xiaomage/Desktop/placeholder.png"];
//            [formData appendPartWithFileData:data name:@"file" fileName:@"test.png" mimeType:@"image/png"];
            
//            [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/placeholder.png"] name:@"file" fileName:@"xxx.png" mimeType:@"image/png" error:nil];
    
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/placeholder.png"] name:@"file" error:nil];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"-------%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
    
    
}

- (void)download
{
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    
//    [mgr downloadTaskWithRequest:<#(NSURLRequest *)#> progress:<#(NSProgress *__autoreleasing *)#> destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        return 
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        
//    }];
}

- (void)get2
{
    // AFHTTPSessionManager内部包装了NSURLSession
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it"
                             };
    
    [mgr GET:@"http://120.25.226.186:32812/login" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功---%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败---%@", error);
    }];
}

- (void)post
{
    // AFHTTPRequestOperationManager内部包装了NSURLConnection
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it"
                             };
    
    [mgr POST:@"http://120.25.226.186:32812/login" parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"请求成功---%@", responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败---%@", error);
     }];
}

- (void)get
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    

    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it"
                             };
 

    [mgr GET:@"http://120.25.226.186:32812/login" parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"请求成功---%@", responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败---%@", error);
    }];
}

@end
