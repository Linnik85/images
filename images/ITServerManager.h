//
//  ITServerManager.h
//  imagesTest
//
//  Created by Линник Александр on 02.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SOAPEngine64/SOAPEngine.h>


@protocol ITServerManagerDelegate <NSObject>

@optional


-(void) getImagListResponds:(NSMutableArray*) imageList;

-(void) getImagResponds:(NSData*) imageData;

-(void) errorResponds:(NSString*) errorDescription;

-(void) progtessLoadImage:(float) totalBytes loadBytes:(float) loadButes;

@end


@interface ITServerManager : NSObject


@property (nonatomic, weak) id < ITServerManagerDelegate > delegate;

+(ITServerManager*) sharedManager;

-(void)getImagList;

-(void)getImageById:(NSInteger)ID;


@end
