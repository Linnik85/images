//
//  ITImageItem.m
//  imagesTest
//
//  Created by Линник Александр on 02.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import "ITImageItem.h"

@implementation ITImageItem


#pragma mark - Privet Methods


//Convert Item from dictionary

-(void) fromDictionary:(NSDictionary*) dictionary{
    
    _imageData = dictionary[@"imageData"];
    
    _imageID = [dictionary[@"imageID"]integerValue];
    
    _imagePreviewData = dictionary[@"imagePreviewData"];
    
    _imageSize = dictionary[@"imageSize"];
}


//Convert Item to dictionary

-(NSDictionary*) toDictionary{
    
    NSMutableDictionary* outDict = [[NSMutableDictionary alloc] init];
    
    if (_imageData) {
        
        [outDict setObject:_imageData forKey:@"imageData"];
    }
    
    if (_imageID) {
        
        [outDict setObject:[NSNumber numberWithInteger:_imageID] forKey:@"imageID"];
    }
    
    if (_imagePreviewData) {
        
        [outDict setObject:_imagePreviewData forKey:@"imagePreviewData"];
    }
    
    if (_imageSize) {
        
        [outDict setObject:_imageSize forKey:@"imageSize"];
    }
    
    return outDict;
}

@end
