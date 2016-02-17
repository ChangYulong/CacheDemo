//
//  ViewController.m
//  CacheDemo
//
//  Created by shanghaikedu on 16/1/7.
//  Copyright © 2016年 Langmuir. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //1.创建请求
    NSURL * url = [NSURL URLWithString:@"http://lol.data.shiwan.com/getArticleListImprove/?cid_rel=212&page=1"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    //2.设置缓存策略（有缓存就用缓存， 没有缓存就重新请求）
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    //3.发送请求
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dict);
        }
    }];
    [task resume];
    
    //获得全局的缓存对象
    NSURLCache * cache = [NSURLCache sharedURLCache];
    
    //取得request请求的缓存
    NSCachedURLResponse *response =[cache cachedResponseForRequest:request];
    if (response) {
        NSLog(@"---这个请求已经存在缓存");
        NSLog(@"%@",NSHomeDirectory());
        
        //从缓存里取得数据
        //NSDictionary * dic = (NSDictionary *)response.data;
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:response.data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic:%@",dict);
    } else {
        NSLog(@"---这个请求没有缓存");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
