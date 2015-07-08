//
//  ITImageItem.h
//  imagesTest
//
//  Created by Линник Александр on 02.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITImageItem : NSObject

@property(assign,nonatomic) NSInteger imageID;
@property(strong,nonatomic) NSData* imageData;

@property(strong,nonatomic) NSData* imagePreviewData;
@property(strong,nonatomic) NSString* imageSize;

-(void) fromDictionary:(NSDictionary*) dictionary;
-(NSDictionary*) toDictionary;

@end
