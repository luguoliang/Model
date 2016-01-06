//
//  ViewController.m
//  kvc-model-0
//
//  Created by 路国良 on 16/1/5.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "ViewController.h"
#import "Book.h"
#import "Author.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary*dict = @{@"province":@"huabei",@"region":@"Tsinghua University Press",@"pid":@"pid",@"author":@{@"name":@"huabei"}};
    Book*book = [[Book alloc] initWithDict:dict];
    NSLog(@"book.province = %@",book.province);
    NSLog(@"book.region = %@",book.region);
    NSLog(@"book.pid = %@",book.pid);
    NSLog(@"book.author.name = %@",book.author.name);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
