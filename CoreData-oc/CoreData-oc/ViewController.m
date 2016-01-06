//
//  ViewController.m
//  CoreData-oc
//
//  Created by 路国良 on 16/1/6.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "ViewController.h"
#import "OperatingDatabase.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary*dict = @{@"name":@"国士无双",@"studentID":@"201000816120",@"book":@{@"price":@"10",@"name":@"计算机组成原理"}};
    OperatingDatabase*database = [[OperatingDatabase alloc] initWithDict:dict];
    
    NSLog(@"student.name = %@",[database getName]);
    NSLog(@"student.book.name = %@",[database getBooksName]);
    NSLog(@"student.book.price = %@",[database getBooksPrice]);
    [database updateNameWith:@"国士无双路"];
    [database updateBooksNameWith:@"计算机网络"];
    [database updateBooksPriceWith:@"100"];
    NSLog(@"student.name = %@",[database getName]);
    NSLog(@"student.book.name = %@",[database getBooksName]);
    NSLog(@"student.book.price = %@",[database getBooksPrice]);    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
