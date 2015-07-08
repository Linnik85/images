//
//  ITModelImages.m
//  imagesTest
//
//  Created by Линник Александр on 02.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import "ITModelImages.h"
#import "ITServerManager.h"
#import "ITImageItem.h"


@interface ITModelImages () <ITServerManagerDelegate>


@property(strong,nonatomic) ITServerManager* serverManager;

@property(strong,nonatomic) NSArray *paths;

@property(strong,nonatomic) NSString *documentsDirectory;

@property(strong,nonatomic) NSString *path;

@property(strong,nonatomic) NSFileManager *fileManager;


@end


@implementation ITModelImages


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.serverManager = [ITServerManager sharedManager];
        
        self.serverManager.delegate = self;
        
        self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        self.documentsDirectory = [self.paths objectAtIndex:0];
        
        self.path = [self.documentsDirectory stringByAppendingPathComponent:@"images.plist"];
        
        self.fileManager = [NSFileManager defaultManager];
        
        self.items = [self loadFromCashe];
        
        
    }
    
    return self;
}


-(void)getImageList{
    
    [self.serverManager getImagList];
}


-(void)getImageByID:(NSInteger)ID{
    
    [self.serverManager getImageById:ID];
    
}


#pragma ITServerManagerDelegate 


-(void) getImagListResponds:(NSMutableArray*) imageList {
    
    BOOL isUpdateModel = NO;
    
    NSMutableArray* tmpArray = [self.items mutableCopy];
    
    if (imageList.count>0 && self.items.count == 0) {
        
        self.items = imageList;
        
        isUpdateModel = YES;
    }
    
    else if (imageList.count>0 && !imageList.count==0) {
        
        for ( ITImageItem* imageItem in imageList ) {
            
                if (![self isArrayContainsObject:imageItem inArray:self.items]) {
                    
                    [tmpArray addObject:imageItem];
                    
                    isUpdateModel = YES;
            }
        }
        
        self.items = tmpArray;
    }

    if (isUpdateModel) {
        
              [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateImageListNotitfication" object:self.items];
    }

}


-(void)getImagResponds:(NSData *)imageData{
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateImageNotitfication" object:imageData];
}

-(void) errorResponds:(NSString*) errorDescription{
    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorNotitfication" object:errorDescription];
    
    
}



#pragma mark - Save & Load local data


-(NSMutableArray*) loadFromCashe
{
     NSMutableArray* imageItems = nil;
    
    if ([self.fileManager fileExistsAtPath: self.path])
        
    {
        imageItems = [NSMutableArray array];
        
     NSMutableArray*  imageItemsDictArray = [[NSMutableArray alloc] initWithContentsOfFile:self.path];
        
        for (NSDictionary* imageItemDict in imageItemsDictArray) {
            
            ITImageItem* image = [[ITImageItem alloc] init];
            
            [image fromDictionary:imageItemDict];
            
            [imageItems addObject:image];
            
        }
        
    }
    
    self.items = imageItems;
    
    return self.items;
}


-(BOOL)saveToCashe{
    
    NSMutableArray* imageItemsDictArray = [NSMutableArray new];
    
    for (ITImageItem* imageItem in self.items) {
        
        NSDictionary* imagDict = [imageItem toDictionary];
        
        [imageItemsDictArray addObject:imagDict];
    }
    
    if (![self.fileManager fileExistsAtPath: self.path])
    {
        self.path = [self.documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"images.plist"]];
    }
    
  BOOL isSave = [imageItemsDictArray writeToFile: self.path atomically:YES];
    
    return isSave;
}


-(void)clearCashe{
    
    self.items = nil;
    
    NSError *error;
    
    BOOL success = [self.fileManager removeItemAtPath:self.path error:&error];
    
    if (success) {

    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    [self getImageList];
}


#pragma mark - Privet Methods


-(BOOL)isArrayContainsObject:(ITImageItem*) object inArray:(NSMutableArray*) array{
    
    for (ITImageItem* image in array ) {
        
        if (image.imageID == object.imageID) {
            
            return YES;

        }
        
    }
    
    return NO;
}


@end
