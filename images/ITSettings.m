//
//  ITSettings.m
//  imagesTest
//
//  Created by Линник Александр on 02.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import "ITSettings.h"

@implementation ITSettings

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.modelImages = [[ITModelImages alloc]init];
  
    }
    return self;
}

@end
