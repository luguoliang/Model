//
//  OperatingDatabase.m
//  CoreData-oc
//
//  Created by 路国良 on 16/1/6.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "OperatingDatabase.h"
#import "Student+CoreDataProperties.h"
#import <CoreData/CoreData.h>
@interface OperatingDatabase(){
    NSManagedObjectContext*_context;
    NSFetchRequest*_fetchRequest;
    Student*_student;
}
@end
@implementation OperatingDatabase
-(instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        if ([self opendb]) {
            [self addpersoninitWithDict:dict];
        }
    }
    return self;
}
-(BOOL)opendb{
    NSManagedObjectModel*model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator*store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSArray*docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*path = [docs[0] stringByAppendingPathComponent:@"OpearatingDataBase.db"];
    NSURL*url = [NSURL fileURLWithPath:path];
    NSError*error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (error) {
        NSLog(@"打开数据库出错");
        return NO;
    }
    else
    {
        NSLog(@"打开数据库成功");
    }
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _context.persistentStoreCoordinator = store;
    return YES;
}

-(void)addpersoninitWithDict:(NSDictionary *)dict{
    NSUserDefaults*userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setValue:dict[@"studentID"] forKey:@"studentID"];
    _fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    _fetchRequest.predicate = [NSPredicate predicateWithFormat:@"studentID LIKE%@",dict[@"studentID"]];;
    NSError*error = nil;
    NSArray*array = [_context executeFetchRequest:_fetchRequest error:&error];
    if (error) {
        NSLog(@"err = %@",error);
    }
    else{
        if (array.count) {
            _student = [array lastObject];
            NSLog(@"该账户已经存在，将进行更新");
            [self ententities:_student WithDict:dict];
        }
        else{
            NSLog(@"该账户不存在，将进行添加");
            _student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:_context];
            Book*book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:_context];
            _student.book = book;
            [self ententities:_student WithDict:dict];
        }
    }
}

-(void)ententities:(Student*)student WithDict:(NSDictionary*)dict{
    if (![[dict objectForKey:@"name"] isKindOfClass:[NSNull class]])
    {
        [student setValue:dict[@"name"] forKey:@"name"];
    }
    else{
        [student setValue:dict[@"name"] forKey:@""];
        
    }
    if (![dict[@"studentID"] isKindOfClass:[NSNull class]]) {
        student.studentID = dict[@"studentID"];
    }
    else{
        student.studentID = @"";
    }
    if (![dict[@"book"] isKindOfClass:[NSNull class]]) {
        student.book.price = dict[@"book"][@"price"];
        NSLog(@"persons.book.price = %@",student.book.price);
    }
    else{
        student.book.price = @"";
    }
    NSError*error = nil;
    if ([_context save:&error]) {
        NSLog(@"添加或者更新数据成功");
    }
    else
    {
        NSLog(@"添加或者更新数据失败");
        NSLog(@"error = %@",error);
    }
}
-(NSString*)getName{
    return [_student valueForKey:@"name"];
}
-(NSString*)getBooksPrice{
    return _student.book.price;
}
-(NSString*)getBooksName{
    return _student.book.name;
}
-(void)updateNameWith:(NSString *)name{
    [_student setValue:name forKey:@"name"];
}
-(void)updateBooksPriceWith:(NSString *)price{
    _student.book.price = price;
}
-(void)updateBooksNameWith:(NSString *)bookname{
    _student.book.name = bookname;
}

@end
