//
//  OperatingDatabase.h
//  CoreData-oc
//
//  Created by 路国良 on 16/1/6.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperatingDatabase : NSObject
-(instancetype)initWithDict:(NSDictionary*)dict;
-(NSString*)getName;
-(NSString*)getBooksPrice;
-(NSString*)getBooksName;
-(void)updateNameWith:(NSString*)name;
-(void)updateBooksPriceWith:(NSString*)price;
-(void)updateBooksNameWith:(NSString*)bookname;
@end
