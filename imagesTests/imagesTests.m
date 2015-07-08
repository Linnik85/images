//
//  imagesTests.m
//  imagesTests
//
//  Created by Линник Александр on 02.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ITModelImages.h"


@interface imagesTests : XCTestCase

@end

@implementation imagesTests

- (void)setUp {
    [super setUp];
   
}


- (void)testToVerifyTheCorrectnessOfTheReturnDataFormat {
    
    ITModelImages* modelImages = [[ITModelImages alloc]init];
    
    id array = [modelImages loadFromCashe];
    
    BOOL isTrue = NO;
    
    if ([array isKindOfClass:[NSMutableArray class]]) {
        
        isTrue = YES;

    }
 
    XCTAssertTrue(isTrue);
}



- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}




@end
