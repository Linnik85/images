//
//  ITModelImages.h
//  imagesTest
//
//  Created by Линник Александр on 02.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITModelImages : NSObject

@property(strong, nonatomic) NSMutableArray *items;

-(void)getImageList;

-(void)getImageByID:(NSInteger)ID;

-(BOOL)saveToCashe;

-(void)clearCashe;

-(NSMutableArray*) loadFromCashe;

@end
