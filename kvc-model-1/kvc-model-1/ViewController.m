//
//  ViewController.m
//  kvc-model-1
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
    NSDictionary*dict = @{@"bookName":@"autolayer",@"pubHouse":@"Tsinghua University Press",@"price":[NSNumber numberWithInt:20],@"id":@"20151212",@"author":@{@"name":@"json"}};
    Book*book = [[Book alloc] init];
    [book setValuesForKeysWithDictionary:dict];
    NSLog(@"book.bookName = %@",book.bookName);
    NSLog(@"book.pubHouse = %@",book.pubHouse);
    NSLog(@"book.id = %@",book.id);
    NSLog(@"book.price = %ld",(long)book.price);
    NSLog(@"book.author.name = %@",book.author.name);

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
